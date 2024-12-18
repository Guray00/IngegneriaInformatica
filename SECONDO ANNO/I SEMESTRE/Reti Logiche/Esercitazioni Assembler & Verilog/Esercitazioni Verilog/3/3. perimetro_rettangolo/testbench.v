module testbench();
    reg [3:0] a, b;
    reg reset_, dav_;

    wire clock, rfd;
    wire [5:0] p;

    clock_generator clk(
        .clock(clock)
    );

    ABC dut(
        .a(a), .b(b), .clock(clock), .reset_(reset_), .dav_(dav_),
        .p(p), .rfd(rfd)
    );

    // Debug variable, used to highlight points on the waveform
    reg error;

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
                //reset phase
                reset_ = 0; #(clk.HALF_PERIOD);
                dav_ = 1;
                reset_ = 1; #(clk.HALF_PERIOD);

                //clock e' all' edge negativo

                if(rfd != 1)
                    $display("rfd is not 1 after reset");
                    
                fork
                    begin: producer
                        reg [5:0] i;
                        reg [3:0] t_a, t_b;
                        reg [5:0] t_p;

                        for (i = 0; i < 32; i++) begin
                            {t_a, t_b, t_p}= get_testcase(i[4:0]);

                            #(2*clk.HALF_PERIOD);
                            a = t_a;
                            b = t_b;
                            #(2*clk.HALF_PERIOD);
                            dav_ = 0;

                            @(negedge rfd);
                            dav_ = 1; #1;
                            {a, b} = 8'bX;

                            @(posedge rfd);
                        end
                    end

                    begin: consumer
                        reg [5:0] i;
                        reg [3:0] t_a, t_b;
                        reg [5:0] t_p;

                        for (i = 0; i < 32; i++) begin
                            {t_a, t_b, t_p}= get_testcase(i[4:0]);

                            @(p);
                            if(p != t_p) begin
                                $display("Expected %d, received %d", t_p, p);
                                error = 1;
                            end
                        end
                    end
                join

                #10;
                disable f;
            end
        join

        $finish;
    end

    initial error = 0;
    always @(posedge error) #1
        error = 0;

    function automatic [13:0] get_testcase;
        input [4:0] i;

        reg [3:0] a, b;
        reg [5:0] p;

        begin
            a = i[4:1] + 3;
            b = i[3:0] + 1;
            p = 2 * (a + b);

            get_testcase = {a, b, p};
        end
    endfunction

endmodule

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