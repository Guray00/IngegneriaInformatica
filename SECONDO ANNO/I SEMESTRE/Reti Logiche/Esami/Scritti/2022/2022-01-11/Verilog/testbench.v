module testbench();
    wire clock;
    clock_generator clk(
        .clock(clock)
    );
    reg reset_;

    wire [15:0] addr;
    wire [7:0] data;
    wire positivo, riducibile;

    ABC dut (
        .addr(addr), .data(data), .positivo(positivo), .riducibile(riducibile), 
        .clock(clock), .reset_(reset_) 
    );

    eprom_16Kx8 eprom (
        .addr(addr), .data(data),
        .s_(1'b0), .mr_(1'b0)
    );

    // linee di errore e sampling, utili per il debug
    reg error, sampling;
    initial error = 0;
    always @(posedge error) #1 
        error = 0;
    initial sampling = 0;
    always @(posedge sampling) #1 
        sampling = 0;

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
            begin: test
                reg [6:0] i;
                reg [3:0] a1, a0;
                reg p, r;
                realtime prev_sample;
                realtime current_sample;
                realtime diff;

                prev_sample = 0;
                //reset phase
                reset_ = 0; #(clk.HALF_PERIOD);

                //first posedge
                reset_ = 1;

                for(i = 0; i < 64; i++) begin
                    {a1, a0, p, r} = get_testcase(i[4:0]);
                    @({positivo, riducibile});
                    sampling = 1;
                    if(positivo !== p || riducibile !== r) begin
                        error = 1;
                        $display("%g-th result is {%b,%b} , expected {%b,%b} instead", i, positivo, riducibile, p, r);
                    end

                    current_sample = $realtime;
                    if(prev_sample != 0) begin
                        diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                        if( diff != 10 ) begin
                            error = 1;
                            $display("Wrong timing: expected 10 clocks, got %g instead", diff);
                        end
                    end
                    prev_sample = current_sample;
                end

                disable f;
            end
        join

        #10;
        $finish;
    end
    
    // same function, copied over to eprom and testbench
    function automatic [9:0] get_testcase;
        input [4:0] i;
        
        reg [3:0] a1, a0;
        reg p, r;

        begin
            a1 = ((i+3) * 5) % 10;
            a0 = ((i+5) * 7) % 10;
            p = (a1 < 5) ? 1 : 0;
            r = (a1 == 0 && a0 < 5) || (a1 == 9 && a1 >= 5);
            get_testcase = {a1, a0, p, r};
        end
    endfunction

endmodule

module eprom_16Kx8 (
    addr, s_, mr_,
    data
);
    input [15:0] addr;
    input s_, mr_;
    
    output [7:0] data;

    wire [4:0] i;
    assign i = addr[4:0];

    reg [3:0] a1, a0;
    reg p, r;
    always @(i) begin
        {a1, a0, p, r} = get_testcase(i);
    end

    assign #1 data = {a1, a0};

    // same function, copied over to eprom and testbench
    function automatic [9:0] get_testcase;
        input [4:0] i;
        
        reg [3:0] a1, a0;
        reg p, r;

        begin
            a1 = ((i+3) * 5) % 10;
            a0 = ((i+5) * 7) % 10;
            p = (a1 < 5) ? 1 : 0;
            r = (a1 == 0 && a0 < 5) || (a1 == 9 && a1 >= 5);
            get_testcase = {a1, a0, p, r};
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
