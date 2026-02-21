module ABC(
    soc_x, eoc_x, x, 
    soc_y, eoc_y, y, 
    out, 
    reset_, clock 
);
    output soc_x; input eoc_x;
    input [7:0] x;
    output soc_y; input eoc_y;
    input [7:0] y;
    output out;
    input reset_, clock;

    reg SOC_X, SOC_Y;
    assign soc_x = SOC_X;
    assign soc_y = SOC_Y;

    reg OUT;
    assign out = OUT;

    reg [5:0] COUNT;

    reg [2:0] STAR;
    localparam
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S5 = 5,
        S6 = 6;
    
    wire soglia_x;
    SOGLIA_X sx( .x(x), .s(soglia_x));

    wire check_xy;
    CHECK_XY cxy( .x(x), .y(y), .c(check_xy));

    always @(reset_ == 0) #1 begin
        SOC_X = 0;
        SOC_Y = 0;
        OUT = 0;
        STAR = S0;
        COUNT = 6'd60;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(STAR)
            S0: begin
                COUNT <= COUNT - 1;
                SOC_X <= 1;
                STAR <= (eoc_x == 0) ? S1 : S0;
            end
            S1: begin
                COUNT <= COUNT - 1;
                SOC_X <= 0;
                STAR <= (eoc_x == 1) ? S2 : S1;
            end
            S2: begin
                COUNT <= COUNT - 1;
                STAR <= soglia_x ? S3 : S6;
            end
            S3: begin
                COUNT <= COUNT - 1;
                SOC_Y <= 1;
                STAR <= (eoc_y == 0) ? S4 : S3;
            end
            S4: begin
                COUNT <= COUNT - 1;
                SOC_Y <= 0;
                STAR <= (eoc_y == 1) ? S5 : S4;
            end
            S5: begin
                COUNT <= COUNT - 1;
                OUT <= check_xy;
                STAR <= S6;
            end
            S6: begin
                COUNT <= (COUNT == 1) ? 6'd60 : COUNT - 1;
                OUT <= 0;
                STAR <= (COUNT == 1) ? S0 : S6;
            end
        endcase
    end

endmodule

module SOGLIA_X(
    x, s
);
    input [7:0] x;
    output s;

    comp_nat #(.N(8)) cn (
        .a(8'd180), .b(x),
        .min(s)
    );
endmodule

module CHECK_XY(
    x, y,
    c
);
    input [7:0] x, y;
    output c;

    // nor di tutti i bit dello xor dei due valori
    // in alternativa, l'uscita eq di un comparatore
    assign #1 c = ~|(x ^ y);
endmodule
