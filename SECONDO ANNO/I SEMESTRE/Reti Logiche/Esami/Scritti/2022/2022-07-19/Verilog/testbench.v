module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    wire soc;
    reg eoc1, eoc2, eoc3, eoc4;
    reg [7:0] x1, x2, x3, x4;

    wire dav_;
    reg rfd;
    wire [7:0] avg;
    
    ABC dut (
        .soc(soc), .eoc1(eoc1), .x1(x1), .eoc2(eoc2), .x2(x2), .eoc3(eoc3), .x3(x3), .eoc4(eoc4), .x4(x4),
        .dav_(dav_), .rfd(rfd), .avg(avg), 
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
                    eoc1 = 1; eoc2 = 1; eoc3 = 1;
                    rfd = 1;

                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;

                    if(soc !== 0)
                        $display("soc is not 0 after reset");

                    if(dav_ !== 1)
                        $display("dav_ is not 1 after reset");

                    fork
                        //AD converter #1
                        begin : producer_1
                            reg [4:0] i;
                            reg [7:0] v1, v2, v3, v4, expected_avg;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, v3, v4, expected_avg} = get_testcase(i);
                                
                                @(posedge soc);
                                #(1*2*clk.HALF_PERIOD); 
                                eoc1 = 0;
                                @(negedge soc);
                                #(1*2*clk.HALF_PERIOD); 
                                x1 = v1;
                                #(1*2*clk.HALF_PERIOD); 
                                eoc1 = 1;    
                            end
                        end
                        //AD converter #2
                        begin : producer_2
                            reg [4:0] i;
                            reg [7:0] v1, v2, v3, v4, expected_avg;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, v3, v4, expected_avg} = get_testcase(i);
                                
                                @(posedge soc);
                                #(2*2*clk.HALF_PERIOD); 
                                eoc2 = 0;
                                @(negedge soc);
                                #(2*2*clk.HALF_PERIOD); 
                                x2 = v2;
                                #(2*2*clk.HALF_PERIOD); 
                                eoc2 = 1;
                            end
                        end
                        //AD converter #3
                        begin : producer_3
                            reg [4:0] i;
                            reg [7:0] v1, v2, v3, v4, expected_avg;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, v3, v4, expected_avg} = get_testcase(i);
                                
                                @(posedge soc);
                                #(3*2*clk.HALF_PERIOD); 
                                eoc3 = 0;
                                @(negedge soc);
                                #(3*2*clk.HALF_PERIOD); 
                                x3 = v3;
                                #(3*2*clk.HALF_PERIOD); 
                                eoc3 = 1;
                            end
                        end
                        //AD converter #4
                        begin : producer_4
                            reg [4:0] i;
                            reg [7:0] v1, v2, v3, v4, expected_avg;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, v3, v4, expected_avg} = get_testcase(i);
                                
                                @(posedge soc);
                                #(4*2*clk.HALF_PERIOD); 
                                eoc4 = 0;
                                @(negedge soc);
                                #(4*2*clk.HALF_PERIOD); 
                                x4 = v4;
                                #(4*2*clk.HALF_PERIOD); 
                                eoc4 = 1;
                            end
                        end
                        //Consumer
                        begin : consumer
                            reg [4:0] i;
                            reg [7:0] v1, v2, v3, v4, expected_avg;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, v3, v4, expected_avg} = get_testcase(i);

                                @(negedge dav_);
                                if(avg !== expected_avg) begin
                                    $display("Test #%g failed, expected %g, got %g", i, expected_avg, avg);
                                    error = 1;
                                end
                                #(2*clk.HALF_PERIOD); rfd = 0;
                                @(posedge dav_);
                                #(2*clk.HALF_PERIOD); rfd = 1;
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

    function automatic [39:0] get_testcase;
        input [4:0] i;

        reg [7:0] v1, v2, v3, v4, expected_avg;
        reg [9:0] sum;
        reg [4:0] j;

        begin
            v1 = (i + 10);
            v2 = (i + 10) * 2;
            v3 = (i + 10) * 3;
            v4 = (i + 10) * 4;

            //shuffle the values
            for(j = 0; j < i; j++)
                {v1, v2, v3, v4} = {v2, v3, v4, v1};

            sum = v1 + v2 + v3 + v4;
            expected_avg = sum[9:2];

            get_testcase = {v1, v2, v3, v4, expected_avg};
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