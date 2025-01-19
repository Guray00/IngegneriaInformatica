// Testbench rivista per risolvere i problemi con soluzioni che svolgono concorrentemente
// gli handshake con i produttori e il consumatore.

module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    wire soc1, soc2, soc3;
    reg eoc1, eoc2, eoc3;
    reg [7:0] x1, x2, x3;

    wire dav_;
    reg rfd;
    wire [15:0] result;
    
    ABC dut (
        .soc1(soc1), .eoc1(eoc1), .x1(x1), 
        .soc2(soc2), .eoc2(eoc2), .x2(x2), 
        .soc3(soc3), .eoc3(eoc3), .x3(x3), 
        .dav_(dav_), .rfd(rfd), .result(result), 
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

                    if(soc1 !== 0)
                        $display("soc1 is not 0 after reset");

                    if(soc2 !== 0)
                        $display("soc2 is not 0 after reset");

                    if(soc3 !== 0)
                        $display("soc3 is not 0 after reset");

                    if(dav_ !== 1)
                        $display("dav_ is not 1 after reset");

                    fork
                        //AD converter #1
                        begin : producer_1
                            reg [4:0] i;
                            reg [7:0] v1, v2, v3;
                            reg [15:0] expected_result;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, v3, expected_result} = get_testcase(i);
                                
                                @(posedge soc1);
                                #(1*2*clk.HALF_PERIOD); 
                                eoc1 = 0;
                                @(negedge soc1);
                                #(1*2*clk.HALF_PERIOD); 
                                x1 = v1;
                                #(1*2*clk.HALF_PERIOD); 
                                eoc1 = 1;    
                            end
                        end
                        //AD converter #2
                        begin : producer_2
                            reg [4:0] i;
                            reg [7:0] v1, v2, v3;
                            reg [15:0] expected_result;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, v3, expected_result} = get_testcase(i);
                                
                                @(posedge soc2);
                                #(2*2*clk.HALF_PERIOD); 
                                eoc2 = 0;
                                @(negedge soc2);
                                #(2*2*clk.HALF_PERIOD); 
                                x2 = v2;
                                #(2*2*clk.HALF_PERIOD); 
                                eoc2 = 1;      
                            end
                        end
                        //AD converter #3
                        begin : producer_3
                            reg [4:0] i;
                            reg [7:0] v1, v2, v3;
                            reg [15:0] expected_result;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, v3, expected_result} = get_testcase(i);
                                
                                @(posedge soc3);
                                #(3*2*clk.HALF_PERIOD); 
                                eoc3 = 0;
                                @(negedge soc3);
                                #(3*2*clk.HALF_PERIOD); 
                                x3 = v3;
                                #(3*2*clk.HALF_PERIOD); 
                                eoc3 = 1;      
                            end
                        end
                        //Consumer
                        begin : consumer
                            reg [4:0] i;
                            reg [7:0] v1, v2, v3;
                            reg [15:0] expected_result;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, v3, expected_result} = get_testcase(i);

                                @(negedge dav_);
                                if(result !== expected_result)
                                    $display("Test #%g failed, expected %g, got %g", i, expected_result, result);
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

    function automatic [44:0] get_testcase;
        input [4:0] i;

        reg [7:0] v1, v2, v3;
        reg [15:0] expected_result;
        reg [4:0] j;

        begin
            if(i < 15) begin
                v1 = (i + 10);
                v2 = (i + 10) * 2;
                v3 = (i + 10) * 3;

                //shuffle the values
                for(j = 0; j < i; j++)
                    {v1, v2, v3} = {v2, v3, v1};
            end
            else begin
                v1 = 255;
                v2 = 255;
                v3 = 255;
            end

            expected_result = 5*(v1 + 3*v2) + v3;

            get_testcase = {v1, v2, v3, expected_result};
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