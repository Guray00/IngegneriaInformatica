module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    wire soc;
    reg eoc;
    reg [7:0] x;

    wire [7:0] m;
    wire z;

    ABC dut (
        .x(x), .soc(soc), .eoc(eoc),
        .m(m), .z(z),
        .clock(clock), .reset_(reset_)
    );

    initial
    begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        //the following structure is used to wait for expected signals, and fail if too much time passes
        fork : f
        begin
            #10000000;
            $display("Timeout - waiting for signal failed");
            disable f;
        end
        //actual tests start here
        begin
            eoc = 1;

            //reset phase
            reset_ = 0; #(clk.HALF_PERIOD);
            
            //first posedge
            reset_ = 1;

            if(soc !== 0)
                $display("soc is not 0 after reset");
    
            fork
            begin : producer
                reg [8:0] i;
                reg [7:0] x_p, m_p;
                
                for (i = 1; i < 129; i++) begin
                    {x_p, m_p} = get_testcase(i[7:0]);

                    @(posedge soc);

                    #(3*clk.HALF_PERIOD);
                    x = 8'bX;
                    eoc = 0;
                    @(negedge soc);
                    #(4*clk.HALF_PERIOD);
                    x = x_p;
                    #1
                    eoc = 1;
                end
            end

            begin : consumer
                reg [8:0] i;
                reg [7:0] x_c, m_c;
                
                for (i = 1; i < 129; i++) begin
                    {x_c, m_c} = get_testcase(i[7:0]);

                    @(posedge z);
                    if(m !== m_c) begin
                        $display("Test #%g failed, expected %g, got %g", i, m_c, m);
                        error = 1;
                    end
                    #(3*clk.HALF_PERIOD); 
                    if(m !== m_c) begin
                        $display("Test #%g failed, expected %g, got %g : did not hold the value!", i, m_c, m);
                        error = 1;
                    end
                end
            end
            join

            disable f;
        end
        join

        $finish;
    end

    // linea di errore, utile per il debug
    reg error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;

    function automatic [23:0] get_testcase;
        input [7:0] i;
        
        reg [7:0] x, m;

        begin
            case(i)
                0: begin x = 0; m = 0; end
                1: begin x = 8; m = 2; end
                2: begin x = 6; m = 2; end
                3: begin x = 14; m = 4; end
                4: begin x = 13; m = 6; end
                5: begin x = 25; m = 10; end
                6: begin x = 36; m = 16; end
                7: begin x = 50; m = 24; end
                8: begin x = 65; m = 34; end
                9: begin x = 67; m = 41; end
                10: begin x = 72; m = 48; end
                11: begin x = 86; m = 57; end
                12: begin x = 85; m = 63; end
                13: begin x = 74; m = 65; end
                14: begin x = 77; m = 67; end
                15: begin x = 67; m = 66; end
                16: begin x = 71; m = 66; end
                17: begin x = 60; m = 64; end
                18: begin x = 60; m = 63; end
                19: begin x = 59; m = 61; end
                20: begin x = 58; m = 59; end
                21: begin x = 56; m = 58; end
                22: begin x = 61; m = 58; end
                23: begin x = 59; m = 57; end
                24: begin x = 49; m = 54; end
                25: begin x = 58; m = 54; end
                26: begin x = 59; m = 54; end
                27: begin x = 54; m = 53; end
                28: begin x = 65; m = 55; end
                29: begin x = 71; m = 58; end
                30: begin x = 78; m = 62; end
                31: begin x = 66; m = 62; end
                32: begin x = 77; m = 65; end
                33: begin x = 76; m = 67; end
                34: begin x = 72; m = 68; end
                35: begin x = 61; m = 66; end
                36: begin x = 73; m = 67; end
                37: begin x = 79; m = 69; end
                38: begin x = 85; m = 72; end
                39: begin x = 75; m = 72; end
                40: begin x = 80; m = 74; end
                41: begin x = 65; m = 71; end
                42: begin x = 81; m = 73; end
                43: begin x = 69; m = 71; end
                44: begin x = 83; m = 73; end
                45: begin x = 71; m = 71; end
                46: begin x = 58; m = 67; end
                47: begin x = 61; m = 65; end
                48: begin x = 45; m = 59; end
                49: begin x = 46; m = 55; end
                50: begin x = 60; m = 56; end
                51: begin x = 50; m = 54; end
                52: begin x = 58; m = 54; end
                53: begin x = 47; m = 51; end
                54: begin x = 63; m = 53; end
                55: begin x = 60; m = 54; end
                56: begin x = 55; m = 53; end
                57: begin x = 52; m = 52; end
                58: begin x = 36; m = 48; end
                59: begin x = 49; m = 48; end
                60: begin x = 57; m = 50; end
                61: begin x = 46; m = 48; end
                62: begin x = 35; m = 44; end
                63: begin x = 20; m = 38; end
                64: begin x = 25; m = 34; end
                65: begin x = 37; m = 34; end
                66: begin x = 29; m = 32; end
                67: begin x = 22; m = 29; end
                68: begin x = 32; m = 29; end
                69: begin x = 18; m = 25; end
                70: begin x = 8; m = 20; end
                71: begin x = 7; m = 16; end
                72: begin x = 22; m = 17; end
                73: begin x = 14; m = 15; end
                74: begin x = 29; m = 18; end
                75: begin x = 35; m = 21; end
                76: begin x = 39; m = 24; end
                77: begin x = 47; m = 29; end
                78: begin x = 61; m = 36; end
                79: begin x = 74; m = 45; end
                80: begin x = 62; m = 48; end
                81: begin x = 69; m = 53; end
                82: begin x = 76; m = 58; end
                83: begin x = 77; m = 62; end
                84: begin x = 70; m = 63; end
                85: begin x = 54; m = 60; end
                86: begin x = 68; m = 62; end
                87: begin x = 61; m = 61; end
                88: begin x = 48; m = 57; end
                89: begin x = 35; m = 50; end
                90: begin x = 31; m = 44; end
                91: begin x = 38; m = 42; end
                92: begin x = 42; m = 41; end
                93: begin x = 38; m = 39; end
                94: begin x = 51; m = 41; end
                95: begin x = 60; m = 45; end
                96: begin x = 67; m = 49; end
                97: begin x = 67; m = 52; end
                98: begin x = 59; m = 53; end
                99: begin x = 52; m = 52; end
                100: begin x = 46; m = 50; end
                101: begin x = 61; m = 52; end
                102: begin x = 68; m = 56; end
                103: begin x = 71; m = 59; end
                104: begin x = 80; m = 64; end
                105: begin x = 80; m = 68; end
                106: begin x = 86; m = 72; end
                107: begin x = 71; m = 71; end
                108: begin x = 84; m = 74; end
                109: begin x = 85; m = 76; end
                110: begin x = 91; m = 79; end
                111: begin x = 95; m = 82; end
                112: begin x = 97; m = 85; end
                113: begin x = 100; m = 88; end
                114: begin x = 85; m = 87; end
                115: begin x = 69; m = 82; end
                116: begin x = 70; m = 78; end
                117: begin x = 67; m = 74; end
                118: begin x = 77; m = 74; end
                119: begin x = 61; m = 70; end
                120: begin x = 76; m = 71; end
                121: begin x = 75; m = 71; end
                122: begin x = 75; m = 71; end
                123: begin x = 86; m = 74; end
                124: begin x = 82; m = 75; end
                125: begin x = 94; m = 79; end
                126: begin x = 87; m = 80; end
                127: begin x = 73; m = 78; end
                128: begin x = 63; m = 73; end
                default: begin x = 0; m = 0; end
            endcase

            get_testcase = {i, x, m};
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
