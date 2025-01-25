module ABC(
    x1, x2, x3,
    eoc1, eoc2, eoc3,
    soc,
    min,
    rfd, dav_,
    clock, reset_
);
    input [7:0] x1, x2, x3;
    input eoc1, eoc2, eoc3;
    output soc;
    
    output [7:0] min;
    input rfd;
    output dav_;
    
    input clock, reset_;

    reg SOC;
    assign soc = SOC;

    reg [7:0] MIN;
    assign min = MIN;

    reg DAV_;
    assign dav_ = DAV_;

    reg [3:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S5 = 5;

    wire [7:0] out_rc;
    MINIMO_3 m3(
        .a(x1), .b(x2), .c(x3),
        .min(out_rc)
    );

    //  Handshake soc/eoc
    // eoc = 1, soc = 0
    // comincia il consumatore: soc = 1
    // risponde il produttore: eoc = 0
    // ack del consumatore: soc = 0
    // risposta del produttore: eoc = 1
    // segnala nuovo dato valido, deve essere valido PRIMA di eoc = 1

    //  Handshake soc/eoc DAL PUNTO DI VISTA DEL CONSUMATORE
    //  @reset soc = 0
    //  soc = 1
    //  ATTENDO eoc = 0
    //  soc = 0
    //  ATTENDO eoc = 1, quando succede il dato è valido

    //  Handshake dav_/rfd
    //   - A riposo: `dav_ = 1`, `rfd = 1`.
    //   - Comincia il produttore: `dav_ = 0`. Questo segnala che il dato è valido.
    //   - ACK del consumatore: `rfd = 0`. Questo segnala che il dato è stato letto.
    //   - Reset del produttore: `dav_ = 1`.
    //   - Reset del consumatore: `rfd = 1`.

    //  Handshake dav_/rfd DAL PUNTO DI VISTA DEL PRODUTTORE
    //  @reset dav_ = 1
    //  assegno MIN
    //  dav_ = 0
    //  ATTENDO rfd = 0
    //  dav_ = 1
    //  ATTENDO rfd = 1
    
    always @(reset_ == 0) begin
        DAV_ = 1;
        SOC = 0;
        STAR = S0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (STAR)
            S0: begin
                SOC <= 1;
                STAR <= ({eoc3, eoc2, eoc1} == 3'b000) ? S1 : S0;
            end
            S1: begin
                MIN <= out_rc;
                SOC <= 0;
                STAR <= ({eoc3, eoc2, eoc1} == 3'b111) ? S2 : S1;
            end
            S2: begin
                DAV_ <= 0;
                STAR <= (rfd == 0) ? S3 : S2;
            end
            S3: begin
                DAV_ <= 1;
                STAR <= (rfd == 1) ? S0 : S3;
            end
        endcase
    end

endmodule

// module MINIMO_3(
//     a, b, c,
//     min
// );
//     input [7:0] a, b, c;
//     output [7:0] min;

//     assign #1 min = ( a < b ) ?
//         ((a < c) ? a : c) :
//         ((b < c) ? b : c) ;

// endmodule

// min(a, b, c) = min( min(a, b), c)

module MINIMO_3(
    a, b, c,
    min
);
    input [7:0] a, b, c;
    output [7:0] min;

    wire [7:0] min_ab;
    MINIMO_2 m1(
        .a(a), .b(b),
        .min(min_ab)
    );

    MINIMO_2 m2(
        .a(min_ab), .b(c),
        .min(min)
    );

endmodule

module MINIMO_2(
    a, b,
    min
);
    input [7:0] a, b;
    output [7:0] min;

    wire b_out;
    diff #( .N(8) ) d(
        .x(a), .y(b), .b_in(1'b0),
        .b_out(b_out)
    );

    // b_out = 1 => a < b
    assign #1 min = b_out ? a : b;

endmodule
