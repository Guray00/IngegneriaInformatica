module ABC(
    addr, data, ior_, iow_,
    clock, reset_ 
);
    inout [7:0] data;
    output [15:0] addr;
    output ior_, iow_;
    input clock, reset_;

    ParteOperativa PO(
        addr, data, ior_, iow_,
        clock, reset_,
        c1, c0,
        b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0
    );

    ParteControllo PC(
        clock, reset_,
        c1, c0,
        b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0
    );

endmodule

module ParteOperativa(
    addr, data, ior_, iow_,
    clock, reset_,
    c1, c0,
    b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0
);
    inout [7:0] data;
    output [15:0] addr;
    output ior_, iow_;
    input clock, reset_;

    output c1, c0;
    input b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0;

    reg IOW_, IOR_;
    assign ior_ = IOR_;
    assign iow_ = IOW_;

    reg [15:0] ADDR;
    assign addr = ADDR;

    reg DIR;
    reg [7:0] DATA;
    assign data = (DIR == 1) ? DATA : 8'bZZ;

    reg [3:0] COUNT;

    reg [7:0] A, B;
    wire [15:0] mul;
    assign #1 mul = A * B;

    assign c0 = data[0];
    assign c1 = (COUNT == 4'b0000);

    always @(reset_ == 0) #1 begin
        IOR_ <= 1;
        IOW_ <= 1;
        DIR <= 0;
        A <= 0;
        COUNT <= 15;
    end

    /*
        6 registri operativi

        u-operazioni su ADDR
        S1,S2,S4,S5,S6,S7,S8,S10: ADDR<=ADDR
        S0: ADDR <= 16'h0120;
        S3: ADDR <= 16'h0140;
        S9: ADDR <= 16'h0100;
        S11: ADDR <= 16'h0101;

        3 variabili di comando (b2,b1,b0)


        u-operazioni su COUNT
        S0 fino a S13: COUNT <= COUNT - 1;
        S14: COUNT <= (COUNT == 0) ? 15 : COUNT - 1;

        1 variabile di comando (b3)

        u-operazioni su IOR_
        tutti gli altri stati: IOR_<=IOR_
        S1,S10,S12: IOR_<=0
        S2,S11,S14: IOR_<=1

        2 variabili di comando (b5,b4)


        u-operazioni su IOW_
        tutti gli altri stati: IOW_<=IOW_
        S4,S7: IOW_<=0
        S5,S8: IOW_<=1

        2 variabili di comando (b7,b6)


        u-operazioni su B
        tutti gli altri stati: B<=B
        S2: B <= data;

        1 variabile di comando (b8)

        b0
        u-operazioni su DATA
        tutti gli altri stati: DATA<=DATA
        S3: DATA <= mul[15:8];
        S6: DATA <= mul[7:0];

        2 variabili di comando (b10,b9)


        u-operazioni su A
        tutti gli altri stati: A<=A
        S13: A <= data;

        1 variabile di comando (b11)

        u-operazioni su DIR
        tutti gli altri stati: DIR<=DIR
        S3: DIR<=1
        S9: DIR<=0

        2 variabili di comando (b13,b12)
    */

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b2,b1,b0})
            3'b000: ADDR <= ADDR;
            3'b001: ADDR <= 16'h0120;
            3'b010: ADDR <= 16'h0140;
            3'b011: ADDR <= 16'h0100;
            3'b1XX: ADDR <= 16'h0101;
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (b3)
            1'b0: COUNT <= COUNT - 1;
            1'b1: COUNT <= (COUNT == 0) ? 15 : COUNT - 1;
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b5,b4})
            2'b00: IOR_ <= IOR_;
            2'b01: IOR_ <= 0;
            2'b1X: IOR_ <= 1;
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b7,b6})
            2'b00: IOW_ <= IOW_;
            2'b01: IOW_ <= 0;
            2'b1X: IOW_ <= 1;
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (b8)
            1'b0: B <= B;
            1'b1: B <= data;
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b10,b9})
            2'b00: DATA <= DATA;
            2'b01: DATA <= mul[15:8];
            2'b1X: DATA <= mul[7:0];
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (b11)
            1'b0: A <= A;
            1'b1: A <= data;
        endcase
    end

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex ({b13,b12})
            2'b00: DIR <= DIR;
            2'b01: DIR <= 1;
            2'b1X: DIR <= 0;
        endcase
    end

endmodule

module ParteControllo(
    clock, reset_,
    c1, c0,
    b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0
);
    input clock, reset_;

    input c1, c0;
    output b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0;

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

    assign {b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0}=
        (STAR==S0)?  14'b00000000000001:
        (STAR==S1)?  14'b00000000010000:
        (STAR==S2)?  14'b000001001X0000:
        (STAR==S3)?  14'b01001000000010:
        (STAR==S4)?  14'b00000001000000:
        (STAR==S5)?  14'b0000001X000000:
        (STAR==S6)?  14'b0001X000000000:
        (STAR==S7)?  14'b00000001000000:
        (STAR==S8)?  14'b0000001X000000:
        (STAR==S9)?  14'b1X000000000011:
        (STAR==S10)? 14'b00000000010000:
        (STAR==S11)? 14'b000000001X01XX:
        (STAR==S12)? 14'b00000000010000:
        (STAR==S13)? 14'b00100000000000:
        (STAR==S14)? 14'b000000001X1000:
        /*default*/  14'b00XXXXXXXXXXXX;

    always @(reset_ == 0) #1 STAR <= S0;

    always @(posedge clock) if(reset_ == 1) #3 begin
        casex (STAR)
            S0: STAR <= S1;

            S1: STAR <= S2;

            S2: STAR <= S3;

            S3: STAR <= S4;

            S4: STAR <= S5;

            S5: STAR <= S6;

            S6: STAR <= S7;

            S7: STAR <= S8;

            S8: STAR <= S9;

            S9: STAR <= S10;

            S10: STAR <= S11;

            S11: STAR <= (c0==1) ? S12 : S14;

            S12: STAR <= S13;

            S13: STAR <= S14;

            S14: STAR <= (c1==1) ? S0 : S14;
        endcase
    end

endmodule