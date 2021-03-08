module ABC (
    data, clock, reset_,
    addr, out, s_, mr_
);
    input clock, reset_;
    input [3:0] data;
    output [7:0] addr;
    output [6:0] out;
    output s_, mr_;

    assign s_ = 0;
    assign mr_ = 0;    
    
    reg [6:0] OUT; assign out=OUT;
    reg [6:0] NEXT_OUT;
    reg [6:0] COUNT, NEXT_COUNT;
    
    reg [7:0] ADDR; assign addr=ADDR;
    
    reg [3:0] STAR; 
    localparam 
        S0=0,
        S1=1,
        S2=2,
        S3=3,
        S4=4,
        S5=5;
    
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
            STAR<=S0;
        end

    always @(posedge clock) if (reset_==1) #3
        casex (STAR)
            S0: 
                begin 
                    COUNT<=COUNT-1;
                    ADDR<=ADDR+1;
                    C0<=data;
                    STAR<=S1;
                end
            S1: 
                begin 
                    COUNT<=COUNT-1;
                    ADDR<=ADDR+1;
                    C1<=data;
                    STAR<=S2;
                end
            S2: 
                begin 
                    COUNT<=COUNT-1;
                    ADDR<=ADDR+1;
                    NEXT_OUT<=c;
                    C0<=data;
                    STAR<=S3;
                end
            S3: 
                begin 
                    COUNT<=COUNT-1;
                    ADDR<=ADDR+1;
                    C1<=data;
                    STAR<=S4;
                end
            S4: 
                begin 
                    COUNT<=COUNT-1;
                    NEXT_COUNT<=c;
                    STAR<=S5;
                end
            S5: 
                begin 
                    COUNT<=(COUNT==1)?NEXT_COUNT:COUNT-1;
                    OUT<=(COUNT==1)?NEXT_OUT:OUT;
                    STAR<=(COUNT==1)?S0:S5;
                end
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