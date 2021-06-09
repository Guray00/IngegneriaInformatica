module ABC (
    colore, endline, dav_, rfd, txd, 
    clock, reset_
);

    input clock, reset_;
    input dav_, colore, endline;
    output txd, rfd;

    reg [6:0] N;
    reg [4:0] COUNT;
    reg [9:0] BUFFER;
    reg       RFD, COLORE, TXD;
    
    reg [2:0] STAR;
    localparam S0=0, S1=1, S2=2, S3=3, S4=4;
    
    localparam marking = 1'B1, start_b = 1'B0, stop_b = 1'B1;
    localparam bianco = 1'B0, nero = 1'B1;

    assign txd=TXD, rfd=RFD;

    always@(reset_==0) #1 begin 
        TXD <= marking; 
        N <= 0; 
        RFD <= 1; 
        COLORE <= nero; 
        STAR <= S0; 
    end 

    always @(posedge clock) if(reset_==1) #3
    casex(STAR)
        S0: begin
            RFD <= 1;
            TXD <= marking;
            STAR <= (dav_==0) ? S1 : S0;
        end
        S1: begin
            N <= (COLORE==colore) ? N+1 : N;
            STAR <= ((COLORE==colore) & (endline==0)) ? S4 : S2;
        end
        S2: begin
            BUFFER <= (endline == 0) ? 
                {stop_b, N, COLORE, start_b} :
                {stop_b, 8'H00, start_b};
            COUNT <= 9;
            COLORE <= colore;
            N <= (endline == 0) ? 1 : 0;
            STAR <= S3;
        end
        S3: begin
            TXD <= BUFFER[0];
            BUFFER <= {marking, BUFFER[9:1]};
            COUNT <= COUNT-1;
            STAR <= (COUNT==0) ? S4 : S3;
        end
        S4: begin
            RFD <= 0;
            STAR <= (dav_==0) ? S4:S0; 
        end
    endcase
endmodule
