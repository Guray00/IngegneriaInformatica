module ABC (
    soc, eoc1, x1, eoc2, x2, eoc3, x3, 
    dav_, rfd, min, 
    clock, reset_
);
    input          clock, reset_;
    input          eoc1, eoc2, eoc3, rfd;
    output         soc, dav_;
    input   [7:0]  x1, x2,x3;
    output  [7:0]  min;
    
    reg            SOC,DAV_;
    reg     [7:0]  MIN;
    reg     [2:0]  STAR;
    
    localparam S0=0, S1=1, S2=2, S3=3, S4=4; 

    assign soc=SOC;
    assign dav_=DAV_;
    assign min=MIN;

    wire [7:0] min_1_2_3;
    MINIMO_3 m (
        .a(x1), .b(x2), .c(x3), .min(min_1_2_3)
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
                    MIN <= min_1_2_3;
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

module MINIMO_3(
    a, b, c,
    min
);
    input [7:0] a, b, c;
    output [7:0] min;

    wire [7:0] min_a_b;
    MINIMO_2 m1 (
        .a(a), .b(b), .min(min_a_b)
    );

    wire [7:0] min_a_b_c;
    MINIMO_2 m2 (
        .a(min_a_b), .b(c), .min(min_a_b_c)
    );

    assign min = min_a_b_c;

endmodule

module MINIMO_2(
    a, b,
    min
);
    input [7:0] a, b;
    output [7:0] min;

    wire b_out;
    sottrattore #( .N(8) ) s (
        .x(a), .y(b), .b_in(1'b0),
        .b_out(b_out)
    );
    
    assign min = b_out ? a : b;
endmodule