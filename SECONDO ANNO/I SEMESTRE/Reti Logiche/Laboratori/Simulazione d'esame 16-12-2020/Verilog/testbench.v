module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg rxd;
    wire out;
    
    ABC dut (
        .out(out), .rxd(rxd), .clock(clock), .reset_(reset_)
    );

    // simulation variables
    reg [4:0] i;    //larger to allow overlflow and quit the for loop
    integer b;

    integer count_edges;
    integer count_length;

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
                    count_edges = 0;
                    count_length = 0;

                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;
                    rxd = 0;

                    #(clk.HALF_PERIOD);
                    //clock is at negative edge

                    for(i = 0; i < 16; i++)
                        begin
                            for (b = 3; b >= 0; b-- ) 
                                begin
                                    #(8*clk.HALF_PERIOD);

                                    if(i[b] == 1)
                                        begin
                                            rxd = 1;
                                            #(10*2*clk.HALF_PERIOD);
                                        end
                                    else   
                                        begin
                                            rxd = 1;
                                            #(5*2*clk.HALF_PERIOD);
                                        end
                                    
                                    rxd = 0;
                                end

                            #(30*clk.HALF_PERIOD);
                        end

                    if(count_edges != 4)
                        $display("Incorrect count of out posedges. Expected 4, is %g", count_edges);

                    if(count_length != 4)
                        $display("Incorrect total length of out=1. Expected 4, is %g", count_length);

                    disable f;
                end
            join

            $finish;
        end

    // counting processes
    always @(posedge out)
        count_edges = count_edges + 1;

    always @(posedge clock) if (out == 1)
        count_length = count_length + 1;

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