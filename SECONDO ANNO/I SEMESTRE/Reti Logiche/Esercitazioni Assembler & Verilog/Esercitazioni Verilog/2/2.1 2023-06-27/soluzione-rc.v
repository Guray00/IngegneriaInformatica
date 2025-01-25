module MAX(
    x, y,
    max
);
    input [7:0] x, y;
    output [7:0] max;

    wire [7:0] y_neg;
    assign #1 y_neg = ~y;

    wire c_out;
    add #( .N(8) ) s (
        .x(x), .y(y_neg), .c_in(1'b1),
        .c_out(c_out)
    );

    wire b_out;
    assign #1 b_out = ~c_out;
    
    assign #1 max = b_out ? y : x;
endmodule