module Soluzione(
    A10,
    A2
);
    input [7:0] A10;
    output [6:0] A2;

    wire [3:0] alpha_1, alpha_0;
    assign alpha_1 = A10[7:4];
    assign alpha_0 = A10[3:0];

    wire min_flag;
    comp_nat #( .N(4) ) p1 (
        .a(alpha_1), .b( 4'B0101),
        .min(min_flag)
    );

    wire [6:0] sum_constant;
    assign sum_constant = { 2'B0, ~min_flag, ~min_flag, ~min_flag, 2'B0 };   // 28 se alpha_1 >= 10, 0 altrimenti

    wire [7:0] m;
    mul_add_nat #( .N(4), .M(4) ) p2 (
        .x(alpha_1), .y(4'B1010), .c(alpha_0),
        .m(m)
    );

    wire [6:0] m_ridotto;
    assign m_ridotto = m[6:0];

    add #( .N(7) ) p3 (
        .x(m_ridotto), .y(sum_constant), .c_in(1'B0),
        .s(A2)
    );

endmodule