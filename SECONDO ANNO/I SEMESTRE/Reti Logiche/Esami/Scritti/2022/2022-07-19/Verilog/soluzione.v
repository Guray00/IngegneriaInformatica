module ABC (
    soc, eoc1, x1, eoc2, x2, eoc3, x3, eoc4, x4, 
    dav_, rfd, avg, 
    clock, reset_
);
    input          clock, reset_;
    input          eoc1, eoc2, eoc3, eoc4, rfd;
    output         soc, dav_;
    input   [7:0]  x1, x2, x3, x4;
    output  [7:0]  avg;
    
    reg            SOC,DAV_;
    reg     [7:0]  AVG;
    reg     [2:0]  STAR;
    
    localparam S0=0, S1=1, S2=2, S3=3, S4=4; 

    assign soc=SOC;
    assign dav_=DAV_;
    assign avg=AVG;

    wire [7:0] avg_rc;
    MEDIA_4 m (
        .a(x1), .b(x2), .c(x3), .d(x4),
        .avg(avg_rc)
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
                    STAR <= ({eoc1,eoc2,eoc3,eoc4}==4'B0000) ? S1 : S0;
                end
            S1: 
                begin
                    SOC <= 0;
                    AVG <= avg_rc;
                    STAR <= ({eoc1,eoc2,eoc3,eoc4}==4'B1111) ? S2 : S1; 
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

module MEDIA_4(
    a, b, c, d,
    avg
);
    input [7:0] a, b, c, d;
    output [7:0] avg;

    wire [7:0] avg_a_b;
    MEDIA_2 m1 (
        .a(a), .b(b), .avg(avg_a_b)
    );

    wire [7:0] avg_c_d;
    MEDIA_2 m2 (
        .a(c), .b(d), .avg(avg_c_d)
    );

    MEDIA_2 m3 (
        .a(avg_a_b), .b(avg_c_d), .avg(avg)
    );

endmodule

module MEDIA_2(
    a, b,
    avg
);
    input [7:0] a, b;
    output [7:0] avg;

    wire [7:0] s;
    wire c_out;
    add #( .N(8) ) add (
        .x(a), .y(b), .c_in(1'b0),
        .s(s), .c_out(c_out)
    );
    
    assign avg = {c_out, s[7:1]};
endmodule