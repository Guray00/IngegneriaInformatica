module ABC(
    s, h, rfd, dav_, out,
    clock, reset_
);
    input clock, reset_;
    input dav_;
    output rfd; 
    output[7:0] out; 
    input s;
    input [6:0] h;  
 
    reg RFD; 
    reg [7:0] OUT;
    reg S; 
    reg [6:0] H;  
 
    reg[1:0] STAR; 
    localparam S0=0, S1=1, S2=2; 

    assign rfd=RFD; 
    assign out=OUT;  
 
    always @(reset_==0) #1
        begin
            RFD <= 1;
            OUT <= 8'h80;
            STAR <= S0;
        end

    always @(posedge clock) if (reset_==1) #3 
        casex(STAR) 
            S0: 
                begin
                    RFD <= 1;
                    S <= s;
                    H <= h;
                    STAR <= (dav_==0) ? S1 : S0;
                end
            S1:
                begin
                    RFD <= 0;
                    H <= H-1;
                    OUT <= (S==0) ? (OUT+1) : (OUT-1);
                    STAR <= (H==1) ? S2 : S1;
                end
            S2:
                begin
                    OUT <= 8'h80;
                    RFD <= 0;
                    STAR <= (dav_==1) ? S0 : S2;
                end
        endcase
endmodule