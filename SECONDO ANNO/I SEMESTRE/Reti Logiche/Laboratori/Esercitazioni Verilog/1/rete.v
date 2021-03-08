module mio_modulo(
    x, y,
    z
);
    input x, y;
    output z;

    assign #5 z = x | y;
endmodule