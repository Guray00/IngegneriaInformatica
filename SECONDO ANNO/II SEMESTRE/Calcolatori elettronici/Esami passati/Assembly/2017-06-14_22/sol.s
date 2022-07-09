.global _ZN2clC1Ec3st1
_ZN2clC1Ec3st1:




#  s.vc[]->0
#    v[0]->+8
#    v[1]->+16
#    v[2]->+24
#    v[3]->+32


#      vc[] ->-24
# i->-12    c->-16
# this       ->-8

.set this, -8
.set c, -24
.set i, -20
.set vc, -16

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %SIL, c(%RBP)
        MOV %RDX, vc(%RBP)

        MOVL $0, i(%RBP)

for:
        CMPL $8, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX    # i

        MOV c(%RBP), %AL        # c

        ADD %CL, %AL            # c +i

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)   # s.vc[i] = c + i

        INCL i(%RBP)
        JMP for

fine_for:
        MOVL $0, i(%RBP)

for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        LEA vc(%RBP), %RSI
        MOV (%RSI, %RCX), %AL       # s2.vc[i]

        MOV this(%RBP), %RDI

        MOV (%RDI, %RCX), %BL       # s.vc[i]

        SUB %BL, %AL

        MOVSBQ %AL, %RBX

        MOV %RBX, 8(%RDI, %RCX, 8)  # v[i] = s2.vc[i] - s.vc[i];

        INCL i(%RBP)
        JMP for2

fine_for2:
        LEAVE
        RET


.global _ZN2cl5elab1ER3st13st2
_ZN2cl5elab1ER3st13st2:

#  s.vc[]   ->-80
#    v[0]   ->-72
#    v[1]   ->-64
#    v[2]   ->-56
#    v[3]   ->-48
#          i->-40 
# ////  v[0]->-32
# //////////
# s1        ->-16
# this      ->-8

.set this, -8
.set s1, -16
.set s2v, -32
.set i, -40
.set cla, -80


        PUSH %RBP
        MOV %RSP, %RBP
        SUB $80, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, s1(%RBP)
        MOV %RDX, s2v(%RBP)
        MOV %RCX, s2v+8(%RBP)

        MOV $'S', %SIL

        LEA cla(%RBP), %RDI
        MOV  s1(%RBP), %RAX
        MOV (%RAX), %RDX

        CALL _ZN2clC1Ec3st1        

        MOVL $0, i(%RBP)

for3:
        CMPL $4, i(%RBP)
        JGE fine_for3

        MOVSLQ i(%RBP), %RCX

        MOV s1(%RBP), %RSI      
        MOV (%RSI, %RCX), %AL                # s1.vc[i]

        MOV this(%RBP), %RDI

        MOV (%RDI, %RCX), %BL                   # s.vc[i]

        CMP %BL, %AL
        JLE fine_if

        LEA cla(%RBP), %RSI                     # cla.s.vc[i];
        MOV (%RSI, %RCX), %AL

        MOV %AL, (%RDI, %RCX)   		# s.vc[i] = cla.s.vc[i];

fine_if:
        LEA cla(%RBP), %RSI  

        MOV 8(%RSI, %RCX, 8), %RAX               # cla.s.vc[i];

        MOV 8(%RDI, %RCX, 8), %RBX              # v[i]

        CMP %RBX, %RAX
        JLE fine_if2

        MOV 8(%RSI, %RCX, 8), %RAX              # cla.v[i]
        ADD %RCX, %RAX                          # cla.v[i] + i

        MOV %RAX, 8(%RDI, %RCX, 8)              # v[i] = cla.v[i] + i;

fine_if2:
        INCL i(%RBP)
        JMP for3




fine_for3:
        LEAVE
        RET



