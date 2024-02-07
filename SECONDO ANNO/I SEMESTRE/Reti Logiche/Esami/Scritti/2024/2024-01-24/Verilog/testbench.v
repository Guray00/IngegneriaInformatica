module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg soc;
    wire eoc;
    reg [7:0] n_0;
    wire [7:0] k;

    ABC dut (
        .n_0(n_0), .k(k), 
        .soc(soc), .eoc(eoc),
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
            soc = 0;

            //reset phase
            reset_ = 0; #(clk.HALF_PERIOD);
            
            //first posedge
            reset_ = 1;

            if(eoc !== 1)
                $display("eoc is not 1 after reset");
    
            fork
            begin : consumer
                reg [8:0] i;
                reg [7:0] n_0_c, k_c;

                for (i = 1; i < 256; i++) begin
                    {n_0_c, k_c} = get_testcase(i[7:0]);

                    n_0 = n_0_c;
                    #(2*clk.HALF_PERIOD);
                    soc = 1;
                    @(negedge eoc);
                    #(20*clk.HALF_PERIOD);
                    soc = 0;
                    @(posedge eoc);

                    if(k !== k_c) begin
                        $display("Test #%g failed, expected %g, got %g", i, k_c, k);
                        error = 1;
                    end
                    
                    #(2*clk.HALF_PERIOD); 
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

    function automatic [15:0] get_testcase;
        input [7:0] n_0;
        reg [7:0] k;

        begin
            case(n_0)
                1: k = 0; 
                2: k = 1; 
                3: k = 7; 
                4: k = 2; 
                5: k = 5; 
                6: k = 8; 
                7: k = 16; 
                8: k = 3; 
                9: k = 19; 
                10: k = 6; 
                11: k = 14; 
                12: k = 9; 
                13: k = 9; 
                14: k = 17; 
                15: k = 17; 
                16: k = 4; 
                17: k = 12; 
                18: k = 20; 
                19: k = 20; 
                20: k = 7; 
                21: k = 7; 
                22: k = 15; 
                23: k = 15; 
                24: k = 10; 
                25: k = 23; 
                26: k = 10; 
                27: k = 111; 
                28: k = 18; 
                29: k = 18; 
                30: k = 18; 
                31: k = 106; 
                32: k = 5; 
                33: k = 26; 
                34: k = 13; 
                35: k = 13; 
                36: k = 21; 
                37: k = 21; 
                38: k = 21; 
                39: k = 34; 
                40: k = 8; 
                41: k = 109; 
                42: k = 8; 
                43: k = 29; 
                44: k = 16; 
                45: k = 16; 
                46: k = 16; 
                47: k = 104; 
                48: k = 11; 
                49: k = 24; 
                50: k = 24; 
                51: k = 24; 
                52: k = 11; 
                53: k = 11; 
                54: k = 112; 
                55: k = 112; 
                56: k = 19; 
                57: k = 32; 
                58: k = 19; 
                59: k = 32; 
                60: k = 19; 
                61: k = 19; 
                62: k = 107; 
                63: k = 107; 
                64: k = 6; 
                65: k = 27; 
                66: k = 27; 
                67: k = 27; 
                68: k = 14; 
                69: k = 14; 
                70: k = 14; 
                71: k = 102; 
                72: k = 22; 
                73: k = 115; 
                74: k = 22; 
                75: k = 14; 
                76: k = 22; 
                77: k = 22; 
                78: k = 35; 
                79: k = 35; 
                80: k = 9; 
                81: k = 22; 
                82: k = 110; 
                83: k = 110; 
                84: k = 9; 
                85: k = 9; 
                86: k = 30; 
                87: k = 30; 
                88: k = 17; 
                89: k = 30; 
                90: k = 17; 
                91: k = 92; 
                92: k = 17; 
                93: k = 17; 
                94: k = 105; 
                95: k = 105; 
                96: k = 12; 
                97: k = 118; 
                98: k = 25; 
                99: k = 25; 
                100: k = 25; 
                101: k = 25; 
                102: k = 25; 
                103: k = 87; 
                104: k = 12; 
                105: k = 38; 
                106: k = 12; 
                107: k = 100; 
                108: k = 113; 
                109: k = 113; 
                110: k = 113; 
                111: k = 69; 
                112: k = 20; 
                113: k = 12; 
                114: k = 33; 
                115: k = 33; 
                116: k = 20; 
                117: k = 20; 
                118: k = 33; 
                119: k = 33; 
                120: k = 20; 
                121: k = 95; 
                122: k = 20; 
                123: k = 46; 
                124: k = 108; 
                125: k = 108; 
                126: k = 108; 
                127: k = 46; 
                128: k = 7; 
                129: k = 121; 
                130: k = 28; 
                131: k = 28; 
                132: k = 28; 
                133: k = 28; 
                134: k = 28; 
                135: k = 41; 
                136: k = 15; 
                137: k = 90; 
                138: k = 15; 
                139: k = 41; 
                140: k = 15; 
                141: k = 15; 
                142: k = 103; 
                143: k = 103; 
                144: k = 23; 
                145: k = 116; 
                146: k = 116; 
                147: k = 116; 
                148: k = 23; 
                149: k = 23; 
                150: k = 15; 
                151: k = 15; 
                152: k = 23; 
                153: k = 36; 
                154: k = 23; 
                155: k = 85; 
                156: k = 36; 
                157: k = 36; 
                158: k = 36; 
                159: k = 54; 
                160: k = 10; 
                161: k = 98; 
                162: k = 23; 
                163: k = 23; 
                164: k = 111; 
                165: k = 111; 
                166: k = 111; 
                167: k = 67; 
                168: k = 10; 
                169: k = 49; 
                170: k = 10; 
                171: k = 124; 
                172: k = 31; 
                173: k = 31; 
                174: k = 31; 
                175: k = 80; 
                176: k = 18; 
                177: k = 31; 
                178: k = 31; 
                179: k = 31; 
                180: k = 18; 
                181: k = 18; 
                182: k = 93; 
                183: k = 93; 
                184: k = 18; 
                185: k = 44; 
                186: k = 18; 
                187: k = 44; 
                188: k = 106; 
                189: k = 106; 
                190: k = 106; 
                191: k = 44; 
                192: k = 13; 
                193: k = 119; 
                194: k = 119; 
                195: k = 119; 
                196: k = 26; 
                197: k = 26; 
                198: k = 26; 
                199: k = 119; 
                200: k = 26; 
                201: k = 18; 
                202: k = 26; 
                203: k = 39; 
                204: k = 26; 
                205: k = 26; 
                206: k = 88; 
                207: k = 88; 
                208: k = 13; 
                209: k = 39; 
                210: k = 39; 
                211: k = 39; 
                212: k = 13; 
                213: k = 13; 
                214: k = 101; 
                215: k = 101; 
                216: k = 114; 
                217: k = 26; 
                218: k = 114; 
                219: k = 52; 
                220: k = 114; 
                221: k = 114; 
                222: k = 70; 
                223: k = 70; 
                224: k = 21; 
                225: k = 52; 
                226: k = 13; 
                227: k = 13; 
                228: k = 34; 
                229: k = 34; 
                230: k = 34; 
                231: k = 127; 
                232: k = 21; 
                233: k = 83; 
                234: k = 21; 
                235: k = 127; 
                236: k = 34; 
                237: k = 34; 
                238: k = 34; 
                239: k = 52; 
                240: k = 21; 
                241: k = 21; 
                242: k = 96; 
                243: k = 96; 
                244: k = 21; 
                245: k = 21; 
                246: k = 47; 
                247: k = 47; 
                248: k = 109; 
                249: k = 47; 
                250: k = 109; 
                251: k = 65; 
                252: k = 109; 
                253: k = 109; 
                254: k = 47; 
                255: k = 47; 
                default: k = 0; 
            endcase
            
            get_testcase = {n_0, k};
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