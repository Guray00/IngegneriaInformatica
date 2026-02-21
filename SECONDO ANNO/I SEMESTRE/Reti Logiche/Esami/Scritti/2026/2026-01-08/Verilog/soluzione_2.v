module ABC(
    addr, data, mr_, mw_,
    soc, eoc, p, max,
    clock, reset_
);

    input[7:0] data;    // non si scrive mai, non serve una forchetta
    output[15:0] addr;
    output mr_, mw_;
    input soc;
    output eoc;
    input [15:0] p;
    output [15:0] max;
    input clock, reset_;

    reg[15:0] ADDR;
    assign addr = ADDR;
    assign mr_ = 1'b0; // la RAM viene tenuta sempre in lettura
    assign mw_ = 1'b1; // non si scrive mai

    reg EOC;
    assign eoc = EOC;
    reg [15:0] MAX;
    assign max = MAX;

    reg [31:0] NODO;  // contiene un nodo intero della lista {numero, indirizzo}

    // scomposizione di NODO per leggibilità
    wire [15:0] nodo_valore;
    wire [15:0] nodo_addr;
    assign nodo_valore = NODO[31:16];
    assign nodo_addr   = NODO[15:0];

	reg [1:0] COUNT;

    wire [15:0] next_max;
    MAX_RC m(
        .x(MAX), .y(nodo_valore),
        .max(next_max) 
    );

    reg[1:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3;

    always@(reset_==0) #1 
        begin 
            ADDR <= 16'h0000;
            EOC <= 1;
            STAR <= S0;
			COUNT <= 3;
        end

    always@(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: begin
			    EOC <= 1;
                ADDR <= p;
                STAR <= (soc == 1) ? S1 : S0;
            end
            // ACK handshake e reset MAX, poi entro nel ciclo di letture
            S1: begin
                EOC <= 0;
				MAX <= 0;
			    STAR <= (soc == 0) ? S2 : S1;
            end
            // lettura valore del nodo corrente
            S2: begin
                ADDR <= ADDR + 1;
                NODO <= {NODO[23:0],data};
				COUNT <= COUNT-1;
                STAR <= (COUNT==0)?S3:S2;
            end
            // aggiorno il massimo e controllo l'indirizzo: se ho terminato, chiudo handshake, altrimenti leggo nodo successivo
            S3: begin
				MAX <= next_max;
				ADDR <= nodo_addr;
                STAR <= (nodo_addr == 16'h0000) ? S0 : S2;
            end
        endcase
endmodule

// Solo descritta
module MAX_RC (
    x, y,
    max
);
    input [15:0] x, y;
    output [15:0] max;

    assign #1 max = (x > y) ? x : y;
endmodule
