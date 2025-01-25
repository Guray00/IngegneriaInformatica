module testbench();
    reg a, b, c_in;
    wire s, c_out;

    full_adder fa(
        .x(a), .y(b), .c_in(c_in),
        .s(s), .c_out(c_out)
    );

    initial
        begin
            a = 0; b = 0; c_in = 0; // apply input
            #10; // wait
            if( c_out == 0 && s == 0 ) // check
                $display("0 0 0 -> 0 0 success.");
            else
                $display("0 0 0 -> 0 0 failed.");
                

            a = 1; b = 0; c_in = 1; // apply input
            #10; // wait
            if( c_out == 1 && s == 0 ) // check
                $display("1 0 1 -> 1 0 success.");
            else
                $display("1 0 1 -> 1 0 failed.");
                
            a = 1; b = 1; c_in = 1; // apply input
            #10; // wait
            if( c_out == 1 && s == 1 ) // check
                $display("1 1 1 -> 1 1 success.");
            else
                $display("1 1 1 -> 1 1 failed.");

        end

endmodule