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

// L'uscita z vale 1 se il punto è interno all'area
module IN_AREA(
    x, y,
    z
);
    input [7:0] x, y;
    output z;

    wire [7:0] abs_x, abs_y;
    abs #( .N(8) ) a1 (
        .x(x), .abs_x(abs_x)
    );
    abs #( .N(8) ) a2 (
        .x(y), .abs_x(abs_y)
    );

    // in_quadrato: 1 se il punto è all'interno del quadrato 'diritto'

    wire in_quadrato;
    comp_nat #( .N(8) ) comp_x(
        .a(abs_x), .b(8'd48),
        .min(in_x), .eq(bordo_x)
    );
    comp_nat #( .N(8) ) comp_y(
        .a(abs_y), .b(8'd48),
        .min(in_y), .eq(bordo_y)
    );
    assign #1 in_quadrato = (in_x | bordo_x) & (in_y | bordo_y);

    // in_quadrato_diagonale: 1 se il punto è all'interno del quadrato 'diagonale'

    wire in_quadrato_diagonale;
    wire [8:0] somma_xy;
    add #( .N(8) ) add_abs(
        .x(abs_x), .y(abs_y), .c_in(1'B0),
        .c_out(somma_xy[8]), .s(somma_xy[7:0])
    );
    comp_nat #( .N(9) ) comp_xy(
        .a(somma_xy), .b(9'd64),
        .min(in_xy), .eq(bordo_xy)
    );
    assign #1 in_quadrato_diagonale = (in_xy | bordo_xy);

    // in_area: l'area in grigio è l'or esclusivo tra le due altre figure
    assign #1 z = in_quadrato ^ in_quadrato_diagonale;

endmodule
