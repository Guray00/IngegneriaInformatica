module ABC(rxd, txd, clock_rx, clock_tx, reset_);
    input rxd, clock_rx, clock_tx, reset_;
    output txd;

    wire [7:0] data;
    wire rfd;
    wire dav_;

    RX rx(
        .rxd(rxd), .clock_rx(clock_rx), .reset_(reset_),
        .data(data), .rfd(rfd), .dav_(dav_)
    );

    TX tx(
        .txd(txd), .clock_tx(clock_tx), .reset_(reset_),
        .data(data), .rfd(rfd), .dav_(dav_)
    );
endmodule

module RX(rxd, clock_rx, reset_, data, rfd, dav_);
    input rxd;
    input clock_rx, reset_;
    
    output [7:0] data;
    input rfd;
    output dav_;
    
    reg [7:0] DATA;
    assign data = DATA;
    reg DAV_;
    assign dav_ = DAV_;

    reg[3:0] COUNT;
    reg[4:0] WAIT;
    
    reg[2:0] STAR; 
    localparam S0=0, S1=1, Wbit=2, Wstop=3, S4 = 4, S5 = 5;
    localparam start_bit=1'B0;

    always @(reset_==0) #1 begin 
        DAV_ <= 1; 
        STAR <= S0; 
    end

    always @(posedge clock_rx) if (reset_==1) #3
        casex(STAR)
            S0: begin
                COUNT <= 8;
                WAIT <= 23;
                STAR <= (rxd==start_bit) ? Wbit : S0; 
            end

            S1: begin
                DATA <= {rxd,DATA[7:1]}; 
                COUNT <= COUNT-1;
                WAIT <= 15; 
                STAR <= (COUNT==1) ? Wstop : Wbit; 
            end

            Wbit: begin
                WAIT <= WAIT-1; 
                STAR <= (WAIT==1) ? S1 : Wbit; 
            end

            Wstop: begin
                WAIT <= WAIT-1;
                STAR <= (WAIT==1) ? S4 : Wstop; 
            end

            S4: begin
                DAV_ <= 0;
                STAR <= (rfd==0) ? S5 : S4;                
            end

            S5: begin
                DAV_ <= 1;
                STAR <= (rfd==1) ? S0 : S5;
            end
        endcase
endmodule

module TX(txd, clock_tx, reset_, data, rfd, dav_);
    output txd;
    input clock_tx, reset_;
    
    input [7:0] data;
    output rfd;
    input dav_;

    reg RFD;
    assign rfd = RFD;
    reg TXD;
    assign txd = TXD;
    
    reg[3:0] COUNT;
    reg[9:0] BUFFER;
    reg[1:0] STAR;
    localparam S0=0, S1=1, S2=2;
    localparam marking=1'B1, start_bit=1'B0, stop_bit=1'B1;

    always @(reset_==0) #1 begin 
        RFD <= 1; 
        TXD <= marking; 
        STAR <= S0; 
    end
    
    always @(posedge clock_tx) if (reset_==1) #3
        casex(STAR)
            S0: begin 
                RFD <= 1; 
                COUNT <= 10; 
                TXD <= marking;
                BUFFER <= {stop_bit,data,start_bit};
                STAR <= (dav_==1) ? S0 : S1; 
            end

            S1: begin 
                RFD <= 0; 
                BUFFER <= {marking,BUFFER[9:1]}; 
                TXD <= BUFFER[0];
                COUNT <= COUNT-1; 
                STAR <= (COUNT==1) ? S2 : S1; 
            end

            S2: begin 
                STAR <= (dav_==0) ? S2 : S0; 
            end
        endcase
endmodule