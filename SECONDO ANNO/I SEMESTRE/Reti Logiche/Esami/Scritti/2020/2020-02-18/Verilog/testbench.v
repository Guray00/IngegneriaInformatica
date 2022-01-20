module testbench();

    reg reset_;
    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg eoc;
    reg [7:0] numero;
    wire soc, out;

    XXX dut (
        .numero(numero), .eoc(eoc), .reset_(reset_), .clock(clock),
        .out(out), .soc(soc)
    );

    // simulation variables, used to measure time distances
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
                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge. as reset_ is set to 1, XXX starts the cycle from out = 0
                    reset_ = 1;
                    eoc = 1; 
                    prev_sample = $realtime;

                    #(clk.HALF_PERIOD);
                    //clock is at negative edge

                    if(out !== 0)
                        $display("out is not 0 after reset");

                    @(posedge out);
                    prev_sample = current_sample;
                    current_sample = $realtime;
                    diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                    if(diff < 5 || diff > 6)    // need some leeway around reset
                        $display("0-cycle of 6 failed: %g", diff);

                    @(posedge soc);
                    eoc = 0;
                    @(negedge soc);
                    numero = 10; eoc = 1;

                    @(negedge out);
                    prev_sample = current_sample;
                    current_sample = $realtime;
                    diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                    if(diff != 6)
                        $display("1-cycle of 6 failed: %g", diff);

                    @(posedge out);
                    prev_sample = current_sample;
                    current_sample = $realtime;
                    diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                    if(diff != 10)
                        $display("0-cycle of 10 failed: %g", diff);

                    @(posedge soc);
                    eoc = 0;
                    @(negedge soc);
                    numero = 25; eoc = 1;

                    @(negedge out);
                    prev_sample = current_sample;
                    current_sample = $realtime;
                    diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                    if(diff != 10)
                        $display("1-cycle of 10 failed: %g", diff);

                    @(posedge out);
                    prev_sample = current_sample;
                    current_sample = $realtime;
                    diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                    if(diff != 25)
                        $display("0-cycle of 25 failed: %g", diff);

                    @(posedge soc);
                    eoc = 0;
                    @(negedge soc);
                    numero = 15; eoc = 1;

                    @(negedge out);
                    prev_sample = current_sample;
                    current_sample = $realtime;
                    diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                    if(diff != 25)
                        $display("1-cycle of 25 failed: %g", diff);

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
