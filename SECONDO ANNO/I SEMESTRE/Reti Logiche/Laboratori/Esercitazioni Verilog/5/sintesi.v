module ABC (
    clock, _reset,
    _dav, rfd,
    a, b,
    p 
);
input clock, _reset;
input _dav;
input [3:0] a, b;

output [5:0] p;
output rfd;

wire b1, b0;
wire c0;

ParteOperativa PO (
    clock, _reset,
    _dav, rfd,
    a, b,
    p,
    b1, b0,
    c0
);

ParteControllo PC (
    clock, _reset,
    b1, b0,
    c0
);
endmodule

module ParteOperativa (
    clock, _reset,
    _dav, rfd,
    a, b,
    p,
    b1, b0,
    c0
);
    
input clock, _reset;
input _dav;
input [3:0] a, b;

output [5:0] p;
output rfd;

input b1, b0;
output c0;

assign c0 = _dav;

reg [5:0] P;
reg RFD;
assign p = P;
assign rfd = RFD;

wire [6:0] per;


RC_PERIMETRO RCP(
    a, b,
    per
);

always @(_reset == 0)#1
P <= 0;
always @(posedge clock) if (_reset == 1)#3
casex ({b0})
    'b1: P <= per[5:0];
    'b0: P <= P; 
endcase

always @(_reset == 0)#1
RFD <= 1;
always @(posedge clock) if (_reset == 1)#3
casex ({b1,b0})
    'b00: RFD <= 1;
    'b01: RFD <= 0;
    'b1x: RFD <= RFD;
endcase
endmodule

module ParteControllo (
    clock, _reset,
    b1, b0,
    c0
);
    input clock, _reset;
    input c0;
    output b1, b0;

    reg [1:0] STAR;
    localparam S0 = 0, S1 = 1, S2 = 2;

    assign b1 = (STAR == S2)? 1 : 0;
    assign b0 = (STAR == S1)? 1 : 0;

    always @(_reset == 0)#1
    STAR <= S0;
always @(posedge clock) if (_reset == 1)#3
    casex ({b1,b0})
        S0: STAR <= (c0 == 0)? S1 : S0;
        S1: STAR <= S2;
        S2: STAR <= (c0 == 0)? S2 : S0;
endcase

endmodule

module RC_PERIMETRO (
    a, b,
    per
);
    input [3:0] a, b;

    output [6:0] per;

    wire [4:0] sum;

    add #(.N(4))  ad(
        .x(a), .y(b), .c_in(1'b0),
        .s(sum[3:0]), .c_out(sum[4])
    );

    mul_add_nat #(.N(5), .M(2)) m(
        .x(sum), .y(2'b10), .c(5'b0),
        .m(per)
    );
    
endmodule
/*
u-add|  b1  b0 | ceff |  ut | uf      
  00     0   0     0     01   00
  01     0   1     /     10   //
  10     1   x     0     10   00
            */