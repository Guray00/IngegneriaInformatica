module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg [7:0] x;
    reg [7:0] y;
    wire [15:0] m;

    reg dav1_, dav2_;
    wire rfd1, rfd2;
    wire ok;

    ABC dut (
        .x(x), .y(y), .m(m), .ok(ok), 
        .dav1_(dav1_), .rfd1(rfd1),
        .dav2_(dav2_), .rfd2(rfd2),
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
            dav1_ = 1;
            dav2_ = 1;

            //reset phase
            reset_ = 0; #(clk.HALF_PERIOD);
            
            //first posedge
            reset_ = 1;

            if(rfd1 !== 1)
                $display("rfd1 is not 1 after reset");
            if(rfd2 !== 1)
                $display("rfd2 is not 1 after reset");
                
            fork
            begin : producer1
                reg [5:0] i_p;
                reg [7:0] x_p;
                reg [7:0] y_p;
                reg [15:0] m_p;

                for (i_p = 0; i_p < 60; i_p++) begin
                    {x_p, y_p, m_p} = get_testcase(i_p);

                    #(3*2*clk.HALF_PERIOD);
                    {x, y} = {x_p, y_p};
                    #(1*2*clk.HALF_PERIOD);
                    dav1_ = 0;
                    @(negedge rfd1);
                    #(3*2*clk.HALF_PERIOD);
                    dav1_ = 1;
                    {x, y} = 8'hXX;
                    @(posedge rfd1);
                end
            end
            begin : producer2
                reg [5:0] i_p;
                reg [7:0] x_p;
                reg [7:0] y_p;
                reg [15:0] m_p;

                for (i_p = 0; i_p < 60; i_p++) begin
                    {x_p, y_p, m_p} = get_testcase(i_p);

                    #(3*2*clk.HALF_PERIOD);
                    {x, y} = {x_p, y_p};
                    #(1*2*clk.HALF_PERIOD);
                    dav2_ = 0;
                    @(negedge rfd2);
                    #(3*2*clk.HALF_PERIOD);
                    dav2_ = 1;
                    {x, y} = 8'hXX;
                    @(posedge rfd2);
                end
            end
            begin : consumer
                reg [5:0] i_c;
                reg [7:0] x_c;
                reg [7:0] y_c;
                reg [15:0] m_c;

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

    function automatic [37:0] get_testcase;
        input [5:0] i;

        reg [7:0] x;
        reg [7:0] y;
        reg [15:0] m;

        begin
            x = (i[5:2] + 1) * 5;
            y = (i[1:0] + 4) * 7;
            m = x * y;
            
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