module ABC (
    soc1, eoc1, x1, 
    soc2, eoc2, x2, 
    out, 
    clock, reset_
);
    input clock, reset_;
    input eoc1, eoc2;
    output soc1, soc2;
    input [7:0] x1, x2;
    output out;
    
    reg SOC;
    assign soc1 = SOC;
    assign soc2 = SOC;
    
    reg OUT;
    assign out = OUT;
    
    reg [7:0] COUNT;

    reg [2:0] STAR;
    localparam S0=0, S1=1, S2=2, S3=3, S4=4; 

    wire [7:0] m;
    MEDIA me (
        .a(x1), .b(x2), .m(m)
    );

    always @(reset_==0) #1 
        begin
            OUT = 0;
            SOC = 0; 
            STAR = S0; 
        end
    
    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: 
                begin
                    OUT <= 0;
                    SOC <= 1;
                    STAR <= ({eoc1,eoc2}==2'B00) ? S1 : S0;
                end
            S1: 
                begin
                    SOC <= 0;
                    COUNT <= m;
                    STAR <= ({eoc1,eoc2}==2'B11) ? S2 : S1; 
                end
            S2: 
                begin
                    STAR <= (COUNT == 0) ? S0 : S3; 
                end
            S3: 
                begin
                    COUNT <= COUNT - 1;
                    OUT <= 1;
                    STAR <= (COUNT == 1) ? S0 : S3; 
                end
        endcase

endmodule

module MEDIA(
    a, b,
    m
);
    input [7:0] a, b;
    output [7:0] m;

    wire [8:0] s;
    add #(.N(8)) a1 (
        .x(a), .y(b), .c_in(1'b0),
        .s(s[7:0]), .c_out(s[8])
    );

    assign m = s[8:1];

endmodule
