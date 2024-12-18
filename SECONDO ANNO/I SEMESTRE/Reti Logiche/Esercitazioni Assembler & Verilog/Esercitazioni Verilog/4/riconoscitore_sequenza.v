// Riconoscitore di sequenza 011
// Mandata sequenzialmente in input
// Se corretta, tenere output a 1 per 4 clock

module RiconoscitoreSequenza(
    in, clock, _reset,
    out
);
    input in, clock, _reset;
    output out;

    reg OUT;
    assign out = OUT;

    reg [2:0] COUNT;

    reg [2:0] STAR;
    localparam 
        S0 = 'B000,
        S1 = 'B001,
        S2 = 'B010,
        S3 = 'B011;

    always @(_reset == 0) #1
        begin
            OUT <= 0;
            STAR <= S0;
            COUNT <= 'B100;
        end

    always @(posedge clock) if(_reset == 1) #1
        casex(STAR)
            S0:
                begin
                   STAR <= (in == 0) ? S1 : S0; 
                   COUNT <= 'B100;
                end

            S1:
                begin
                    STAR <= (in == 1) ? S2 : S0; 
                end

            S2:
                begin
                    STAR <= (in == 1) ? S3 : S0;
                    OUT <= (in == 1) ? 1 : 0;
                end

            S3:
                begin
                    OUT <= (COUNT == 1) ? 0 : 1;
                    COUNT <= COUNT - 1; 
                    STAR <= (COUNT == 1) ? S0 : S3; 
                end

        endcase

endmodule

// k valora partenza
// j valore fine

// k - j + 1
// 4 - 1 + 1 = 4
// 3 - 0 + 1 = 4