module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg colore, endline;
    reg dav_; wire rfd;
    wire txd;    

    ABC dut (
        .colore(colore), .endline(endline), .dav_(dav_), .rfd(rfd), .txd(txd),
        .clock(clock), .reset_(reset_)
    );

    // simulation variables
    reg [6:0] i, j, k;
    reg [7:0] received;
    reg [7:0] expected;
    reg current_color, next_color;
    reg first_pixel_already_sent;

    // Debug variables, used to highlight points on the waveform
    reg sampling;
    reg error;

    localparam marking = 1'B1, start_b = 1'B0, stop_b = 1'B1;
    localparam bianco = 1'B0, nero = 1'B1;

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
                    first_pixel_already_sent = 1;
                    next_color = nero;
                    sampling = 0; error = 0;

                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    dav_ = 1;
                    reset_ = 1;

                    #(clk.HALF_PERIOD);

                    if(rfd !== 1)
                        $display("rfd is not 1 after reset");
                    
                    for (i = 30; i < (30 + 16) ; i++ ) begin
                        current_color = next_color;
                        if(txd !== marking)
                            $display("Error: marking expected from txd");

                        fork
                            begin
                                // handshakes to build the byte
                                
                                for (
                                    j = first_pixel_already_sent ? 1 : 0;
                                    j < i ; j++ ) begin
                                    
                                    #(2*clk.HALF_PERIOD);
                                    colore = current_color;
                                    endline = 0;
                                    #(2*clk.HALF_PERIOD);
                                    dav_ = 0;
                                    
                                    @(negedge rfd);
                                    dav_ = 1; #1;
                                    colore = ~current_color;                                   
                                    
                                    @(posedge rfd);     
                                end

                                // last handshake
                                if( i[0] == 0 ) begin
                                    // even will be endlines
                                    next_color = current_color;
                                    first_pixel_already_sent = 0;
                                    
                                    #(2*clk.HALF_PERIOD);
                                    colore = current_color;
                                    endline = 1;
                                    #(2*clk.HALF_PERIOD);
                                    dav_ = 0;
                                    
                                    @(negedge rfd);
                                    dav_ = 1;
                                    colore = ~current_color;                                   
                                    
                                    @(posedge rfd);
                                end
                                else begin
                                    // odds will complete
                                    next_color = ~current_color;
                                    first_pixel_already_sent = 1;

                                    #(2*clk.HALF_PERIOD);
                                    colore = next_color;
                                    endline = 0;
                                    #(2*clk.HALF_PERIOD);
                                    dav_ = 0;
                                    
                                    @(negedge rfd);
                                    dav_ = 1;
                                    colore = current_color;                                   
                                    
                                    @(posedge rfd);
                                end
                            end
                            begin
                                // receive and check the byte from txd
                                @(negedge txd); #(clk.HALF_PERIOD);
                                sampling = 1;

                                received = 8'H00;
                                
                                for (k = 0; k < 8; k++) begin
                                    #(2*clk.HALF_PERIOD);
                                    sampling = 1;
                                    received[k] = txd;
                                end

                                #(2*clk.HALF_PERIOD);
                                sampling = 1;
                                if(txd !== stop_b) begin
                                    $display("Error: stop expected from txd");
                                    error = 1;
                                end

                                expected = (i[0] == 0) ?
                                    8'H00 :
                                    { i, current_color };

                                if(received !== expected) begin
                                    $display("Expected byte %h, received %h", expected, received);
                                    error = 1;
                                end
                            end
                        join
                    end

                    #10;
                    disable f;
                end
            join

            $finish;
        end

    always @(posedge sampling) #1
        sampling = 0;

    always @(posedge error) #1
        error = 0;

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