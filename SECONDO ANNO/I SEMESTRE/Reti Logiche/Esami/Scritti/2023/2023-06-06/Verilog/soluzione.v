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
    
    reg SOC, DAV_;
    reg Z;
    reg [2:0] STAR;
    
    localparam S0=0, S1=1, S2=2, S3=3; 

    assign soc_x = SOC;
    assign soc_y = SOC;
    assign dav_ = DAV_;
    assign z = Z;

    wire result;
    IN_AREA m (
        .x(x), .y(y), .z(result)
    );

    always @(reset_==0) #1 
        begin
            SOC = 0; 
            DAV_ = 1; 
            STAR = S0; 
        end
    
    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: 
                begin
                    SOC <= 1;
                    STAR <= ({eoc_x, eoc_y} == 2'B00) ? S1 : S0;
                end
            S1: 
                begin
                    SOC <= 0;
                    Z <= result;
                    STAR <= ({eoc_x, eoc_y} == 2'B11) ? S2 : S1; 
                end
            S2: 
                begin
                    DAV_ <= 0;
                    STAR <= (rfd == 1) ? S2 : S3; 
                end
            S3: 
                begin
                    DAV_ <= 1; 
                    STAR <= (rfd == 0) ? S3 : S0; 
                end
        endcase

endmodule

// L'uscita z vale 1 se il punto è interno all'area del cerchio
module IN_AREA(
    x, y,
    z
);
    input [7:0] x, y;
    output z;

    localparam RAGGIO_QUADRO = 16'd4096;

    wire [7:0] abs_x, abs_y;
    abs #( .N(8) ) a1 (
        .x(x), .abs_x(abs_x)
    );
    abs #( .N(8) ) a2 (
        .x(y), .abs_x(abs_y)
    );

    wire [15:0] x_quadro;
    mul_add_nat #( .N(8), .M(8) ) mx(
        .x(abs_x), .y(abs_x), .c(8'd0),
        .m(x_quadro)
    );

    wire [15:0] y_quadro;
    mul_add_nat #( .N(8), .M(8) ) my(
        .x(abs_y), .y(abs_y), .c(8'd0),
        .m(y_quadro)
    );

    wire [15:0] somma;
    add #( .N(16) ) somma_quadrati(
        .x(x_quadro), .y(y_quadro), .c_in(1'B0),
        .s(somma[15:0])
    );

    comp_nat #( .N(16) ) comp(
        .a(somma), .b(RAGGIO_QUADRO),
        .min(in), .eq(bordo)
    );

    assign z = in | bordo;
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