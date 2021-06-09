module ABC(
    data, addr, ior_, iow_, clock, reset_
);
    input         clock, reset_;
    inout  [7:0]  data;
    output [15:0] addr;
    output ior_, iow_;

    reg [15:0] ADDR;
    reg [7:0]  DATA;
    reg        IOR_, IOW_, DIR;
    reg [7:0]  PREV_A;  // ci si appoggia il byte che viene letto dall’interfaccia A
    reg [15:0] PROD;

    reg [4:0]  STAR;
    parameter[4:0] 	S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7,
    S8=8, S9=9, S10=10, S11=11, S12=12, S13=13, S14=14, S15=15;

    assign   addr = ADDR;
    assign   ior_ = IOR_;
    assign   iow_ = IOW_;
    assign   data = (DIR==1)?DATA:'BZZ; //FORCHETTA
 
    always @(reset_==1) #3
        begin
            PREV_A <= 'H00; 
            DIR <= 0; 
            IOR_ <= 1; 
            IOW_ <= 1; 
            STAR <= S0; 
        end
    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: begin 
                    ADDR <= 'H0120; 
                    DIR <= 0; 
                    IOR_ <= 0; 
                    STAR <= S1; 
                end
            S1: begin 
                    PROD <= data*PREV_A; 
                    IOR_ <= 1; 
                    STAR <= S2; 
                end
            S2: begin 
                    ADDR <= 'H0140; 
                    DATA <= PROD[15:8];
                    DIR <= 1; 
                    STAR <= S3; 
                end
            S3: begin 
                    IOW_ <= 0; 
                    STAR <= S4; 
                end
            S4: begin 
                    IOW_ <= 1; 
                    STAR <= S5; 
                end 
            S5: begin 
                    DATA <= PROD[7:0]; 
                    STAR <= S6; 
                end
            S6: begin 
                    IOW_ <= 0; 
                    STAR <= S7; 
                end
            S7: begin 
                    IOW_ <= 1; 
                    STAR <= S8; 
                end
            S8: begin 
                    DIR <= 0; 
                    ADDR <= 'H0100; 
                    STAR <= S9; 
                end
            S9: begin 
                    IOR_ <= 0; 
                    STAR <= S10; 
                end
            S10: begin 
                    DATA <= data; 
                    IOR_ <= 1; 
                    ADDR <= 'H0101; 
                    STAR <= S11; 
                end
            // Se il flag FI e' ad 1 si legge un nuovo byte, altrimenti si perde un
            // tempo equivalente, lasciando pero' inalterato il contenuto di PREV_A
            S11: begin 
                    IOR_ <= ~DATA[0]; 
                    STAR <= S12; 
                end
            S12: begin 
                    PREV_A <= (IOR_==0)?data:PREV_A; 
                    IOR_ <= 1; 
                    STAR <= S13; 
                end
            S13: STAR <= S14;
            S14: STAR <= S15;
            S15: STAR <= S0;
        endcase
endmodule

