module ABC(
    numero, eoc, clock, reset_,
    out, soc
);
    input [7:0] numero;
    input eoc;
    input clock, reset_;

    output out;
    output soc;

    reg SOC;
    assign soc = SOC;

    reg OUT;
    assign out = OUT;

    reg [7:0] NUMERO;
    reg [7:0] COUNT;

    reg [1:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3;

    always @(reset_ == 0) #3 begin
        STAR   <= S0;
        NUMERO <= 6;
        COUNT  <= 6;
        SOC    <= 0;
        OUT    <= 0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex(STAR)
            S0: begin
                OUT <= 0;
                COUNT <= ( COUNT == 1 ) ? NUMERO : COUNT - 1;
                STAR <= ( COUNT == 1 ) ? S1 : S0;
            end

            S1: begin
                OUT <= 1;
                COUNT <= COUNT - 1;
                SOC <= 1;
                STAR <= (eoc == 0) ? S2 : S1;
            end

            S2: begin
                OUT <= 1;
                COUNT <= COUNT - 1;
                SOC <= 0;
                NUMERO <= numero;
                STAR <= (eoc == 1) ? S3 : S2;
            end

            S3: begin
                OUT <= 1;
                COUNT <= ( COUNT == 1 ) ? NUMERO : COUNT - 1;
                STAR <= ( COUNT == 1 ) ? S0 : S3;
            end

        endcase
    end 

endmodule