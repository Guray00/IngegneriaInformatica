module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    wire [7:0] addr;
    wire [3:0] data;
    wire s_, mr_;

    eprom_256x4 eprom(
        .addr(addr), .s_(s_), .mr_(mr_),
        .data(data)
    );

    reg reset_;
    wire [6:0] out;
    
    ABC dut (
        .data(data), .reset_(reset_), .clock(clock),
        .out(out), .addr(addr), .s_(s_), .mr_(mr_)
    );

    // simulation variables
    realtime prev_sample;
    realtime current_sample;
    realtime diff;

    integer i;
    reg [6:0] v;
    reg [6:0] t;

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
                    
                    //first posedge. as reset_ is set to 1, ABC starts the cycle from V_i = 0, T_i = 99
                    reset_ = 1;
                    
                    prev_sample = $realtime;

                    #(clk.HALF_PERIOD);
                    //clock is at negative edge

                    if(out !== 0)
                        $display("out is not 0 after reset");

                    @(out);
                    prev_sample = current_sample;
                    current_sample = $realtime;
                    diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                    if(diff < 98 || diff > 99)    // need some leeway around reset
                        $display("reset-cycle of 99 failed: %g", diff);

                    for(i = 0; i < 64; i++)
                        begin
                            // compute next v and t, according to relation used in test eprom
                            v = ((i + 1) %10) * 10 + ((i + 1) % 10);
                            t = ((i % 9) + 1) * 10 + (i % 10);

                            if(out !== v)
                                $display("%g-th out is not %g, %g instead", i, v, out);

                            @(out)  //wait for next value change
                            prev_sample = current_sample;
                            current_sample = $realtime;
                            diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                            if(diff != t)    // need some leeway around reset
                                $display("%g-th value was not held for %g cycles, %g instead", i, t, diff);
                        end

                    

                    disable f;
                end   
            join

            $finish;
        end

endmodule

// il modulo eprom_256x4 simula una eprom con una funzione nota tra ingresso e uscita
// tale funzione è usata per verificare il comportamento della rete potendo calcolare a priori cosa dovrebbe fare 
module eprom_256x4 (
    addr, s_, mr_,
    data
);
    input [7:0] addr;
    input s_, mr_;

    output [3:0] data;

    wire [5:0] i; 
    wire [1:0] offset;
    
    assign i = addr[7:2];
    assign offset = addr[1:0];  

    assign #1 data = ((s_ !== 0) || (mr_ !== 0)) ? 4'Bz : f(i, offset);

    function [3:0] f;
        input [5:0] i; 
        input [1:0] offset;
         
        casex(offset)
            0: f = (i + 1) % 10;    // V_i_0
            1: f = (i + 1) % 10;    // V_i_1
            2: f = i % 10;          // T_i_0
            3: f = (i % 9) + 1;     // T_i_1
        endcase
    endfunction

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