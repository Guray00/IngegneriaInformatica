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

    wire [7:0] diff;
    wire diff_ow;
    add #(.N(8)) sub(
        .x(BYTE_CURR), .y(~BYTE_PREV), .c_in(1'b1),
        .s(diff), .ow(diff_ow)
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
                BYTE_CURR <= {COUNT_BIT[3], BYTE_CURR[7:1]}; // COUNT_BIT > 7 implica COUNT_BIT[3] == 0
                COUNT_BIT <= 0; 
                COUNT_BYTE <= COUNT_BYTE + 1; 
                STAR <= ( COUNT_BYTE == 7) ? S3 : S0;
            end
            S3: begin
                OUT <= diff;
                STAR <= S4;
            end
            S4: begin 
                SIGNAL <= ~diff_ow;
                OW <= diff_ow;
                BYTE_PREV <= diff_ow ? 0 : BYTE_CURR;
                BYTE_CURR <= 0;
                COUNT_BIT <= 0;
                COUNT_BYTE <= 0;
                STAR <= S0;
            end
        endcase

endmodule

module DIFF(
    a, b,
    d, ow
);
    input [7:0] a, b;
    output [7:0] d;
    output ow;

    wire [7:0] n_b;
    assign n_b = ~b;
    wire c_out, b_out;
    assign b_out = ~c_out;
    wire [7:0] diff;
    
    add #(.N(8)) sub(
        .x(a), .y(n_b), .c_in(1'b1),
        .s(diff), .c_out(c_out)
    );

    assign b_ae_a = b_out | diff == 8'b0;

endmodule