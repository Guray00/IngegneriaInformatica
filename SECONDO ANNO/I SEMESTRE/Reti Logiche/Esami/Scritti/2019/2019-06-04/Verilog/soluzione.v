module XXX(d15_d0,a3_a0,x,z7_z0,clock,reset_);
    input         clock,reset_;
    output [3:0]  a3_a0;
    input  [15:0] d15_d0;
    input         x;
    output [7:0]  z7_z0;

    reg [7:0]   OUT;
    assign    z7_z0=OUT;
    
    reg [3:0]     A3_A0;
    assign    a3_a0=A3_A0;

    reg [3:0]     COUNT;
    reg           STAR;
    localparam ST0=0, ST1=1;

    localparam Num_Periodi=10;

    always @(reset_==0) 
    begin 
        A3_A0 <= 0;
        OUT <= 0;
        COUNT <= Num_Periodi;
        STAR <= ST0;
    end
    
    always @(posedge clock) if (reset_==1) #3 
    casex(STAR)
        ST0: begin 
            COUNT <= COUNT-1;
            STAR <= (COUNT==2) ? ST1 : ST0;
        end
            
        ST1: begin 
            OUT <= d15_d0[7:0];
            A3_A0 <= (x==0) ? d15_d0[15:12] : d15_d0[11:8];
            COUNT <= Num_Periodi;
            STAR <= ST0;
        end
    endcase

endmodule