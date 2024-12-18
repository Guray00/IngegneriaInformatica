module testbench();
    reg x, y;
    reg c_in;
    wire s;
    wire c_out;

    full_adder fa (
        .x(x), .y(y), .c_in(c_in),
        .s(s), .c_out(c_out)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
        
        x = 0;
        y = 0;
        c_in = 0;
        #10;
        if(c_out == 0 && s == 0)
            $display("0 0 0 -> 0 0 success");
        else
            $display("0 0 0 -> 0 0 fail");

        x = 1;
        y = 0;
        c_in = 1;
        #10;
        if(c_out == 1 && s == 0)
            $display("1 0 1 -> 1 0 success");
        else
            $display("1 0 1 -> 1 0 fail");

    end

endmodule