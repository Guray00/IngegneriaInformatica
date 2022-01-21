module testbench();

    reg [7:0] X, Y;
    wire [7:0] S;
    wire c_out, ow;

    Soluzione dut(
        .X(X), .Y(Y),
        .S(S), .c_out(c_out), .ow(ow)
    );    

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            X = 8'h00; Y = 8'h08; // 0 8
            #10;
            if(S !== 8'h08 || c_out !== 1'B0 || ow !== 1'B0 )
                $display("h00 h08 failed.");  

            X = 8'h80; Y = 8'h80; // 128 128 as naturals; -128 -128 as integers
            #10;
            if(S !== 8'h00 || c_out !== 1'B1 || ow !== 1'B1 )
                $display("h80 h80 failed.");

            X = 8'h40; Y = 8'h40; // 64 64
            #10;
            if(S !== 8'h80 || c_out !== 1'B0 || ow !== 1'B1 )
                $display("h40 h40 failed.");  

            X = 8'hFF; Y = 8'h01; // 255 1 as naturals; -1 1 as integers
            #10;
            if(S !== 8'h00 || c_out !== 1'B1 || ow !== 1'B0 )
                $display("hFF h01 failed.");

        end

endmodule