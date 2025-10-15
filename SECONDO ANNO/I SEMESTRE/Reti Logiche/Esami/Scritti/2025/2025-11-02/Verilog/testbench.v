module testbench();

    wire clock;
    reg reset_;

    clock_generator clk(
        .clock(clock)
    );

    wire [15:0] addr;
    wire [7:0] data;
    wire ior_, iow_;

    wire [11:0] out;

    ABC dut (
        .iow_(iow_), .ior_(ior_), .addr(addr), .data(data),
        .out(out),
        .reset_(reset_), .clock(clock)
    );


    // i fili del bus sono ritardati cosicché le corse critiche vadano quasi sempre male :)
    wire [15:0] addr_io;
    assign #1 addr_io = addr;

    wire s_A_, s_B_, s_C_;    
    assign #1 s_A_ = ( { addr_io[15:1], 1'B0 } == 16'h0100 ) ? 0 : 1;
    assign #1 s_B_ = ( addr_io == 16'h0120 ) ? 0 : 1;
    assign #1 s_C_ = ( addr_io == 16'h0140 ) ? 0 : 1;

    wire ior_io_, iow_io_;
    assign #1 ior_io_ = ior_;
    assign #1 iow_io_ = iow_;

    // testbench variables to control interfaces
    reg tb_fiA; 
    reg [7:0] tb_valueA, tb_valueB;
    wire tb_signal_read_A;
    wire tb_signal_read_B;
    
    wire error_A;
    interface_in_hs A(
        .s_(s_A_), .ior_(ior_io_), .addr(addr[0]), .data(data),
        .tb_value(tb_valueA), .tb_fi(tb_fiA), .tb_signal_read(tb_signal_read_A),
        .error(error_A)
    );

    interface_in B(
        .ior_(ior_io_), .s_(s_B_), .data(data),
        .tb_value(tb_valueB), .tb_signal_read(tb_signal_read_B)
    );

    wire [7:0] tb_valueC;
    interface_out C(
        .iow_(iow_io_), .s_(s_C_), .data(data),
        .tb_value(tb_valueC)
    );

    wire io_CA_error;
    wire s_catch_all_;
    assign s_catch_all_ = ~(s_A_ === 1'b1 | s_A_ === 1'bX) | ~(s_B_ === 1'b1 | s_B_ === 1'bX) | ~(s_C_ === 1'b1 | s_C_ === 1'bX);

    io_catch_all io_CA(
        .iow_(iow_io_), .ior_(ior_io_), .s_(s_catch_all_),
        .tb_error(io_CA_error)
    );

    // Debug variables to highlight errors in waveform diagram
    reg error_value;
    initial error_value = 0;
    always @(posedge error_value) #1
        error_value = 0;

    wire error_IO = error_A | io_CA_error;
    
    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            tb_fiA = 0;

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
                    reset_ = 0; #(clk.HALF_PERIOD + 1);
                    
                    //just after first posedge
                    reset_ = 1;

                    if(out !== 0)
                        $display("out is not 0 after reset");

                    fork
                        begin : Interface_A
        	                reg [7:0] i;
                            reg [7:0] a, b;
                            reg [9:0] expected;

                            for(i = 0; i < 30; i++) begin
                                {a, b, expected} = get_testcase(i);

                                tb_fiA = 0;
                                #((i*2 + 2)*clk.HALF_PERIOD);
                                tb_valueA = a;
                                #1;
                                tb_fiA = 1;

                                @(posedge tb_signal_read_A);
                                @(negedge tb_signal_read_A);
                                #1;
                            end
                        end

                        begin : Interface_B
        	                reg [7:0] i;
                            reg [7:0] a, b;
                            reg [9:0] expected;

                            for(i = 0; i < 30; i++) begin
                                {a, b, expected} = get_testcase(i);

                                tb_valueB = b;
                                @(posedge tb_signal_read_B);
                                @(negedge tb_signal_read_B);
                            end
                        end

                        begin : out_check
        	                reg [7:0] i;
                            reg [7:0] a, b;
                            reg [9:0] expected;

                            for(i = 0; i < 30; i++) begin
                                {a, b, expected} = get_testcase(i);

                                @(out);
                                if(out != expected) begin
                                    $display("Wrong output: expected %d, got %d instead", expected, out);
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


    function automatic [25:0] get_testcase;
        input [4:0] i;

        reg [7:0] a, b;
        reg [9:0] expected_result;
        reg [4:0] j;

        begin
            if(i == 4) begin
                a = 0;
                b = 0;
            end
            else if(i == 6) begin
                a = 255;
                b = 255;
            end
            else begin
                a = (i + 10);
                b = (i + 10) * 2;

                //shuffle the values
                for(j = 0; j < i; j++)
                    {a, b} = {b, a};
            end

            expected_result = a + b;

            get_testcase = {a, b, expected_result};
        end
    endfunction
endmodule

// il modulo interface simula una interfaccia di ingresso parallela con handshake
// gli ingressi tb_* sono utilizzati dalla testbench per guidare lo stato dell'interfaccia
module interface_in_hs (
    ior_, s_, addr, data,
    tb_value, tb_fi, tb_signal_read, error
);
    input ior_; 
    input s_; 
    input addr; 
    inout [7:0] data;

    input [7:0] tb_value;
    input tb_fi;
    output tb_signal_read;

    output error;

    reg ERROR;
    assign error = ERROR;
    initial ERROR = 0;
    always @(posedge ERROR) #1
        ERROR = 0;
    
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
                        ERROR = 1;
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
    tb_value, tb_signal_read
);
    input ior_; 
    input s_; 
    output [7:0] data;

    input [7:0] tb_value;

    output tb_signal_read;
    
    reg DIR;

    reg [7:0] DATA;
    assign data = (DIR == 1) ? DATA : 8'hZZ;

    reg TB_SIGNAL_READ;
    assign tb_signal_read = TB_SIGNAL_READ;

    always @(*) if (s_==1 || ior_==1) begin
        DIR = 0;
        DATA = 8'bX;
        TB_SIGNAL_READ = 0;
    end

    always @(*) if (ior_==0 && s_==0) begin
        DIR = 1;
        DATA = tb_value;
        TB_SIGNAL_READ = 1;
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