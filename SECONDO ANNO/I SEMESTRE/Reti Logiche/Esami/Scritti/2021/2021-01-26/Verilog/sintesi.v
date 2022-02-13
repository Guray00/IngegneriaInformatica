/*
Sintesi proposta da uno studente
basata
sulla descrizione proposta dai docenti
*/

module ABC(
	colore, endline, dav_,
	txd, rfd,
	reset_, clock
);

	wire b9,b8,b7,b6,b5,b4,b3,b2,b1,b0;
	wire c3,c2,c1,c0;

	input colore, endline, dav_, reset_, clock;
	output txd, rfd;

	PARTE_OPERATIVA PO(
		colore, endline, dav_,
		txd, rfd,
		b9,b8,b7,b6,b5,b4,b3,b2,b1,b0,		// comando
		c3,c2,c1,c0,					// condizionamento
		reset_, clock
	);
	
	PARTE_CONTROLLO PC(
		b9,b8,b7,b6,b5,b4,b3,b2,b1,b0,		// comando
		c3,c2,c1,c0,					// condizionamento
		reset_, clock
	);

endmodule


module PARTE_OPERATIVA (
	colore, endline, dav_,
	txd, rfd,
	b9,b8,b7,b6,b5,b4,b3,b2,b1,b0,		// comando
	c3,c2,c1,c0,					// condizionamento
	reset_, clock
);
	input  b9,b8,b7,b6,b5,b4,b3,b2,b1,b0;
	output c3,c2,c1,c0;

	input colore, endline, dav_, reset_, clock;
	output txd, rfd;
	
	
	// dalla rete ===================================
	reg TXD;
	reg RFD;
	reg B;
	reg ENDLINE;
	reg [6:0] N;
	reg [3:0] CONT;
	reg [9:0] BUFFER;

	assign #1 rfd = RFD;
	assign #1 txd = TXD;
		
	localparam	mark = 1'd1, spacing = 1'd0, start_bit = 1'd0, 
				end_bit = 1'd1;
	// ==============================================


	// assign c =====================================
	assign c0 = ~dav_;
	assign c1 = (colore != B) & (~endline);
	assign c2 = ENDLINE;
	assign c3 = ~CONT[3] & ~CONT[2] & ~CONT[1] & CONT[0];
	// ==============================================
	
	
	// ALWAYS =======================================
	always @(reset_ == 0) #1 RFD <= 1;
	always @(posedge clock) if (reset_==1) #3
        casex({b1, b0}) 
            2'b00: RFD <= 1;
            2'b01: RFD <= 0;
			2'b1?: RFD <= RFD;
    	endcase	

	always @(reset_ == 0) #1 TXD <= 1;
	always @(posedge clock) if (reset_==1) #3
        casex({b3, b2}) 
            2'b00: TXD <= 1;
            2'b01: TXD <= BUFFER[0];
			2'b1?: TXD <= TXD;
    	endcase	

	always @(reset_ == 0) #1 ENDLINE <= 1;
	always @(posedge clock) if (reset_==1) #3
        casex(b4) 
            1'b0: ENDLINE <= endline;
			1'b1: ENDLINE <= ENDLINE;
    	endcase	

	always @(reset_ == 0) #1 N <= 0;
	always @(posedge clock) if (reset_==1) #3
        casex({b6, b5}) 
            2'b00: N <= (B == colore) ? N+1 : N;
            2'b01: N <= 0;
			2'b1?: N <= N;
    	endcase	

	
	always @(posedge clock) if (reset_==1) #3
        casex({b6, b5}) 
            2'b00: CONT <= 4'd10;
            2'b01: CONT <= CONT - 1;
			2'b1?: CONT <= CONT;
    	endcase	


	
	always @(reset_ == 0) #1 B <= 0;
	always @(posedge clock) if (reset_==1) #3
        casex(b7) 
            1'b0: B <= colore;
			1'b1: B <= B;
    	endcase

	always @(posedge clock) if (reset_==1) #3
        casex({b9, b8}) 
            2'b00: BUFFER <= {end_bit, N, B, start_bit};
            2'b01: BUFFER <= {end_bit, 8'H00, start_bit};
            2'b10: BUFFER <= {mark, BUFFER[9:1]};
			2'b11: BUFFER <= BUFFER;
    	endcase	





endmodule



module PARTE_CONTROLLO (
	b9,b8,b7,b6,b5,b4,b3,b2,b1,b0,		// comando
	c3,c2,c1,c0,					// condizionamento
	reset_, clock
);

	input clock, reset_;
	input  c3,c2,c1,c0;
	output b9,b8,b7,b6,b5,b4,b3,b2,b1,b0;

	reg [2:0] STAR;


	// assign b =====================================
	assign {b1,b0} =  (STAR == S0) ? 2'b00 :
					  (STAR == S5) ? 2'B01 :
							    	 2'B1X;
	
	assign {b3,b2} =  (STAR == S0) ? 2'b00 :
					  (STAR == S4) ? 2'B01 :
							    	 2'B1X;

	assign b4 = (STAR == S1) ? 1'b0 : 1'b1;

	assign {b6,b5} =  (STAR == S1) ? 2'b00 :
					  (STAR == S4) ? 2'b01 :
							    	 2'b1X;

	assign b7 = (STAR == S2) ? 1'b0 : 1'b1;

	assign {b9,b8} =  (STAR == S2) ? 2'b00 :
					  (STAR == S3) ? 2'b01 :
					  (STAR == S4) ? 2'b10 :
									 2'b11;
	// ==============================================

	localparam 
		S0 = 0,
		S1 = 1,
		S2 = 2,
		S3 = 3,
		S4 = 4,
		S5 = 5,
		S6 = 6;


	always @(reset_ == 0) #1 STAR <= S0;


	always @(posedge clock) if(reset_ == 1) #3 begin
		casex (STAR)
			S0: STAR <= (c0) ? S1 : S0;
			S1: STAR <= (c1) ? S2 : S3;
			S2: STAR <= S4;
			S3: STAR <= (c2) ? S4 : S5; 
			S4: STAR <= (c3) ? S5 : S4;
			S5: STAR <= (c0) ? S5 : S0;
		endcase
	end


endmodule
