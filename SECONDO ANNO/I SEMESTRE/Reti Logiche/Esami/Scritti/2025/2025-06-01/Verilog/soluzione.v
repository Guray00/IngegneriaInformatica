module ABC (
    soc1, eoc1, x1, 
    soc2, eoc2, x2, 
    soc3, eoc3, x3, 
    dav_, rfd, result, 
    clock, reset_
);
    input   clock, reset_;
    input   eoc1, eoc2, eoc3;
    output  soc1, soc2, soc3;
    input   rfd;
    output  dav_;
    input   [7:0]  x1, x2,x3;
    output  [15:0]  result;
    
    reg            SOC,DAV_;
    reg     [15:0] RESULT;
    reg     [2:0]  STAR;
    
    localparam S0=0, S1=1, S2=2, S3=3, S4=4; 

    assign soc1=SOC;
    assign soc2=SOC;
    assign soc3=SOC;
    assign dav_=DAV_;
    assign result=RESULT;

    wire [12:0] expr_result;
    EXPR e (
        .a(x1), .b(x2), .c(x3), .r(expr_result)
    );

    always @(reset_==0) #1 
        begin
            SOC=0; 
            DAV_=1; 
            STAR=S0; 
        end
    
    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: 
                begin
                    SOC <= 1;
                    STAR <= ({eoc1,eoc2,eoc3}==3'B000) ? S1 : S0;
                end
            S1: 
                begin
                    SOC <= 0;
                    RESULT <= {3'd0, expr_result};
                    STAR <= ({eoc1,eoc2,eoc3}==3'B111) ? S2 : S1; 
                end
            S2: 
                begin
                    DAV_ <= 0;
                    STAR <= (rfd==1) ? S2 : S3; 
                end
            S3: 
                begin
                    DAV_ <= 1; 
                    STAR <= (rfd==0) ? S3 : S0; 
                end
        endcase

endmodule

module EXPR(
    a, b, c,
    r
);
    input [7:0] a, b, c;
    output [12:0] r;

    wire [9:0] b3;
    mul_add_nat #(.N(8), .M(2)) m1 (
        .x(b), .y(2'd3), .c(8'd0),
        .m(b3)
    );

    wire [9:0] ab3;
    add #(.N(10)) a1 (
        .x({2'b00, a}), .y(b3), .c_in(1'b0),
        .s(ab3)
    );

    wire [12:0] ab3_5;
    mul_add_nat #(.N(10), .M(3)) m2 (
        .x(ab3), .y(3'd5), .c(10'd0),
        .m(ab3_5)
    );

    add #(.N(13)) a2 (
        .x(ab3_5), .y({5'd0, c}), .c_in(1'b0),
        .s(r)
    );

endmodule
