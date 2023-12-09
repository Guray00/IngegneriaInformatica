module testbench();

    wire clock;
    reg reset_;

    clock_generator clk(
        .clock(clock)
    );

    wire [15:0] addr;
    wire [7:0] data;
    wire ior_, iow_;

    ABC dut (
        .iow_(iow_), .ior_(ior_), .addr(addr), .data(data),
        .reset_(reset_), .clock(clock)
    );

    // i fili del bus sono ritardati e ballanti cosicché le corse critiche vadano quasi sempre male :)
    reg [15:0] addr_io;
    reg s_A_, s_B_in_, s_B_out_;
    always @(addr) begin
        {s_A_, s_B_in_, s_B_out_, addr_io} = 'bX;
        #1; 
        addr_io = addr;
        #1; 
        s_A_ = ( { addr_io[15:1], 1'B0 } == 16'h0100 ) ? 0 : 1;
        #1;
        s_B_in_ = ( addr_io == 16'h0120 ) ? 0 : 1;
        #1;
        s_B_out_ = ( addr_io == 16'h0121 ) ? 0 : 1;
    end
    reg ior_io_, iow_io_;
    always @(negedge ior_) ior_io_ = ior_;
    always @(posedge ior_) #4 ior_io_ = ior_;
    always @(negedge iow_) iow_io_ = iow_;
    always @(posedge iow_) #4 iow_io_ = iow_;

    // testbench variables to control interfaces
    reg tb_fiA; 
    reg [7:0] tb_valueA, tb_value_B_in;
    wire tb_signal_read_A;
    wire [7:0] tb_value_B_out;
    wire tb_signal_write_B_out;

    interface_in_hs A(
        .s_(s_A_), .ior_(ior_io_), .addr(addr_io[0]), .data(data),
        .tb_value(tb_valueA), .tb_fi(tb_fiA), .tb_signal_read(tb_signal_read_A)
    );

    interface_in B_in(
        .ior_(ior_io_), .s_(s_B_in_), .data(data),
        .tb_value(tb_value_B_in)
    );

    interface_out B_out(
        .iow_(iow_io_), .s_(s_B_out_), .data(data),
        .tb_value(tb_value_B_out), .tb_signal_write(tb_signal_write_B_out)
    );

    wire io_CA_error;
    wire s_catch_all_;
    assign s_catch_all_ = ~(s_A_ === 1'b1 | s_A_ === 1'bX) | ~(s_B_in_ === 1'b1 | s_B_in_ === 1'bX) | ~(s_B_out_ === 1'b1 | s_B_out_ === 1'bX);

    io_catch_all io_CA(
        .iow_(iow_io_), .ior_(ior_io_), .s_(s_catch_all_),
        .tb_error(io_CA_error)
    );

    // Debug variables to highlight errors in waveform diagram
    reg error_value;
    reg error_timing;

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            error_value = 0;
            error_timing = 0;

            //the following structure is used to wait for expected signals, and fail if too much time passes
            fork : f
                begin
                    #100000;
                    $display("Timeout - waiting for signal failed");
                    disable f;
                end
            //actual tests start here
                begin
                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    tb_value_B_in = 8'hDE;
                    
                    //first posedge
                    reset_ = 1;

                    fork
                        begin : A
                            reg [7:0] i;

                            for(i = 0; i < 30; i++) begin
                                tb_valueA = i + 3;
                                tb_fiA = 0;
                                #(12*2*clk.HALF_PERIOD);
                                tb_valueA = i * i + 5;
                                tb_fiA = 1;
                                
                                @(posedge tb_signal_read_A);
                                @(negedge tb_signal_read_A);
                                #1;
                            end
                        end
                        
                        begin : B_out
                            reg [7:0] i;
                            reg [7:0] curr_A;
                            reg [15:0] expected;
                            reg [15:0] current;

                            expected = 0;
                            current = 0;

                            for(i = 0; i < 30; i++) begin
                                // Punto 1
                                curr_A = i * i + 5;                                
                                @(negedge s_B_out_);
                                
                                // Punto 2
                                expected = curr_A * 5;
                                
                                @(posedge tb_signal_write_B_out);
                                current[15:8] = tb_value_B_out;
                                @(posedge tb_signal_write_B_out);
                                current[7:0] = tb_value_B_out;

                                if(expected !== current) begin
                                    $display("Wrong output: expected %d, got %d instead", expected, current);
                                    error_value = 1;
                                end                                
                            end
                        end
                    join                   

                    disable f;
                end   
            join

            $finish;
        end

    always @(posedge error_value) #1
        error_value = 0;

    always @(posedge error_timing) #1
        error_timing = 0;        

endmodule

// il modulo interface simula una interfaccia di ingresso parallela con handshake
// gli ingressi tb_* sono utilizzati dalla testbench per guidare lo stato dell'interfaccia
module interface_in_hs (
    ior_, s_, addr, data,
    tb_value, tb_fi, tb_signal_read
);
    input ior_; 
    input s_; 
    input addr; 
    inout [7:0] data;

    input [7:0] tb_value;
    input tb_fi;
    output tb_signal_read;
    
    reg DIR;

    reg [7:0] DATA;
    assign data = (DIR == 1) ? DATA : 8'hZZ;

    reg TB_SIGNAL_READ;
    assign tb_signal_read = TB_SIGNAL_READ;

    always @(*) if (s_==1 || ior_==1) begin
        DIR = 0;
        TB_SIGNAL_READ = 0;
    end

    always @(*) if (ior_==0 && s_==0)
        begin
            DIR = 1;
            casex(addr)
                1'b0: begin
                    DATA = { 7'b0, tb_fi };
                    TB_SIGNAL_READ = 0;
                end
                1'b1: begin
                    DATA = tb_value;
                    if(tb_fi != 1) begin
                        $display("Read access while FI is 0!");
                        TB_SIGNAL_READ = 0;
                    end
                    else begin
                        TB_SIGNAL_READ = 1;
                    end
                end
            endcase
        end
            
endmodule

// il modulo simula una interfaccia di ingresso parallela senza handshake
// l'ingresso tb_value è utilizzato dalla testbench per guidare lo stato dell'interfaccia
module interface_in (
    ior_, s_, data,
    tb_value
);
    input ior_; 
    input s_; 
    output [7:0] data;

    input [7:0] tb_value;
    
    reg DIR;

    reg [7:0] DATA;
    assign data = (DIR == 1) ? DATA : 8'hZZ;

    always @(*) if (s_==1 || ior_==1)
        DIR = 0;

    always @(*) if (ior_==0 && s_==0)
        begin
            DIR = 1;
            DATA = tb_value;
        end
            
endmodule

// il modulo simula una interfaccia di uscita parallela senza handshake
// le uscite tb_* sono utilizzate dalla testbench per controllare lo stato dell'interfaccia
module interface_out (
    iow_, s_, data,
    tb_value, tb_signal_write
);
    input iow_; 
    input s_; 
    input [7:0] data;

    output [7:0] tb_value;
    output tb_signal_write;
    
    reg [7:0] TB_VALUE;
    assign tb_value = TB_VALUE;

    reg TB_SIGNAL_WRITE;
    assign tb_signal_write = TB_SIGNAL_WRITE;

    always @(*) if (iow_==1 || s_==1)
        begin
            TB_SIGNAL_WRITE = 0;
        end

    always @(*) if (iow_==0 && s_==0)
        begin
            TB_VALUE = data;
            TB_SIGNAL_WRITE = 1;
        end
            
endmodule

// il modulo io_catch_all simula tutto il resto dello spazio io:
// ogni comando che lo raggiunge e' un errore
module io_catch_all(
    iow_, ior_, s_,
    tb_error
);
    input iow_, ior_, s_;
    output tb_error;
    
    reg error; assign tb_error = error;
    initial error = 0;
    always @(posedge error) #1 
        error = 0;

    always @(negedge iow_) #0.1
        if(s_ == 0) begin
            error = 1;
            $display("Invalid write access to random interface!");
        end

    always @(negedge ior_) #0.1
        if(s_ == 0) begin
            error = 1;
            $display("Invalid read access to random interface!");
        end

endmodule

// generatore del segnale di clock
module clock_generator(
    clock
);
    output clock;

    parameter HALF_PERIOD = 5;

    reg CLOCK;
    assign clock = CLOCK;

    initial CLOCK <= 0;
    always #HALF_PERIOD CLOCK <= ~CLOCK;

endmodule