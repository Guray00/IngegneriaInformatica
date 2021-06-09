module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg eoc;
    wire soc;

    reg [7:0] x;
    wire [2:0] out;

    ABC dut (
        .x(x), .soc(soc), .eoc(eoc), .out(out),
        .clock(clock), .reset_(reset_)
    );

    // simulation variables
    reg [2:0] i, j;
    reg [7:0] next_value;

    realtime prev_sample;
    realtime current_sample;
    realtime diff;

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
                    prev_sample = 0;

                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;

                    if(soc !== 0)
                        $display("soc is not 0 after reset");
                    
                    for (i = 0; i < 5 ; i++ ) begin
                        // add i pairs of 0 using lshifts
                        next_value = 8'hFF;
                        for (j = 0; j < i ; j++ ) begin
                            next_value = next_value << 2;
                        end

                        @(posedge soc);
                        #(2*2*clk.HALF_PERIOD); 
                        eoc = 0;
                        @(negedge soc);
                        #(2*2*clk.HALF_PERIOD); 
                        x = next_value;
                        #(2*2*clk.HALF_PERIOD); 
                        eoc = 1;

                        @(out);
                        current_sample = $realtime;

                        if(out !== i)
                            $display("Wrong output: expected %d, got %d instead", i, out);

                        if(prev_sample != 0) begin
                            diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                            if( diff != 20 )
                                $display("Wrong timing: expected 20 clocks, got %g instead", diff);
                        end
                        prev_sample = current_sample;
                    end

                    #10;
                    disable f;
                end
            join

            $finish;
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