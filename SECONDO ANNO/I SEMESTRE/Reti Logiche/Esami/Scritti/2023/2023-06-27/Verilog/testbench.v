module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    wire rfd_x, rfd_y;
    reg dav_x, dav_y;
    reg [7:0] x, y;

    wire out;
    
    ABC dut (
        .rfd_x(rfd_x), .rfd_y(rfd_y), .dav_x(dav_x), .x(x), .dav_y(dav_y), .y(y),
        .out(out), 
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
                    dav_x = 1; dav_y = 1;

                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;

                    if(rfd_x !== 1)
                        $display("rfd_x is not 1 after reset");
                
                    if(rfd_y !== 1)
                        $display("rfd_y is not 1 after reset");

                    if(out !== 0)
                        $display("out is not 0 after reset");

                    fork
                        //Produttore X
                        begin : producer_x
                            reg [5:0] i;
                            reg [7:0] t_x, t_y, t_z;

                            for (i = 0; i < 32; i++) begin
                                {t_x, t_y, t_z} = get_testcase(i[4:0]);
                                
                                #(3*2*clk.HALF_PERIOD);
                                x = t_x;
                                #(1*2*clk.HALF_PERIOD);
                                dav_x = 0;
                                @(negedge rfd_x);
                                #(3*2*clk.HALF_PERIOD);
                                dav_x = 1;
                                x = 8'hXX;
                                @(posedge rfd_x);
                            end
                        end

                        //Produttore Y
                        begin : producer_y
                            reg [5:0] i;
                            reg [7:0] t_x, t_y, t_z;

                            for (i = 0; i < 32; i++) begin
                                {t_x, t_y, t_z} = get_testcase(i[4:0]);
                                
                                #(2*3*2*clk.HALF_PERIOD);
                                y = t_y;
                                #(2*1*2*clk.HALF_PERIOD);
                                dav_y = 0;
                                @(negedge rfd_y);
                                #(2*3*2*clk.HALF_PERIOD);
                                dav_y = 1;
                                y = 8'hXX;
                                @(posedge rfd_y);
                            end
                        end

                        //Consumer
                        begin : consumer
                            reg [5:0] i;
                            reg [7:0] t_x, t_y, t_z;
                            
                            realtime sample_pe;
                            realtime sample_ne;
                            realtime diff;

                            for (i = 0; i < 32; i++) begin
                                {t_x, t_y, t_z} = get_testcase(i[4:0]);

                                @(posedge out);
                                sample_pe = $realtime;
                                @(negedge out);
                                sample_ne = $realtime;

                                diff = (sample_ne - sample_pe)/(2*clk.HALF_PERIOD);

                                if(diff != t_z)
                                    $display("Test #%g failed, expected %g, got %g", i, t_z, diff);
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

        reg [7:0] x, y, z;
        
        begin
            if( i[0] == 1) begin
                x = (i[4:2] + 4) * 3;
                y = (i[1:0] + 1) * 5;
            end
            else begin
                x = (i[1:0] + 1) * 5;
                y = (i[4:2] + 4) * 3;
            end

            x = x > 0 ? x : 1;
            y = y > 0 ? y : 1;

            z = x > y ? x : y;
            
            get_testcase = {x, y, z};
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