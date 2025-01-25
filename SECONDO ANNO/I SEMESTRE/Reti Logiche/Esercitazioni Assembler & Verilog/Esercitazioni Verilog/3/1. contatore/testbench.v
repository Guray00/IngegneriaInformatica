module testbench();
    reg reset_;
    wire clock;
    clock clk(
        .clock(clock)
    );

    wire [3:0] out;

    contatore dut (
        .out(out),
        .reset_(reset_), .clock(clock)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        reset_ = 0;
        #(2*clk.HALF_PERIOD);
        reset_ = 1;

        #(60*clk.HALF_PERIOD);

        $finish;
    end

endmodule

module clock(
    clock
);
    output clock;
    
    parameter HALF_PERIOD = 5;

    reg CLOCK;
    assign clock = CLOCK;

    initial CLOCK = 0;
    always #HALF_PERIOD CLOCK <= ~CLOCK;

endmodule