module testbench();
    reg [7:0] x, y;
    wire [7:0] z;
    
    MAX m (
        .x(x), .y(y), .max(z)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        x = 10; y = 5;
        #10;
        if(z != 10)
            $display("Test failed!");

        x = 5; y = 10;
        #10;
        if(z != 10)
            $display("Test failed!");

        x = 10; y = 10;
        #10;
        if(z != 10)
            $display("Test failed!");

        x = 255; y = 254;
        #10;
        if(z != 255)
            $display("Test failed!");

        x = 254; y = 255;
        #10;
        if(z != 255)
            $display("Test failed!");
    end
endmodule