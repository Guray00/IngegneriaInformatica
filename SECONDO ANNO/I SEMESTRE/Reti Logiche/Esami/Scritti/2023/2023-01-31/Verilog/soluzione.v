module ABC(x, y, dav1_, rfd1, dav2_, rfd2, m, ok, clock, reset_);
    input [7:0] x;
    input [7:0] y;
    input dav1_, dav2_;
    output rfd1, rfd2;
    output [15:0] m;    
    output ok;
    input clock, reset_;

    reg [7:0] X;
    reg [7:0] Y;
    reg RFD;
    assign rfd1 = RFD;
    assign rfd2 = RFD;

    reg OK;
    assign ok = OK;
    
    MUL8 m8(
        .x(X), .y(Y),
        .m(m)
    );

    reg [1:0] STAR;
    localparam 
        S0 = 0, 
        S1 = 1, 
        S2 = 2, 
        S3 = 3;


    always@(reset_==0) #1 
    begin 
        RFD <= 1;
        OK <= 0;
        STAR <= S0;
    end

    always @(posedge clock) if (reset_==1) #3
    casex(STAR)
        S0: begin
            OK <= 0;
            RFD <= 1;
            X <= x;
            Y <= y;
            STAR <= ({dav1_, dav2_} == 2'b00) ? S1 : S0;
        end

        S1: begin
            OK <= 1;
            RFD <= 0;
            STAR <= ({dav1_, dav2_} == 2'b11) ? S0 : S1;
        end
    endcase

endmodule

// x naturale su 8 bit
// y naturale su 8 bit
// m = x * y, su 16 bit
module MUL8(x, y, m);
    input [7:0] x;
    input [7:0] y;
    output [15:0] m;   

    wire [3:0] x0, x1;
    assign {x1, x0} = x;
    wire [3:0] y0, y1;
    assign {y1, y0} = y;
    
    wire [7:0] m0;
    mul_add_nat ma0(
        .x(x0), .y(y0), .c(4'b0000),
        .m(m0)
    );

    wire [7:0] m1;
    mul_add_nat ma1(
        .x(x0), .y(y1), .c(m0[7:4]),
        .m(m1)
    );

    wire [7:0] m2;
    mul_add_nat ma2(
        .x(x1), .y(y0), .c(4'b0000),
        .m(m2)
    );

    wire [7:0] s12;
    add #( .N(8) ) a (
        .x(m1), .y(m2), .c_in(1'b0),
        .s(s12)
    );

    wire [7:0] m3;
    mul_add_nat ma3(
        .x(x1), .y(y1), .c(s12[7:4]),
        .m(m3)
    );

    assign m = {m3, s12[3:0], m0[3:0]};
endmodule
