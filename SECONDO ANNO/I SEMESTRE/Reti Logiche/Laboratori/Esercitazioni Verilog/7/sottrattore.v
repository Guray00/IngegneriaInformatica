// Sottrattore per numeri naturali
module sottrattore(
    x, y, d, b_in, b_out
);
    parameter N = 8;

    input [N-1:0] x, y;
    input b_in;

    output [N-1:0] d;
    output b_out;

    assign #1 {b_out, d} = x - y - b_in;

endmodule