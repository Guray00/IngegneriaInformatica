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

    reg [7:0] MIN;
    assign min = MIN;
    reg SOC, DAV_;
    assign soc = SOC;
    assign dav_ = DAV_; 

    reg [1:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3;

    wire [7:0] minimo_3;
    MINIMO_3 m(
        .a(x1), .b(x2), .c(x3),
        .min(minimo_3)
    );

    always @(reset_ == 0) #1 begin
        SOC <= 0;
        DAV_ <= 1;
        STAR <= S0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(STAR)
            S0: begin
                SOC <= 1;
                STAR <= ({eoc1, eoc2, eoc3}==3'b000) ? S1 : S0;
            end

            S1: begin
                SOC <= 0;
                MIN <= minimo_3;
                STAR <= ({eoc1, eoc2, eoc3}==3'b111) ? S2 : S1;
            end

            S2: begin
                DAV_ <= 0;
                STAR <= (rfd==1) ? S2 : S3;
            end

            S3: begin
                DAV_ <= 1;
                STAR <= (rfd==0) ? S3 : S0;
            end
        endcase
    end
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