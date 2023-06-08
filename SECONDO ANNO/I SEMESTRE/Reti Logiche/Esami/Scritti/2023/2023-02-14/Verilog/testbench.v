module testbench();
    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    wire [7:0] x;
    reg ok, eoc;

    wire [15:0] addr;
    wire ior_, iow_;
    wire [7:0] data;

    ABC dut(
        .x(x), .ok(ok), .soc(soc), .eoc(eoc),
        .addr(addr), .data(data), .ior_(ior_), .iow_(iow_),
        .reset_(reset_), .clock(clock)
    );

    // i select e addr sono ritardati e ballanti cosicché le corse critiche vadano sempre male :)
    reg s_b_, a;
    always @(addr) begin
        {s_b_, a} = 'bX;
        #1; 
        a = addr[0];
        #1; 
        s_b_ = !({addr[15:1],1'b0} == 16'h0ABC);
    end
    
    wire [7:0] tb_outvalue;
    reg tb_fo;
    wire io_B_error;

    io_out_hs B(
        .iow_(iow_), .ior_(ior_), .s_(s_b_), .addr(a), .data(data),
        .tb_outvalue(tb_outvalue), .tb_fo(tb_fo), .tb_error(io_B_error)
    );

    wire io_CA_error;
    wire s_catch_all_;
    assign s_catch_all_ = ~(s_b_ === 1'b1 | s_b_ === 1'bX);

    io_catch_all io_CA(
        .iow_(iow_), .ior_(ior_), .s_(s_catch_all_),
        .tb_error(io_CA_error)
    );

    localparam nice_byte = 8'h1A;
    
    reg error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        //the following structure is used to wait for expected signals, and fail if too much time passes
        fork : f
            begin
                #100000;
                $display("Timeout - waiting for signal failed");
                disable f;
            end
        //actual tests start here
            begin
                eoc = 1; ok = 0;
                tb_fo = 0;

                //reset phase
                reset_ = 0; #(clk.HALF_PERIOD);

                //first posedge
                reset_ = 1;

                if(soc !== 0) begin
                    $display("soc is not 0 after reset");
                    error = 1;
                end

                fork
                    begin : A
                        reg [7:0] sampled_byte;
                        while(1) begin
                            @(posedge soc);
                            sampled_byte = x;
                            #4;
                            eoc = 0;
                            if(sampled_byte == nice_byte) begin
                                ok = 1;
                            end
                            @(negedge soc);
                            #4;
                            eoc = 1;
                        end
                    end

                    begin : B
                        while(1) begin
                            #1800;
                            tb_fo = 1;
                            @(tb_outvalue);
                            if(tb_outvalue !== nice_byte) begin
                                $display("Wrong byte: expected %h, is %h", nice_byte, tb_outvalue);
                                error = 1;
                            end
                            else
                                // $display("Correct byte transmitted.");
                                #10;
                                disable f;
                            tb_fo = 0;
                        end
                    end
                join
            end
        join

        $finish;
    end

endmodule

// il modulo io_out_hs simula una interfaccia parallela di uscita con handshake
// gli ingressi tb_* sono utilizzati dalla testbench per guidare e controllare lo stato dell'interfaccia
module io_out_hs (
    iow_, ior_, s_, addr, data,
    tb_outvalue, tb_fo, tb_error
);
    input iow_; 
    input ior_; 
    input s_; 
    input addr;
    inout [7:0] data;

    input tb_fo;
    output [7:0] tb_outvalue;
    output tb_error;
    
    reg [7:0] TB_OUTVALUE;
    assign tb_outvalue = TB_OUTVALUE;    
    
    reg DIR;
    reg [7:0] DATA;
    assign data = (DIR == 1) ? DATA : 8'hZZ;

    reg error; assign tb_error = error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;

    always @(*) if (s_==1 || ior_==1)
        DIR = 0;

    always @(*) if (ior_==0 && s_==0)
        begin
            casex(addr)
                1'b0: begin
                    DIR = 1;
                    DATA = { 2'b0, tb_fo, 5'b0 };
                end
                1'b1: begin
                    $display("Read access to TBR!");
                    error = 1;
                end
            endcase
        end
        
    always @(*) if (iow_==0 && s_==0) begin
        casex(addr) 
            1'b0: begin
               $display("Write access to TSR!");
               error = 1;
            end
            1'b1: begin
                if(tb_fo != 1) begin
                    $display("Write access while FO is 0!");
                    error = 1;
                end                    
                else begin
                    TB_OUTVALUE = data;
                    DIR = 0;
                end
            end
        endcase
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