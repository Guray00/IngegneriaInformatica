module ABC(
    x, soc, eoc, out, clock, reset_
);
 
  input       clock,reset_;

  input [7:0] x;
  input       eoc;
  output      soc;
  output[2:0] out;

  reg [7:0] BYTE;
  reg [2:0] OUT,NUM_COPPIE;
  reg       SOC;
  reg [4:0] COUNT;
 
  reg [2:0] STAR;
  localparam[2:0] S0=0, S1=1, S2=2, S3=3, S4=4;

  assign soc=SOC;
  assign out=OUT;

  always @(reset_==0) #1 
    begin
        COUNT <= 0;
        STAR <= S0;
        SOC <= 0;        
    end
  always @(posedge clock) if (reset_==1)#3
    casex(STAR)
     S0: 
        begin
            SOC <= 1;
            COUNT <= COUNT+1;
            STAR <= (eoc==1) ? S0 : S1;
        end
     S1: 
        begin
            SOC <= 0;
            BYTE <= x;
            NUM_COPPIE <= 0;
            COUNT <= COUNT+1;
            STAR <= (eoc==0) ? S1 : S2;
        end
     S2: 
        begin
            NUM_COPPIE <= (BYTE[7:6]=='B00) ? (NUM_COPPIE+1) : NUM_COPPIE;
            BYTE <= (BYTE[7:6]=='B00) ? ({BYTE[5:0],2'B11}) : ({BYTE[6:0],1'B1});
            COUNT <= COUNT+1;
            STAR <= (BYTE=='HFF) ? S3 : S2;
        end
     S3: 
        begin
            COUNT <= COUNT+1;
            STAR <= (COUNT==18) ? S4 : S3;
        end
     S4: 
        begin
            COUNT <= 0;
            OUT <= NUM_COPPIE;
            STAR <= S0;
        end
    endcase
endmodule
