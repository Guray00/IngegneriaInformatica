module ABC(
    out, rxd, clock, reset_
);
    input clock, reset_;
    input rxd;
    output out;
    
    reg [3:0] DURATA;
    reg [3:0] BUFFER;
    reg [2:0] COUNT;
    
    reg OUT;
    assign out=OUT;
    
    reg [1:0] STAR; 
    localparam 
        S0=0,
        S1=1,
        S2=2,
        S3=3;

    // Come evidenziato nel testo, il bit DURATA[3] coincide con il bit utile
    wire bit_utile; 
    assign bit_utile = DURATA[3];

    always @(reset_==0) 
        begin 
            OUT <= 0;
            DURATA <= 0;
            COUNT <= 4;
            STAR <= S0;
        end

    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0:
                begin 
                    OUT <= 0;
                    DURATA <= DURATA + rxd;
                    STAR <= (rxd==0) ? S0 : S1;
                end
            S1:
                begin 
                    DURATA <= DURATA + rxd;
                    STAR <= (rxd==1) ? S1 : S2; 
                end
            S2:
                begin 
                    BUFFER <= {bit_utile, BUFFER[3:1]};
                    COUNT <= COUNT-1; 
                    DURATA <= 0; 
                    STAR <= (COUNT==1) ? S3 : S0; 
                end
            S3:
                begin 
                    OUT <= (BUFFER[3:2] == BUFFER[1:0]) ? 1 : 0; 
                    COUNT <= 4;
                    STAR <= S0; 
                end
        endcase

endmodule
