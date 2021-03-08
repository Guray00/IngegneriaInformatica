// rete consumatore in handshake _dav/rfd
// in ingresso due valori 4 bit a,b
// in uscita perimetro rettangolo con lati a,b

module PerimetroRettangolo(
    a, b, clock, _reset, _dav,
    p, rfd
);
    input [3:0] a, b;
    input clock, _reset, _dav;

    reg [3:0] A, B;

    output [5:0] p; // 2 * (a + b)
    output rfd;

    reg [5:0] P;
    assign p = P;

    reg RFD;
    assign rfd = RFD;

    reg [1:0] STAR;
    localparam
        S0 = 'B00,
        S1 = 'B01,
        S2 = 'B10,
        S3 = 'B11;

    always @(_reset == 0) #1
        begin
            P <= 0;
            RFD <= 1;
            STAR <= S0;
            A <= 0;
            B <= 0;
        end

    always @(posedge clock) if(_reset == 1) #1
        casex(STAR)
            S0:
                begin
                    STAR <= (_dav == 0) ? S1 : S0;
                    P <= P;
                end     

            S1:
                begin
                    A <= a;
                    B <= b;
                    RFD <= 0;
                    STAR <= S2;
                end

            S2:
                begin
                    STAR <= (_dav == 1) ? S3 : S1;
                end

            S3:
                begin
                    P <= 2 * (A + B);
                    STAR <= S0;
                    RFD <= 1;
                end

        endcase

endmodule
