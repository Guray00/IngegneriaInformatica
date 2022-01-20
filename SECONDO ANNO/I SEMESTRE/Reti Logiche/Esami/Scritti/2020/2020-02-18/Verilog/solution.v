module XXX(
  soc, eoc, numero,
  out, clock, reset_
);
    input      clock,reset_;
    input      eoc;
    output     soc,out;
    input[7:0] numero; 

    reg        SOC,OUT; 
    assign soc=SOC; 
    assign out=OUT;
    
    reg[7:0]   COUNT,NUMERO;

    reg[1:0]   STAR;    
    parameter S0=0,S1=1,S2=2,S3=3;

    always @(reset_==0) 
        begin 
            OUT<=0; 
            SOC<=0; 
            NUMERO<=6; 
            COUNT<=6; 
            STAR<=S0; 
        end 
        
    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: 
                begin 
                    COUNT<=(COUNT==1)?NUMERO:(COUNT-1); 
                    OUT<=(COUNT==1)?1:0;
                    STAR<=(COUNT==1)?S1:S0; 
                end
            S1: 
                begin 
                    COUNT<=COUNT-1; 
                    SOC<=1; 
                    STAR<=(eoc==1)?S1:S2; 
                end
            S2: 
                begin 
                    COUNT<=COUNT-1; 
                    SOC<=0; 
                    NUMERO<=numero; 
                    STAR<=(eoc==0)?S2:S3; 
                end
            S3: 
                begin 
                    COUNT<=(COUNT==1)?NUMERO:(COUNT-1); 
                    OUT<=(COUNT==1)?0:1;
                    STAR<=(COUNT==1)?S0:S3; 
                end
        endcase
endmodule
