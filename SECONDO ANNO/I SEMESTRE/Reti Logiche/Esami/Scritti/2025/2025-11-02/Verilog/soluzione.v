module ABC(
    addr, data, ior_, iow_,
    out,
    clock, reset_ 
);
    // questa rete utilizza data solo in ingresso, non è necessaria quindi una forchetta
    input [7:0] data;
    output [15:0] addr;
    output ior_, iow_;
    output [11:0] out;
    input clock, reset_;
    
    // questa rete non fa scritture su interfacce
    // quindi l'uscita iow_ può essere collegata direttamente a Vcc senza passare da registri
    assign iow_ = 1'b1;

    reg IOR_;
    assign ior_ = IOR_;

    reg [15:0] ADDR;
    assign addr = ADDR;
    
    reg [11:0] OUT;
    assign out = OUT;

    reg [7:0] APP1, APP0;
    
    reg [2:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        Sin_0 = 5,
        Sin_1 = 6,
        Sin_2 = 7;

    reg [2:0] MJR;

    reg [7:0] A, B;
    wire [9:0] sum;
    assign #1 sum = A + B;

    always @(reset_ == 0) #1 begin
        IOR_ <= 1;
        A <= 0;
        B <= 0;
        OUT <= 0;
        STAR <= S0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (STAR)
            // Lettura da RSR di A, aggiornamento OUT a risultato ciclo precedente
            S0: begin
                OUT <= sum;
                APP1 <= 8'h01;
                APP0 <= 8'h00;
                MJR <= S1;
                STAR <= Sin_0;
            end

            // Check di FI
            S1: begin
                STAR <= APP0[0] ? S2 : S0;
            end
            
            // Lettura da RBR di A
            S2: begin
                APP1 <= 8'h01;
                APP0 <= 8'h01;
                MJR <= S3;
                STAR <= Sin_0;
            end

            // Lettura da RBR di B, salvataggio dato A
            S3: begin
                A <= APP0;
                APP1 <= 8'h01;
                APP0 <= 8'h20;
                MJR <= S4;
                STAR <= Sin_0;
            end

            // Salvataggio dato B, nuovo ciclo
            S4: begin
                B <= APP0;
                STAR <= S0;
            end

            // Lettura da interfaccia di IO
            // L'indirizzo è passato come argomento tramite { APP1, APP0 }
            // Il dato letto è lasciato in APP0
            Sin_0: begin
                ADDR <= {APP1, APP0};
                STAR <= Sin_1;
            end

            Sin_1: begin
                IOR_ <= 0;
                STAR <= Sin_2;
            end

            Sin_2: begin
                APP0 <= data;
                IOR_ <= 1;
                STAR <= MJR;
            end
        endcase
    end

endmodule