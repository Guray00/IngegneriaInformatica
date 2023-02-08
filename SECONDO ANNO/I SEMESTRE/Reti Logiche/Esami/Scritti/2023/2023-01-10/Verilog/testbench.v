module testbench();

    wire clock;

    clock_generator clk(
        .clock(clock)
    );

    reg reset_;

    reg [7:0] x;
    reg eoc;
    wire soc;

    wire [2:0] c1;
    reg rfd1;
    wire dav1_;

    wire [2:0] c2;
    reg rfd2;
    wire dav2_;

    wire [2:0] c3;
    reg rfd3;
    wire dav3_;

    ABC dut (
        .x(x), .soc(soc), .eoc(eoc), 
        .c1(c1), .rfd1(rfd1), .dav1_(dav1_),
        .c2(c2), .rfd2(rfd2), .dav2_(dav2_),
        .c3(c3), .rfd3(rfd3), .dav3_(dav3_),
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
                rfd1 = 1; rfd2 = 1; rfd3 = 1;

                //reset phase
                reset_ = 0; #(clk.HALF_PERIOD);
                
                //first posedge
                reset_ = 1;

                if(soc !== 0)
                    $display("soc is not 0 after reset");

                if(dav1_ !== 1)
                    $display("dav1_ is not 1 after reset");
                if(dav2_ !== 1)
                    $display("dav2_ is not 1 after reset");
                if(dav3_ !== 1)
                    $display("dav3_ is not 1 after reset");

                fork
                    // Producer
                    begin : producer
                        reg [4:0] i;
                        reg [7:0] v;
                        reg [2:0] c;

                        for (i = 0; i < 16; i++) begin
                            {v, c} = get_testcase(i);
                            
                            @(posedge soc);
                            #(2*clk.HALF_PERIOD); 
                            eoc = 0;
                            @(negedge soc);
                            #(2*clk.HALF_PERIOD); 
                            x = v;
                            #(2*clk.HALF_PERIOD); 
                            eoc = 1;    
                        end
                    end
                    //Consumer 1
                    begin : consumer_1
                        reg [4:0] i;
                        reg [7:0] v;
                        reg [2:0] c;

                        for (i = 0; i < 16; i++) begin
                            {v, c} = get_testcase(i);

                            @(negedge dav1_);
                            if(c1 !== c) begin
                                error = 1;
                                $display("C1: Test #%g failed, expected %g, got %g", i, c, c1);
                            end
                            #(1*2*clk.HALF_PERIOD); 
                            rfd1 = 0;
                            @(posedge dav1_);
                            #(1*2*clk.HALF_PERIOD); 
                            rfd1 = 1;
                        end
                    end
                    //Consumer 2
                    begin : consumer_2
                        reg [4:0] i;
                        reg [7:0] v;
                        reg [2:0] c;

                        for (i = 0; i < 16; i++) begin
                            {v, c} = get_testcase(i);

                            @(negedge dav2_);
                            if(c2 !== c) begin
                                error = 1;
                                $display("C2: Test #%g failed, expected %g, got %g", i, c, c2);
                            end
                            #(2*2*clk.HALF_PERIOD); 
                            rfd2 = 0;
                            @(posedge dav2_);
                            #(2*2*clk.HALF_PERIOD); 
                            rfd2 = 1;
                        end
                    end
                    //Consumer 3
                    begin : consumer_3
                        reg [4:0] i;
                        reg [7:0] v;
                        reg [2:0] c;

                        for (i = 0; i < 16; i++) begin
                            {v, c} = get_testcase(i);

                            @(negedge dav3_);
                            if(c3 !== c) begin
                                error = 1;
                                $display("C3: Test #%g failed, expected %g, got %g", i, c, c3);
                            end
                            #(3*2*clk.HALF_PERIOD); 
                            rfd3 = 0;
                            @(posedge dav3_);
                            #(3*2*clk.HALF_PERIOD); 
                            rfd3 = 1;
                        end
                    end
                join

                #10;
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

    function automatic [15:0] get_testcase;
        input [4:0] i;

        reg [7:0] v;
        reg [2:0] c;

        begin
            v[7:4] = i * 5;
            v[3:0] = i * 7;

            c = 0;
            if(v[6] == 1)
                c += 1;
            if(v[4] == 1)
                c += 1;
            if(v[2] == 1)
                c += 1;
            if(v[0] == 1)
                c += 1;

            get_testcase = {v, c};
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