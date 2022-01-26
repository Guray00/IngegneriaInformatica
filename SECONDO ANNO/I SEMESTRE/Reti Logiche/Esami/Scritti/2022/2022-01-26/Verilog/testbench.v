module testbench();
    wire clock;
    clock_generator clk(
        .clock(clock)
    );
    reg reset_;

    reg eocA, eocB;
    wire socA, socB;
    reg [3:0] a, b;

    wire davC_;
    reg rfdC;
    wire [3:0] z1, z0;

    ABC dut (
        .eocA(eocA), .eocB(eocB), .a(a), .b(b), .rfdC(rfdC),
        .socA(socA), .socB(socB), .davC_(davC_), .z1(z1), .z0(z0), 
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
                eocA = 1; eocB = 1; rfdC = 1;

                //reset phase
                reset_ = 0; #(clk.HALF_PERIOD);

                //first posedge
                reset_ = 1;

                if(socA !== 0)
                    $display("socA is not 0 after reset");

                if(socB !== 0)
                    $display("socB is not 0 after reset");

                if(davC_ !== 1)
                    $display("davC_ is not 1 after reset");

                fork
                    begin: producerA
                        reg [5:0] i;
                        
                        reg [3:0] a_b, a_z1, a_z0; // unused

                        for (i = 0; i < 32; i++) begin
                            @(posedge socA);
                            #(1*2*clk.HALF_PERIOD);
                            eocA = 0;
                            a = 4'bX;
                            @(negedge socA);
                            #(2*2*clk.HALF_PERIOD);
                            {a, a_b, a_z1, a_z0} = get_testcase(i[4:0]);
                            #(1*2*clk.HALF_PERIOD);
                            eocA = 1;
                        end
                    end

                    begin: producerB
                        reg [5:0] i;
                        
                        reg [3:0] b_a, b_z1, b_z0; // unused

                        for (i = 0; i < 32; i++) begin
                            @(posedge socB);
                            #(2*2*clk.HALF_PERIOD);
                            eocB = 0;
                            b = 4'bX;
                            @(negedge socB);
                            #(4*2*clk.HALF_PERIOD);
                            {b_a, b, b_z1, b_z0} = get_testcase(i[4:0]);
                            #(1*2*clk.HALF_PERIOD);
                            eocB = 1;
                        end
                    end

                    begin: consumerC
                        reg [5:0] i;

                        reg [3:0] c_a, c_b; // unused
                        reg [3:0] c_z1, c_z0;

                        for (i = 0; i < 32; i++) begin
                            @(negedge davC_);
                            {c_a, c_b, c_z1, c_z0} = get_testcase(i[4:0]);
                            if(z1 !== c_z1 || z0 !== c_z0) begin
                                error = 1;
                                $display("Test #%g failed, expected {%g,%g}, got {%g,%g}", i, c_z1, c_z0, z1, z0);
                            end
                            #(1*2*clk.HALF_PERIOD);
                            rfdC = 0;
                            @(posedge davC_);
                            #(2*2*clk.HALF_PERIOD);
                            rfdC = 1;
                        end
                    end                    
                join

                disable f;
            end
        join

        #10;
        $finish;
    end

    // linea di errore, utile per il debug
    reg error;
    initial error = 0;
    always @(posedge error) #1
        error = 0;

    function automatic [15:0] get_testcase;
        input [4:0] i;
        
        reg [3:0] a, b;
        reg [3:0] z1, z0;

        begin
            a = ( ((i+5) * 19) % 100 ) / 10;
            b = ( ((i+5) * 19) % 100 ) % 10;
            z1 = (a + b) / 10;
            z0 = (a + b) % 10;
            get_testcase = {a, b, z1, z0};
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