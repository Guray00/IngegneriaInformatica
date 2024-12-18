module ABC(
    x1, x2, x3, eoc1, eoc2, eoc3, rfd,
    min, soc, dav_,
    clock, reset_
);
    input [7:0] x1, x2, x3;
    input eoc1, eoc2, eoc3, rfd;
    output [7:0] min;
    output soc, dav_;

    input clock, reset_;

    wire b4, b3, b2, b1, b0;
    wire c2, c1, c0;

    ABC_PC pc(
        clock, reset_,
        b4, b3, b2, b1, b0,
        c2, c1, c0
    );

    ABC_PO po(
        x1, x2, x3, eoc1, eoc2, eoc3, rfd,
        min, soc, dav_,
        clock, reset_,
        b4, b3, b2, b1, b0,
        c2, c1, c0
    );

endmodule

module ABC_PO(
    x1, x2, x3, eoc1, eoc2, eoc3, rfd,
    min, soc, dav_,
    clock, reset_,
    b4, b3, b2, b1, b0,
    c2, c1, c0
);
    input [7:0] x1, x2, x3;
    input eoc1, eoc2, eoc3, rfd;
    output [7:0] min;
    output soc, dav_;

    input clock, reset_;

    reg [7:0] MIN;
    assign min = MIN;
    reg SOC, DAV_;
    assign soc = SOC;
    assign dav_ = DAV_; 

    input b4, b3, b2, b1, b0;
    output c2, c1, c0;

    assign c0 = ~eoc1 & ~eoc2 & ~eoc3; // {eoc1, eoc2, eoc3}==3'b000;
    assign c1 = eoc1 & eoc2 & eoc3; // {eoc1, eoc2, eoc3}==3'b111;
    assign c2 = rfd;

    wire [7:0] minimo_3;
    MINIMO_3 m(
        .a(x1), .b(x2), .c(x3),
        .min(minimo_3)
    );

    always @(reset_ == 0) #1 SOC <= 0;
    always @(posedge clock) if(reset_ == 1) #3 begin
        casex({b1, b0})
            2'b00: SOC <= 1;
            2'b01: SOC <= 0;
            2'b1?: SOC <= SOC;
        endcase
    end

    always @(reset_ == 0) #1 DAV_ <= 1;
    always @(posedge clock) if(reset_ == 1) #3 begin
        casex({b3, b2})
            2'b00: DAV_ <= DAV_;
            2'b01: DAV_ <= 0;
            2'b1?: DAV_ <= 1;
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(b4)
            1'b0: MIN <= MIN;
            1'b1: MIN <= minimo_3;                
        endcase
    end
endmodule

module ABC_PC(
    clock, reset_,
    b4, b3, b2, b1, b0,
    c2, c1, c0
);
    input clock, reset_;

    output b4, b3, b2, b1, b0;
    input c2, c1, c0;

    assign {b4, b3, b2, b1, b0} = 
        (STAR == S0) ? 5'b00000 :
        (STAR == S1) ? 5'b10001 :
        (STAR == S2) ? 5'b0011X :
        (STAR == S3) ? 5'b01X1X :
        /*default*/    5'bXXXXX;

    reg [1:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3;

    always @(reset_ == 0) #1 STAR <= S0;
    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(STAR)
            S0: STAR <= c0 ? S1 : S0;
            S1: STAR <= c1 ? S2 : S1;
            S2: STAR <= c2 ? S2 : S3;
            S3: STAR <= c2 ? S0 : S3;
        endcase
    end

    /*
        S0 = 00, S1 = 01, S2 = 10, S3 = 11;
        c0 = 00, c1 = 01, c2 = 1?

        M-addr  b4, b3, b2, b1, b0  ceff    M-addrT M-addrF
        00      00000               00      01      00
        01      10001               01      10      01
        10      0011X               1X      10      11
        11      01X1X               1X      00      11
    */

endmodule

module MINIMO_3(
    a, b, c,
    min
);
    input [7:0] a, b, c;
    output [7:0] min;

    wire [7:0] min_ab;
    MINIMO_2 m1(
        .a(a), .b(b),
        .min(min_ab)
    );

    wire [7:0] min_abc;
    MINIMO_2 m2(
        .a(min_ab), .b(c),
        .min(min_abc)
    );

    assign min = min_abc;

endmodule

module MINIMO_2(
    a, b,
    min
);
    input [7:0] a, b;
    output [7:0] min;

    wire b_out;
    sottrattore #( .N(8) ) s(
        .x(a), .y(b), .b_in(1'b0),
        .b_out(b_out)
    );

    assign min = b_out ? a : b;

endmodule