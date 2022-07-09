.global _ZN2clC1Ec3st1
_ZN2clC1Ec3st1:

#   s.vc[]->0
#     v[0]->8
#     v[1]->16
#     v[2]->24
#     v[3]->32

#
#               i->-24
#  s2.vc[]->-12 c->-16
#           this ->-8

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

        MOV c(%RBP), %AL                # c
        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)           # s.vc[i] = c

        LEA s2(%RBP), %RSI

        MOV (%RSI, %RCX), %BL           # s2.vc[i]

        SUB %AL, %BL                    # s2.vc[i] - c

        MOVSBQ %BL, %RBX

        MOV %RBX, 8(%RDI, %RCX, 8)      # v[i] = s2.vc[i] - c

        INCL i(%RBP)
        JMP for
fine_for:
        LEAVE 
        RET

.global _ZN2cl5elab1ER3st1
_ZN2cl5elab1ER3st1:

#   s.vc[]->-64
#     v[0]->-56
#     v[1]->-48
#     v[2]->-40
#     v[3]->-32

#        i->-24
#       s1->-16
#     this->-8


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
        MOV $'p', %SIL

        CALL _ZN2clC1Ec3st1             # cl cla('p', s1);

        MOVL $0, i(%RBP)
for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        MOV s1(%RBP), %RSI

        MOV (%RSI, %RCX), %AL           # s1.vc[i]

        MOV this(%RBP), %RDI

        MOV (%RDI, %RCX), %BL           # s.vc[i]

        CMP %BL, %AL                    # if (s.vc[i] < s1.vc[i])
        JLE fine_if

        LEA cla(%RBP), %RSI
        MOV (%RSI, %RCX), %AL           # cla.s.vc[i];

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)           # s.vc[i] = cla.s.vc[i];

        MOV 8(%RSI, %RCX, 8), %RAX      # cla.v[i] 

        ADD %RCX, %RAX                  # cla.v[i] + i

        MOV %RAX, 8(%RDI, %RCX, 8)

fine_if:
        INCL i(%RBP)
        JMP for2

fine_for2:
        LEAVE
        RET

        



