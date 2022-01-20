module testbench();

    reg reset_;
    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg dav_;
    reg [1:0] numero;
    wire rfd, out;

    XXX dut (
        .numero(numero), .dav_(dav_), .reset_(reset_), .clock(clock),
        .out(out), .rfd(rfd)
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
                    dav_ = 1; 

                    #(clk.HALF_PERIOD);
                    //clock is at negative edge
                    
                    if(out !== 0)
                        $display("out is not 0 after reset");
                    if(rfd !== 1)
                        $display("rfd is not 1 after reset");

                    numero = 2'B00; dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            numero = 2'B01; dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(posedge out);
                            prev_sample = $realtime;
                            @(negedge out);
                            current_sample = $realtime;

                            diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                            if(diff != 2)
                                $display("1-cycle of 2 failed: %g", diff);                             
                        end
                    join

                    numero = 2'B01; dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            numero = 2'B10; dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(posedge out);
                            prev_sample = $realtime;
                            @(negedge out);
                            current_sample = $realtime;

                            diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                            if(diff != 4)
                                $display("1-cycle of 4 failed: %g", diff);                             
                        end
                    join

                    numero = 2'B10; dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            numero = 2'B11; dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(posedge out);
                            prev_sample = $realtime;
                            @(negedge out);
                            current_sample = $realtime;

                            diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                            if(diff != 6)
                                $display("1-cycle of 6 failed: %g", diff);                             
                        end
                    join

                    numero = 2'B11; dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            numero = 2'B00; dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(posedge out);
                            prev_sample = $realtime;
                            @(negedge out);
                            current_sample = $realtime;

                            diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                            if(diff != 8)
                                $display("1-cycle of 8 failed: %g", diff);                             
                        end
                    join

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