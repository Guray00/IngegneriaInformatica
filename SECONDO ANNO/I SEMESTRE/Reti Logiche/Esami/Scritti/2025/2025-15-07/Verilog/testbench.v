`timescale 1s/1ms

module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    wire soc;
    reg eoc;
    reg [7:0] n;

    wire dav_a_, dav_b_;
    reg rfd_a, rfd_b;
    wire [31:0] out;
    
    ABC dut (
        .soc(soc), .eoc(eoc), .n(n),
        .dav_a_(dav_a_), .rfd_a(rfd_a), 
        .dav_b_(dav_b_), .rfd_b(rfd_b),
        .out(out),
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
                    eoc = 1;
                    rfd_a = 1; rfd_b = 1;

                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;

                    if(soc !== 0)
                        $display("soc is not 0 after reset");

                    if(dav_a_ !== 1)
                        $display("dav_a_ is not 1 after reset");

                    if(dav_b_ !== 1)
                        $display("dav_b_ is not 1 after reset");

                    fork
                        //Produttore
                        begin : producer
                            reg [7:0] t_n;

                            for (t_n = 2; t_n <= 40; t_n++) begin
                                @(posedge soc);
                                #(1*2*clk.HALF_PERIOD); 
                                eoc <= 0;
                                @(negedge soc);
                                #(1*2*clk.HALF_PERIOD); 
                                n <= t_n;
                                #(1*2*clk.HALF_PERIOD); 
                                eoc <= 1;
                            end
                        end

                        //Consumer A
                        begin : consumer_a
                            reg [7:0] t_n;
                            reg [32:0] t_f_n;

                            for (t_n = 2; t_n <= 40; t_n++) begin
                                {t_f_n} = get_testcase(t_n);

                                @(negedge dav_a_);
                                if(out !== t_f_n) begin
                                    $display("Consumer A, test n = %g failed, expected %h, got %h", t_n, t_f_n, out);
                                    error = 1;
                                end
                                #(2*clk.HALF_PERIOD); rfd_a <= 0;
                                @(posedge dav_a_);
                                #(2*clk.HALF_PERIOD); rfd_a <= 1;
                            end
                        end

                        //Consumer B
                        begin : consumer_b
                            reg [7:0] t_n;
                            reg [32:0] t_f_n;

                            for (t_n = 2; t_n <= 40; t_n++) begin
                                {t_f_n} = get_testcase(t_n);

                                @(negedge dav_b_);
                                if(out !== t_f_n) begin
                                    $display("Consumer B, test n = %g failed, expected %h, got %h", t_n, t_f_n, out);
                                    error = 1;
                                end
                                #(2*3*clk.HALF_PERIOD); rfd_b <= 0;
                                @(posedge dav_b_);
                                #(2*3*clk.HALF_PERIOD); rfd_b <= 1;
                            end
                        end
                    join

                    disable f;
                end
            join

            $finish;
        end

    function automatic [39:0] get_testcase;
        input [7:0] n;

        reg [31:0] f_n;

        begin
            case(n)
                0:	f_n = 32'h00000000;
                1:	f_n = 32'h00000001;
                2:	f_n = 32'h00000001;
                3:	f_n = 32'h00000002;
                4:	f_n = 32'h00000003;
                5:	f_n = 32'h00000005;
                6:	f_n = 32'h00000008;
                7:	f_n = 32'h0000000D;
                8:	f_n = 32'h00000015;
                9:	f_n = 32'h00000022;
                10:	f_n = 32'h00000037;
                11:	f_n = 32'h00000059;
                12:	f_n = 32'h00000090;
                13:	f_n = 32'h000000E9;
                14:	f_n = 32'h00000179;
                15:	f_n = 32'h00000262;
                16:	f_n = 32'h000003DB;
                17:	f_n = 32'h0000063D;
                18:	f_n = 32'h00000A18;
                19:	f_n = 32'h00001055;
                20:	f_n = 32'h00001A6D;
                21:	f_n = 32'h00002AC2;
                22:	f_n = 32'h0000452F;
                23:	f_n = 32'h00006FF1;
                24:	f_n = 32'h0000B520;
                25:	f_n = 32'h00012511;
                26:	f_n = 32'h0001DA31;
                27:	f_n = 32'h0002FF42;
                28:	f_n = 32'h0004D973;
                29:	f_n = 32'h0007D8B5;
                30:	f_n = 32'h000CB228;
                31:	f_n = 32'h00148ADD;
                32:	f_n = 32'h00213D05;
                33:	f_n = 32'h0035C7E2;
                34:	f_n = 32'h005704E7;
                35:	f_n = 32'h008CCCC9;
                36:	f_n = 32'h00E3D1B0;
                37:	f_n = 32'h01709E79;
                38:	f_n = 32'h02547029;
                39:	f_n = 32'h03C50EA2;
                40:	f_n = 32'h06197ECB;
                default:	
                    f_n = 32'h00000000;
            endcase

            get_testcase = {f_n};
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