.global _ZN2clC1Ec3st1
_ZN2clC1Ec3st1:

#    v[0]->0
#    v[1]->8
#    v[2]-16
#    v[3]->24
# s.vcv[]->32

#          i->-24 
# s2->-12  c->-16   
#       this->-8


.set this, -8
.set c, -16
.set s2, -12
.set i, -24

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %SIL, c(%RBP)
        MOV %EDX, s2(%RBP)

        MOVL $0, i(%RBP)

for:    
        CMPL $4, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX

        MOV c(%RBP), %AL                    # c

        MOV this(%RBP), %RDI               

        MOV %AL, 32(%RDI, %RCX)             # s.vc[i] = c

        LEA s2(%RBP), %RSI

        MOV (%RSI, %RCX), %BL               # s2.vc[i]

        SUB %AL, %BL                        # s2.vc[i] - c

        MOVSBQ %BL, %RBX

        MOV %RBX, (%RDI, %RCX, 8)           # v[i] = s2.vc[i] - c;

        INCL i(%RBP)
        JMP for
fine_for:
        LEAVE
        RET


.global _ZN2cl5elab1ER3st1
_ZN2cl5elab1ER3st1:

#      v[0]->-64
#      v[1]->-56
#      v[2]->-48
#      v[3]->-40
#   s.vcv[]->-32
#         i->-24
#        s1->-16
#      this->-8

.set this, -8
.set s1, -16
.set i, -24
.set cla, -64

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $64, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, s1(%RBP)

        MOV (%RSI), %EDX

        LEA cla(%RBP), %RDI
        MOV $'x', %SIL

        CALL _ZN2clC1Ec3st1

        MOVL $0, i(%RBP)

for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        MOV s1(%RBP), %RSI

        MOV (%RSI, %RCX), %AL                   # s1.vc[i]

        MOV this(%RBP), %RDI

        MOV 32(%RDI, %RCX), %BL                 # s.vc[i]

        CMP %AL, %BL
        JG fine_if

        LEA cla(%RBP), %RSI                     # s.vc[i] <= s1.vc[i]

        MOV 32(%RSI, %RCX), %AL                 # cla.s.vc[i]

        MOV %AL, 32(%RDI, %RCX)                 # s.vc[i] = cla.s.vc[i]

        MOV (%RSI, %RCX, 8), %RAX               # cla.v[i]


        ADD %RCX, %RAX                          # cla.v[i] + i

        # MOV $0, %RAX

        MOV %RAX, (%RDI, %RCX, 8)               # v[i] = cla.v[i] + i

fine_if:
        INCL i(%RBP)
        JMP for2

fine_for2:
        LEAVE
        RET

