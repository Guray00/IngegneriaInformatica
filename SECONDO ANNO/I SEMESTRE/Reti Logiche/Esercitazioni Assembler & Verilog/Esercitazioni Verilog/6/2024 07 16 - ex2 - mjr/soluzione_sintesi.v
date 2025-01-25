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

    wire [2:0] mjr;
    wire c;
    wire b8, b7, b6, b5, b4, b3, b2, b1, b0;

    PO po(
        x,
        soc, eoc,
        out,
        mjr,
        c,
        b8, b7, b6, b5, b4, b3, b2, b1, b0,
        clock, reset_
    );

    PC pc(
        mjr,
        c,
        b8, b7, b6, b5, b4, b3, b2, b1, b0,
        clock, reset_
    );

endmodule

module PO(
    x,
    soc, eoc,
    out,
    mjr,
    c,
    b8, b7, b6, b5, b4, b3, b2, b1, b0,
    clock, reset_
);
    input [7:0] x;
    output soc;
    input eoc;
    
    output out;
    
    input clock, reset_;

    output [2:0] mjr;
    output c;
    input b8, b7, b6, b5, b4, b3, b2, b1, b0;

    reg SOC;
    assign soc = SOC;

    reg OUT;
    assign out = OUT;
    
    reg [7:0] X2, X1, X0;

    // la codifica degli stati deve essere note alla parte operativa,
    // per pilotare correttamente MJR
    reg [2:0] MJR;
    assign mjr = MJR;
    localparam
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S_read0 = 5,
        S_read1 = 6,
        S_read2 = 7;

    assign c = eoc;

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b1, b0})
            3'b00: MJR <= MJR;
            3'b01: MJR <= S1;
            3'b10: MJR <= S2;
            3'b11: MJR <= S3;
        endcase
    end

    always @(reset_ == 0) #1 begin
        OUT = 0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b3, b2})
            2'b00: OUT <= OUT;
            2'b01: OUT <= 0;
            2'b1X: OUT <= ((X0 + X1 + X2) >= 164) ? 1 : 0;
        endcase
    end

    always @(reset_ == 0) #1 begin
        SOC = 0;
    end
    
    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b5, b4})
            2'b00: SOC <= SOC;
            2'b1X: SOC <= 1;
            2'b01: SOC <= 0;
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b6})
            1'b0: X0 <= X0;
            1'b1: X0 <= x;
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b7})
            1'b0: X1 <= X1;
            1'b1: X1 <= X0;
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b8})
            1'b0: X2 <= X2;
            1'b1: X2 <= X0;
        endcase
    end

endmodule

module PC(
    mjr,
    c,
    b8, b7, b6, b5, b4, b3, b2, b1, b0,
    clock, reset_
);

    input clock, reset_;

    input [2:0] mjr;
    input c;
    output b8, b7, b6, b5, b4, b3, b2, b1, b0;

    assign {b8, b7, b6, b5, b4, b3, b2, b1, b0} =
        (STAR == S0) ?            9'b000000101 :
        (STAR == S1) ?            9'b100000010 :
        (STAR == S2) ?            9'b010000011 :
        (STAR == S3) ?            9'b000001X00 :
        (STAR == S_read0) ?       9'b0001X0000 :
        (STAR == S_read1) ?       9'b000010000 :
        /*(STAR == S_read2) ? */  9'b001000000 ;

    reg [2:0] STAR;
    localparam
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S_read0 = 4,
        S_read1 = 5,
        S_read2 = 6;

    always @(reset_ == 0) #1 begin
        STAR = S0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (STAR)
            S0: STAR <= S_read0;
            S1: STAR <= S_read0;
            S2: STAR <= S_read0;
            S3: STAR <= S0;
            
            // microsottoprogramma per l'acquisizione di un campione
            S_read0: STAR <= c ? S_read0 : S_read1;
            S_read1: STAR <= c ? S_read2 : S_read1;
            S_read2: STAR <= mjr;
        endcase
    end

    // Per utilizzare il registro MJR, va esteso il modello di sintesi della parte controllo e la relativa ROM, in modo da distinguere i salti guidati da MJR e non (salti incondizionati o a due vie).

    // Per distinguere questi salti da quelli guidati da MJR, introduciamo un altro multiplexer guidato dal campo m-type della ROM
    // Questo varrà 0 per i salti incondizionati o a due vie e 1 per i salti guidati da MJR.

    // Per i salti incondizionati o a due vie, si utilizzano i campi m-addr T ed m-addr F della ROM, ed un multiplexer guidato da una delle variabile di condizionamento prodotte dalla parte operativa.
    // Dato che, in questo caso, abbiamo una sola variabile di condizionamento, non c'è bisogno di distinguerle tramite un multiplexer ed il campo c_eff della ROM, che quindi omettiamo.

    /* 
    m-addr          | m-code      | m-addr T      | m-addr F      | m-type
    -------------------------------------------------------------------------
    001 (S1)        | 000000101   | 100 (S_read0) | 100 (S_read0) | 0
    000 (S0)        | 100000010   | 100 (S_read0) | 100 (S_read0) | 0
    010 (S2)        | 010000011   | 100 (S_read0) | 100 (S_read0) | 0
    011 (S3)        | 000001X00   | 000 (S0)      | 000 (S0)      | 0
    100 (S_read0)   | 0001X0000   | 100 (S_read0) | 101 (S_read1) | 0
    101 (S_read1)   | 000010000   | 110 (S_read2) | 101 (S_read1) | 0
    110 (S_read2)   | 001000000   | XXX           | XXX           | 1

    */

endmodule