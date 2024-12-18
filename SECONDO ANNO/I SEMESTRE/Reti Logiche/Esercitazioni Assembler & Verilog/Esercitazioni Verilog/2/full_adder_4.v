module full_adder_4(
    x, y, c_in,
    s, c_out
);
    input [3:0] x, y;
    input c_in;
    output [3:0] s;
    output c_out;

    wire c_out_0;
    full_adder fa_0(
        .x(x[0]), .y(y[0]), .c_in(c_in),
        .s(s[0]), .c_out(c_out_0)
    );

    wire c_out_1;
    full_adder fa_1(
        .x(x[1]), .y(y[1]), .c_in(c_out_0),
        .s(s[1]), .c_out(c_out_1)
    );

    wire c_out_2;
    full_adder fa_2(
        .x(x[2]), .y(y[2]), .c_in(c_out_1),
        .s(s[2]), .c_out(c_out_2)
    );

    full_adder fa_3(
        .x(x[3]), .y(y[3]), .c_in(c_out_2),
        .s(s[3]), .c_out(c_out)
    );

endmodule