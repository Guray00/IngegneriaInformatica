module ABC(
    led, rxd, ref, clock, reset_
);
    input clock, reset_;
    input rxd;
    input [4:0] ref;
    output [2:0] led;
    
    reg [7:0] BYTE;       
    reg [3:0] COUNT_BIT;   // Conta il tempo per cui rxd e' a 0
    reg [2:0] COUNT_BYTE;  // Conta i bit ricevuti
    reg [2:0] LED;
    
    assign led=LED;

    reg [1:0] STAR;
    parameter S0=0, S1=1, S2=2, S3=3;
    
    parameter mark = 1, space = 0;

    always @( reset_==0) #3 
        begin 
            STAR <= S0;
            LED <= 3'B000;
            COUNT_BIT <= 0; 
            COUNT_BYTE <= 0;
            BYTE <= 0;
        end

    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: begin 
                STAR <= (rxd == mark) ? S0 : S1; 
            end
            S1: begin 
                COUNT_BIT <= COUNT_BIT+1; 
                STAR <= (rxd == space) ? S1 : S2;
            end
            S2: begin 
                BYTE <= {~COUNT_BIT[3], BYTE[7:1]}; // COUNT_BIT > 7 implica COUNT_BIT[3] == 1
                COUNT_BIT <= 0; 
                COUNT_BYTE <= COUNT_BYTE + 1; 
                STAR <= ( COUNT_BYTE == 7) ? S3 : S0;
            end
            S3: begin 
                LED <= (BYTE[7:3] == ref) ? BYTE[2:0] : LED;
                COUNT_BIT <= 0; 
                COUNT_BYTE <= 0;
                BYTE <= 0;
                STAR <= S0;
            end
        endcase

endmodule
