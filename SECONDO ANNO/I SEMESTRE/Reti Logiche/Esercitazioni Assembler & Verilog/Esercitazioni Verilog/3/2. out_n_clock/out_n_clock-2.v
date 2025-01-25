module out_n_clock(
    out,
    clock, reset_
);

    output out;
    input clock, reset_;

    // registri uscita
    reg OUT;
    assign out = OUT;

    // registri interni

    localparam N = 3;
    reg [3:0] COUNT;

    reg STAR;
    localparam
        S0 = 0,
        S1 = 1;

    always @(reset_ == 0) begin
        OUT = 0;
        COUNT = N;
        STAR = S0;
    end

    wire [3:0] next_count_S0;
    assign #2 next_count_S0 = COUNT - 1;

    wire next_star_S0;
    assign #2 next_star_S0 = (COUNT == 1) ? S1 : S0;

    always @(posedge clock) if (reset_ == 1) #3 begin
        casex (STAR)
            S0 : begin
                OUT <= 1;
                COUNT <= next_count_S0;
                STAR <= next_star_S0;
            end 
            S1 : begin
                OUT <= 0;
                COUNT <= N;
                STAR <= S0;
            end
        endcase
    end

endmodule