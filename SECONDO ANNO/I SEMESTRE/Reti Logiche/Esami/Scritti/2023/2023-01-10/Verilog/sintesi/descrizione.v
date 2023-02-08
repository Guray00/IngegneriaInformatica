// Primo appello invernale 2023
// Contatore di bit a 1 di posto pari

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

    //registro di stato
    reg [2:0] STAR;
    localparam
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4;

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

    always @(reset_ == 0) #1 begin
        SOC <= 0;
        DAV1_ <= 1;
        DAV2_ <= 1;
        DAV3_ <= 1;
        STAR <= S0;
        //COUNT <= 0
    end

    always @(posedge clock) if(reset_ == 1) #2 begin
        casex (STAR)
            S0: begin
                //apro l'handshake con il produttore
                SOC <= 1;   //richiedo un nuovo dato
                STAR <= (eoc == 0) ? S1 : S0 ;  //salto quando il Produttore ha iniziato a produrre un nuovo dato
            end

            S1: begin
                //chiudo l'handshake con il produttore
                SOC <= 0;   //smetto di chiedere un nuovo dato
                STAR <= (eoc == 1) ? S2 : S1 ;  //salto quando il Produttore ha finito di produrre un nuovo dato
                //dato che salto quando il dato è pronto, posso campionare l'ingresso qui, in modo che l'ultimo campionamento (ovvero quello contemporaneo al salto prenda un dato valido)
                X <= x;
                COUNT <= 4; //dovrò leggere 4 dati uno alla volta
                N <= 0;     //azzero il contatore di bit
            end

            S2: begin
                //stadio in cui conto i bit a 1 di posto pari
                N <= (X[0] == 1) ? N+1 : N ;    //incremento se la LSD di X vale 1
                X <= { 2'B00, X[7:2] };         //shifto X a dx di due posti (così che la nuova LSD sia quella che prima del clock era al posto 2)
                COUNT <= COUNT - 1;
                STAR <= (COUNT == 1) ? S3 : S2; //quando COUNT == 1 al clock faccio la lettura dell'ultimo bit di posto pari (x6)
            end

            S3: begin
                //apro l'handshake con i consumatori
                DAV1_ <= 0;
                DAV2_ <= 0;
                DAV3_ <= 0;
                C1 <= N;
                C2 <= N;
                C3 <= N;
                STAR <= ( {rfd3, rfd2, rfd1} == 3'B000 ) ? S4 : S3 ;    //salto quando tutti e tre i consumatori hanno letto il dato
            end

            S4: begin
                //chiudo l'handshake con i consumatori
                DAV1_ <= 1;
                DAV2_ <= 1;
                DAV3_ <= 1;
                STAR <= ( {rfd3, rfd2, rfd1} == 3'B111 ) ? S0 : S4 ;    //salto quando tutti e tre i consumatori hanno chiuso l'handshake
            end
        endcase
    end

endmodule
