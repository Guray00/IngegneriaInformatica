module sintesi_1(
    b2, b1, b0,
    y
);

    input [1:0] b2, b1, b0;
    output [4:0] y;

    wire [3:0] m_1;
    mul_add #( .N(2), .M(2) ) ma0(
        .x(b1), .y(2'b11), .c(b0),
        .m(m_1)
    );

    wire [5:0] m_2;
    mul_add #( .N(4), .M(2) ) ma1(
        .x(4'b1001), .y(b2), .c(m_1),
        .m(m_2)
    );

    assign y = m_2[4:0];

endmodule