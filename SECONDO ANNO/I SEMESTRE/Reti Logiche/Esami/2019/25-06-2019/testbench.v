// Made with <3 by Aleandro Prudenzano

module testbench();

    wire [2:0] out_comb;
    reg reset_;
    reg rfd;

    wire [2:0] in_comb;
    wire dav_;
    wire [23:0] riga;

    wire clock;

    clock_generator clk(clock);
    XXX dut(
        .reset_(reset_), .clock(clock),
        .in_comb(in_comb), .out_comb(out_comb),
        .dav_(dav_), .rfd(rfd), .riga(riga)
    );

    assign out_comb = RC(in_comb);

    //Simulation vars
    integer i;
    reg [23:0] next_row;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        fork : f
            begin
                #100000;
                $display("Timeout");
                disable f;
            end
            begin
                //reset
                rfd = 1;
                reset_ = 0; #(clk.HALF_PERIOD);

                if(dav_ != 1) begin
                    $display("Handshake not at rest at reset!");
                    $finish;
                end

                reset_ = 1; #(clk.HALF_PERIOD);
                for(i = 0; i < 8; i++) begin
                    //Wait for handshake to start
                    while(dav_ != 0) begin
                        #1;
                    end

                    next_row = {4'H3, 1'B0, i[2:0], 8'H3A, 4'H3, 1'B0, RC(i)};

                    //fetch value
                    if(riga != next_row) begin
                        $display("WRONG: in = %d, out = %x expected %x", i, riga, next_row);
                        $finish;
                    end

                    rfd = 0;

                    while(dav_ != 1) begin
                        #1;
                    end

                    rfd = 1;
                end

                for(i = 0; i < 20; i++) begin
                    if(dav_ == 0) begin
                        $display("Expected rest until reset, got dav_ negedge");
                        $finish;
                    end
                    #(clk.HALF_PERIOD);
                end

                $display("Everything is working afaik");

                disable f;
            end
        join
        $finish;
    end

    function [2:0] RC;
        input [2:0] in;
        RC =(in == 'B000) ? 3'B101:
            (in == 'B001) ? 3'B110:
            (in == 'B010) ? 3'B100:
            (in == 'B011) ? 3'B001:
            (in == 'B100) ? 3'B010:
            (in == 'B101) ? 3'B000:
            (in == 'B110) ? 3'B111:
            (in == 'B111) ? 3'B011 : 'BXX;
    endfunction
endmodule

module clock_generator(clock);

    output clock;
    parameter HALF_PERIOD = 5;

    reg CLOCK;          assign clock = CLOCK;

    initial CLOCK = 0;

    always #(HALF_PERIOD) CLOCK <= ~CLOCK;
endmodule