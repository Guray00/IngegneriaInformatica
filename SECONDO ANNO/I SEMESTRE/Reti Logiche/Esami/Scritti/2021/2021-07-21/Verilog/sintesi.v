// soluzione proposta da uno studente
// la sintesi è basata 
// sulla soluzione proposta dai docenti

module ABC (
    soc_x, eoc_x, x, soc_y, eoc_y, y, 
    dav_, rfd, z, 
    clock, reset_
);

input clock, reset_;
    input eoc_x, eoc_y, rfd;
    output soc_x, soc_y, dav_;
    input [7:0] x, y;
    output z;


    wire b4, b3, b2, b1, b0;
    wire c2, c1, c0;

    
    ParteOperativa PO(
     soc_x, eoc_x, x, soc_y, eoc_y, y, 
    dav_, rfd, z, 
    clock, reset_,
    b4, b3, b2, b1, b0,
    c2, c1, c0
);   
    ParteControllo PC (
    clock, reset_,
    b4, b3, b2, b1, b0,
    c2, c1, c0 
    );

endmodule

module ParteOperativa (
    soc_x, eoc_x, x, soc_y, eoc_y, y, 
    dav_, rfd, z, 
    clock, reset_,
    b4, b3, b2, b1, b0,
    c2, c1, c0
);   
    input clock, reset_;
    input eoc_x, eoc_y, rfd;
    output soc_x, soc_y, dav_;
    input [7:0] x, y;
    output z;

    wire result;
    IN_AREA m (
        .x(x), .y(y), .z(result)
    );


    reg SOC, DAV_;
    reg Z;
    assign soc_x = SOC;
    assign soc_y = SOC;
    assign dav_ = DAV_;
    assign z = Z;

    input  b4, b3, b2, b1, b0;
    output  c2, c1, c0;

    assign c0 = (eoc_x | eoc_y);
    assign c1 = (eoc_x & eoc_y);
    assign c2 = rfd;

    always @(reset_ == 0)#1
    SOC = 0;
    always @(posedge clock) if (reset_ == 1)  #3
    casex ({b1, b0})
      'b00:  SOC <= 1;
      'b01: SOC <= 0;
      'b1x: SOC <= SOC;
    endcase

    always @(reset_ == 0)#1
    DAV_ = 1;
    always @(posedge clock) if (reset_ == 1)  #3
    casex ({b3, b2})
      'b00:   DAV_ <= 0;
      'b01:   DAV_ <= 1;
      'b1x:   DAV_ <= DAV_;
    endcase

    always @(posedge clock) if (reset_ == 1)  #3
    casex (b4)
      'b0: Z <= Z;
      'b1: Z <= result;
    endcase
endmodule

module ParteControllo (
    clock, reset_,
    b4, b3, b2, b1, b0,
    c2, c1, c0 
);

input clock, reset_;

input c2, c1, c0;
output b4, b3, b2, b1, b0;

reg [2:0] STAR;
    
    localparam S0=0, S1=1, S2=2, S3=3; 

assign b0 = (STAR == S0)? 0 : 1;
assign b1 = (STAR == S2 || STAR == S3)? 1 : 0;

assign b2 = (STAR == S2)? 0 : 1;
assign b3 = (STAR == S0 || STAR == S1) ? 1 : 0;

assign b4 = (STAR == S1) ? 1 : 0;

always @(reset_ == 0)#1
    STAR = S0;
    always @(posedge clock) if (reset_ == 1)  #3
    casex (STAR)
      S0: STAR <= (c0 == 0)? S1 : S0;
      S1: STAR <= (c1 == 1)? S2 : S1;
      S2: STAR <= (c2 == 1)? S2 : S3;
      S3: STAR <= (~c2 == 1)? S3 : S0;
    endcase
endmodule


// u-add | b4 b3 b2 b1 b0 | ceff | u-add-t | u-add-f|
//  S0   | 0  1  1  0  0  |  0   |     01  |   00   |   
//  S1   | 1  1  1  0  1  |  1   |     10  |   01   | 
//  S2   | 0  0  0  1  1  |  2   |     10  |   11   | 
//  S3   | 0  0  1  1  1  |  2   |     11  |   00   | 


module IN_AREA(
    x, y,
    z
);
    input [7:0] x, y;
    output z;

    wire in_64, bordo_64;
    IN_QUADRATO #( .LIMITE(9'd64) ) in_quadrato_64 (
        .x(x), .y(y),
        .in(in_64), .bordo(bordo_64)
    );

    wire in_32, bordo_32;
    IN_QUADRATO #( .LIMITE(9'd32) ) in_quadrato_32 (
        .x(x), .y(y),
        .in(in_32), .bordo(bordo_32)
    );

    assign z = (in_64 & ~in_32) | bordo_64;
endmodule

// L'uscita in vale 1 se il punto è interno al quadrato, bordo escluso; l'uscita bordo vale 1 se il punto è sul bordo del quadrato
// La rete calcola il risultato valutando le espressioni |x| + |y| < LIMITE e |x| + |y| = LIMITE
// In alternativa all'uso del parameter LIMITE, si possono scrivere due reti IN_QUADRATO_32 e IN_QUADRATO_64 (sintatticamente è lo stesso)
module IN_QUADRATO(
    x, y,
    in, bordo
);
    parameter LIMITE = 9'd64;

    input [7:0] x, y;
    output in, bordo;

    wire [7:0] abs_x, abs_y;
    abs #( .N(8) ) a1 (
        .x(x), .abs_x(abs_x)
    );
    abs #( .N(8) ) a2 (
        .x(y), .abs_x(abs_y)
    );

    wire [8:0] somma;
    add #( .N(8) ) somma_abs(
        .x(abs_x), .y(abs_y), .c_in(1'B0),
        .c_out(somma[8]), .s(somma[7:0])
    );

    comp_nat #( .N(9) ) comp(
        .a(somma), .b(LIMITE),
        .min(in), .eq(bordo)
    );
endmodule

// Valore assoluto di un numero intero
// L'ingresso x e' un numero intero su N bit
// L'uscita abs_x e' un numero naturale su N bit
module abs(
    x,
    abs_x
);
    parameter N = 8;

    input [N-1:0] x;
    output [N-1:0] abs_x;

    wire [N-1:0] neg_x;
    add #( .N(N) ) a_neg_x(
        .x(~x), .y(8'B0), .c_in(1'B1),
        .s(neg_x)
    );

    assign abs_x = (x[N-1] == 1) ? neg_x : x;
endmodule