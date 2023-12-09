module ABC (
    rfd_x, dav_x, x, rfd_y, dav_y, y, 
    out, 
    clock, reset_
);
    input clock, reset_;
    input dav_x, dav_y;
    output rfd_x, rfd_y;
    input [7:0] x, y;
    output out;
    
    reg RFD;
    reg OUT;
    reg [2:0] STAR;
    reg [7:0] COUNT;
    
    localparam S0=0, S1=1, S2=2, S3=3; 

    assign rfd_x = RFD;
    assign rfd_y = RFD;
    assign out = OUT;

    wire [7:0] max;
    MAX m (
        .x(x), .y(y), .max(max)
    );

    always @(reset_==0) #1 
        begin
            RFD = 1; 
            OUT = 0;
            STAR = S0; 
        end
    
    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: 
                begin
                    RFD <= 1;
                    OUT <= 0;
                    COUNT <= max;
                    STAR <= ({dav_x, dav_y} == 2'B00) ? S1 : S0;
                end
            S1: 
                begin
                    RFD <= 0;
                    STAR <= ({dav_x, dav_y} == 2'B11) ? S2 : S1; 
                end
            S2: 
                begin
                    OUT <= 1;
                    COUNT <= COUNT - 1;
                    STAR <= (COUNT == 1) ? S0 : S2;
                end
        endcase

endmodule

module MAX(
    x, y,
    max
);
    input [7:0] x, y;
    output [7:0] max;

    wire [7:0] y_neg = y[7] ? y : (~y + 1);
    wire c_out;
    add #( .N(8) ) s (
        .x(x), .y(y_neg), .c_in(1'b1),
        .c_out(c_out)
    );

    wire b_out = ~c_out;
    
    assign max = b_out ? y : x;
endmodule