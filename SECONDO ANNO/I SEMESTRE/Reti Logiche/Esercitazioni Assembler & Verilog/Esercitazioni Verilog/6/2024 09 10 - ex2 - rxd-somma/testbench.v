module testbench();

    wire clock;
    reg reset_;

    clock_generator clk(
        .clock(clock)
    );

    parameter mark = 1, space = 0; 
    reg rxd;

    wire [7:0] out;
    wire signal, ow;
    
    ABC dut (
        .rxd(rxd), 
        .out(out), .signal(signal), .ow(ow), 
        .reset_(reset_), .clock(clock)
    );

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
                    rxd = mark;
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;

                    fork
                        begin : transmitter
                            reg [5:0] i;

                            reg [7:0] byte;
                            reg [3:0] bit_idx;
                            reg [3:0] bit_len;
                            
                            for(i = 1; i < 32; i++) begin
                                byte = get_x_n(i[4:0]);

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
                        
                        begin : out_correctness
                            reg [5:0] i;
                            reg [7:0] byte_curr, byte_prev;
                            reg [7:0] expected_sum;
                            reg expected_ow;

                            byte_prev = 0;
                            for(i = 1; i < 32; i++) begin
                                byte_curr = get_x_n(i[4:0]);
                                
                                {expected_sum, expected_ow} = get_expected(byte_curr, byte_prev);

                                if(expected_ow) begin
                                    @(posedge ow);
                                    @(negedge ow);
                                    byte_prev = 0;
                                end
                                else begin
                                    @(posedge signal);
                                    if(expected_sum !== out) begin
                                        $display("Wrong output: expected %d, got %d instead", expected_sum, out);
                                        error = 1;
                                    end
                                    @(negedge signal);
                                    byte_prev = byte_curr;
                                end
                            end
                        end
                    join                   

                    disable f;
                end   
            join

            $finish;
        end

    // linea di errore, utile per il debug
    reg error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;

    function automatic [7:0] get_x_n;
        input [4:0] i;
        
        begin
            if(i == 0)
                get_x_n = 0;
            else if (i < 8)
                get_x_n = (i+5) * 19;
            else
                get_x_n = 230 - i * 31;
        end
    endfunction

    function automatic [8:0] get_expected;
        input [7:0] x_curr, x_prev;
        reg [7:0] sum;
        reg ow;
        
        begin
            sum = x_curr + x_prev;
            ow = (x_curr[7] == x_prev[7]) && (x_curr[7] != sum[7]);
            get_expected = {sum, ow};
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