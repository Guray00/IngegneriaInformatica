module testbench();
    reg [2:0] x, y;
    reg c_in;
    wire [2:0] s;
    wire c_out;

    full_adder_3 fa (
        .x(x), .y(y), .c_in(c_in),
        .s(s), .c_out(c_out)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        x = 3'b000;
        y = 3'b000;
        c_in = 0;
        #20;
        if(c_out == 0 && s == 3'b000)
            $display("000 000 0 -> 0 000 success");
        else
            $display("000 000 0 -> 0 000 fail");

        x = 3'b101;
        y = 3'b011;
        c_in = 0;   
        #20;
        if(c_out == 1 && s == 3'b000)
            $display("101 011 0 -> 1 000 success");
        else
            $display("101 011 0 -> 1 000 fail");

    end

endmodule