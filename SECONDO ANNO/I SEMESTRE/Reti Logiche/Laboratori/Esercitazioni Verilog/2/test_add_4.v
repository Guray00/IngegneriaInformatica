module testbench();
    reg [3:0] a, b;
    reg c_in;

    wire [3:0] s;
    wire c_out;

    full_adder_4 fa(
        .x(a), .y(b), .c_in(c_in),
        .s(s), .c_out(c_out)
    );

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            a = 4'b0000; b = 4'b0000; c_in = 0; // apply input
            #10; // wait
            if( c_out == 0 && s == 4'b0000 ) // check
                $display("0000 0000 0 -> 0 0000 success.");
            else
                $display("0000 0000 0 -> 0 0000 failed.");
                
            a = 4'b0101; b = 4'b0011; c_in = 0; // apply input
            #10; // wait
            if( c_out == 0 && s == 4'b1000 ) // check
                $display("0101 0011 0 -> 0 1000 success.");
            else
                $display("0101 0011 0 -> 0 1000 failed.");


            a = 4'b1100; b = 4'b0011; c_in = 1; // apply input
            #10; // wait
            if( c_out == 1 && s == 4'b0000 ) // check
                $display("1100 0011 1 -> 1 0000 success.");
            else
                $display("1100 0011 1 -> 1 0000 failed.");

        end

endmodule