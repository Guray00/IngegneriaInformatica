module ABC (
    soc, eoc, n,
    dav_a_, rfd_a, 
    dav_b_, rfd_b,
    out,
    clock, reset_
);
    input clock, reset_;
    input eoc, rfd_a, rfd_b;
    output soc, dav_a_, dav_b_;
    input [7:0] n;
    output [31:0] out;
    
    reg SOC, DAV_;
    reg [5:0] COUNT;
    reg [26:0] OUT;
    
    reg [2:0] STAR;
    localparam S0=0, S1=1, S2=2, S3=3, S4=4;

    assign soc = SOC;
    assign dav_a_ = DAV_;
    assign dav_b_ = DAV_;
    assign out = {5'b0, OUT};

    reg [26:0] F_N_m1, F_N_m2;
    wire [26:0] f_n;
    NEXT_FIBONACCI nf (
        .f_n_m1(F_N_m1), .f_n_m2(F_N_m2), 
        .f_n(f_n)
    );

    always @(reset_==0) #1 
        begin
            SOC = 0;
            DAV_ = 1;
            STAR = S0;
        end
    
    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: 
                begin
                    SOC <= 1;
                    STAR <= (eoc == 1'B0) ? S1 : S0;
                end
            S1: 
                begin
                    SOC <= 0;
                    COUNT <= n;
                    F_N_m1 <= 1;
                    F_N_m2 <= 0;
                    STAR <= (eoc == 1'B1) ? S2 : S1;
                end
            S2:
                begin
                    COUNT <= COUNT - 1;
                    OUT <= f_n;
                    F_N_m1 <= f_n;
                    F_N_m2 <= F_N_m1;
                    STAR <= (COUNT == 2) ? S3 : S2;
                end
            S3: 
                begin
                    DAV_ <= 0;
                    STAR <= ({rfd_a, rfd_b} == 2'b00) ? S4 : S3;
                end
            S4: 
                begin
                    DAV_ <= 1;
                    STAR <= ({rfd_a, rfd_b} == 2'b11) ? S0 : S4;
                end
        endcase

endmodule

module NEXT_FIBONACCI(
    f_n_m1, f_n_m2, 
    f_n
);
    input [26:0] f_n_m1, f_n_m2;
    output [26:0] f_n;

    add #( .N(27) ) a (
        .x(f_n_m1), .y(f_n_m2), .c_in(1'b0),
        .s(f_n)
    );

endmodule
