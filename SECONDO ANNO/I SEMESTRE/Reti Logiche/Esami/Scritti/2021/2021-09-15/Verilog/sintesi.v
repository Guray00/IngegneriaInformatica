module ABC(
    s, h, rfd, dav_, out,
    clock, reset_
);
    input clock, reset_;
    input dav_;
    output rfd; 
    output[7:0] out; 
    input s;
    input [6:0] h;  
 
	wire b2, b1, b0;
	wire c1, c0;

	PARTE_CONTROLLO PC (
		clock, reset_,
		b2, b1, b0,
		c1, c0
	);

	PARTE_OPERATIVA PO(
		s, h, rfd, dav_, out,
		clock, reset_	,
		b2, b1, b0,
		c1, c0
	);
	
endmodule


module PARTE_CONTROLLO (
    clock, reset_,
	b2, b1, b0,
	c1, c0
);

	input clock, reset_;
	output b2, b1, b0;
	input c1, c0;

	assign b0 = (STAR == S0) ? 1'b0 : 1'b1;
	assign {b2,b1} = (STAR == S0) ? 2'b00 : (STAR == S1) ? 2'b01 : 2'b1x;
    
 	reg[1:0] STAR; 
    localparam S0=0, S1=1, S2=2; 
	
	always @(reset_ == 0) #1 STAR <= S0;
    always @(posedge clock) if (reset_==1) #3 
        casex(STAR) 
            S0: STAR <= (c0) ? S1 : S0;
            S1: STAR <= (c1) ? S2 : S1;
            S2: STAR <= (~c0) ? S0 : S2;
        endcase
endmodule

module PARTE_OPERATIVA(
    s, h, rfd, dav_, out,
    clock, reset_	,
	b2, b1, b0,
	c1, c0
);

	input clock, reset_;
    input dav_;
    output rfd; 
    output[7:0] out; 
    input s;
    input [6:0] h; 

	input b2, b1, b0;
	output c1, c0;

	assign c0 = ~dav_;
	assign c1 = H[0] & ~H[1] & ~H[2] & ~H[3] & ~H[4] & ~H[5];

	reg RFD; 
    reg [7:0] OUT;
    reg S; 
    reg [6:0] H;  
 
    assign rfd=RFD; 
    assign out=OUT;  

	// RFD
	always @(reset_ == 0) #1 RFD <= 0;
	always @(posedge clock) if(reset_ == 1) #3
	casex (b0)
		1'b0: RFD <= 1;
		1'b1: RFD <= 0;
	endcase

	// S
	always @(posedge clock) if(reset_ == 1) #3
	casex (b0)
		1'b0: S <= s;
		1'b1: S <= S;
	endcase

	// H
	always @(posedge clock) if (reset_==1) #3
        casex({b2, b1}) 
            2'B00: H <= h;
            2'B01: H <= H-1;
			2'B1?: H <= H;
    endcase

	// OUT
	always @(reset_ == 0) #1 OUT <=  8'h80;;
	always @(posedge clock) if (reset_==1) #3
        casex({b2, b1}) 
			2'B00: OUT <= OUT;
            2'B01: OUT <= (S==0) ? (OUT+1) : (OUT-1);
            2'B1?:	OUT <= 8'h80;	
    	endcase

endmodule