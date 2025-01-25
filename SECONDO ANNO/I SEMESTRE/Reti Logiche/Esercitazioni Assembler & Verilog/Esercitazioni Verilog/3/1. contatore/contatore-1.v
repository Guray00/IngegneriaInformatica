module contatore(
    out,
    clock, reset_
);

    output [3:0] out;
    input clock, reset_;

    reg [3:0] OUT;
    assign out = OUT;

    always @(reset_ == 0) begin
        OUT = 0;
    end

    always @(posedge clock) if (reset_ == 1) #3 begin
        OUT <= OUT + 1;
    end

endmodule