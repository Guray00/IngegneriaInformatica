module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    wire [7:0] x, y;
    
    wire eoc;
    reg soc;
    wire [15:0] out;

    ABC dut (
        .x(x), .y(y),
        .soc(soc), .eoc(eoc), .out(out),
        .clock(clock), .reset_(reset_)
    );

    A rc (
        .x(x), .y(y)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        //the following structure is used to wait for expected signals, and fail if too much time passes
        fork : f
            begin
                #100000;
                $display("Timeout - waiting for signal failed");
                disable f;
            end
        //actual tests start here
            begin
                soc = 0;

                //reset phase
                reset_ = 0; #(clk.HALF_PERIOD);
                
                //first posedge
                reset_ = 1;

                if(eoc !== 1)
                    $display("eoc is not 1 after reset");

                fork
                    //B
                    begin : B
                        reg [5:0] i;
                        reg [7:0] t_x, t_y;
                        reg do_loop;

                        t_x = 0;
                        for (i = 0; i < 32; i++) begin
                            do_loop = 1;
                            while (do_loop) begin
                                t_x += 1;
                                t_y = A_function(t_x);
                                if ((t_x * t_y) < 'hABBA)
                                    do_loop = 1;
                                else
                                    do_loop = 0;                                
                            end
                            
                            soc = 1;
                            @(negedge eoc);
                            #(3*2*clk.HALF_PERIOD);
                            soc = 0;
                            @(posedge eoc);

                            if(out !== {t_x, t_y})
                                $display("Test #%g failed, expected %g, got %g", i, {t_x, t_y}, out);
                        end
                    end
                join

                disable f;
            end
        join

        $finish;
    end

    function automatic [15:0] A_function;
        input [7:0] x;
        reg [7:0] y;
        
        begin
            y = {x[1:0], x[5:4], x[7:6], x[3:2]};
            A_function = {x, y};
        end
    endfunction
endmodule

module A(x, y);
    input [7:0] x;
    output [7:0] y;

    assign #1 y = A_function(x);

    function automatic [15:0] A_function;
        input [7:0] x;
        reg [7:0] y;
        
        begin
            y = {x[1:0], x[5:4], x[7:6], x[3:2]};
            A_function = {x, y};
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