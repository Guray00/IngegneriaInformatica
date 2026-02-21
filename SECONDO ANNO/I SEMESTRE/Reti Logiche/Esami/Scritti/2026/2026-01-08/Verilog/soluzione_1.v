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
    reg MR_;
    assign mr_ = MR_;
    assign mw_ = 1'b1; // non si scrive mai

    reg EOC;
    assign eoc = EOC;
    reg [15:0] MAX;
    assign max = MAX;

    reg [15:0] CURRENT_ADDR;
    reg [15:0] CURRENT_MAX;
    reg [15:0] LAST_VALUE;

    wire [15:0] next_max;
    MAX_RC m(
        .x(CURRENT_MAX), .y(LAST_VALUE),
        .max(next_max) 
    );

    reg[3:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S5 = 5,
        S6 = 6,
        S7 = 7,
        S8 = 8;

    always@(reset_==0) #1 
        begin 
            ADDR <= 16'h0000;
            MR_ <= 1;
            EOC <= 1;
            STAR <= S0;
        end

    always@(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: begin
                CURRENT_ADDR <= p;
                STAR <= (soc == 1) ? S1 : S0;
            end
            // ACK handshake, poi entro nel ciclo di letture
            S1: begin
                CURRENT_MAX <= 0;
                EOC <= 0;
                STAR <= (soc == 0) ? S2 : S1;
            end
            // lettura valore del nodo corrente
            S2: begin
                ADDR <= CURRENT_ADDR;
                MR_ <= 0;
                STAR <= S3;
            end
            S3: begin
                ADDR <= ADDR + 1;
                LAST_VALUE <= {data, LAST_VALUE[7:0]};
                STAR <= S4;
            end
            S4: begin
                ADDR <= ADDR + 1;
                LAST_VALUE <= {LAST_VALUE[15:8], data};
                STAR <= S5;
            end
            // aggiornamento max, lettura indirizzo successivo
            S5: begin
                ADDR <= ADDR + 1;
                CURRENT_MAX <= next_max;
                CURRENT_ADDR <= {data, CURRENT_ADDR[7:0]};
                STAR <= S6;
            end
            S6: begin
                MR_ <= 1;
                CURRENT_ADDR <= {CURRENT_ADDR[15:8], data};
                STAR <= S7;
            end
            // check indirizzo: se ho terminato, chiudo handshake, altrimenti leggo nodo successivo
            S7: begin
                STAR <= (CURRENT_ADDR == 16'h0000) ? S8 : S1;
            end
            S8: begin
                MAX <= CURRENT_MAX;
                EOC <= 1;
                STAR <= S0;
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
