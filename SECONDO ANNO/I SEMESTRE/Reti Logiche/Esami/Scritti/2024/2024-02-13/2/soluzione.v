module ABC(
    b, c, l_0, r_0, x_0,  
    soc, eoc,
    clock, reset_
);
    input [9:0] b, c;
    input [7:0] l_0, r_0;
    output [7:0] x_0;
    input soc;
    output eoc;
    input clock, reset_;

    reg EOC;
    assign eoc = EOC;

    reg [7:0] X_0;
    assign x_0 = X_0;

    reg [9:0] B, C;
    reg [7:0] L_CURR, R_CURR;
    wire [7:0] l_next, r_next;
    
    PROSSIMO_INTERVALLO pi(
        .b(B), .c(C),
        .l_curr(L_CURR), .r_curr(R_CURR),
        .l_next(l_next), .r_next(r_next)
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
                    B <= b;
                    C <= c;
                    L_CURR <= l_0;
                    R_CURR <= r_0;
                    STAR <= soc ? S1 : S0;
                end
            S1: 
                begin
                    EOC <= 0;
                    L_CURR <= l_next;
                    R_CURR <= r_next;
                    STAR <= (l_next + 1 == r_next) ? S2 : S1;
                end
            S2: 
                begin
                    X_0 <= R_CURR;
                    STAR <= soc ? S2 : S0; 
                end
        endcase

endmodule

module PROSSIMO_INTERVALLO (
    b, c,
    l_curr, r_curr,
    l_next, r_next
);
    input [9:0] b, c;
    input [7:0] l_curr, r_curr;
    output [7:0] l_next, r_next;
    
    // circuito per il calcolo di m
    
    wire [7:0] m;

    wire [8:0] lr;
    add #( .N(8) ) a_lr (
        .x(l_curr), .y(r_curr), .c_in(1'b0),
        .c_out(lr[8]), .s(lr[7:0])
    );
    assign m = lr[8:1];

    // circuito per il calcolo di f(m)

    wire [15:0] m2; // m^2
    mul_add_nat #( .N(8), .M(8) ) mul_mm (
        .x(m), .y(m), .c(8'd0),
        .m(m2)
    );

    wire [17:0] bm; // b*m
    mul_add_nat #( .N(8), .M(10) ) mul_bm (
        .x(m), .y(b), .c(8'd0),
        .m(bm)
    );

    // sottrarre b*m e c da m^2 equivale a sommare tre numeri interi
    // che stanno, rispettivamente, su 16, 18 e 10 bit.
    // la somma starà su 20 bit
    wire [19:0] m2_ext;
    assign m2_ext = {4'b0, m2};

    wire [19:0] bm_ext;
    assign bm_ext = {2'b0, bm};

    wire [19:0] c_ext;
    assign c_ext = {10'b0, c};

    wire [19:0] m2_bm;
    diff #( .N(20) ) a_m2_bm (
        .x(m2_ext), .y(bm_ext), .b_in(1'b0),
        .d(m2_bm)
    );
    
    wire [19:0] fm;
    diff #( .N(20) ) a_fm (
        .x(m2_bm), .y(c_ext), .b_in(1'b0),
        .d(fm)
    );

    // circuito per la scelta dei successivi l e r
    // f(m) >= 0 -> [l, m]
    // f(m) < 0 -> [m, r]

    assign l_next = fm[19] ? m : l_curr;
    assign r_next = fm[19] ? r_curr : m;    

endmodule
