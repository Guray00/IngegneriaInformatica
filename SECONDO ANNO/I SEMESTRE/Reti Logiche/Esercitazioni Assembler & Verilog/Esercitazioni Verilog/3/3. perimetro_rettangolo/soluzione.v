
module ABC(
    a, b,
    p,
    dav_, rfd,
    clock, reset_
);
    input [3:0] a, b;
    output [5:0] p;

    input dav_;
    output rfd;

    input clock, reset_;

    // registri di uscita
    reg [5:0] P;
    assign p = P;

    reg RFD;
    assign rfd = RFD;

    // registri interni

    reg [3:0] A, B;

    reg [2:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4;

    wire [5:0] out_rc;
    RC_PERIMETRO rc(
        .a(A), .b(B),
        .p(out_rc)
    );

//  Handshake dav_/rfd
//   - A riposo: `dav_ = 1`, `rfd = 1`.
//   - Comincia il produttore: `dav_ = 0`. Questo segnala che il dato è valido.
//   - ACK del consumatore: `rfd = 0`. Questo segnala che il dato è stato letto.
//   - Reset del produttore: `dav_ = 1`.
//   - Reset del consumatore: `rfd = 1`.

//  Handshake dav_/rfd DAL PUNTO DI VISTA DEL CONSUMATORE
//  - al reset e all'inizio di ogni hs, rfd = 1
//  - ASPETTO che il produttore metta dav_ = 0
//  - CONSUMO il dato
//  - SEGNALO di averlo fatto con rfd = 0
//  - ASPETTO che il produttore metta dav_ = 1
//  - SEGNALO con rfd = 1 di essere pronto a un nuovo hs

    always @(reset_ == 0) begin
        P = 0;
        RFD = 1;
        STAR = S0;
    end

    always @(posedge clock) if( reset_ == 1) #3 begin
        casex (STAR)
            S0 : begin
                STAR <= (dav_ == 0) ? S1 : S0;
            end
            S1 : begin
                A <= a;
                B <= b;
                RFD <= 0;
                STAR <= S2;
            end
            S2 : begin
                P <= out_rc;
                STAR <= (dav_ == 1) ? S3 : S2;
            end
            S3 : begin
                RFD <= 1;
                STAR <= S0;
            end
        endcase
    end

endmodule

// descrizione della rete combinatoria
module RC_PERIMETRO(
    a, b,
    p
);
    input [3:0] a, b;
    output [5:0] p;

    assign #2 p = (a + b) * 2;
endmodule