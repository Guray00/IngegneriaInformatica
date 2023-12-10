module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg [3:0] x;
    reg [2:0] y;
    wire m;

    reg dav_;
    wire rfd;
    wire [7:0] avg;

    TEST_MULTIPLO dut (
        .x(x), .y(y), .m(m), .ok(ok), 
        .dav_(dav_), .rfd(rfd),
        .clock(clock), .reset_(reset_)
    );

    initial
    begin
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
            dav_ = 1;

            //reset phase
            reset_ = 0; #(clk.HALF_PERIOD);
            
            //first posedge
            reset_ = 1;

            if(rfd !== 1)
                $display("rfd is not 1 after reset");
                
            fork
            begin : producer
                reg [5:0] i_p;
                reg [3:0] x_p;
                reg [2:0] y_p;
                reg m_p;

                for (i_p = 0; i_p < 60; i_p++) begin
                    {x_p, y_p, m_p} = get_testcase(i_p);

                    #(3*2*clk.HALF_PERIOD);
                    {x, y} = {x_p, y_p};
                    #(1*2*clk.HALF_PERIOD);
                    dav_ = 0;
                    @(negedge rfd);
                    #(3*2*clk.HALF_PERIOD);
                    dav_ = 1;
                    {x, y} = 8'hXX;
                    @(posedge rfd);
                end
            end
            begin : consumer
                reg [5:0] i_c;
                reg [3:0] x_c;
                reg [2:0] y_c;
                reg m_c;

                for (i_c = 0; i_c < 60; i_c++) begin
                    {x_c, y_c, m_c} = get_testcase(i_c);

                    @(posedge ok);
                    if(m != m_c) begin
                        $display("Wrong result: expected %d, got %d", m_c, m);
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

    // linea di errore, utile per il debug
    reg error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;

    function automatic [7:0] get_testcase;
        input [5:0] i;

        reg [3:0] x;
        reg [2:0] y;
        reg m;

        begin
            x = i[5:2] + 1;
            y = i[1:0] + 4;
            m = (x % y) == 0;
            
            get_testcase = {x, y, m};
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