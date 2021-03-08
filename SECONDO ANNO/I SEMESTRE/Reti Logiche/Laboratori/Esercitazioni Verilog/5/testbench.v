module testbench();
    reg [3:0] a, b;
    reg _reset, _dav;

    wire clock, rfd;
    wire [5:0] p;

    clock_generator clk(
        .clock(clock)
    );

    PerimetroRettangolo dut(
        .a(a), .b(b), .clock(clock), ._reset(_reset), ._dav(_dav),
        .p(p), .rfd(rfd)
    );

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            //reset phase
            _reset = 0; #(clk.HALF_PERIOD);
            _dav = 1;
            _reset = 1; #(clk.HALF_PERIOD);

            //clock e' all' edge negativo

            if(rfd != 1)
                begin
                    $display("rfd a 0 dopo il reset");
                    $finish;
                end

            a = 3; b = 2;
            _dav = 0;

            #(6*clk.HALF_PERIOD);
            if(rfd != 0)
                begin
                    $display("rfd rimasto a 1 quando _dav = 0");
                    $finish;
                end

            _dav = 1;

            #(6*clk.HALF_PERIOD);
            if(rfd != 1)
                begin
                    $display("rfd rimasto a 0 quando _dav = 1");
                    $finish;
                end

            $finish;
        end

endmodule
