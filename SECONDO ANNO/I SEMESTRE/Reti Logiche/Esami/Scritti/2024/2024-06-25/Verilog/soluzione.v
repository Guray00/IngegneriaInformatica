module ABC (
    vx, vy,
    soc_vx, eoc_vx,
    soc_vy, eoc_vy,
    x, y,
    soc_p, eoc_p,
    clock, reset_
);

    input [3:0] vx, vy;
    output soc_vx, soc_vy;
    input eoc_vx, eoc_vy;
    
    output [7:0] x, y;
    input soc_p;
    output eoc_p;

    input clock, reset_;

    reg SOC;
    assign soc_vx = SOC;
    assign soc_vy = SOC;

    reg EOC;
    assign eoc_p = EOC;

    reg [7:0] X, Y;
    assign x = X;
    assign y = Y;

    wire [7:0] x_next, y_next;
    PROSSIMA_POSIZIONE P (
        .x(X), .y(Y),
        .vx(vx), .vy(vy),
        .x_next(x_next), .y_next(y_next)
    );

    reg [2:0] STAR;
    localparam
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S5 = 5;

    always @(reset_ == 0) #1 begin
        SOC = 0;
        EOC = 1;
        STAR = S0;
        X = 0;
        Y = 0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (STAR)
            S0: begin
                STAR <= (soc_p == 1) ? S1 : S0;
            end
            S1: begin
                EOC = 0;
                STAR <= (soc_p == 0) ? S2 : S1;
            end
            S2: begin
                SOC <= 1;
                STAR <= ({eoc_vx, eoc_vy} == 2'b00) ? S3 : S2;
            end
            S3: begin
                SOC <= 0;
                STAR <= ({eoc_vx, eoc_vy} == 2'b11) ? S4 : S3;
            end
            S4: begin
                X <= x_next;
                Y <= y_next;
                STAR <= S5;
            end
            S5: begin
                EOC <= 1;
                STAR <= S0;
            end
        endcase
    end

endmodule

module PROSSIMA_POSIZIONE (
    x, y,
    vx, vy,
    x_next, y_next
);
    input [3:0] vx, vy;
    input [7:0] x, y;
    output [7:0] x_next, y_next;


    wire [7:0] vx_ext = {vx[3], vx[3], vx[3], vx[3], vx};
    wire [7:0] vy_ext = {vy[3], vy[3], vy[3], vy[3], vy};

    wire [7:0] xn;
    wire ow_x;
    add #(.N(8)) ax (
        .x(x), .y(vx_ext), .c_in(1'b0),
        .s(xn), .ow(ow_x)
    );
    assign x_next = ow_x ? x : xn;

    wire [7:0] yn;
    wire ow_y;
    add #(.N(8)) ay (
        .x(y), .y(vy_ext), .c_in(1'b0),
        .s(yn), .ow(ow_y)
    );
    assign y_next = ow_y ? x : yn;

endmodule
