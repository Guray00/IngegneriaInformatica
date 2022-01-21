module testbench();

    reg [7:0] A10;    //A10 è composto da N10 cifre in base 10, ciascuna rappresentata su 4 bit.
    wire [6:0] A2;

    Soluzione dut(
        .A10(A10),
        .A2(A2)
    );    

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            A10 = 8'B0000_0101; //+5
            #10;
            if(A2 !== 7'b000_0101)
                $display("+5 failed.");  

            A10 = 8'B0001_0101; //+15
            #10;
            if(A2 !== 7'b000_1111)
                $display("+15 failed.");  

            A10 = 8'B1001_1001; //-1
            #10;
            if(A2 !== 7'b111_1111)
                $display("-1 failed.");  

            A10 = 8'B0110_1001; //-31
            #10;
            if(A2 !== 7'b110_0001)
                $display("-31 failed.");  

        end

endmodule