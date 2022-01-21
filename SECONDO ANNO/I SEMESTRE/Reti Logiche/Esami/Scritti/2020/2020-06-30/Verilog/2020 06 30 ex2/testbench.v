module testbench();

    reg [3:0] c_op, r_op;
    wire [3:0] c, r;

    tastiera t (
        .c(c), .c_op(c_op), .r_op(r_op),
        .r(r)
    );

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg _reset;
    wire [3:0] q;
    wire done;

    XX dut (
        .r3_r0(r), ._reset(_reset), .clock(clock),
        .c3_c0(c), .done(done), .q3_q0(q)
    );

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            //the following structure is used to wait for expected signals, and fail if too much time passes
            fork : f
                begin
                    #10000;
                    $display("Timeout - waiting for signal failed");
                    disable f;
                end
            //actual tests start here
                begin
                    //reset phase
                    _reset = 0; #(clk.HALF_PERIOD);
                    r_op = 0; c_op = 0;
                    _reset = 1; #(clk.HALF_PERIOD);

                    //clock is at negative edge

                    if(done !== 0)
                        $display("done is not down when no key is pressed.");

                    c_op = 4'B0100; r_op = 4'B0010; // 6 key
                    @(posedge done);
                    if(q !== 4'h6)
                        $display("6 failed");

                    r_op = 0; c_op = 0;
                    @(negedge done);

                    c_op = 4'B1000; r_op = 4'B0100; // B key
                    @(posedge done);
                    if(q !== 4'hB)
                        $display("B failed");

                    r_op = 0; c_op = 0;
                    @(negedge done);
                    
                    c_op = 4'B0100; r_op = 4'B1000; // E key
                    @(posedge done);
                    if(q !== 4'hE)
                        $display("E failed");

                    r_op = 0; c_op = 0;
                    @(negedge done);
                    
                    c_op = 4'B1000; r_op = 4'B0001; // 3 key
                    @(posedge done);
                    if(q !== 4'h3)
                        $display("3 failed");

                    r_op = 0; c_op = 0;
                    @(negedge done);

                    disable f;
                end   
            join

            $finish;
        end

endmodule

// il modulo tastiera simula sia la tastiera che l'operatore
// gli ingressi c_op ed r_op sono utilizzati dalla testbench per indicare il tasto che l'operatore preme
module tastiera(
    c, c_op, r_op, 
    r
);
    input [3:0] c, c_op, r_op;
    output [3:0] r;

    assign r = (c == c_op) ? r_op : 4'B0;
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