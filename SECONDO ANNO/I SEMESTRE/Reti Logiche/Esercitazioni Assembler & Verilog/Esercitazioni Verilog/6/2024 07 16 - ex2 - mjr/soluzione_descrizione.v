module ABC (
    x,
    soc, eoc,
    out,
    clock, reset_
);

    input [7:0] x;
    output soc;
    input eoc;
    
    output out;
    
    input clock, reset_;

    reg SOC;
    assign soc = SOC;

    reg OUT;
    assign out = OUT;
    
    reg [7:0] X2, X1, X0;
    
    reg [2:0] STAR;
    localparam
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S_read0 = 4,
        S_read1 = 5,
        S_read2 = 6;

    reg [2:0] MJR;

    always @(reset_ == 0) #1 begin
        OUT = 0;
        SOC = 0;
        //STAR = S0;
        MJR = S1; 
        STAR = S_read0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (STAR)
            S0: begin
                OUT <= 0;
                MJR <= S1; 
                STAR <= S_read0;
            end
            S1: begin
                X2 <= X0;
                MJR <= S2;
                STAR <= S_read0;
            end
            S2: begin
                X1 <= X0;
                MJR <= S3;
                STAR <= S_read0;
            end
            S3: begin
                OUT <= ((X0 + X1 + X2) >= 164) ? 1 : 0;
                STAR <= S0;
            end
            
            // microsottoprogramma per l'acquisizione di un campione
            // il dato acquisito viene lasciato in X0
            S_read0: begin
                SOC <= 1; 
                STAR <= (eoc == 1'b0) ? S_read1 : S_read0;
            end
            S_read1: begin
                SOC <= 0; 
                STAR <= (eoc == 1'b1) ? S_read2 : S_read1;
            end
            S_read2: begin
                X0 <= x;
                STAR <= MJR;
            end
        endcase
    end

endmodule
