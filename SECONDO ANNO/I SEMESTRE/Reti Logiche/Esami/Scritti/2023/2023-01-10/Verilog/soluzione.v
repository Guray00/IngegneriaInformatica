module ABC(
    x, soc, eoc, 
    c1, rfd1, dav1_,
    c2, rfd2, dav2_,
    c3, rfd3, dav3_,
    clock, reset_
);
    input [7:0] x;
    output soc;
    input eoc;

    output [2:0] c1;
    input rfd1;
    output dav1_;

    output [2:0] c2;
    input rfd2;
    output dav2_;

    output [2:0] c3;
    input rfd3;
    output dav3_;

    input clock, reset_;

    reg [7:0] X;
    reg SOC;
    reg [2:0] C;
    reg DAV_;

    assign soc = SOC;
    assign c1 = C;
    assign c2 = C;
    assign c3 = C;
    assign dav1_ = DAV_;
    assign dav2_ = DAV_;
    assign dav3_ = DAV_;

    reg [2:0] STAR;
    localparam[2:0] S0=0, S1=1, S2=2, S3=3, S4=4;

    always @(reset_ == 0) #1 
    begin
        STAR <= S0;
        SOC <= 0;
        DAV_ <= 1;        
    end
    always @(posedge clock) if (reset_==1)#3
    casex(STAR)
        S0: begin
            SOC <= 1;
            STAR <= (eoc==1) ? S0 : S1;
        end
        S1: begin
            SOC <= 0;
            X <= x;
            C <= 0;
            STAR <= (eoc==0) ? S1 : S2;
        end
        S2: begin
            C <= C + X[0];
            X <= {2'b00, X[7:2]};
            STAR <= (X == 'H00) ? S3 : S2;
        end
        S3: begin
            DAV_ <= 0;
            STAR <= ({rfd1, rfd2, rfd3} == 3'b000) ? S4 : S3;
        end
        S4: begin
            DAV_ <= 1;
            STAR <= ({rfd1, rfd2, rfd3} == 3'b111) ? S0 : S4;
        end
    endcase
endmodule
