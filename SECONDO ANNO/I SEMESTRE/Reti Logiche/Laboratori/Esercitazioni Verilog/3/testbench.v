// 28 01 2020 - Esercizio 1
// Dato un numero naturale N espresso su 3 cifre in base 3 
// 1) sintetizzare il circuito che esprime N su ? bit in base 2
// 2) sintetizzare un circuito fatto di soli sommatori che calcola lo stesso risultato

module testbench();
    //reg di input rc, wire di output
    reg [1:0] b2, b1, b0;   // 3 cifre base 3, 2 bit ciascuna
    wire [4:0] y;   // 5 cifre base 2

    //instanziazione e collegamento
    sintesi_1 dut(
        .b2(b2), .b1(b1), .b0(b0),
        .y(y)
    );

    // sintesi_2 dut(
    //     .b2(b2), .b1(b1), .b0(b0),
    //     .y(y)
    // );

    //test della rete
    initial 
        begin
            // $dumpfile("waveform.vcd");
            // $dumpvars;

            b2 = 'd0; b1 = 'd0; b0 = 'd0; // apply input
            #10; // wait
            if(y !== 'd0) // check
                $display("000 -> 0 failed.");  
            else
                $display("000 -> 0 success.");

            b2 = 'd0; b1 = 'd1; b0 = 'd0;
            #10;
            if(y !== 'd3) 
                $display("010 -> 3 failed.");
            else
                $display("010 -> 3 success.");

            b2 = 'd1; b1 = 'd0; b0 = 'd0;
            #10;
            if(y !== 'd9) 
                $display("100 -> 9 failed.");
            else
                $display("100 -> 9 success.");

            b2 = 'd0; b1 = 'd2; b0 = 'd0;
            #10;
            if(y !== 'd6) 
                $display("020 -> 6 failed.");
            else
                $display("020 -> 6 success.");

            b2 = 'd1; b1 = 'd2; b0 = 'd1;
            #10;
            if(y !== 'd16) 
                $display("121 -> 16 failed.");
            else
                $display("121 -> 16 success.");
        end

endmodule