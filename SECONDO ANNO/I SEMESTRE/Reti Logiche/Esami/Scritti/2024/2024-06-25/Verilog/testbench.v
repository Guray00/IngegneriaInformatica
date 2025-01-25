module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg [3:0] vx, vy;
    wire soc_vx, soc_vy;
    reg eoc_vx, eoc_vy; 

    wire [7:0] x, y;
    reg soc_p;
    wire eoc_p;

    ABC dut (
        .vx(vx), .vy(vy),
        .soc_vx(soc_vx), .eoc_vx(eoc_vx),
        .soc_vy(soc_vy), .eoc_vy(eoc_vy),
        .x(x), .y(y),
        .soc_p(soc_p), .eoc_p(eoc_p),
        .clock(clock), .reset_(reset_)
    );

    initial begin
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
                eoc_vx = 1;
                eoc_vy = 1;
                soc_p = 0;

                //reset phase
                reset_ = 0; #(clk.HALF_PERIOD);
                
                //first posedge
                reset_ = 1;

                if(soc_vx !== 0)
                    $display("soc_vx is not 0 after reset");

                if(soc_vy !== 0)
                    $display("soc_vy is not 0 after reset");

                if(eoc_p !== 1)
                    $display("eoc_p is not 1 after reset");

                #(clk.HALF_PERIOD);

                fork
                    begin : producer_vx
                        reg [7:0] i;
                        reg [3:0] pvx_vx, pvx_vy;
                        reg [7:0] pvx_x, pvx_y;

                        for (i = 0; i < 128; i++) begin
                            {pvx_vx, pvx_vy, pvx_x, pvx_y} = get_testcase(i);
                            
                            @(posedge soc_vx);
                            vx = 4'bX;
                            #(5*2*clk.HALF_PERIOD);
                            eoc_vx = 0;
                            @(negedge soc_vx);
                            #(5*2*clk.HALF_PERIOD);
                            vx = pvx_vx;
                            #(2*clk.HALF_PERIOD);
                            eoc_vx = 1;
                        end
                    end

                    begin : producer_vy
                        reg [7:0] i;
                        reg [3:0] pvy_vx, pvy_vy;
                        reg [7:0] pvy_x, pvy_y;

                        for (i = 0; i < 128; i++) begin
                            {pvy_vx, pvy_vy, pvy_x, pvy_y} = get_testcase(i);
                            
                            @(posedge soc_vy);
                            vy = 4'bX;
                            #(3*2*clk.HALF_PERIOD);
                            eoc_vy = 0;
                            @(negedge soc_vy);
                            #(3*2*clk.HALF_PERIOD);
                            vy = pvy_vy;
                            #(2*clk.HALF_PERIOD);
                            eoc_vy = 1;
                        end
                    end

                    begin : consumer
                        reg [7:0] i;
                        reg [3:0] c_vx, c_vy;
                        reg [7:0] c_x, c_y;

                        reg [7:0] smp_x, smp_y;

                        for (i = 0; i < 128; i++) begin
                            {c_vx, c_vy, c_x, c_y} = get_testcase(i);
                            
                            soc_p = 1;
                            @(negedge eoc_p);
                            #(2*2*clk.HALF_PERIOD);
                            soc_p = 0;
                            @(posedge eoc_p);

                            smp_x = x;
                            smp_y = y;
                            if((x !== c_x) || (y !== c_y)) begin
                                $display("Test #%g failed, expected (%d, %d) got (%d, %d)", i, $signed(c_x), $signed(c_y), $signed(x), $signed(y));
                                error = 1;
                            end
                            #(3*clk.HALF_PERIOD); 
                            if((x !== smp_x) || (y !== smp_y)) begin
                                $display("Test #%g failed: did not hold the value (%d, %d), got (%d, %d)", i, $signed(smp_x), $signed(smp_y), $signed(x), $signed(y));
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

    function automatic [31:0] get_testcase;
        input [7:0] i;
        
        reg [3:0] vx, vy;
        reg [7:0] x, y;

        begin
            case(i)
                0: begin vx = 4'd5; vy = 4'd0; x = 8'd5; y = 8'd0; end
                1: begin vx = -4'd7; vy = 4'd7; x = -8'd2; y = 8'd7; end
                2: begin vx = 4'd4; vy = 4'd7; x = 8'd2; y = 8'd14; end
                3: begin vx = -4'd1; vy = 4'd2; x = 8'd1; y = 8'd16; end
                4: begin vx = -4'd1; vy = -4'd3; x = 8'd0; y = 8'd13; end
                5: begin vx = 4'd6; vy = 4'd4; x = 8'd6; y = 8'd17; end
                6: begin vx = -4'd5; vy = 4'd6; x = 8'd1; y = 8'd23; end
                7: begin vx = -4'd5; vy = -4'd7; x = -8'd4; y = 8'd16; end
                8: begin vx = 4'd0; vy = -4'd5; x = -8'd4; y = 8'd11; end
                9: begin vx = 4'd0; vy = 4'd1; x = -8'd4; y = 8'd12; end
                10: begin vx = -4'd6; vy = -4'd7; x = -8'd10; y = 8'd5; end
                11: begin vx = -4'd4; vy = 4'd6; x = -8'd14; y = 8'd11; end
                12: begin vx = 4'd7; vy = 4'd2; x = -8'd7; y = 8'd13; end
                13: begin vx = -4'd8; vy = 4'd3; x = -8'd15; y = 8'd16; end
                14: begin vx = -4'd7; vy = 4'd5; x = -8'd22; y = 8'd21; end
                15: begin vx = -4'd1; vy = -4'd1; x = -8'd23; y = 8'd20; end
                16: begin vx = 4'd7; vy = 4'd0; x = -8'd16; y = 8'd20; end
                17: begin vx = -4'd4; vy = -4'd7; x = -8'd20; y = 8'd13; end
                18: begin vx = -4'd6; vy = 4'd0; x = -8'd26; y = 8'd13; end
                19: begin vx = -4'd1; vy = -4'd6; x = -8'd27; y = 8'd7; end
                20: begin vx = 4'd3; vy = -4'd5; x = -8'd24; y = 8'd2; end
                21: begin vx = -4'd7; vy = 4'd1; x = -8'd31; y = 8'd3; end
                22: begin vx = -4'd2; vy = -4'd2; x = -8'd33; y = 8'd1; end
                23: begin vx = -4'd1; vy = -4'd7; x = -8'd34; y = -8'd6; end
                24: begin vx = -4'd5; vy = 4'd6; x = -8'd39; y = 8'd0; end
                25: begin vx = -4'd8; vy = -4'd7; x = -8'd47; y = -8'd7; end
                26: begin vx = -4'd1; vy = 4'd6; x = -8'd48; y = -8'd1; end
                27: begin vx = -4'd8; vy = -4'd6; x = -8'd56; y = -8'd7; end
                28: begin vx = 4'd6; vy = -4'd6; x = -8'd50; y = -8'd13; end
                29: begin vx = -4'd4; vy = 4'd0; x = -8'd54; y = -8'd13; end
                30: begin vx = -4'd5; vy = -4'd8; x = -8'd59; y = -8'd21; end
                31: begin vx = -4'd5; vy = 4'd4; x = -8'd64; y = -8'd17; end
                32: begin vx = 4'd0; vy = -4'd1; x = -8'd64; y = -8'd18; end
                33: begin vx = 4'd5; vy = 4'd4; x = -8'd59; y = -8'd14; end
                34: begin vx = -4'd8; vy = 4'd5; x = -8'd67; y = -8'd9; end
                35: begin vx = 4'd1; vy = 4'd1; x = -8'd66; y = -8'd8; end
                36: begin vx = -4'd4; vy = -4'd5; x = -8'd70; y = -8'd13; end
                37: begin vx = -4'd2; vy = 4'd6; x = -8'd72; y = -8'd7; end
                38: begin vx = -4'd4; vy = -4'd3; x = -8'd76; y = -8'd10; end
                39: begin vx = -4'd4; vy = 4'd1; x = -8'd80; y = -8'd9; end
                40: begin vx = -4'd7; vy = -4'd2; x = -8'd87; y = -8'd11; end
                41: begin vx = 4'd1; vy = 4'd1; x = -8'd86; y = -8'd10; end
                42: begin vx = 4'd0; vy = 4'd3; x = -8'd86; y = -8'd7; end
                43: begin vx = 4'd0; vy = 4'd4; x = -8'd86; y = -8'd3; end
                44: begin vx = 4'd7; vy = -4'd8; x = -8'd79; y = -8'd11; end
                45: begin vx = 4'd0; vy = -4'd3; x = -8'd79; y = -8'd14; end
                46: begin vx = -4'd5; vy = 4'd6; x = -8'd84; y = -8'd8; end
                47: begin vx = -4'd3; vy = 4'd7; x = -8'd87; y = -8'd1; end
                48: begin vx = -4'd5; vy = 4'd0; x = -8'd92; y = -8'd1; end
                49: begin vx = -4'd8; vy = -4'd7; x = -8'd100; y = -8'd8; end
                50: begin vx = -4'd1; vy = 4'd3; x = -8'd101; y = -8'd5; end
                51: begin vx = -4'd6; vy = -4'd6; x = -8'd107; y = -8'd11; end
                52: begin vx = 4'd4; vy = -4'd8; x = -8'd103; y = -8'd19; end
                53: begin vx = 4'd0; vy = 4'd5; x = -8'd103; y = -8'd14; end
                54: begin vx = -4'd7; vy = 4'd4; x = -8'd110; y = -8'd10; end
                55: begin vx = -4'd8; vy = 4'd4; x = -8'd118; y = -8'd6; end
                56: begin vx = 4'd4; vy = 4'd6; x = -8'd114; y = 8'd0; end
                57: begin vx = -4'd1; vy = -4'd2; x = -8'd115; y = -8'd2; end
                58: begin vx = -4'd8; vy = 4'd6; x = -8'd123; y = 8'd4; end
                59: begin vx = -4'd6; vy = 4'd4; x = -8'd123; y = 8'd8; end
                60: begin vx = -4'd3; vy = 4'd3; x = -8'd126; y = 8'd11; end
                61: begin vx = 4'd4; vy = 4'd5; x = -8'd122; y = 8'd16; end
                62: begin vx = -4'd8; vy = -4'd2; x = -8'd122; y = 8'd14; end
                63: begin vx = 4'd6; vy = -4'd7; x = -8'd116; y = 8'd7; end
                64: begin vx = -4'd1; vy = -4'd2; x = -8'd117; y = 8'd5; end
                65: begin vx = -4'd6; vy = 4'd3; x = -8'd123; y = 8'd8; end
                66: begin vx = -4'd6; vy = -4'd5; x = -8'd123; y = 8'd3; end
                67: begin vx = 4'd4; vy = 4'd0; x = -8'd119; y = 8'd3; end
                68: begin vx = 4'd7; vy = -4'd4; x = -8'd112; y = -8'd1; end
                69: begin vx = 4'd2; vy = -4'd3; x = -8'd110; y = -8'd4; end
                70: begin vx = 4'd3; vy = 4'd2; x = -8'd107; y = -8'd2; end
                71: begin vx = -4'd2; vy = 4'd2; x = -8'd109; y = 8'd0; end
                72: begin vx = 4'd3; vy = -4'd1; x = -8'd106; y = -8'd1; end
                73: begin vx = -4'd4; vy = 4'd0; x = -8'd110; y = -8'd1; end
                74: begin vx = 4'd3; vy = 4'd1; x = -8'd107; y = 8'd0; end
                75: begin vx = 4'd1; vy = -4'd6; x = -8'd106; y = -8'd6; end
                76: begin vx = -4'd6; vy = 4'd2; x = -8'd112; y = -8'd4; end
                77: begin vx = 4'd2; vy = 4'd7; x = -8'd110; y = 8'd3; end
                78: begin vx = -4'd3; vy = 4'd6; x = -8'd113; y = 8'd9; end
                79: begin vx = -4'd4; vy = 4'd4; x = -8'd117; y = 8'd13; end
                80: begin vx = -4'd3; vy = -4'd4; x = -8'd120; y = 8'd9; end
                81: begin vx = 4'd4; vy = 4'd5; x = -8'd116; y = 8'd14; end
                82: begin vx = 4'd6; vy = -4'd8; x = -8'd110; y = 8'd6; end
                83: begin vx = -4'd5; vy = 4'd7; x = -8'd115; y = 8'd13; end
                84: begin vx = 4'd5; vy = -4'd4; x = -8'd110; y = 8'd9; end
                85: begin vx = 4'd3; vy = -4'd8; x = -8'd107; y = 8'd1; end
                86: begin vx = -4'd2; vy = -4'd3; x = -8'd109; y = -8'd2; end
                87: begin vx = -4'd3; vy = 4'd6; x = -8'd112; y = 8'd4; end
                88: begin vx = -4'd7; vy = -4'd3; x = -8'd119; y = 8'd1; end
                89: begin vx = -4'd7; vy = 4'd0; x = -8'd126; y = 8'd1; end
                90: begin vx = 4'd6; vy = -4'd4; x = -8'd120; y = -8'd3; end
                91: begin vx = -4'd5; vy = -4'd5; x = -8'd125; y = -8'd8; end
                92: begin vx = 4'd7; vy = -4'd2; x = -8'd118; y = -8'd10; end
                93: begin vx = 4'd5; vy = -4'd3; x = -8'd113; y = -8'd13; end
                94: begin vx = -4'd6; vy = -4'd8; x = -8'd119; y = -8'd21; end
                95: begin vx = -4'd6; vy = 4'd5; x = -8'd125; y = -8'd16; end
                96: begin vx = -4'd2; vy = -4'd3; x = -8'd127; y = -8'd19; end
                97: begin vx = -4'd1; vy = -4'd2; x = -8'd128; y = -8'd21; end
                98: begin vx = 4'd0; vy = -4'd5; x = -8'd128; y = -8'd26; end
                99: begin vx = -4'd5; vy = 4'd3; x = -8'd128; y = -8'd23; end
                100: begin vx = -4'd7; vy = -4'd5; x = -8'd128; y = -8'd28; end
                101: begin vx = 4'd2; vy = -4'd4; x = -8'd126; y = -8'd32; end
                102: begin vx = -4'd8; vy = 4'd1; x = -8'd126; y = -8'd31; end
                103: begin vx = 4'd7; vy = 4'd5; x = -8'd119; y = -8'd26; end
                104: begin vx = 4'd0; vy = -4'd3; x = -8'd119; y = -8'd29; end
                105: begin vx = -4'd3; vy = -4'd3; x = -8'd122; y = -8'd32; end
                106: begin vx = -4'd2; vy = 4'd1; x = -8'd124; y = -8'd31; end
                107: begin vx = -4'd8; vy = -4'd2; x = -8'd124; y = -8'd33; end
                108: begin vx = 4'd7; vy = 4'd1; x = -8'd117; y = -8'd32; end
                109: begin vx = -4'd3; vy = 4'd7; x = -8'd120; y = -8'd25; end
                110: begin vx = 4'd4; vy = -4'd4; x = -8'd116; y = -8'd29; end
                111: begin vx = 4'd2; vy = 4'd0; x = -8'd114; y = -8'd29; end
                112: begin vx = -4'd4; vy = 4'd2; x = -8'd118; y = -8'd27; end
                113: begin vx = 4'd3; vy = -4'd4; x = -8'd115; y = -8'd31; end
                114: begin vx = 4'd6; vy = -4'd5; x = -8'd109; y = -8'd36; end
                115: begin vx = 4'd3; vy = -4'd5; x = -8'd106; y = -8'd41; end
                116: begin vx = 4'd3; vy = -4'd3; x = -8'd103; y = -8'd44; end
                117: begin vx = 4'd3; vy = -4'd2; x = -8'd100; y = -8'd46; end
                118: begin vx = -4'd4; vy = 4'd3; x = -8'd104; y = -8'd43; end
                119: begin vx = -4'd7; vy = 4'd1; x = -8'd111; y = -8'd42; end
                120: begin vx = -4'd3; vy = -4'd5; x = -8'd114; y = -8'd47; end
                121: begin vx = -4'd5; vy = 4'd5; x = -8'd119; y = -8'd42; end
                122: begin vx = -4'd5; vy = -4'd3; x = -8'd124; y = -8'd45; end
                123: begin vx = 4'd1; vy = 4'd6; x = -8'd123; y = -8'd39; end
                124: begin vx = -4'd5; vy = -4'd6; x = -8'd128; y = -8'd45; end
                125: begin vx = -4'd8; vy = 4'd4; x = -8'd128; y = -8'd41; end
                126: begin vx = 4'd5; vy = -4'd1; x = -8'd123; y = -8'd42; end
                127: begin vx = -4'd8; vy = -4'd7; x = -8'd123; y = -8'd49; end 
            endcase

            get_testcase = {vx, vy, x, y};
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
