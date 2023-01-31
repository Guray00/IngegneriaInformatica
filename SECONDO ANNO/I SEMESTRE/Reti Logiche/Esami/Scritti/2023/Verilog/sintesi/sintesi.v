// Primo appello invernale 2023
// Contatore di bit a 1 di posto pari

// Questa sintesi è basata 
// sulla descrizione proposta da 
// uno studente presente nella stessa cartella

module ABC (
    x,
    c1, c2, c3,
    soc, eoc,
    dav1_, rfd1,
    dav2_, rfd2,
    dav3_, rfd3,
    clock, reset_
);
    input [7:0] x;
    output [2:0] c1, c2, c3;
    input eoc;  output soc;
    input rfd1; output dav1_;
    input rfd2; output dav2_;
    input rfd3; output dav3_;
    input clock, reset_;

    wire k4, k3, k2, k1, k0;
    wire b16, b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0;

    parte_controllo PC (
        k4, k3, k2, k1, k0,
        b16, b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0,
        clock, reset_
    );

    parte_operativa PO (
        x,
        c1, c2, c3,
        soc, eoc,
        dav1_, rfd1,
        dav2_, rfd2,
        dav3_, rfd3,
        clock, reset_,
        b16, b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0,
        k4, k3, k2, k1, k0
    );


endmodule

 
module parte_controllo (
    k4, k3, k2, k1, k0,
    b16, b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0,
    clock, reset_
);
    input k4, k3, k2, k1, k0;
    output b16, b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0;
    input clock, reset_;

    //registro di stato
    reg [2:0] STAR;
    localparam
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4;

    assign { b16, b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0 } =
        (STAR == S0) ?  17'B00000000000000000 :
        (STAR == S1) ?  17'B01010100000000001 :
        (STAR == S2) ?  17'B1X1X1X0000000001X :
        (STAR == S3) ?  17'B0000001110101011X :
        (STAR == S4) ?  17'B0000000001X1X1X1X :
        /* default */   17'BXXXXXXXXXXXXXXXXX ;

    //STAR
    always @(reset_ == 0) #1 STAR <= S0;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex (STAR)
            S0: STAR <= k0 ? S1 : S0 ;
            S1: STAR <= k1 ? S2 : S1 ;
            S2: STAR <= k2 ? S3 : S2 ;
            S3: STAR <= k3 ? S4 : S3 ;
            S4: STAR <= k4 ? S0 : S4 ;
        endcase
    end
endmodule

module parte_operativa (
    x,
    c1, c2, c3,
    soc, eoc,
    dav1_, rfd1,
    dav2_, rfd2,
    dav3_, rfd3,
    clock, reset_,
    b16, b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0,
    k4, k3, k2, k1, k0
);
    input [7:0] x;
    output [2:0] c1, c2, c3;
    input eoc;  output soc;
    input rfd1; output dav1_;
    input rfd2; output dav2_;
    input rfd3; output dav3_;
    input clock, reset_;

    input b16, b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0;
    output k4, k3, k2, k1, k0;
    
    //registri operativi d'uscita
    reg [2:0] C1, C2, C3;
    assign c1 = C1;
    assign c2 = C2;
    assign c3 = C3;
    reg DAV1_;  assign dav1_ = DAV1_;
    reg DAV2_;  assign dav2_ = DAV2_;
    reg DAV3_;  assign dav3_ = DAV3_;
    reg SOC;    assign soc = SOC;

    //altri registri operativi
    reg [2:0] COUNT;    //conta quanti cicli faccio (ne dovrò fare 4)
    reg [7:0] X;        //registro che memorizza l'ingresso e che shifto per prelevare ogni volta la cifra meno significativa
    reg [2:0] N;        //lo uso per contare i bit a 1 di posto pari

    assign k0 = ~eoc;
    assign k1 = eoc;
    assign k2 = ~COUNT[2] & ~COUNT[1] & COUNT[0];
    assign k3 = ~rfd3 & ~rfd2 & ~rfd1;
    assign k4 = rfd3 & rfd2 & rfd1;

    
    //SOC
    always @(reset_ == 0) #1 SOC <= 0;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex ({b1, b0})
            2'B00 : SOC <= 1;
            2'B01 : SOC <= 0;
            2'B1X : SOC <= SOC;
        endcase
    end

    //DAV1_
    always @(reset_ == 0) #1 DAV1_ <= 1;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex ({b3, b2})
            2'B00 : DAV1_ <= DAV1_;
            2'B01 : DAV1_ <= 0;
            2'B1X : DAV1_ <= 1;
        endcase
    end

    //DAV2_
    always @(reset_ == 0) #1 DAV2_ <= 1;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex ({b5, b4})
            2'B00 : DAV2_ <= DAV2_;
            2'B01 : DAV2_ <= 0;
            2'B1X : DAV2_ <= 1;
        endcase
    end

    //DAV3_
    always @(reset_ == 0) #1 DAV3_ <= 1;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex ({b7, b6})
            2'B00 : DAV3_ <= DAV3_;
            2'B01 : DAV3_ <= 0;
            2'B1X : DAV3_ <= 1;
        endcase
    end

    //C1
    always @(reset_ == 0) #1 C1 <= 3'BXXX;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex ({b8})
            1'B0 : C1 <= C1;
            1'B1 : C1 <= N;
        endcase
    end

    //C2
    always @(reset_ == 0) #1 C2 <= 3'BXXX;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex ({b9})
            1'B0 : C2 <= C2;
            1'B1 : C2 <= N;
        endcase
    end

    //C3
    always @(reset_ == 0) #1 C3 <= 3'BXXX;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex ({b10})
            1'B0 : C3 <= C3;
            1'B1 : C3 <= N;
        endcase
    end

    //X
    always @(reset_ == 0) #1 X <= 8'BXXXXXXXX;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex ({b12, b11})
            2'B00 : X <= X;
            2'B01 : X <= x;
            2'B1X : X <= { 2'B00, X[7:2] };
        endcase
    end

    //COUNT
    always @(reset_ == 0) #1 COUNT <= 3'BXXX;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex ({b14, b13})
            2'B00 : COUNT <= COUNT;
            2'B01 : COUNT <= 4;
            2'B1X : COUNT <= COUNT - 1;
        endcase
    end

    //N
    always @(reset_ == 0) #1 N <= 3'BXXX;
    always @(posedge clock) if(reset_ == 1) #2 begin
        casex ({b16, b15})
            2'B00 : N <= N;
            2'B01 : N <= 0;
            2'B1X : N <= (X[0] == 1) ? N+1 : N ;
        endcase
    end
endmodule