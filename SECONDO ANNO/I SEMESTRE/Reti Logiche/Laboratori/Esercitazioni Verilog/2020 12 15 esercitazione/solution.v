module ABC(
    iow_, ior_, addr, data, reset_, clock
);
    output iow_;
    output ior_;
    output [15:0] addr;
    inout [7:0] data;
    input reset_;
    input clock;

    reg IOW_;
    assign iow_ = IOW_;

    reg IOR_;
    assign ior_ = IOR_;

    reg [15:0] ADDR;
    assign addr = ADDR;
    
    reg [7:0] OUTVALUE;

    reg DIR;
    assign data = (DIR == 1) ? OUTVALUE : 8'hZZ;

    reg [3:0] STAR;
    localparam 
        S0=0, S1=1, S2=2, S3=3, S4=4, S5=5,
        S6=6, S7=7, S8=8, S9=9;

    localparam
        FI = 0;

    wire [7:0] converted;
    CONV conv(
        .data(data),
        .out(converted)
    );

    always @(reset_ == 0) #1
        begin
            IOW_ <= 1;
            IOR_ <= 1;
            ADDR <= 16'H0000;
            STAR <= S0;
        end

    always @(posedge clock) if (reset_ == 1) #3
        casex(STAR)
            S0:
                begin
                    ADDR <= 16'hAAA0;
                    DIR <= 0;
                    STAR <= S1;
                end
            S1:
                begin
                    IOR_ <= 0;
                    STAR <= S2;
                end
            S2:
                begin
                    STAR <= (data[FI] == 1) ? S3 : S2;
                end
            S3:
                begin
                    IOR_ <= 1;
                    STAR <= S4;
                end
            S4:
                begin
                    ADDR <= 16'hAAA1;
                    STAR <= S5;
                end            
            S5:
                begin
                    IOR_ <= 0;
                    STAR <= S6;
                end
            S6:
                begin
                    OUTVALUE <= converted;
                    IOR_ <= 1;
                    STAR <= S7;
                end
            S7:
                begin
                    ADDR <= 16'hAAA3;
                    DIR <= 1;
                    STAR <= S8;
                end
            S8:
                begin
                    IOW_ <= 0;
                    STAR <= S9;
                end
            S9:
                begin
                    IOW_ <= 1;
                    STAR <= S0;
                end
        endcase

endmodule

module CONV (
    data,
    out
);
    input [7:0] data;
    output [7:0] out;

    wire sign;
    wire [2:0] c1, c0;
    assign sign = data[6];
    assign c1 = data[5:3];
    assign c0 = data[2:0];

    wire [5:0] positive;
    mul_add_nat #( .N(3), .M(3) ) mul(
        .x(c1), .y(3'B110), .c(c0),
        .m(positive)
    );
    
    wire [6:0] negative;
    wire [6:0] a_in;
    assign a_in = { 1'b1, ~positive };
    add #( .N(7) ) a(
        .x(a_in), .y(7'B0), .c_in(1'B1),
        .s(negative)
    );

    wire [6:0] out_7b;
    assign out_7b = sign ? negative : { 1'b0, positive };

    assign out = { out_7b[6], out_7b };

endmodule

module MASK(
    addr,
    s_
);
    input [13:0] addr;
    output s_;

    assign s_ = ( { addr, 2'B00 } == 16'hAAA0 ) ? 0 : 1;

    // sintesi, non richiesta
    // assign s_ = | ( { addr, 2'B00 } ^ 16'hAAA0 );

endmodule