module testbench();

    wire clock;
    reg reset_;

    clock_generator clk(
        .clock(clock)
    );

    wire [15:0] addr;
    wire [7:0] data;
    wire ior_, iow_;
    wire sA_, sB_, sC_;

    mask_A mA(
        .addr(addr[15:1]), .s_(sA_)
    );

    mask_B mB(
        .addr(addr), .s_(sB_)
    );

    mask_C mC(
        .addr(addr), .s_(sC_)
    );
    
    // testbench variables to control interfaces
    reg tb_fiA; 
    reg [7:0] tb_valueA, tb_valueB;
    wire [7:0] tb_valueC;
    wire tb_signal_newC;

    interface_in_hs A(
        .s_(sA_), .ior_(ior_), .addr(addr[0]), .data(data),
        .tb_value(tb_valueA), .tb_fi(tb_fiA)
    );

    interface_in B(
        .ior_(ior_), .s_(sB_), .data(data),
        .tb_value(tb_valueB)
    );

    interface_out C(
        .iow_(iow_), .s_(sC_), .data(data),
        .tb_value(tb_valueC), .tb_signal_new(tb_signal_newC)
    );

    ABC dut (
        .iow_(iow_), .ior_(ior_), .addr(addr), .data(data),
        .reset_(reset_), .clock(clock)
    );

    // Debug variables to highlight errors in waveform diagram
    reg error_value;
    reg error_timing;

    initial
        begin
            $dumpfile("waveform.vcd");
            $dumpvars;

            error_value = 0;
            error_timing = 0;

            //the following structure is used to wait for expected signals, and fail if too much time passes
            fork : f
                begin
                    #100000;
                    $display("Timeout - waiting for signal failed");
                    disable f;
                end
            //actual tests start here
                begin
                    //reset phase
                    reset_ = 0; #(clk.HALF_PERIOD);
                    
                    //first posedge
                    reset_ = 1;

                    fork
                        begin : value_correctness
                            reg [7:0] i;
                            reg [7:0] prev_A;
                            reg [15:0] expected;
                            reg [15:0] current;

                            prev_A = 0;
                            expected = 0;
                            current = 0;

                            for(i = 0; i < 30; i++) begin
                                // Punto 1
                                tb_valueB = i * i + 5;                                
                                @(negedge sB_);
                                
                                // Punto 2
                                expected = tb_valueB * prev_A;
                                
                                @(posedge tb_signal_newC);
                                current[15:8] = tb_valueC;
                                @(posedge tb_signal_newC);
                                current[7:0] = tb_valueC;

                                if(expected !== current) begin
                                    $display("Wrong output: expected %d, got %d instead", expected, current);
                                    error_value = 1;
                                end
                                
                                // Punto 3
                                tb_valueA = ( i << 2 ) + i + 3;
                                tb_fiA = tb_valueB[2];

                                if(tb_fiA == 1)
                                    prev_A = tb_valueA;
                            end
                        end
                        
                        begin : timing
                            reg [5:0] i;
                            realtime prev_sample;
                            realtime current_sample;
                            realtime diff;

                            prev_sample = 0;

                            for(i = 0; i < 30; i++) begin
                                @(negedge sB_);
                                current_sample = $realtime;

                                if(prev_sample != 0) begin
                                    diff = (current_sample - prev_sample)/(2*clk.HALF_PERIOD);
                                    if( diff != 16) begin
                                        $display("Wrong timing: expected 16 clocks, got %g instead", diff);
                                        error_timing = 1;
                                    end
                                end

                                prev_sample = current_sample;
                            end
                        end
                    join                   

                    disable f;
                end   
            join

            $finish;
        end

    always @(posedge error_value) #1
        error_value = 0;

    always @(posedge error_timing) #1
        error_timing = 0;        

endmodule

module mask_A (
    addr, 
    s_
);
    input [14:0] addr;
    output s_;

    assign s_ = ( { addr, 1'B0 } == 16'h0100 ) ? 0 : 1;

endmodule

module mask_B (
    addr, 
    s_
);
    input [15:0] addr;
    output s_;

    assign s_ = ( addr == 16'h0120 ) ? 0 : 1;

endmodule

module mask_C (
    addr, 
    s_
);
    input [15:0] addr;
    output s_;

    assign s_ = ( addr == 16'h0140 ) ? 0 : 1;
endmodule

// il modulo interface simula una interfaccia di ingresso parallela con handshake
// gli ingressi tb_* sono utilizzati dalla testbench per guidare lo stato dell'interfaccia
module interface_in_hs (
    ior_, s_, addr, data,
    tb_value, tb_fi
);
    input ior_; 
    input s_; 
    input addr; 
    inout [7:0] data;

    input [7:0] tb_value;
    input tb_fi;
    
    reg DIR;

    reg [7:0] DATA;
    assign data = (DIR == 1) ? DATA : 8'hZZ;

    always @(*) if (s_==1 || ior_==1)
        DIR = 0;

    always @(*) if (ior_==0 && s_==0)
        begin
            DIR = 1;
            casex(addr)
                1'b0:
                    DATA = { 7'b0, tb_fi };
                1'b1:
                    DATA = tb_value;
            endcase
        end
            
endmodule

// il modulo simula una interfaccia di ingresso parallela senza handshake
// l'ingresso tb_value è utilizzato dalla testbench per guidare lo stato dell'interfaccia
module interface_in (
    ior_, s_, data,
    tb_value
);
    input ior_; 
    input s_; 
    output [7:0] data;

    input [7:0] tb_value;
    
    reg DIR;

    reg [7:0] DATA;
    assign data = (DIR == 1) ? DATA : 8'hZZ;

    always @(*) if (s_==1 || ior_==1)
        DIR = 0;

    always @(*) if (ior_==0 && s_==0)
        begin
            DIR = 1;
            DATA = tb_value;
        end
            
endmodule

// il modulo simula una interfaccia di uscita parallela senza handshake
// le uscite tb_* sono utilizzate dalla testbench per controllare lo stato dell'interfaccia
module interface_out (
    iow_, s_, data,
    tb_value, tb_signal_new
);
    input iow_; 
    input s_; 
    input [7:0] data;

    output [7:0] tb_value;
    output tb_signal_new;
    
    reg [7:0] TB_VALUE;
    assign tb_value = TB_VALUE;

    reg TB_SIGNAL_NEW;
    assign tb_signal_new = TB_SIGNAL_NEW;

    always @(*) if (iow_==1 || s_==1)
        begin
            TB_SIGNAL_NEW = 0;
        end

    always @(*) if (iow_==0 && s_==0)
        begin
            TB_VALUE = data;
            TB_SIGNAL_NEW = 1;
        end
            
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