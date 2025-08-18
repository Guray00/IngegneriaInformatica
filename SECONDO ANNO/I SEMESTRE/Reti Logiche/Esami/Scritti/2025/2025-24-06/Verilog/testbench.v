`timescale 1s/1ms

module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    wire soc_x, soc_y;
    reg eoc_x, eoc_y;
    reg [7:0] x, y;

    wire dav_;
    reg rfd;
    wire [7:0] z;
    
    ABC dut (
        .soc_x(soc_x), .soc_y(soc_y), .eoc_x(eoc_x), .x(x), .eoc_y(eoc_y), .y(y),
        .dav_(dav_), .rfd(rfd), .z(z), 
        .clock(clock), .reset_(reset_)
    );

    // linea di errore, utile per il debug
    reg error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;

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
                    eoc_x = 1; eoc_y = 1;
                    rfd = 1;

                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;

                    if(soc_x !== 0)
                        $display("soc_x is not 0 after reset");

                    if(soc_y !== 0)
                        $display("soc_y is not 0 after reset");

                    if(dav_ !== 1)
                        $display("dav_ is not 1 after reset");

                    fork
                        //Produttore X
                        begin : producer_x
                            reg [5:0] i;
                            reg [7:0] t_x, t_y;
                            reg [7:0] t_z;

                            for (i = 0; i < 32; i++) begin
                                {t_x, t_y, t_z} = get_testcase(i[4:0]);
                                
                                @(posedge soc_x);
                                #(1*2*clk.HALF_PERIOD); 
                                eoc_x <= 0;
                                @(negedge soc_x);
                                #(1*2*clk.HALF_PERIOD); 
                                x <= t_x;
                                #(1*2*clk.HALF_PERIOD); 
                                eoc_x <= 1;    
                            end
                        end

                        //Produttore Y
                        begin : producer_y
                            reg [5:0] i;
                            reg [7:0] t_x, t_y;
                            reg [7:0] t_z;

                            for (i = 0; i < 32; i++) begin
                                {t_x, t_y, t_z} = get_testcase(i[4:0]);
                                
                                @(posedge soc_y);
                                #(2*2*clk.HALF_PERIOD); 
                                eoc_y <= 0;
                                @(negedge soc_y);
                                #(2*2*clk.HALF_PERIOD); 
                                y <= t_y;
                                #(2*2*clk.HALF_PERIOD); 
                                eoc_y <= 1;      
                            end
                        end

                        //Consumer
                        begin : consumer
                            reg [5:0] i;
                            reg [7:0] t_x, t_y;
                            reg [7:0] t_z;

                            for (i = 0; i < 32; i++) begin
                                {t_x, t_y, t_z} = get_testcase(i[4:0]);

                                @(negedge dav_);
                                if(z !== t_z) begin
                                    $display("Test #%g failed, expected %g, got %g", i, t_z, z);
                                    error = 1;
                                end
                                #(2*clk.HALF_PERIOD); rfd <= 0;
                                @(posedge dav_);
                                #(2*clk.HALF_PERIOD); rfd <= 1;
                            end
                        end
                    join

                    disable f;
                end
            join

            $finish;
        end

    function automatic [28:0] get_testcase;
        input [4:0] i;

        reg [7:0] x, y;
        reg [7:0] z;

        begin
            case(i[2:0])
                0: begin
                    x = 0;
                    y = 0;
                    z = 8;    
                end
                1: begin
                    x = 255;
                    y = 255;
                    z = 0;
                end
                2: begin
                    x = 8'hAA;
                    y = 8'hAA;
                    z = 4;
                end
                3: begin
                    x = 8'h80;
                    y = 8'h80;
                    z = 7;
                end
                4: begin
                    x = 8'h80;
                    y = 8'h08;
                    z = 6;
                end
                5: begin
                    x = 8'h73;
                    y = 8'h37;
                    z = 2;
                end
                6: begin
                    x = 8'h33;
                    y = 8'h11;
                    z = 4;
                end
                7: begin
                    x = 8'h00;
                    y = 8'h83;
                    z = 5;
                end
            endcase

            if(i[3]) begin
                //shuffle the values
                {x, y} = {y, x};
            end

            get_testcase = {x, y, z};
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