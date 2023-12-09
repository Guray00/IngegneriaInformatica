module ABC (
    x, y,
    soc, eoc, out, 
    clock, reset_
);
    input clock, reset_;
    input soc;
    output eoc;
    output [7:0] x;
    input [7:0] y;
    output [15:0] out;
    
    reg EOC;
    reg [7:0] X;
    reg [15:0] OUT;
    
    reg [2:0] STAR;
    
    localparam S0=0, S1=1, S2=2, S3=3; 

    assign eoc = EOC;
    assign x = X;
    assign out = OUT;

    wire check;
    CHECK c (
        .x(x), .y(y), .check(check)
    );

    always @(reset_==0) #1 
        begin
            EOC = 1; 
            X = 0;
            OUT = 0;
            STAR = S0; 
        end
    
    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: 
                begin
                    EOC <= 1;
                    STAR <= soc ? S1 : S0;
                end
            S1: 
                begin
                    EOC <= 0;
                    STAR <= soc ? S1 : S2; 
                end
            S2: 
                begin
                    X <= X + 1;
                    STAR <= S3;
                end
            S3:
                begin
                    OUT <= {X, y};
                    STAR <= check ? S0 : S2;
                end
        endcase

endmodule

module CHECK(
    x, y,
    check
);
    input [7:0] x, y;
    output check;

    wire [15:0] prod;
    mul_add_nat #( .N(8), .M(8) ) m (
        .x(x), .y(y), .c(8'b0),
        .m(prod)
    );

    wire min;
    comp_nat #( .N(16) ) comp (
        .a(prod), .b(16'hABBA),
        .min(min)
    );

    assign check = ~min;
endmodule