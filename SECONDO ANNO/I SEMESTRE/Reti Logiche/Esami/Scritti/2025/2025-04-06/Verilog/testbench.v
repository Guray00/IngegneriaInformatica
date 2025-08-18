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
    wire z;
    
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
                            reg [6:0] i;
                            reg [7:0] t_x, t_y;
                            reg t_z;

                            for (i = 0; i < 64; i++) begin
                                {t_x, t_y, t_z} = get_testcase(i[5:0]);
                                
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
                            reg [6:0] i;
                            reg [7:0] t_x, t_y;
                            reg t_z;

                            for (i = 0; i < 64; i++) begin
                                {t_x, t_y, t_z} = get_testcase(i[5:0]);
                                
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
                            reg [6:0] i;
                            reg [7:0] t_x, t_y;
                            reg t_z;

                            for (i = 0; i < 64; i++) begin
                                {t_x, t_y, t_z} = get_testcase(i[5:0]);

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

    function automatic [24:0] get_testcase;
        input [5:0] i;

        reg [7:0] x, y;
        reg z;
        reg [5:0] j;

        begin
            if(i[3:0] == 4'd0) begin
                // valori limite da testare singolarmente
                casex(i[5:4])
                    2'd0: {x, y, z} = {8'd0, 8'd0, 1'b0};
                    2'd1: {x, y, z} = {-8'd128, 8'd0, 1'b0};
                    2'd2: {x, y, z} = {8'd0, -8'd128, 1'b0};
                    2'd3: {x, y, z} = {-8'd128, -8'd128, 1'b0};
                endcase
            end
            else begin
                // valori da testare in tutti i quadranti
                casex(i[3:0])
                    4'd1: {x, y, z} = {8'd40, 8'd40, 1'b1};
                    4'd2: {x, y, z} = {8'd32, 8'd32, 1'b0};
                    4'd3: {x, y, z} = {8'd10, 8'd50, 1'b1};
                    4'd4: {x, y, z} = {8'd50, 8'd10, 1'b1};
                    4'd5: {x, y, z} = {8'd50, 8'd50, 1'b0};
                    4'd6: {x, y, z} = {8'd64, 8'd0, 1'b1};
                    4'd7: {x, y, z} = {8'd0, 8'd64, 1'b1};
                    4'd8: {x, y, z} = {8'd48, 8'd0, 1'b0};
                    4'd9: {x, y, z} = {8'd0, 8'd48, 1'b0};
                    default: {x, y, z} = {8'd0, 8'd0, 1'b0};
                endcase

                casex(i[5:4])
                    2'd0: {x, y, z} = {x, y, z};
                    2'd1: {x, y, z} = {-x, y, z};
                    2'd2: {x, y, z} = {x, -y, z};
                    2'd3: {x, y, z} = {-x, -y, z};
                endcase
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