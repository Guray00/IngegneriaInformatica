module testbench();

    wire clock;
    reg reset_;

    clock_generator clk(
        .clock(clock)
    );

    parameter mark = 1, space = 0; 
    reg rxd;

    reg [4:0] ref;
    wire [2:0] led;
    
    ABC dut (
        .led(led), .rxd(rxd), .ref(ref),
        .reset_(reset_), .clock(clock)
    );

    // Debug variables to highlight errors in waveform diagram
    reg error;

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            error = 0;
            
            //the following structure is used to wait for expected signals, and fail if too much time passes
            fork : f
                begin
                    #100000;
                    $display("Timeout - waiting for signal failed");
                    disable f;
                end
            //actual tests start here
                begin
                    //reset phase
                    ref = 5'B01010;
                    rxd = mark;
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;

                    fork
                        begin : transmitter
                            reg [3:0] i;

                            reg [7:0] byte;
                            reg [3:0] bit_idx;
                            reg [3:0] bit_len;
                            
                            for(i = 1; i < 8; i++) begin
                                if(i[0] == 0)
                                    // pari: valido
                                    byte = {ref, i[2:0]};
                                else
                                    // dispari: invalido
                                    byte = {~ref, i[2:0]};

                                // trasmissione di ciascun bit, a partire da LSB
                                for(bit_idx = 0; bit_idx < 8; bit_idx++) begin
                                    if(byte[bit_idx] == 1) 
                                        bit_len = 2 + ({byte, bit_idx} % 6);    // [2, 7]
                                    else
                                        bit_len = 11 + ({byte, bit_idx} % 5);   // [11, 15]
                                    
                                    rxd = space;
                                    #( bit_len * 2 * clk.HALF_PERIOD);
                                    rxd = mark;
                                    #( 20 * 2 * clk.HALF_PERIOD);
                                end
                            end
                        end
                        
                        begin : led_correctness
                            reg [3:0] i;
                            reg [2:0] expected;

                            for(i = 2; i < 8; i = i + 2) begin
                                @(led);
                                expected = i[2:0];

                                if(expected !== led) begin
                                    $display("Wrong output: expected %d, got %d instead", expected, led);
                                    error = 1;
                                end
                            end
                        end
                    join                   

                    disable f;
                end   
            join

            $finish;
        end

    always @(posedge error) #1
        error = 0;

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