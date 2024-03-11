module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg soc;
    wire eoc;
    
    reg [9:0] b;
    reg [9:0] c;

    reg [7:0] l_0;
    reg [7:0] r_0;
        
    wire [7:0] x_0;

    ABC dut (
        .b(b), .c(c), .l_0(l_0), .r_0(r_0), .x_0(x_0),  
        .soc(soc), .eoc(eoc),
        .clock(clock), .reset_(reset_)
    );

    initial
    begin
        $dumpfile("waveform.vcd");
        $dumpvars;

        //the following structure is used to wait for expected signals, and fail if too much time passes
        fork : f
        begin
            #10000000;
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
            begin : consumer
                reg [8:0] i;
                reg [9:0] b_c, c_c;
                reg [7:0] l_0_c, r_0_c, x_0_c;

                for (i = 1; i < 20; i++) begin
                    {b_c, c_c, l_0_c, r_0_c, x_0_c} = get_testcase(i[7:0]);

                    b = b_c;
                    c = c_c;
                    l_0 = l_0_c;
                    r_0 = r_0_c;
                    #(2*clk.HALF_PERIOD);
                    soc = 1;
                    @(negedge eoc);
                    #(20*clk.HALF_PERIOD);
                    soc = 0;
                    @(posedge eoc);

                    if(x_0 !== x_0_c) begin
                        $display("Test #%g failed, expected %g, got %g", i, x_0_c, x_0);
                        error = 1;
                    end
                    #(3*clk.HALF_PERIOD); 
                    if(x_0 !== x_0_c) begin
                        $display("Test #%g failed, expected %g, got %g : did not hold the value!", i, x_0_c, x_0);
                        error = 1;
                    end
                    
                    #(2*clk.HALF_PERIOD); 
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

    function automatic [51:0] get_testcase;
        input [7:0] i_0;
        
        reg [9:0] b, c;
        reg [7:0] l_0, r_0, x;

        begin
            case(i_0)
                0: begin
                    b = 3;
                    c = 4;
                    l_0 = 0;
                    r_0 = 10;
                    x = 4;
                end
                
                1: begin
                    b = 3;
                    c = 4;
                    l_0 = 0;
                    r_0 = 6;
                    x = 4;
                end
                
                2: begin
                    b = 3;
                    c = 4;
                    l_0 = 0;
                    r_0 = 8;
                    x = 4;
                end
                
                3: begin
                    b = 3;
                    c = 4;
                    l_0 = 0;
                    r_0 = 8;
                    x = 4;
                end
                
                4: begin
                    b = 3;
                    c = 4;
                    l_0 = 0;
                    r_0 = 8;
                    x = 4;
                end
                
                5: begin
                    b = 46;
                    c = 992;
                    l_0 = 0;
                    r_0 = 63;
                    x = 62;
                end
                
                6: begin
                    b = 125;
                    c = 126;
                    l_0 = 0;
                    r_0 = 127;
                    x = 126;
                end

                7: begin
                    b = 154;
                    c = 960;
                    l_0 = 0;
                    r_0 = 240;
                    x = 160;
                end
                
                default: begin
                    b = 3;
                    c = 4;
                    l_0 = 0;
                    r_0 = 10;
                    x = 4;
                end
            endcase
            
            get_testcase = {b, c, l_0, r_0, x};
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
