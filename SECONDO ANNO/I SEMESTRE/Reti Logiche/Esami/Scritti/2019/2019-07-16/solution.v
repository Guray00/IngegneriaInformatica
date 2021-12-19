module XXX(
    dx, dy, dav_, clock, reset_,
    q, ow, rfd
);
    input clock, reset_;
    input [6:0] dx, dy;
    input dav_;
    
    output rfd; 
    output [1:0] q;
    output ow;

    reg [8:0] X, Y;
    
    reg RFD;
    assign rfd = RFD;
    
    reg [1:0] Q;
    assign q = Q;
    
    reg OW;
    assign ow = OW;
    
    reg[1:0] STAR;
    localparam 
        S0=0,
        S1=1,
        S2=2,
        S3=3;
        
    always @(reset_==0) #1 
        begin 
            X=0;
            Y=0;
            RFD=1;
            OW=0;
            Q=0;
            STAR<=S0;
        end 
        
    always @(posedge clock) if (reset_==1) #3
        casex (STAR)
            S0: 
                begin 
                    RFD<=1;
                    STAR<=(dav_==1)?S0:S1;
                end
            S1: 
                begin 
                    X<=X+{dx[6],dx[6],dx};
                    Y<=Y+{dy[6],dy[6],dy};
                    STAR<=S2;
                end
            S2: 
                begin 
                    RFD<=0;
                    Q<={X[8],Y[8]};
                    OW<=((X[8]==X[7])&(Y[8]==Y[7]))?0:1;
                    STAR<=(dav_==0)?S2:S3;
                end
            S3: 
                begin 
                    STAR<=(OW==1)?S3:S0;
                end
    endcase
endmodule
