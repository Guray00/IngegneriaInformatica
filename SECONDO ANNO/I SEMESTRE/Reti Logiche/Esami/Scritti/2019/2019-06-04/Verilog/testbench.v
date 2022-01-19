// Autore: Aleandro Prudenzano

module testbench();
    wire clock;
    clock_generator clk(clock);

    reg x;
    reg reset_;
    wire [15:0] d15_d0;

    wire [3:0] a3_a0;           assign d15_d0 = ROM(a3_a0);
    wire [7:0] z7_z0;

    XXX dut(
        .reset_(reset_), .clock(clock),
        .x(x), .d15_d0(d15_d0),
        .a3_a0(a3_a0), .z7_z0(z7_z0)
    );

    //Simulation vars
    reg [4:0] i;
    reg [7:0] next_out;
    reg [3:0] next_address;
    integer start_time;
    integer end_time;
    integer diff;
    integer lastValue;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
        fork : f
            begin
                #100000;
                $display("Timeout");
                disable f;
            end
            begin
                // Reset
                reset_ = 0;
                x = 0;
                #(clk.HALF_PERIOD);

                if(a3_a0 != 0) begin
                    $display("a3_a0 is not 0 at reset");
                    $finish;
                end

                if(z7_z0 != 0) begin
                    $display("z7_z0 is not 0 at reset");
                    $finish;
                end

                #(clk.HALF_PERIOD);
                reset_ = 1;
                start_time = $time;
                lastValue = 0;

                for(i = 0; i < 16; i++) begin
                    x = (i+1)%2;
                    next_address = (x==1) ? d15_d0[11:8] : d15_d0[15:12];
                    next_out = d15_d0[7:0];
                    #(10*2*clk.HALF_PERIOD);

                    if(next_address != a3_a0) begin
                        $display("Wrong address!");
                        $finish;
                    end

                    if(next_out != z7_z0) begin
                        $display("Wrong output!");
                        $finish;
                    end
                end

                #(10*2*clk.HALF_PERIOD);

                $display("Everything is working afaik");
                disable f;
            end
        join
        $finish;
    end

    always @(negedge clock) begin
        if(z7_z0 != lastValue) begin
            end_time = $time;
            diff = (end_time - start_time)/(2*clk.HALF_PERIOD);
            if(diff != 10) begin
                $display("Output is on for %d clocks, expected 10", diff);
                $finish;
            end
            start_time = $time;
            lastValue = z7_z0;
        end
    end

    function [15:0] ROM;
        input [3:0] address;
        casex(address)
            0: ROM = 16'H120F;
            1: ROM = 16'H349A;
            2: ROM = 16'H515B;
            3: ROM = 16'H759D;
            4: ROM = 16'H3934;
            5: ROM = 16'H780C;
            6: ROM = 16'HAFD3;
            7: ROM = 16'HB51E;
            8: ROM = 16'H9F84;
            9: ROM = 16'H3DDE;
            10: ROM = 16'H761A;
            11: ROM = 16'H598F;
            12: ROM = 16'H359E;
            13: ROM = 16'H9F5C;
            14: ROM = 16'H5C9D;
            15: ROM = 16'H3DE3;
        endcase
    endfunction
endmodule

module clock_generator(clock);
    output clock;

    parameter HALF_PERIOD = 5;

    reg CLOCK;      assign clock = CLOCK;

    initial
        CLOCK = 0;

    always #(HALF_PERIOD) CLOCK <= ~CLOCK;
endmodule