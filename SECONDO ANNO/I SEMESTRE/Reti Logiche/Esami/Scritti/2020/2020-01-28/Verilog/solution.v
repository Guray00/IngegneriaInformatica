// Un possibile modo di esprimere il valore da immettere in COUNT, in funzione
// del numero fornito dal Produttore, è (numero+1)*2 che sta sempre su 4 bit

module XXX(numero,dav_,rfd, out,clock,reset_);
    input       clock,reset_;

    input       dav_;
    output      rfd;
    input[1:0]  numero;

    output      out;

    reg         RFD;   assign rfd=RFD;
    reg[3:0]    COUNT;
    reg         OUT;   assign out = OUT;
    
    reg[1:0]    STAR;  parameter S0=0,S1=1,S2=2;

    always @(reset_==0) #1 
        begin 
            RFD<=1; 
            OUT<=0; 
            STAR<=S0; 
        end  
    always @(posedge clock) if (reset_==1) #3
        casex(STAR)
            S0: 
                begin 
                    OUT<=0; 
                    RFD<=1; 
                    COUNT<= (numero+1)*2; 
                    STAR<=(dav_==0)?S1:S0; 
                end
            S1: 
                begin 
                    RFD<=0; 
                    STAR<=(dav_==0)?S1:S2; 
                end 
            S2: 
                begin 
                    OUT<=1; 
                    COUNT<=COUNT-1; 
                    STAR<=(COUNT==1)?S0:S2; 
                end 
        endcase
endmodule
