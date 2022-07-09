.global _ZN2clC1EcR3st2
_ZN2clC1EcR3st2:


#   cl.s.vc[]->0
#        v[0]->+8
#        v[1]->+16
#        v[2]->+24
#        v[3]->+32

# indirizzos2->-24
# i->-12    c->-16
#       this ->-8

.set this, -8
.set c, -16
.set i, -12
.set s2, -24

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %SIL, c(%RBP)
        MOV %RDX, s2(%RBP)


        MOVL $0, i(%RBP)

for:    
        CMPL $4, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX

        MOV c(%RBP), %AL

        ADD %CL, %AL                        # c + i

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)               # s.vc[i] = c + i;

        MOV s2(%RBP), %RSI

        MOVSLQ (%RSI, %RCX, 4), %RAX        # s2.vd[i]

        MOVSBQ (%RDI, %RCX), %RBX           # s.vc[i]

        ADD %RBX, %RAX                      # s2.vd[i] + s.vc[i];

        MOV %RAX, 8(%RDI, %RCX, 8)          # v[i] = s2.vd[i] + s.vc[i];

        INCL i(%RBP)

        JMP for

fine_for:
        LEAVE
        RET



.global _ZN2cl5elab1E3st13st2
_ZN2cl5elab1E3st13st2:


#   cl.s.vc[]->-72
#        v[0]->-64
#        v[1]->-56
#        v[2]->-48
#        v[3]->-40

#            s2->-32   
#
#  i->-12    s1->-16
#           this->-8

.set this, -8
.set s1, -16
.set s2, -32
.set cla, -72

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $80, %RSP

        MOV %RDI, this(%RBP)
        MOV %EAX, s1(%RBP)
        MOV %RDX, s2(%RBP)
        MOV %RCX, s2+8(%RBP)

        LEA cla(%RBP), %RDI
        MOV $'a', %SIL
        LEA s2(%RBP), %RDX

        CALL _ZN2clC1EcR3st2

        MOVL $0, i(%RBP)
for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        XOR %RAX, %RAX


        MOV s1(%RBP, %RCX), %AL         # s1.vc[i]) 

        MOV this(%RBP), %RDI

        XOR %RBX, %RBX

        MOV (%RDI, %RCX), %BL           # s.vc[i]

        CMP %BL, %AL
        JG fine_if

        LEA cla(%RBP), %RSI

        MOV (%RSI, %RCX), %AL           # cla.s.vc[i];

        MOV %AL, (%RDI, %RCX)           # s.vc[i] = cla.s.vc[i];


        MOV 8(%RSI, %RCX, 8), %RAX      # cla.v[i];

        MOV %RAX, 8(%RDI, %RCX, 8)      # v[i] = cla.v[i];

fine_if:
        INCL i(%RBP)
        JMP for2

fine_for2:
        LEAVE 
        RET







