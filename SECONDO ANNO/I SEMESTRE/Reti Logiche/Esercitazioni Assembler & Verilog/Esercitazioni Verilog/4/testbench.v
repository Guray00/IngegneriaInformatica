module testbench();
    reg in, _reset;

    wire clock, out;

    clock_generator clk(
        .clock(clock)
    );

    RiconoscitoreSequenza dut(
        .in(in), .clock(clock), ._reset(_reset),
        .out(out)
    );

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            //reset phase
            _reset = 0; #(clk.HALF_PERIOD);
            in = 1;
            _reset = 1; #(clk.HALF_PERIOD);

            //clock e' all' edge negativo

            // seq sbagliata #1
            in = 1;
            #(2 * clk.HALF_PERIOD);

            // seq sbagliata #2
            in = 0;
            #(2 * clk.HALF_PERIOD);

            in = 0;
            #(2 * clk.HALF_PERIOD);

            // sequenza giusta
            in = 0;
            #(2 * clk.HALF_PERIOD);

            in = 1;
            #(2 * clk.HALF_PERIOD);

            in = 1;
            #(2 * clk.HALF_PERIOD);            

            // seq sbagliata #3
            in = 0;
            #(2 * clk.HALF_PERIOD);

            in = 0;
            #(2 * clk.HALF_PERIOD);

            // seq sbagliata #3
            in = 1;
            #(2 * clk.HALF_PERIOD);

            in = 0;
            #(2 * clk.HALF_PERIOD);

            // seq sbagliata #3
            in = 1;
            #(2 * clk.HALF_PERIOD);

            in = 0;
            #(2 * clk.HALF_PERIOD);

            // seq sbagliata #3
            in = 0;
            #(2 * clk.HALF_PERIOD);

            in = 1;
            #(2 * clk.HALF_PERIOD);

            $finish;
        end

endmodule
