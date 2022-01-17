module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg s;
    reg [6:0] h;
    reg dav_;
    wire rfd;
    wire [7:0] out;
    
    ABC dut (
        .s(s), .h(h), .rfd(rfd), .dav_(dav_), .out(out),
        .clock(clock), .reset_(reset_)
    );

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
                    dav_ = 1;

                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;

                    if(rfd !== 0)
                        $display("rfd is not 0 after reset");

                    if(out !== 8'h80)
                        $display("v(t) is not 0 after reset");

                    fork
                        //Produttore
                        begin : producer
                            reg [5:0] i;
                            
                            for (i = 2; i < 32; i++) begin
                                @(posedge rfd);
                                #(1*2*clk.HALF_PERIOD); 
                                {s, h} = get_testcase(i[4:0]);
                                #(1*2*clk.HALF_PERIOD); 
                                dav_ = 0;
                                @(negedge rfd);
                                #(1*2*clk.HALF_PERIOD); 
                                dav_ = 1;
                                {s, h} = 8'hXX;
                            end
                        end

                        //Convertitore D/A
                        begin : converter
                            reg [5:0] i;
                            reg [7:0] j;
                            reg c_s;
                            reg [6:0] c_h;
                            reg [7:0] expected;

                            realtime prev_sample;
                            realtime current_sample;
                            realtime diff;

                            for (i = 2; i < 32; i++) begin
                                {c_s, c_h} = get_testcase(i[4:0]);

                                expected = 8'h80;
                                prev_sample = 0;

                                for(j = c_h - 1; j <= c_h; j--) begin
                                    if(c_s == 0)
                                        expected = expected + 1;
                                    else
                                        expected = expected - 1;

                                    @(out);
                                    current_sample = $realtime;

                                    if(out !== expected)
                                        $display("Test %g.%g failed, expected %h, got %h", i, j, expected, out);

                                    if(prev_sample != 0) begin
                                        diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                                        if( diff != 1 )
                                            $display("Wrong timing: expected 1 clocks, got %g instead", diff);
                                    end
                                    prev_sample = current_sample;                                    
                                end

                                // last step: go back to rest
                                @(out);
                                if(out !== 8'h80)
                                    $display("v(t) is not 0 at rest");
                                current_sample = $realtime;
                                diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                                if( diff != 1 )
                                    $display("Wrong timing: expected 1 clocks, got %g instead", diff);
                            end
                        end
                    join

                    disable f;
                end
            join

            $finish;
        end

    function automatic [7:0] get_testcase;
        input [4:0] i;

        reg s;
        reg [6:0] h;

        begin
            {s, h} = {i[0], 2'b0, i};
            get_testcase = {s, h};
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