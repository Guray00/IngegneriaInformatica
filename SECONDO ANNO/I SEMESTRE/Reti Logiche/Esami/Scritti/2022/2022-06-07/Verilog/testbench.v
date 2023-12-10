module testbench();
    wire clock;
    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg davA_, davB_;
    wire rfdA, rfdB;
    reg [7:0] dataA, dataB;
    wire out;

    ABC dut(
        .davA_(davA_), .rfdA(rfdA), .dataA(dataA),
        .davB_(davB_), .rfdB(rfdB), .dataB(dataB),
        .out(out),
        .clock(clock), .reset_(reset_)
    );

    // simulation variables
    reg [2:0] i, j;
    reg [7:0] next_value;

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
                //reset phase
                reset_ = 0; #(clk.HALF_PERIOD);
                
                //first posedge. as reset_ is set to 1, XXX starts the cycle from out = 0
                reset_ = 1;
                davA_ = 1; 
                davB_ = 1; 

                #(clk.HALF_PERIOD);
                //clock is at negative edge
                
                if(out !== 0)
                    $display("out is not 0 after reset");
                if(rfdA !== 1)
                    $display("rfdA is not 1 after reset");
                if(rfdB !== 1)
                    $display("rfdB is not 1 after reset");

                fork
                    begin: producerA
                        reg [5:0] i;
                        reg [7:0] a, b;

                        for (i = 0; i < 32; i++) begin
                            {a, b} = get_testcase(i[4:0]);
                            #(1*2*clk.HALF_PERIOD); 
                            dataA = a;
                            #(1*2*clk.HALF_PERIOD); 
                            davA_ = 0;
                            @(negedge rfdA);
                            #(1*2*clk.HALF_PERIOD); 
                            davA_ = 1;
                            @(posedge rfdA);
                        end
                    end

                    begin: producerB
                        reg [5:0] i;
                        reg [7:0] a, b;

                        for (i = 0; i < 32; i++) begin
                            {a, b} = get_testcase(i[4:0]);
                            #(3*2*clk.HALF_PERIOD); 
                            dataB = b;
                            #(1*2*clk.HALF_PERIOD); 
                            davB_ = 0;
                            @(negedge rfdB);
                            #(1*2*clk.HALF_PERIOD); 
                            davB_ = 1;
                            @(posedge rfdB);
                        end
                    end

                    begin: consumer
                        reg [5:0] i;
                        reg [7:0] a, b;

                        realtime prev_sample;
                        realtime current_sample;
                        realtime diff;

                        for (i = 0; i < 32; i++) begin
                            {a, b} = get_testcase(i[4:0]);
                            @(posedge out);
                            prev_sample = $realtime;
                            @(negedge out);
                            current_sample = $realtime;
                            diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                            if(b >= a) begin
                                if(diff != 12) begin
                                    error = 1;
                                    $display("Wrong timing: expected 12 clocks, got %g instead", diff);
                                end
                            end
                            else begin
                                if(diff != 6) begin
                                    error = 1;
                                    $display("Wrong timing: expected 6 clocks, got %g instead", diff);
                                end
                            end
                        end
                    end
                join

                disable f;
            end   
        join

        $finish;
    end

    // linea di errore, utile per il debug
    reg error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;

    function automatic [15:0] get_testcase;
        input [4:0] i;

        reg [7:0] a, b;
        
        begin
            a = ( ((i+5) * 19) % 100 ) / 10;
            b = ( ((i+5) * 19) % 100 ) % 10;
            get_testcase = {a, b};
        end
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