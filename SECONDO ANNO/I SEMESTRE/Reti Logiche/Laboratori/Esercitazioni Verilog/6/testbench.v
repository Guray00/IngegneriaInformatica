module testbench();

    reg reset_;
    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg eoc;
    reg [7:0] numero;
    wire soc, out;

    ABC dut (
        .numero(numero), .eoc(eoc), .reset_(reset_), .clock(clock),
        .out(out), .soc(soc)
    );

    // simulation variables, used to measure time distances
    realtime prev_sample;
    realtime current_sample;
    realtime diff;

    // Debug variable, used to highlight points on the waveform
    reg error;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
        error = 0;

        //the following structure is used to wait for expected signals, and fail if too much time passes
        fork : f
            begin
                #100000;
                $display("Timeout - waiting for signal failed");
                disable f;
            end
        //actual tests start here
            begin: test
                //reset phase
                reset_ = 0; #(clk.HALF_PERIOD);
                
                //first posedge. as reset_ is set to 1, ABC starts the cycle from out = 0
                reset_ = 1;
                eoc = 1; 
                prev_sample = $realtime;

                #(clk.HALF_PERIOD);
                //clock is at negative edge

                if(out !== 0)
                    $display("out is not 0 after reset");

                fork
                    begin: producer
                        reg [5:0] i;
                        reg [7:0] n;

                        for (i = 0; i < 32; i++) begin
                            n = get_testcase(i[4:0]);

                            @(posedge soc);
                            numero = 8'bX; #1;
                            eoc = 0;                            
                            @(negedge soc);
                            numero = n; #1;
                            eoc = 1;
                        end

                        //last handshake, whose result is not tested
                        @(posedge soc);
                        eoc = 0;
                        @(negedge soc);
                        eoc = 1;
                    end

                    begin: consumer
                        reg [5:0] i;
                        reg [7:0] n;
                        
                        //first time: reset value, 6
                        @(posedge out);
                        prev_sample = current_sample;
                        current_sample = $realtime;
                        diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                        // need some leeway around reset
                        if(diff < 5 || diff > 7) begin
                            $display("0-cycle of 6 failed: %g", diff);
                            error = 1;
                        end
                        @(negedge out);
                        prev_sample = current_sample;
                        current_sample = $realtime;
                        diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                        if(diff != 6) begin
                            $display("1-cycle of 6 failed: %g", diff);
                            error = 1;
                        end

                        for (i = 0; i < 32; i++) begin
                            n = get_testcase(i[4:0]);

                            @(posedge out);
                            prev_sample = current_sample;
                            current_sample = $realtime;
                            diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                            if(diff != n) begin
                                $display("0-cycle of %d failed: %g", n, diff);
                                error = 1;
                            end        
                            @(negedge out);
                            prev_sample = current_sample;
                            current_sample = $realtime;
                            diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                            if(diff != n) begin
                                $display("1-cycle of %d failed: %g", n, diff);
                                error = 1;
                            end
                        end
                    end
                join

                #10;
                disable f;
            end   
        join

        $finish;
    end

    always @(posedge error) #1
        error = 0;

    function automatic [7:0] get_testcase;
        input [4:0] i;

        begin
            get_testcase = {i, 2'd3, i[0]}; // min. value is 6
        end
    endfunction

endmodule

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
