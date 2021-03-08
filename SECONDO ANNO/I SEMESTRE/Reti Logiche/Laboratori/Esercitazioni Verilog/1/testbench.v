module testbench();
    // input e output
    reg a, b;
    wire c;

    // reti utilizzate e collegamenti tra esse
    mio_modulo m(
        .x(a), .y(b),
        .z(c)
    );

    // test
    initial 
        begin
            
            a = 0; b = 0;   // fornire nuovi segnali input
            #10;            // attendere per corretto pilotaggio della rete
            if( c == 0 )    // check risultato
                $display("0 0 -> 0 success");
            else
                $display("0 0 -> 0 failed");

            a = 0; b = 1; 
            #10;          
            if( c == 1 )  
                $display("0 1 -> 1 success");
            else
                $display("0 1 -> 1 failed");

            a = 1; b = 0; 
            #10;          
            if( c == 1 )  
                $display("1 0 -> 1 success");
            else
                $display("1 0 -> 1 failed");

            a = 1; b = 1; 
            #10;          
            if( c == 1 )  
                $display("1 1 -> 1 success");
            else
                $display("1 1 -> 1 failed");

        end

endmodule