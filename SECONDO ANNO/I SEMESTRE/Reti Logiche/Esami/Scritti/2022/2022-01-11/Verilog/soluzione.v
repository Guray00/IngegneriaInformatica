module ABC(
    addr, data, positivo, riducibile,
    clock, reset_
);

    input[7:0] data;
    output[15:0] addr;
    output positivo, riducibile;
    input clock, reset_;

    reg[3:0] MSD, LSD;
    reg POSITIVO, RIDUCIBILE;
    reg[3:0] WAIT;
    reg[15:0] ADDR;
    assign positivo=POSITIVO, riducibile=RIDUCIBILE, addr=ADDR;

    reg[1:0] STAR;
    parameter S0=0, S1=1, S2=2;

    wire p, r;
    detettore check (
        .msd(MSD), .lsd(LSD),
        .pos(p), .rid(r)
    );

    always@(reset_==0) #1 
        begin 
            ADDR <= 16'h0000;
            WAIT <= 9; 
            STAR <= S0;
        end

    always@(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: begin
                MSD <= data[7:4];
                LSD <= data[3:0];
                ADDR <= ADDR+1;
                WAIT <= WAIT-1;
                STAR <= S1;
            end
            S1: begin
                WAIT <= WAIT-1;
                STAR <= (WAIT==1) ? S2 : S1;
            end
            S2: begin
                POSITIVO <= p;
                RIDUCIBILE <= r;
                WAIT <= 9;
                STAR <= S0;
            end
        endcase
endmodule

module detettore (
    msd, lsd,
    pos, rid
);
    input [3:0] msd, lsd;
    output pos, rid;

    wire [3:0] d1; // msd - 5
    wire pos; // 1 se msd < 5
    diff #(.N(4)) diff1(
        .x(msd), .y(4'd5), .b_in(1'b0),
        .d(d1), .b_out(pos)
    );

    wire [3:0] d0; // lsd - 5
    wire pos0; // 1 se lsd < 5
    diff #(.N(4)) diff0(
        .x(lsd), .y(4'd5), .b_in(1'b0),
        .d(d0), .b_out(pos0)
    );

    assign rid = ((msd==4'b0000) && (pos0==1)) ? 1:
                 ((msd==4'b1001) && (pos0==0)) ? 1:0; 

endmodule
