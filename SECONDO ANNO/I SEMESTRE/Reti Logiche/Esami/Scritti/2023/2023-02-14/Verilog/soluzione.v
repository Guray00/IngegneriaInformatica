module ABC(
    soc, eoc, x, ok, 
    ior_, iow_, addr, data, 
    clock, reset_
);
    input clock,reset_;
    input eoc,ok;
    output soc, ior_, iow_;
    output [15:0] addr;
    output[7:0] x;
    inout [7:0] data;

    reg SOC, IOR_, IOW_;
    reg [15:0] ADDR; 
    assign soc = SOC, ior_ = IOR_, iow_ = IOW_, addr = ADDR;

    reg[7:0] X; assign x = X; 
    reg DIR; assign data = (DIR==1) ? X : 'HZZ; //FORCHETTA

    reg [2:0] STAR; 
    localparam 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S5 = 5,
        S6 = 6,
        S7 = 7;

    always @(reset_==0) #1 begin 
        X = 0; 
        SOC = 0; 
        IOR_ = 1; 
        IOW_ = 1; 
        ADDR = 16'h0ABC; 
        DIR = 0;
        STAR = S0;
    end

    always @(posedge clock) if (reset_==1) #3
    casex(STAR)
        // handshake con A, finché X non è corretto
        S0: begin 
            SOC <= 1;
            STAR <= (eoc == 1) ? S0 : S1;
        end
        S1: begin 
            SOC <= 0;
            STAR <= (eoc == 0) ? S1 : S2;
        end
        S2: begin 
            X <= (ok == 1) ? X : (X+1);
            STAR <= (ok == 0) ? S0 : S3;
        end

        // Verifica che l’interfaccia sia pronta 
        S3: begin 
            IOR_ <= 0;
            STAR <= S4;
        end
        S4: begin 
            IOR_ <= 1;
            STAR <= (data[5] == 0) ? S3 : S5;
        end

        // Emissione di X 
        S5: begin 
            ADDR <= 16'h0ABD;
            DIR <= 1;
            STAR <= S6;
        end
        S6: begin 
            IOW_ <= 0;
            STAR <= S7;
        end
        S7: begin 
            IOW_ <= 1;
            STAR <= S7;
        end
    endcase
endmodule
