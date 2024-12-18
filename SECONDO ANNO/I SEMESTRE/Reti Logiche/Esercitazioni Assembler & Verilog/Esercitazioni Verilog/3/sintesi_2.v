module sintesi_2(
    b2, b1, b0,
    y
);

    input [1:0] b2, b1, b0;
    output [4:0] y;

    wire co_0;
    wire [1:0] s_0;
    add #( .N(2) ) a0 (
        .x(b1), .y(b0), .c_in(1'b0),
        .s(s_0), .c_out(co_0)
    );

    wire [2:0] se_0;
    assign se_0 = { co_0, s_0 };
    
    wire [2:0] b1_2;
    assign b1_2 = { b1, 1'b0 };

    wire co_1;
    wire [2:0] s_1;
    add #( .N(3) ) a1 (
        .x(b1_2), .y(se_0), .c_in(1'b0),
        .s(s_1), .c_out(co_1)
    );

    wire [4:0] se_1;
    assign se_1 = { 1'b0,  co_1, s_1 };

    wire [4:0] b2_9;
    assign b2_9 = { b2, 1'b0, b2 };

    wire co_2;
    wire [4:0] s_2;
    add #( .N(5) ) a2 (
        .x(b2_9), .y(se_1), .c_in(1'b0),
        .s(s_2), .c_out(co_2)
    );

    assign y = s_2;

endmodule