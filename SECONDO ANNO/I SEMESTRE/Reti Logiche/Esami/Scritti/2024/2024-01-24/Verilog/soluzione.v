module ABC (
    n_0, k, 
    soc, eoc,
    clock, reset_
);
    input [7:0] n_0;
    output [7:0] k;
    input soc;
    output eoc;

    input clock, reset_;

    reg EOC;
    assign eoc = EOC;

    reg [7:0] K;
    assign k = K;

    reg [13:0] N_CURR;
    wire [13:0] n_next;
    
    CALCOLO_ITERAZIONE ci(
        .n_curr(N_CURR), 
        .n_next(n_next)
    );

    reg [1:0] STAR;
    localparam 
        S0 = 0, 
        S1 = 1, 
        S2 = 2, 
        S3 = 3;


    always @(reset_==0) #1 
        begin
            EOC = 1; 
            STAR = S0; 
        end

    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: 
                begin
                    EOC <= 1;
                    N_CURR <= {6'b0, n_0};
                    K <= soc ? 0 : K;
                    STAR <= soc ? S1 : S0;
                end
            S1: 
                begin
                    EOC <= 0;
                    K <= (N_CURR == 1) ? K : K + 1;
                    N_CURR <= n_next;
                    STAR <= (N_CURR == 1) ? S2 : S1; 
                end
            S2: 
                begin
                    STAR <= soc ? S2 : S0; 
                end
        endcase

endmodule

// n_curr e n_next naturali su 8 bit
// se n_curr è pari, n_next = n_curr / 2
// se n_curr è dispari, n_next = 3 * n_curr + 1
module CALCOLO_ITERAZIONE(n_curr, n_next);
    input [13:0] n_curr;
    output [13:0] n_next;   

    wire [13:0] n_next_pari;
    assign n_next_pari = {1'b0, n_curr[13:1]};

    wire [13:0] n_next_dispari;

    wire [15:0] m_result;
    mul_add_nat #( .N(2), .M(14)) m (
        .x(2'h3), .y(n_curr), .c(2'b1),
        .m(m_result)
    );
    assign n_next_dispari = m_result[13:0];

    assign n_next = n_curr[0] ? n_next_dispari : n_next_pari;

endmodule
