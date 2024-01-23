module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    wire soc;
    reg eocx, eocy;
    reg [7:0] x, y;

    wire dav_;
    reg rfd;
    wire [31:0] q;

    ABC dut (
        .x(x), .y(y), .soc(soc), .eocx(eocx), .eocy(eocy), 
        .q(q), .dav_(dav_), .rfd(rfd),
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
            eocx = 1; eocy = 1;
            rfd = 1;

            //reset phase
            reset_ = 0; #(clk.HALF_PERIOD);
            
            //first posedge
            reset_ = 1;

            if(soc !== 0)
                $display("soc is not 0 after reset");

            if(dav_ !== 1)
                $display("dav_ is not 1 after reset");
                
            fork
            //AD converter #1
            begin : producer_1
                reg [4:0] i;
                reg [7:0] x_p, y_p;
                reg [31:0] q_p;

                for (i = 0; i < 16; i++) begin
                    {x_p, y_p, q_p} = get_testcase(i);
                    
                    @(posedge soc);
                    #(1*2*clk.HALF_PERIOD); 
                    eocx = 0;
                    @(negedge soc);
                    #(1*2*clk.HALF_PERIOD); 
                    x = x_p;
                    #(1*2*clk.HALF_PERIOD); 
                    eocx = 1;    
                end
            end
            //AD converter #2
            begin : producer_2
                reg [4:0] i;
                reg [7:0] x_p, y_p;
                reg [31:0] q_p;

                for (i = 0; i < 16; i++) begin
                    {x_p, y_p, q_p} = get_testcase(i);
                    
                    @(posedge soc);
                    #(1*2*clk.HALF_PERIOD); 
                    eocy = 0;
                    @(negedge soc);
                    #(1*2*clk.HALF_PERIOD); 
                    y = y_p;
                    #(1*2*clk.HALF_PERIOD); 
                    eocy = 1;    
                end
            end
            //Consumer
            begin : consumer
                reg [4:0] i;
                reg [7:0] x_c, y_c;
                reg [31:0] q_c;

                for (i = 0; i < 16; i++) begin
                    {x_c, y_c, q_c} = get_testcase(i);

                    @(negedge dav_);
                    if(q !== q_c) begin
                        $display("Test #%g failed, expected %g, got %g", i, q_c, q);
                        error = 1;
                    end
                    #(2*clk.HALF_PERIOD); 
                    rfd = 0;
                    @(posedge dav_);
                    #(2*clk.HALF_PERIOD); 
                    rfd = 1;
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

    function automatic [47:0] get_testcase;
        input [5:0] i;

        reg [7:0] x, y;
        reg [31:0] q;

        begin
            case(i)
                0: begin
                    x = 8'hff;
                    y = 8'hff;
                end
                default: begin
                    x = i[5:2] + 1;
                    y = i[1:0] + 4;
                end
            endcase
            
            q = (x + y) * (x + y);
            get_testcase = {x, y, q};
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