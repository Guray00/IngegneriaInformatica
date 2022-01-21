// soluzione NON UFFICIALE proposta da uno studente

module XX(
    r3_r0, clock, _reset,
    c3_c0, done, q3_q0 
);

    input clock, _reset;
    input  [3:0]  r3_r0;
    output [3:0]  c3_c0;
    output [3:0]  q3_q0;
    output        done;

    wire b2, b1, b0;
    wire c0;

    ParteOperativa PO(
        r3_r0, clock, _reset,
        c3_c0, done, q3_q0,
        b2, b1, b0,
        c0
    );

    ParteControllo PC(
        clock, _reset,
        b2, b1, b0,
        c0
    );

endmodule

module ParteOperativa (
        r3_r0, clock, _reset,
        c3_c0, done, q3_q0,
        b2, b1, b0,
        c0
);
    
    input clock, _reset;
    input  [3:0]  r3_r0;
    output [3:0]  c3_c0;
    output [3:0]  q3_q0;
    output        done;

    input b2, b1, b0;
    output c0;

    assign c0 = r3_r0[0] || r3_r0[1] || r3_r0[2] || r3_r0[3];

    
    reg           DONE;
    reg [3:0]     C3_C0, Q3_Q0;
    reg [1:0]     STAR;

    assign   done=DONE;
    assign   q3_q0=Q3_Q0;
    assign   c3_c0=C3_C0;

    always @(_reset==0) #1
    DONE <=0;
    always @(posedge clock) if (_reset==1) #3
    casex ({b1,b0})
        'b00: DONE <= 0;
        'b01: DONE <= DONE;
        'b1x: DONE <= 1;
        endcase

    always @(_reset==0) #1
    C3_C0 <= 'b1000;
    always @(posedge clock) if (_reset==1) #3
    casex (b0)
        0: C3_C0<={C3_C0[0],C3_C0[3:1]};
        1: C3_C0 <= C3_C0;
        endcase   

    always @(posedge clock) if (_reset==1) #3
    casex (b2)
        0: Q3_Q0<=decodifica(C3_C0,r3_r0);
        1: Q3_Q0 <= Q3_Q0;
        endcase 

    function [3:0] decodifica;
        input [3:0] C3_C0,r3_r0;
        casex({C3_C0,r3_r0})
            'B1000_1000: decodifica='B1111;
            'B0100_1000: decodifica='B1110;
            'B0010_1000: decodifica='B1101;
            'B0001_1000: decodifica='B1100;
            'B1000_0100: decodifica='B1011;
            'B0100_0100: decodifica='B1010;
            'B0010_0100: decodifica='B1001;
            'B0001_0100: decodifica='B1000;
            'B1000_0010: decodifica='B0111;
            'B0100_0010: decodifica='B0110;
            'B0010_0010: decodifica='B0101;
            'B0001_0010: decodifica='B0100;
            'B1000_0001: decodifica='B0011;
            'B0100_0001: decodifica='B0010;
            'B0010_0001: decodifica='B0001;
            'B0001_0001: decodifica='B0000;
            default   : decodifica='BXXXX;
        endcase
    endfunction

endmodule


module ParteControllo (
    clock, _reset,
        b2, b1, b0,
        c0
);

input c0;
input clock, _reset;

output b2, b1, b0;

reg [1:0]     STAR;
    parameter [2:0] S0=0, S1=1, S2=2;

assign b0 = (STAR == S0)? 0 : 1;
assign b1 = (STAR == S2)? 1 : 0;

assign b2 = (STAR == S1)? 1 : 0;

    always @(posedge clock) if (_reset==1) #3
    casex (STAR)
        S0: STAR <= S1;
        S1: STAR <= (c0 != 0)? S2 : S0;
        S2: STAR <= (c0 != 0)? S2 : S0;
        endcase
    
endmodule