module full_adder(
    x, y, c_in,
    s, c_out
);
    input x, y, c_in;
    output s, c_out;

    // descrizione
    // assign #1 {c_out, s} = x + y + c_in;

    // sintesi
    assign #1 s = x ^ y ^ c_in;
    assign #1 c_out = ( x & y ) | ( x & c_in ) | ( y & c_in ); 

endmodule