module testbench();

    reg reset_;
    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg dav_;
    wire rfd;

    reg [6:0] dx, dy;
    wire [1:0] q;
    wire ow;

    XXX dut (
        .dx(dx), .dy(dy), .dav_(dav_), .reset_(reset_), .clock(clock),
        .q(q), .ow(ow), .rfd(rfd)
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
                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge. as reset_ is set to 1, XXX starts the cycle from out = 0
                    reset_ = 1;
                    dav_ = 1; 

                    #(clk.HALF_PERIOD);
                    //clock is at negative edge
                    
                    if(ow !== 0)
                        $display("ow is not 0 after reset");
                    if(q !== 2'B00)
                        $display("q is not (0,0) after reset");
                    if(rfd !== 1)
                        $display("rfd is not 1 after reset");

                    dx = 7'h60; dy = 7'h00; // -32, +0
                    dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(q);
                            if(q !== 2'B10)
                                $display("(1,0) failed");
                        end
                    join

                    dx = 7'h00; dy = 7'h60; // +0, -32
                    dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(q);
                            if(q !== 2'B11)
                                $display("(1,1) failed");
                        end
                    join

                    dx = 7'h3F; dy = 7'h00; // +63, +0
                    dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(q);
                            if(q !== 2'B01)
                                $display("(0,1) failed");
                        end
                    join

                    dx = 7'h00; dy = 7'h3F; // +0, +63
                    dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(q);
                            if(q !== 2'B00)
                                $display("(0,0) failed");
                        end
                    join

                    dx = 7'h40; dy = 7'h00; // -64, +0
                    dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(q);
                            if(q !== 2'B10)
                                $display("(1,0) failed");
                        end
                    join

                    fork
                        begin
                            //need two commands to force overflow
                            dx = 7'h40; dy = 7'h00; // -64, +0
                            dav_ = 0;

                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                            
                            dx = 7'h40; dy = 7'h00;
                            dav_ = 0;
                            
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            
                            // rfd will not go back to 1 while device is in overflow
                            // @(posedge rfd);
                        end
                        begin
                            @(posedge ow);
                        end
                    join

                    dx = 7'h00; dy = 7'h00;
                    
                    reset_ = 0; 
                    #(clk.HALF_PERIOD);
                    reset_ = 1;
                    #(3*clk.HALF_PERIOD);

                    // same test is repeated

                    if(ow !== 0)
                        $display("ow is not 0 after reset");
                    if(q !== 2'B00)
                        $display("q is not (0,0) after reset");
                    if(rfd !== 1)
                        $display("rfd is not 0 after reset");

                    dx = 7'h60; dy = 7'h00; // -32, +0
                    dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(q);
                            if(q !== 2'B10)
                                $display("(1,0) failed");
                        end
                    join

                    dx = 7'h00; dy = 7'h60; // +0, -32
                    dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(q);
                            if(q !== 2'B11)
                                $display("(1,1) failed");
                        end
                    join

                    dx = 7'h3F; dy = 7'h00; // +63, +0
                    dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(q);
                            if(q !== 2'B01)
                                $display("(0,1) failed");
                        end
                    join

                    dx = 7'h00; dy = 7'h3F; // +0, +63
                    dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(q);
                            if(q !== 2'B00)
                                $display("(0,0) failed");
                        end
                    join

                    dx = 7'h40; dy = 7'h00; // -64, +0
                    dav_ = 0;
                    fork
                        begin
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                        end
                        begin
                            @(q);
                            if(q !== 2'B10)
                                $display("(1,0) failed");
                        end
                    join

                    fork
                        begin
                            //need two commands to force overflow
                            dx = 7'h40; dy = 7'h00; // -64, +0
                            dav_ = 0;

                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            @(posedge rfd);
                            
                            dx = 7'h40; dy = 7'h00;
                            dav_ = 0;
                            
                            @(negedge rfd);
                            dx = 7'h40; dy = 7'h40;
                            dav_ = 1; 
                            
                            // rfd will not go back to 1 while device is in overflow
                            // @(posedge rfd);
                        end
                        begin
                            @(posedge ow);
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