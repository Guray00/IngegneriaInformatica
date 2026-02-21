module ABC (
    n_0, result, 
    soc, eoc,
    clock, reset_
);
    input [7:0] n_0;
    output [15:0] result;
    input soc;
    output eoc;

    input clock, reset_;

    reg EOC;
    assign eoc = EOC;

    reg [15:0] RESULT;
    assign result = RESULT;

    // Il massimo valore di interesse è (200 * 5) - 10 = 990, 
    // quindi 10 bit sono sufficienti
    reg [9:0] N_CURR;
    wire [9:0] n_next;
    CALCOLO_ITERAZIONE ci(
        .n_curr(N_CURR), 
        .n_next(n_next)
    );

    wire done;
    comp_nat #(.N(10)) comp_done(
        .a(10'd200), .b(n_next),
        .min(done)
    );

    reg [1:0] STAR;
    localparam 
        S0 = 0, 
        S1 = 1, 
        S2 = 2;

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
                    N_CURR <= {2'b0, n_0};
                    STAR <= soc ? S1 : S0;
                end
            S1: 
                begin
                    EOC <= 0;
                    N_CURR <= n_next;
                    STAR <= done ? S2 : S1; 
                end
            S2: 
                begin
                    RESULT <= {6'b0, N_CURR};
                    STAR <= soc ? S2 : S0;
                end
        endcase

endmodule

// n_curr e n_next naturali su 10 bit
// se n_curr <= 2, n_next = n_curr + 2
// se n_curr > 2, n_next = (n_curr * 5) - 10
module CALCOLO_ITERAZIONE(n_curr, n_next);
    input [9:0] n_curr;
    output [9:0] n_next;

    // Comparatore per verificare se n_curr <= 2
    wire is_le_2;
    comp_nat #(.N(10)) comp(
        .a(n_curr),
        .b(10'd3),
        .min(is_le_2)
    );
    
    // Calcolo per il caso n_curr <= 2: n_next = n_curr + 2
    wire [9:0] n_next_le2;
    add #(.N(10)) add_2(
        .x(n_curr), .y(10'd2), .c_in(1'b0),
        .s(n_next_le2)
    );

    // Calcolo per il caso n_curr > 2: n_next = (n_curr * 5) - 10
    wire [12:0] mult_5_result;
    mul_add_nat #(.N(10), .M(3)) mult_5(
        .x(n_curr),
        .y(3'd5),
        .c(10'd0),
        .m(mult_5_result)
    );

    wire [9:0] n_next_gt2;
    add #(.N(10)) sub_10(
        .x(mult_5_result[9:0]),
        .y(~(10'd10)),
        .c_in(1'b1),
        .s(n_next_gt2)
    );
    
    // Multiplexer per la scelta tra i due casi
    assign n_next = is_le_2 ? n_next_le2 : n_next_gt2;

endmodule
