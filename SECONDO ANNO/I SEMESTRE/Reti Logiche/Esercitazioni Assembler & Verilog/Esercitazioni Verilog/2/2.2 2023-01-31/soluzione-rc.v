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

    wire [8:0] s12;
    add #( .N(8) ) a (
        .x(m1), .y(m2), .c_in(1'b0),
        .s(s12[7:0]), .c_out(s12[8])
    );

    wire [7:0] m3;
    mul_add_nat ma3(
        .x(x1), .y(y1), .c(s12[7:4]),
        .m(m3)
    );

    wire [3:0] sh;
    add #( .N(4) ) a2 (
        .x(m3[7:4]), .y(4'b0), .c_in(s12[8]),
        .s(sh)
    );

    assign m = {sh, m3[3:0], s12[3:0], m0[3:0]};
endmodule