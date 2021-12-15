module ABC(
    addr, data, ior_, iow_,
    clock, reset_ 
);
    inout [7:0] data;
    output [15:0] addr;
    output ior_, iow_;
    input clock, reset_;

    reg IOW_, IOR_;
    assign ior_ = IOR_;
    assign iow_ = IOW_;

    reg [15:0] ADDR;
    assign addr = ADDR;

    reg DIR;
    reg [7:0] DATA;
    assign data = (DIR == 1) ? DATA : 8'bZZ;

    reg [3:0] COUNT;

    reg [3:0] STAR;
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S5 = 5,
        S6 = 6,
        S7 = 7,
        S8 = 8,
        S9 = 9,
        S10 = 10,
        S11 = 11,
        S12 = 12,
        S13 = 13,
        S14 = 14;

    reg [7:0] A, B;
    wire [15:0] mul;
    assign #1 mul = A * B;

    always @(reset_ == 0) #1 begin
        IOR_ <= 1;
        IOW_ <= 1;
        DIR <= 0;
        A <= 0;
        STAR <= S0;
        COUNT <= 15;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (STAR)
            // Lettura da RBR di B
            S0: begin
                ADDR <= 16'h0120;
                COUNT <= COUNT - 1;
                STAR <= S1;
            end

            S1: begin
                IOR_ <= 0;
                COUNT <= COUNT - 1;
                STAR <= S2;
            end

            S2: begin
                B <= data;
                IOR_ <= 1;
                COUNT <= COUNT - 1;
                STAR <= S3;
            end

            // Scrittura in TBR di C
            S3: begin
                DATA <= mul[15:8];
                ADDR <= 16'h0140;
                DIR <= 1;
                COUNT <= COUNT - 1;
                STAR <= S4;
            end

            S4: begin
                IOW_ <= 0;
                COUNT <= COUNT - 1;
                STAR <= S5;
            end

            S5: begin
                IOW_ <= 1;
                COUNT <= COUNT - 1;
                STAR <= S6;
            end

            S6: begin
                DATA <= mul[7:0];
                COUNT <= COUNT - 1;
                STAR <= S7;
            end

            S7: begin
                IOW_ <= 0;
                COUNT <= COUNT - 1;
                STAR <= S8;
            end

            S8: begin
                IOW_ <= 1;
                COUNT <= COUNT - 1;
                STAR <= S9;
            end

            // Lettura da RSR di A
            S9: begin
                ADDR <= 16'h0100;
                DIR <= 0;
                COUNT <= COUNT - 1;
                STAR <= S10;
            end

            S10: begin
                IOR_ <= 0;
                COUNT <= COUNT - 1;
                STAR <= S11;
            end

            S11: begin
                IOR_ <= 1;
                ADDR <= 16'h0101;   // lo impostiamo anche se non viene usato
                COUNT <= COUNT - 1;
                STAR <= data[0] ? S12 : S14;
            end

            // Lettura da RBR di A
            S12: begin
                IOR_ <= 0;
                COUNT <= COUNT - 1;
                STAR <= S13;
            end

            S13: begin
                A <= data;
                COUNT <= COUNT - 1;
                STAR <= S14;
            end

            // Attesa fine ciclo
            S14: begin
                IOR_ <= 1; // necessario se segue S13
                COUNT <= (COUNT == 0) ? 15 : COUNT - 1;
                STAR <= (COUNT == 0) ? S0 : S14;
            end

        endcase
    end

endmodule