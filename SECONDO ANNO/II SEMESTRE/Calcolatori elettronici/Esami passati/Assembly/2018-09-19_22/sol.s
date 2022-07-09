.global _ZN2clC1EcR3st2

_ZN2clC1EcR3st2:
.text
# st1.c1->0   | st1.c2->+4 <-this
#                 v[0]->+8 
#                 v[1]->+16 
#                 v[2]->+24
#                 v[3]->+32




# indirizzo di s2 ->-24
#   i->-12 |    c ->-16 
#            this ->-8

.set this, -8
.set c, -16
.set i, -12
.set s2, -24

.set c1, 0
.set c2, +4
.set v, +8


        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %SIL, c(%RBP) # c'è il valore, non l'indirizzo
        MOV %RDX, s2(%RBP)

        MOVL $0, i(%RBP)

for:
        CMPL $4, i(%RBP)
        JGE fine_for

        # c1.vc[i] = c; 
        MOVSLQ i(%RBP), %RCX            # recupero i
        MOV c(%RBP), %SIL               # recupero c
        MOV this(%RBP), %RDI            # recupero l'indirizzo dlla classe
        MOV %SIL, (%RDI, %RCX)          # c1 sta all'offset 0
        # c2.vc[i] = c
        MOV %SIL, 4(%RDI, %RCX)         # in SIL ho ancora il valore corretto
                                        # c2 sta all'offset 4 ed è char
        # c++ incremento postfisso
        INCB c(%RBP)

        # v[i] = s2.vd[i] + c2.vc[i];
	
        MOVSBQ 4(%RDI, %RCX), %RAX      # recupero c2.vc
        MOV s2(%RBP), %RDI              # recupero s2.vd: ho già l'indirizzo per cui basta una MOV di esso
        MOVSLQ (%RDI, %RCX, 4), %RBX    # estendo a Q essendo v un long

        ADD %RAX, %RBX                  # s2.vd[i] + c2.vc[i]

        MOV this(%RBP), %RDI

        MOV %RBX, 8(%RDI, %RCX, 8)      # assegnamento
        
        
        
                                        
        INCL i(%RBP)
        JMP for

fine_for:
        LEAVE
        RET



.global _ZN2cl5elab1E3st13st2

_ZN2cl5elab1E3st13st2:
.text
# st1.c1->0 <-this  | st1.c2->+4 
#                    v[0]->+8 
#                    v[1]->+16 
#                    v[2]->+24
#                    v[3]->+32



# st1.c2      |      st1.c1->-80
#                      v[0]->-72
#                      v[1]->-64 
#                      v[2]->-56
#                      v[3]->-48
#                         i->-40      
#   s2.vd[1]->-28  s2.vd[0]->-32
#   s2.vd[3]->-20  s2.vd[2]->-24
#                        s1->-16     
#      this ->-8

.set this, -8
.set s1, -16
.set s2, -32
.set cla, -80
.set i, -40
.set c2, 4

        MOV %RDI, this(%RBP)
        MOV %ESI, s1(%RBP)
        MOV %RDX, s2(%RBP)
        MOV %RCX, s2+8(%RBP)

        MOV $'a', %SIL
        LEA cla(%RBP), %RDI
        LEA s2(%RBP), %RDX

        CALL _ZN2clC1EcR3st2            # cl cla('a', s2);

        MOVL $0, i(%RBP)                # i = 0
for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        mov this(%rbp), %rdi
        movslq i(%rbp), %rcx
        mov 4(%rdi, %rcx), %al
        cmpb s1(%rbp, %rcx), %al
        JLE if
        JMP pre_for2
         

if:     LEA cla(%RBP), %RDI             # cla.c2.vc[i]
        MOVSBL 4(%RDI, %RCX), %EAX

        ADD i(%RBP), %EAX               # i + cla.c2.vc[i]

        MOV %AL, this(%RBP, %RCX)       # c1.vc[i] = i + cla.c2.vc[i];

        LEA cla(%RBP), %RDI
        MOV 8(%RDI, %RCX, 8), %RAX      # cla.v[i];
        MOVSLQ i(%RBP), %RDX
        SUB %RAX, %RDX                  # i - cla.v[i];            
        MOV this(%RBP), %RDI
        MOV %RDX, 8(%RDI, %RCX, 8)      # v[i] = i - cla.v[i];

pre_for2:
        INCL i(%RBP)
        JMP for2

fine_for2:
        MOV this(%RBP), %RAX
        LEAVE
        RET

