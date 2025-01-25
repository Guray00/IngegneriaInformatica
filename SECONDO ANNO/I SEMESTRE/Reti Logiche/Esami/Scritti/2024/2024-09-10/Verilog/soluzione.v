module ABC(
    rxd, out, signal, ow, clock, reset_
);
    input clock, reset_;
    input rxd;
    output [7:0] out;
    output signal, ow;
    
    reg [7:0] BYTE_CURR, BYTE_PREV;    
    reg [3:0] COUNT_BIT;   // Conta il tempo per cui rxd e' a 0
    reg [2:0] COUNT_BYTE;  // Conta i bit ricevuti
    reg [7:0] OUT;
    reg SIGNAL, OW;
    
    assign out=OUT, signal=SIGNAL, ow=OW;

    wire [7:0] sum;
    wire sum_ow;
    PROSSIMO_S ps (
        .x_curr(BYTE_CURR), .x_prev(BYTE_PREV),
        .s_curr(sum), .ow(sum_ow)
    );

    reg [2:0] STAR;
    localparam S0=0, S1=1, S2=2, S3=3, S4=4;
    
    parameter mark = 1, space = 0;

    always @( reset_==0) #3 
        begin 
            BYTE_CURR <= 0;
            BYTE_PREV <= 0;
            COUNT_BIT <= 0; 
            COUNT_BYTE <= 0;
            STAR <= S0;
        end

    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: begin 
                SIGNAL <= 0;
                OW <= 0;
                STAR <= (rxd == mark) ? S0 : S1; 
            end
            S1: begin 
                COUNT_BIT <= COUNT_BIT+1; 
                STAR <= (rxd == space) ? S1 : S2;
            end
            S2: begin 
                BYTE_CURR <= {~COUNT_BIT[3], BYTE_CURR[7:1]}; // COUNT_BIT > 7 implica COUNT_BIT[3] == 0
                COUNT_BIT <= 0; 
                COUNT_BYTE <= COUNT_BYTE + 1; 
                STAR <= ( COUNT_BYTE == 7) ? S3 : S0;
            end
            S3: begin
                OUT <= sum;
                STAR <= S4;
            end
            S4: begin 
                SIGNAL <= ~sum_ow;
                OW <= sum_ow;
                BYTE_PREV <= sum_ow ? 0 : BYTE_CURR;
                BYTE_CURR <= 0;
                COUNT_BIT <= 0;
                COUNT_BYTE <= 0;
                STAR <= S0;
            end
        endcase

endmodule

module PROSSIMO_S (
    x_curr, x_prev,
    s_curr, ow
);
    input [7:0] x_curr, x_prev;
    output [7:0] s_curr;
    output ow;

    add #(.N(8)) sub(
        .x(x_curr), .y(x_prev), .c_in(1'b0),
        .s(s_curr), .ow(ow)
    );
    
endmodule