module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg [7:0] x;
    wire soc;
    reg eoc; 

    wire out;

    ABC dut (
        .x(x),
        .soc(soc), .eoc(eoc),
        .out(out),
        .clock(clock), .reset_(reset_)
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
                eoc = 1;
                
                //reset phase
                reset_ = 0; #(2*clk.HALF_PERIOD);
                
                //first posedge
                reset_ = 1;

                if(soc !== 0)
                    $display("soc is not 0 after reset");

                if(out !== 0)
                    $display("out is not 0 after reset");

                #(clk.HALF_PERIOD);

                fork
                    begin : producer
                        reg [7:0] i;
                        reg [7:0] x2, x1, x0;

                        for (i = 0; i < 10; i++) begin
                            {x2, x1, x0} = get_testcase(i);
                            
                            @(posedge soc);
                            x = 4'bX;
                            #(3*2*clk.HALF_PERIOD);
                            eoc = 0;
                            @(negedge soc);
                            #(3*2*clk.HALF_PERIOD);
                            x = x2;
                            #(2*clk.HALF_PERIOD);
                            eoc = 1;

                            @(posedge soc);
                            x = 4'bX;
                            #(3*2*clk.HALF_PERIOD);
                            eoc = 0;
                            @(negedge soc);
                            #(3*2*clk.HALF_PERIOD);
                            x = x1;
                            #(2*clk.HALF_PERIOD);
                            eoc = 1;

                            @(posedge soc);
                            x = 4'bX;
                            #(3*2*clk.HALF_PERIOD);
                            eoc = 0;
                            @(negedge soc);
                            #(3*2*clk.HALF_PERIOD);
                            x = x0;
                            #(2*clk.HALF_PERIOD);
                            eoc = 1;
                        end
                    end

                    begin : consumer
                        reg [7:0] i;
                        reg [7:0] x2, x1, x0;


                        for (i = 0; i < 10; i++) begin
                            {x2, x1, x0} = get_testcase(i);

                            if((x2 + x1 + x0) >= 164) begin
                                @(posedge out);
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

    function automatic [31:0] get_testcase;
        input [7:0] i;
        
        reg [7:0] x2, x1, x0;

        begin
            case(i)
                0: begin x2 = 8'd5; x1 = 8'd15; x0 = 8'd5; end
                1: begin x2 = 8'd2; x1 = 8'd28; x0 = 8'd2; end
                2: begin x2 = 8'd200; x1 = 8'd2; x0 = 8'd2; end
                3: begin x2 = 8'd1; x1 = 8'd101; x0 = 8'd1; end
                4: begin x2 = 8'd0; x1 = 8'd0; x0 = 8'd0; end
                5: begin x2 = 8'd64; x1 = 8'd86; x0 = 8'd36; end
                6: begin x2 = 8'd1; x1 = 8'd1; x0 = 8'd1; end
                7: begin x2 = 8'd4; x1 = 8'd4; x0 = 8'd4; end
                8: begin x2 = 8'd24; x1 = 8'd14; x0 = 8'd4; end
                9: begin x2 = 8'd4; x1 = 8'd4; x0 = 8'd4; end
            endcase

            get_testcase = {x2, x1, x0};
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
