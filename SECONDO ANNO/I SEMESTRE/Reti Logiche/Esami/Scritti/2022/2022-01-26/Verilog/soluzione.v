module ABC(
    socA, socB, eocA, eocB, a, b,
    davC_, rfdC, z1, z0,
    clock, reset_
);

    input eocA, eocB, rfdC;
    input[3:0] a,b;
    output socA, socB, davC_;
    output[3:0] z1, z0;
    input clock, reset_;

    reg[3:0] MSD, LSD;
    assign z1 = MSD, z0 = LSD;

    reg  SOC;
    assign socA = SOC, socB = SOC;

    reg  DAV_;
    assign davC_ = DAV_;

    reg[1:0] STAR;
    localparam 
        S0 = 0, 
        S1 = 1, 
        S2 = 2, 
        S3 = 3;

    wire [3:0] s1, s0;
    somma_base_10 sb10 (
        .a(a), .b(b),
        .z1(s1), .z0(s0)
    );

    always@(reset_==0) #1 
        begin 
            SOC <= 0;
            DAV_ <= 1;
            STAR <= S0;
        end

    always@(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: begin
                SOC <= 1;
                STAR <= ({eocA, eocB}==2'B00) ? S1 : S0;
            end
            S1: begin
                SOC <= 0;
                STAR <= ({eocA, eocB}==2'B11) ? S2 : S1;
                LSD <= s0;
                MSD <= s1;
            end
            S2: begin
                DAV_ <= 0;
                STAR <= (rfdC==1) ? S2 : S3;
            end
            S3: begin
                DAV_ <= 1;
                STAR <= (rfdC==1) ? S0 : S3;
            end
        endcase
endmodule

module somma_base_10 (
    a, b,
    z1, z0
);
    input [3:0] a, b;
    output [3:0] z1, z0;

    wire [4:0] s; // somma di a e b, su 5 cifre base 2
    add #( .N(4) ) a0(
        .x(a), .y(b), .c_in(1'b0),
        .s(s[3:0]), .c_out(s[4])
    );

    wire [4:0] d; // s0 - 10
    wire comp; // 1 se s0 < 10
    diff #(.N(5)) d0(
        .x(s), .y(5'd10), .b_in(1'b0),
        .d(d), .b_out(comp)
    );

    // se (a + b) < 10 => z1 = 0; z0 = a + b
    // se (a + b) >= 10 => z1 = 1; z0 = a + b - 10

    assign {z1, z0} = comp ? {4'b0, s[3:0]} : {4'b1, d[3:0]};

endmodule