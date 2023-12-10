module testbench();

    wire clock_rx, clock_tx;
    clock_generator #( .HALF_PERIOD(7.1) ) clk_rx(
        .clock(clock_rx)
    );
    clock_generator #( .HALF_PERIOD(5.9) ) clk_tx(
        .clock(clock_tx)
    );

    reg reset_;

    reg rxd;
    wire txd;

    ABC dut (
        .rxd(rxd), .txd(txd),
        .clock_rx(clock_rx), .clock_tx(clock_tx), .reset_(reset_)
    );

    localparam marking = 1'B1, start_bit = 1'B0, stop_bit = 1'B1;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        // the following structure is used to wait for expected signals, and fail if too much time passes
        fork : f
            begin
                #10000000;
                $display("Timeout - waiting for signal failed");
                disable f;
            end
        // actual tests start here
            begin
                rxd = marking;

                //reset phase
                reset_ = 0; #20;
                reset_ = 1;

                fork
                    begin: rx
                        reg [5:0] i;
                        reg [4:0] j;
                        reg [9:0] buffer;

                        for (i = 0; i < 32; i++) begin
                            buffer = {stop_bit,get_testcase(i[4:0]),start_bit};
                            for (j = 0; j < 10; j++) begin
                                rxd = buffer[0];
                                buffer = {1'b0, buffer[9:1]};
                                #(16*2*clk_rx.HALF_PERIOD); // tempo di bit rx = 16 cicli clock_rx
                            end
                            rxd = marking;
                            #(160*2*clk_rx.HALF_PERIOD); // intervallo abbondante tra un byte e il successivo
                        end
                    end

                    begin: tx
                        reg [7:0] received;
                        reg [7:0] expected;
                        reg [5:0] i;
                        reg [3:0] j;

                        for (i = 0; i < 32; i++) begin
                            @(negedge txd); #(clk_tx.HALF_PERIOD); // attesa per start_bit, poi allineamento al centro di un ciclo di clock_tx 
                            sampling = 1;

                            expected = get_testcase(i[4:0]);
                            received = 8'H00;

                            for (j = 0; j < 8; j++) begin
                                #(2*clk_tx.HALF_PERIOD); // attendere un intero ciclo di clock_tx mantiene l'allineamento al centro 
                                sampling = 1;
                                received[j] = txd;
                            end

                            #(2*clk_tx.HALF_PERIOD);
                            sampling = 1;
                            if(txd !== stop_bit) begin
                                $display("Error: stop expected from txd");
                                error = 1;
                            end

                            if(received !== expected) begin
                                $display("Expected byte %h, received %h", expected, received);
                                error = 1;
                            end
                        end
                    end
                join

                disable f;
            end
        join

        #20;
        $finish;
    end

    // linee di errore e sampling, utili per il debug
    reg error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;
    
    reg sampling;
    initial sampling = 0;
    always @(posedge sampling) #1
        sampling = 0;

    function automatic [7:0] get_testcase;
        input [4:0] i;
        
        begin
            get_testcase = i * 17 + 13;
        end
    endfunction    

endmodule

// generatore del segnale di clock
module clock_generator(
    clock
);
    output clock;

    parameter HALF_PERIOD = 5;

    reg CLOCK;
    assign clock = CLOCK;

    initial CLOCK <= 0;
    always #HALF_PERIOD CLOCK <= ~CLOCK;

endmodule