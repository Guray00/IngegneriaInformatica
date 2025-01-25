module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    wire [15:0] addr;
    wire s_;
    MASK m(
        .addr(addr[15:2]), .s_(s_)
    ); 

    wire [7:0] data;
    wire ior_, iow_;

    // testbench-interface inputs
    reg [7:0] tb_invalue;
    reg tb_fi;
    wire signed [7:0] tb_outvalue;

    interface int_a(
        .iow_(iow_), .ior_(ior_), .s_(s_), .addr(addr[1:0]), .data(data),
        .tb_invalue(tb_invalue), .tb_outvalue(tb_outvalue), .tb_fi(tb_fi)
    );

    reg reset_;
    wire [6:0] out;
    
    ABC dut (
        .iow_(iow_), .ior_(ior_), .addr(addr), .data(data),
        .reset_(reset_), .clock(clock)
    );

    // simulation variables
    reg [5:0] i;
    integer expected;
    reg sign;
    reg [2:0] c1, c0;

    initial
        begin
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
                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;
                    tb_fi = 0;

                    #(clk.HALF_PERIOD);
                    //clock is at negative edge

                    for(i = 0; i < 30; i++)
                        begin
                            tb_fi = 0;
                            tb_invalue = 0;

                            #(16*clk.HALF_PERIOD);

                            sign = i[0]; 
                            c1 = (i + 3) / 6;
                            c0 = (i + 3) % 6;
                            expected = (sign == 1) ? -(c1 * 6 + c0) : (c1 * 6 + c0);                           
                            
                            tb_invalue = { 1'b0, sign, c1, c0 };
                            tb_fi = 1;

                            @(tb_outvalue);
                            if(tb_outvalue != expected)
                                $display("%g-th out is not %g, %g instead", i, expected, tb_outvalue);
                        end

                    disable f;
                end   
            join

            $finish;
        end

endmodule

// il modulo interface simula una interfaccia parallela con handshake
// gli ingressi tb_* sono utilizzati dalla testbench per guidare
// e controllare lo stato dell'interfaccia
module interface (
    iow_, ior_, s_, addr, data,
    tb_invalue, tb_outvalue, tb_fi 
);
    input iow_; 
    input ior_; 
    input s_; 
    input [1:0] addr; 
    inout [7:0] data;

    input [7:0] tb_invalue;
    input tb_fi;
    output [7:0] tb_outvalue;

    reg [7:0] TB_OUTVALUE;
    assign tb_outvalue = TB_OUTVALUE;    
    
    reg DIR;

    reg [7:0] DATA;
    assign data = (DIR == 1) ? DATA : 8'hZZ;

    always @(*) if (s_==1 || ior_==1)
        DIR = 0;

    always @(*) if (ior_==0 && s_==0)
        begin
            DIR = 1;
            casex(addr)
                2'b00:
                    DATA = { 7'b0, tb_fi };
                2'b01:
                    DATA = tb_invalue;
                2'b10:
                    DATA = 8'bX;
                2'b11:
                    DATA = 8'bX;
            endcase
        end
        
    always @(*) if (iow_==0 && s_==0 && addr==2'b11 )
        begin
            TB_OUTVALUE = data;
            DIR = 0;
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