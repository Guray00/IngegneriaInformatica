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

reg [5:0] P;
reg RFD;
assign p = P;
assign rfd = RFD;

reg [1:0] STAR;
localparam S0 = 0, S1 = 1, S2 = 2;
wire [6:0] per;


RC_PERIMETRO RCP(
    a, b,
    per
);

always @(_reset == 0)#1 begin
    P <= 0;
    RFD <= 1;    
end
always @(posedge clock)if(_reset == 1)#3 begin
    casex (STAR) 
    S0: begin
        RFD <= 1;
        STAR <= (_dav == 0) ? S1 : S0;

    end    
    S1: begin
        RFD <= 0;
        P <= per[5:0];
        STAR <= S2;
    end
    S2: begin
        STAR <= (_dav == 0)? S2 : S0;
    end
endcase
end
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