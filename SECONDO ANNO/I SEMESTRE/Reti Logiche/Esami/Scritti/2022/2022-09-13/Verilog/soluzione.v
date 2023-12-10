module TEST_MULTIPLO(x, y, dav_, rfd, m, ok, clock, reset_);
    input [3:0] x;
    input [2:0] y;
    input dav_;
    output rfd;
    output m, ok;    
    input clock, reset_;

    reg [3:0] X;
    reg [2:0] Y;
    reg RFD;
    assign rfd = RFD;

    reg OK;
    assign ok = OK;

    TEST_MULTIPLO_RC tm(
        .x(X), .y(Y),
        .m(m)
    );

    reg [1:0] STAR;
    localparam 
        S0 = 0, 
        S1 = 1, 
        S2 = 2, 
        S3 = 3;


    always@(reset_==0) #1 
    begin 
        RFD <= 1;
        OK <= 0;
        STAR <= S0;
    end

    always @(posedge clock) if (reset_==1) #3
    casex(STAR)
        S0: begin
            OK <= 0;
            RFD <= 1;
            X <= x;
            Y <= y;
            STAR <= (dav_ == 0)?S1:S0;
        end

        S1: begin
            OK <= 1;
            RFD <= 0;
            STAR <= (dav_ == 0)?S1:S0;
        end
    endcase

endmodule

// x naturale su 4 bit
// y naturale su 3 bit >= 6
// m = 1 se x è un multiplo di y
module TEST_MULTIPLO_RC(x, y, m);
    input [3:0] x;
    input [2:0] y;
    output m;   

    wire [3:0] y_ext;
    assign y_ext = {1'b0,y};

    wire [3:0] d_1;
    wire b_out_1;

    diff #(4) diff_1(
        .x(x), .y(y_ext), .b_in(1'b0),
        .d(d_1), .b_out(b_out_1)
    );

    wire m_1;
    assign m_1 = d_1 == 0;

    wire [3:0] d_2;
    wire b_out_2;

    diff #(4) diff_2(
        .x(d_1), .y(y_ext), .b_in(1'b0),
        .d(d_2), .b_out(b_out_2)
    );

    wire m_2;
    assign m_2 = ~b_out_1 & (d_2 == 0);

    wire [3:0] d_3;
    wire b_out_3;

    diff #(4) diff_3(
        .x(d_2), .y(y_ext), .b_in(1'b0),
        .d(d_3), .b_out(b_out_3)
    );

    wire m_3;
    assign m_3 = ~b_out_1 & ~b_out_2 & (d_3 == 0);

    assign m = m_1 | m_2 | m_3;

endmodule
