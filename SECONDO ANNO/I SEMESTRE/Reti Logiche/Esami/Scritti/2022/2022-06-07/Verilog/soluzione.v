
module ABC(
    davA_, rfdA, dataA,
    davB_, rfdB, dataB,
    out,
    clock, reset_
);
    input clock, reset_;

    input davA_;
    output rfdA;
    input [7:0] dataA;

    input davB_;
    output rfdB;
    input [7:0] dataB;

    output out;

    reg OUT;
    assign out = OUT;

    reg RFDA, RFDB;
    assign rfdA = RFDA, rfdB = RFDB;

    reg [7:0] A, B;
    wire b_ae_a;
    COMP c( .a(A), .b(B), .b_ae_a(b_ae_a) );

    reg [3:0] COUNT;

    reg [1:0] STAR; 
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2;

    always @(reset_==0) #1 begin 
        RFDA = 1;
        RFDB = 1;
        OUT = 0;
        STAR = S0;
    end

    always @(posedge clock) if (reset_==1) #3
    casex(STAR)
        S0: begin
            RFDA <= 1;
            RFDB <= 1;
            A <= dataA;
            B <= dataB;
            OUT <= 0;
            STAR <= (davA_ == 1 || davB_ == 1) ? S0 : S1;
        end
        S1: begin 
            RFDA <= 0;
            RFDB <= 0;
            COUNT <= b_ae_a ? 12 : 6;
            STAR <= (davA_ == 0 || davB_ == 0) ? S1 : S2;
        end
        S2: begin 
            OUT <= 1;
            COUNT <= COUNT - 1;
            STAR <= (COUNT == 1) ? S0 : S2;
        end
    endcase

endmodule

module COMP(
    a, b,
    b_ae_a
);
    input [7:0] a, b;
    output b_ae_a;

    wire [7:0] n_b;
    assign n_b = ~b;
    wire c_out, b_out;
    assign b_out = ~c_out;
    wire [7:0] diff;
    
    add #(.N(8)) sub(
        .x(a), .y(n_b), .c_in(1'b1),
        .s(diff), .c_out(c_out)
    );

    assign b_ae_a = b_out | diff == 8'b0;

endmodule