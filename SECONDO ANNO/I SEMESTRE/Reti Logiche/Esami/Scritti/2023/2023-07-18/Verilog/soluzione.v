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

    reg [3:0] STAR;
    localparam 
        SA_0 = 0,
        SA_1 = 1,
        SA_2 = 2,
        SA_3 = 3,
        SA_4 = 4,
        SA_5 = 5,
        SB_0 = 6,
        SB_1 = 7,
        SB_2 = 8,
        SB_3 = 9,
        SB_4 = 10,
        SB_5 = 11;

    reg [7:0] A;
    wire [15:0] mul;
    MUL5 m5 (
        .a(A), .m(mul)
    );

    always @(reset_ == 0) #1 begin
        IOR_ <= 1;
        IOW_ <= 1;
        DIR <= 0;
        A <= 0;
        STAR <= SA_0;
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (STAR)
            // Lettura da RSR di A
            SA_0: begin
                ADDR <= 16'h0100;
                DIR <= 0;
                STAR <= SA_1;
            end

            SA_1: begin
                IOR_ <= 0;
                STAR <= SA_2;
            end

            SA_2: begin
                IOR_ <= 1;
                STAR <= data[0] ? SA_3 : SA_0;  // controllo FI
            end

            // Lettura da RBR di A
            SA_3: begin
                ADDR <= 16'h0101;
                STAR <= SA_4;
            end
            
            SA_4: begin
                IOR_ <= 0;
                STAR <= SA_5;
            end

            SA_5: begin
                A <= data;
                IOR_ <= 1;
                STAR <= SB_0;
            end

            // Scrittura in TBR di B
            SB_0: begin
                DATA <= mul[15:8];
                ADDR <= 16'h0121;
                DIR <= 1;
                STAR <= SB_1;
            end

            SB_1: begin
                IOW_ <= 0;
                STAR <= SB_2;
            end

            SB_2: begin
                IOW_ <= 1;
                STAR <= SB_3;
            end

            SB_3: begin
                DATA <= mul[7:0];
                STAR <= SB_4;
            end

            SB_4: begin
                IOW_ <= 0;
                STAR <= SB_5;
            end

            SB_5: begin
                IOW_ <= 1;
                STAR <= SA_0;
            end

        endcase
    end

endmodule

module MUL5(a, m);
    input [7:0] a;
    output [15:0] m;

    wire [9:0] a1_ext;
    assign a1_ext = {2'b00, a};
    wire [9:0] a4_ext;
    assign a4_ext = {a, 2'b00};
    
    wire [9:0] sum;
    wire c_out;
    add #( .N(10) ) s (
        .x(a1_ext), .y(a4_ext), .c_in(1'b0),
        .s(sum), .c_out(c_out)
    );

    assign m = { 5'h00, c_out, sum };
endmodule
