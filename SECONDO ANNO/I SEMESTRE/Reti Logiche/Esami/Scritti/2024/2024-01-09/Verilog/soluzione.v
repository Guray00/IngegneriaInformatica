module ABC (
    x, y, soc, eocx, eocy, 
    q, dav_, rfd,
    clock, reset_
);
    input [7:0] x, y;
    input eocx, eocy;
    output soc;

    output [31:0] q;
    input rfd;
    output dav_;

    input clock, reset_;

    reg SOC;
    assign soc = SOC;

    reg DAV_;
    assign dav_ = DAV_;

    reg [31:0] Q;
    assign q = Q;

    wire [17:0] qds_result;
    QUADRATO_DELLA_SOMMA qds(
        .x(x), .y(y),
        .q(qds_result)
    );

    reg [1:0] STAR;
    localparam 
        S0 = 0, 
        S1 = 1, 
        S2 = 2, 
        S3 = 3;


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
                    STAR <= ({eocx,eocy}==2'B00) ? S1 : S0;
                end
            S1: 
                begin
                    SOC <= 0;
                    Q <= { 14'b0, qds_result };
                    STAR <= ({eocx,eocy}==2'B11) ? S2 : S1; 
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

// x e y naturali su 8 bit
// q = (x + y)^2 naturale su 18 bit
module QUADRATO_DELLA_SOMMA(x, y, q);
    input [7:0] x, y;
    output [17:0] q;   

    // (x + y) su 9 bit, non si può usare per il quadrato
    // (x + y)^2 = x^2 + 2xy + y^2 -> somma di prodotti con operandi a 8 bit

    wire [15:0] x2;
    mul_add_nat mx2 (
        .x(x), .y(x), .c(8'b0),
        .m(x2)
    );

    wire [15:0] xy;
    mul_add_nat mxy (
        .x(x), .y(y), .c(8'b0),
        .m(xy)
    );

    wire [15:0] y2;
    mul_add_nat my2 (
        .x(y), .y(y), .c(8'b0),
        .m(y2)
    );

    wire [16:0] s1;
    add #(.N(16)) a1 (
        .x(x2), .y(y2), .c_in(1'b0),
        .c_out(s1[16]), .s(s1[15:0])
    );

    add #(.N(17)) a2 (
        .x(s1), .y({xy, 1'b0}), .c_in(1'b0),
        .c_out(q[17]), .s(q[16:0])
    );

endmodule
