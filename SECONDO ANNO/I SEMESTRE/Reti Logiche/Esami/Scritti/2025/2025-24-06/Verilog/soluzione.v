module ABC (
    soc_x, eoc_x, x, soc_y, eoc_y, y, 
    dav_, rfd, z, 
    clock, reset_
);
    input clock, reset_;
    input eoc_x, eoc_y, rfd;
    output soc_x, soc_y, dav_;
    input [7:0] x, y;
    output [7:0] z;
    
    reg SOC, DAV_;
    reg [7:0] Z;
    reg [2:0] STAR;
    
    localparam S0=0, S1=1, S2=2, S3=3; 

    assign soc_x = SOC;
    assign soc_y = SOC;
    assign dav_ = DAV_;
    assign z = Z;

    wire [3:0] result;
    CONTA_BIT_0 m (
        .x(x), .y(y), .z(result)
    );

    always @(reset_==0) #1 
        begin
            SOC = 0; 
            DAV_ = 1; 
            STAR = S0; 
        end
    
    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: 
                begin
                    SOC <= 1;
                    STAR <= ({eoc_x, eoc_y} == 2'B00) ? S1 : S0;
                end
            S1: 
                begin
                    SOC <= 0;
                    Z <= {4'b0, result};
                    STAR <= ({eoc_x, eoc_y} == 2'B11) ? S2 : S1; 
                end
            S2: 
                begin
                    DAV_ <= 0;
                    STAR <= (rfd == 1) ? S2 : S3; 
                end
            S3: 
                begin
                    DAV_ <= 1; 
                    STAR <= (rfd == 0) ? S3 : S0; 
                end
        endcase

endmodule

module CONTA_BIT_0(
    x, y,
    z
);
    input [7:0] x, y;
    output [3:0] z;

    // Ogni wire è 1 se entrambi i bit corrispondenti sono 0.
    // Calcolati utilizzando NOR bit a bit.
    wire b7, b6, b5, b4, b3, b2, b1, b0;
    assign {b7, b6, b5, b4, b3, b2, b1, b0} = ~(x | y);

    // Per calcolarne la somma, utilizziamo 8 inc_en in cascata.
    // Bastano 3 bit per tutti gli inc_en, solo l'ultimo può generare carry.
    wire [2:0] sum0;
    inc_en #(.N(3)) inc0 (
        .x(3'b0), .en(b0),
        .y(sum0)
    );

    wire [2:0] sum1;
    inc_en #(.N(3)) inc1 (
        .x(sum0), .en(b1),
        .y(sum1)
    );

    wire [2:0] sum2;
    inc_en #(.N(3)) inc2 (
        .x(sum1), .en(b2),
        .y(sum2)
    );

    wire [2:0] sum3;
    inc_en #(.N(3)) inc3 (
        .x(sum2), .en(b3),
        .y(sum3)
    );

    wire [2:0] sum4;
    inc_en #(.N(3)) inc4 (
        .x(sum3), .en(b4),
        .y(sum4)
    );

    wire [2:0] sum5;
    inc_en #(.N(3)) inc5 (
        .x(sum4), .en(b5),
        .y(sum5)
    );

    wire [2:0] sum6;
    inc_en #(.N(3)) inc6 (
        .x(sum5), .en(b6),
        .y(sum6)
    );

    wire [2:0] sum7;
    wire c_out;
    inc_en #(.N(3)) inc7 (
        .x(sum6), .en(b7),
        .y(sum7), .c_out(c_out)
    );
    
    assign z = {c_out, sum7};

endmodule
