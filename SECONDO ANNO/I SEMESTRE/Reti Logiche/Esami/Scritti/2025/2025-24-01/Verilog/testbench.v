module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    wire soc1, soc2;
    reg eoc1, eoc2;
    reg [7:0] x1, x2;

    wire dav_;
    reg rfd;
    wire [15:0] result;
    
    ABC dut (
        .soc1(soc1), .eoc1(eoc1), .x1(x1), 
        .soc2(soc2), .eoc2(eoc2), .x2(x2), 
        .out(out),
        .clock(clock), .reset_(reset_)
    );

    // Linea di errore per debug
    reg error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;

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
                    eoc1 = 1; eoc2 = 1;

                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;

                    if(soc1 !== 0)
                        $display("soc1 is not 0 after reset");

                    if(soc2 !== 0)
                        $display("soc2 is not 0 after reset");

                    if(out !== 0)
                        $display("out is not 0 after reset");

                    fork
                        //AD converter #1
                        begin : producer_1
                            reg [4:0] i;
                            reg [7:0] v1, v2;
                            reg [7:0] expected_result;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, expected_result} = get_testcase(i);
                                
                                @(posedge soc1);
                                x1 = 8'bX;
                                #(1*2*clk.HALF_PERIOD); 
                                eoc1 = 0;
                                @(negedge soc1);
                                #(1*2*clk.HALF_PERIOD); 
                                x1 = v1;
                                #(1 + 1*2*clk.HALF_PERIOD); 
                                eoc1 = 1;    
                            end
                        end
                        //AD converter #2
                        begin : producer_2
                            reg [4:0] i;
                            reg [7:0] v1, v2;
                            reg [7:0] expected_result;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, expected_result} = get_testcase(i);
                                
                                @(posedge soc2);
                                x2 = 8'bX;
                                #(2*2*clk.HALF_PERIOD); 
                                eoc2 = 0;
                                @(negedge soc2);
                                #(2*2*clk.HALF_PERIOD); 
                                x2 = v2;
                                #(1 + 1*2*clk.HALF_PERIOD); 
                                eoc2 = 1;      
                            end
                        end
                        //Consumer
                        begin : consumer
                            reg [4:0] i;
                            reg [7:0] v1, v2;
                            reg [7:0] expected_result;

                            realtime t_start;
                            realtime t_end;
                            realtime diff;

                            for (i = 0; i < 16; i++) begin
                                {v1, v2, expected_result} = get_testcase(i);

                                if(expected_result == 0) begin
                                    // do nothing
                                end
                                else begin
                                    @(posedge out);
                                    t_start = $realtime;
                                    @(negedge out);
                                    t_end = $realtime;

                                    diff = (t_end - t_start)/(2*clk.HALF_PERIOD);

                                    if(diff != expected_result) begin
                                        $display("Wrong output: expected %d, got %d instead", expected_result, diff);
                                        error = 1;
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

    function automatic [23:0] get_testcase;
        input [4:0] i;

        reg [7:0] v1, v2;
        reg [7:0] expected_result;
        reg [4:0] j;

        begin
            if(i == 4) begin
                v1 = 0;
                v2 = 0;
            end
            else begin
                v1 = (i + 10);
                v2 = (i + 10) * 2;

                //shuffle the values
                for(j = 0; j < i; j++)
                    {v1, v2} = {v2, v1};
            end

            expected_result = (v1 + v2) / 2;

            get_testcase = {v1, v2, expected_result};
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