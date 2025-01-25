module ABC(
    clock, reset_, data, 
    addr, out, s_, mr_
);

    input clock, reset_;
    input [3:0] data;
    output [7:0] addr;
    output [6:0] out;
    output s_, mr_;

    ParteOperativa PO(
        clock, reset_, data, 
        addr, out, s_, mr_,
        c0,
        b6, b5, b4, b3, b2, b1, b0
    );

    ParteControllo PC(
        clock, reset_,
        c0,
        b6, b5, b4, b3, b2, b1, b0
    );

endmodule

module ParteOperativa(
    clock, reset_, data, 
    addr, out, s_, mr_,
    c0,
    b6, b5, b4, b3, b2, b1, b0
);

    input clock, reset_;
    input [3:0] data;
    output [7:0] addr;
    output [6:0] out;
    output s_, mr_;

    output c0;
    input b6, b5, b4, b3, b2, b1, b0;

    assign c0 = (COUNT==1);

    assign s_ = 0;
    assign mr_ = 0;    
    
    reg [6:0] OUT; assign out=OUT;
    reg [6:0] NEXT_OUT;
    reg [6:0] COUNT, NEXT_COUNT;
    
    reg [7:0] ADDR; assign addr=ADDR;
    
    // first we load the two digits in C1 and C0
    // then we can read in c the number as binary notation
    reg [3:0] C1, C0;
    wire [6:0] c;

    CONV conv(
        .c1(C1), .c0(C0),
        .converted(c)
    );
    
    always @(reset_==0) #1 
        begin 
            COUNT<=99;
            OUT<=0;
            ADDR<=0;
        end

    /*
        Registri operativi COUNT, NEXT_COUNT, ADDR, C0, C1, OUT, NEXT_OUT

        u-operazioni su COUNT
        S1,S2,S3,S4: COUNT<=COUNT-1;
        S5: COUNT<=(COUNT==1)?NEXT_COUNT:COUNT-1;

        1 variabile di comando b0


        u-operazioni su ADDR
        S1,S2,S3: ADDR<=ADDR+1;
        S4,S5: ADDR<=ADDR;

        1 variabile di comando b1


        u-operazioni su C0
        S0,S2: C0<=data;
        S1,S3,S4,S5: C0<=C0;

        1 variabile di comando b2


        u-operazioni su C1
        S1,S3: C1<=data;
        S0,S2,S4,S5: C1<=C1;

        1 variabile di comando b3


        u-operazioni su NEXT_COUNT
        S1,S2,S3,S5: NEXT_COUNT<=NEXT_COUNT;
        S4: NEXT_COUNT<=c;

        1 variabile di comando b4


        u-operazioni su OUT
        S1,S2,S3,S4: OUT<=OUT;
        S5: OUT<=(COUNT==1)?NEXT_OUT:OUT;

        1 variabile di comando b5


        u-operazioni su NEXT_OUT
        S1,S3,S4,S5: NEXT_OUT<=NEXT_OUT;
        S2: NEXT_OUT<=c;

        1 variabile di comando b6
    */

    always @(posedge clock) if (reset_==1) #3
        casex (b0)
            1'b0: COUNT<=COUNT-1;
            1'b1: COUNT<=(COUNT==1)?NEXT_COUNT:COUNT-1;
        endcase
    
    always @(posedge clock) if (reset_==1) #3
        casex (b1)
            1'b0: ADDR<=ADDR+1;
            1'b1: ADDR<=ADDR;
        endcase
    
    always @(posedge clock) if (reset_==1) #3
        casex (b2)
            1'b0: C0<=data;
            1'b1: C0<=C0;
        endcase    
    
    always @(posedge clock) if (reset_==1) #3
        casex (b3)
            1'b0: C1<=data;
            1'b1: C1<=C1;
        endcase    
    
    always @(posedge clock) if (reset_==1) #3
        casex (b4)
            1'b0: NEXT_COUNT<=NEXT_COUNT;
            1'b1: NEXT_COUNT<=c;
        endcase    

    always @(posedge clock) if (reset_==1) #3
        casex (b5)
            1'b0: OUT<=OUT;
            1'b1: OUT<=(COUNT==1)?NEXT_OUT:OUT;
        endcase 

    always @(posedge clock) if (reset_==1) #3
        casex (b6)
            1'b0: NEXT_OUT<=NEXT_OUT;
            1'b1: NEXT_OUT<=c;
        endcase 

endmodule

module ParteControllo(
    clock, reset_,
    c0,
    b6, b5, b4, b3, b2, b1, b0
);
    input clock, reset_;

    input c0;
    output b6, b5, b4, b3, b2, b1, b0;
    
    reg [2:0] STAR; 
    localparam 
        S0=0,
        S1=1,
        S2=2,
        S3=3,
        S4=4,
        S5=5;
    
    assign {b6, b5, b4, b3, b2, b1, b0}=
        (STAR==S0)? 7'b0001000:
        (STAR==S1)? 7'b0000100:
        (STAR==S2)? 7'b1001000:
        (STAR==S3)? 7'b0000100:
        (STAR==S4)? 7'b0011110:
        (STAR==S5)? 7'b0101111:
        /*default*/ 7'bXXXXXXX;

    always @(reset_==0) #1 STAR<=S0;

    always @(posedge clock) if (reset_==1) #3
        casex (STAR)
            S0: STAR<=S1;

            S1: STAR<=S2;

            S2: STAR<=S3;

            S3: STAR<=S4;

            S4: STAR<=S5;

            S5: STAR<=(c0==1)?S0:S5;
        endcase
        
endmodule

module CONV(
    c1, c0,
    converted
);
    input [3:0] c1, c0;
    output [6:0] converted;

    wire [7:0] mul_result;
    mul_add_nat #( .N(4), .M(4) ) mul (
        .x(c1), .y(4'B1010), .c(c0),
        .m(mul_result)
    );
    assign converted = mul_result[6:0];
endmodule

/*
    ROM
    S0=000, S1=001, S2=010, S3=011, S4=100, S5=101
    c0=0

    u-addr   b6, b5, b4, b3, b2, b1, b0   ceff   u-addrT   u-addrF
    000      b0001000                     X      001       001 
    001      b0000100                     X      010       010 
    010      b1001000                     X      011       011 
    011      b0000100                     X      100       100 
    100      b0011110                     X      101       101 
    101      b0101111                     0      000       101 
*/