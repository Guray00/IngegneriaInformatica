// Made with <3 by Aleandro Prudenzano

module testbench();
    wire clock;
    wire dir;
    wire data;

    reg reset_;
    reg DATA;
    assign data = (dir == 0) ? DATA : 'HZ;

    clock_generator clk(clock);
    XXX dut(
        .reset_(reset_), .clock(clock),
        .dir(dir), .data(data)
    );

    //Simulation vars
    integer readedData;
    integer expectedData;
    integer i;
    integer j;
    integer waitTime;

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            fork : f
                begin
                    #100000;
                    $display("Timeout - waiting for too long");
                    disable f;
                end
                begin
                    readedData = 0;
                    DATA = 1;

                    // Reset
                    reset_ = 0; #(clk.HALF_PERIOD);

                    if(dir != 0)
                        $display("dir is not 0 at reset");

                    reset_ = 1;

                    for (i = 0; i < 300 ; i++) begin
                        readedData = 0;
                        expectedData = i%256;
                        waitTime = (i%10) + 1;   // wait from 1 to 10 clock cycles

                        while(dir != 1) begin
                            //Wait for DIR posedge
                            #1;
                        end

                        DATA = 0;

                        for(j = 0; j < 8; j++) begin
                            #(clk.HALF_PERIOD);
                            //Sample at half bit time
                            readedData |= (data << j);
                            #(clk.HALF_PERIOD);
                        end

                        if(readedData != expectedData) begin
                            $display("Readed %d, expected %d", readedData, expectedData);
                            $finish;
                        end

                        //Wait arbitrary time before ack
                        #(waitTime*2*clk.HALF_PERIOD);
                        DATA = 1;
                    end
                    $display("Everything is working afaik");
                    disable f;
                end
            join
            $finish;
        end
endmodule

module clock_generator(clock);
    output clock;
    parameter HALF_PERIOD = 5;

    reg CLOCK;      assign clock = CLOCK;

    initial
        CLOCK <= 0;

    always #HALF_PERIOD CLOCK = ~CLOCK;
endmodule