.global _ZN2clC1Ec3st2
_ZN2clC1Ec3st2:

#      s.vc[]->0
#        v[0]->+8
#        v[1]->+16
#        v[2]->+24
#        v[3]->+32

#           i-> -40
#        vd[]-> -32         
#
#          c-> -16
#       this-> -8

.set this, -8
.set c, -16
.set vd, -32
.set i, -40

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $40, %RSP

        MOV %RDI, this(%RBP)
        MOV %SIL, c(%RBP)
        MOV %RDX, vd(%RBP)
        MOV %RCX, vd+8(%RBP)

        MOVL $0, i(%RBP)
for:
        CMPL $4, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX

        MOV c(%RBP), %AL                    # c

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)               # s.vc[i] = c;

        LEA vd(%RBP), %RSI

        MOVSLQ (%RSI, %RCX, 4), %RAX        # s2.vd[i]

        MOV this(%RBP), %RDI

        MOVSBQ (%RDI, %RCX), %RBX           # s.vc[i]

        SUB %RBX, %RAX                      # s2.vd[i] - s.vc[i]

        MOV this(%RBP), %RDI

        MOV %RAX, 8(%RDI, %RCX, 8)

        INCL i(%RBP)
        JMP for

fine_for:
        LEAVE 
        RET


.global _ZN2cl5elab1E3st1R3st2
_ZN2cl5elab1E3st1R3st2:

.set cla, -64
.set st2, -24
.set i, -12
.set vc, -16
.set this, -8

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $64, %RSP

        MOV %RDI, this(%RBP)
        MOV %ESI, vc(%RBP)
        MOV %RDX, st2(%RBP)

        MOV (%RDX), %RAX
        MOV 8(%RDX), %RBX

        MOV %RAX, %RDX
        MOV %RBX, %RCX

        LEA cla(%RBP), %RDI
        MOV $'f', %SIL

        CALL _ZN2clC1Ec3st2                     # cl cla('f', s2);

        MOVL $0, i(%RBP)
for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        MOV this(%RBP), %RDI
        MOV (%RDI, %RCX), %AL                   # s.vc[i]

        LEA vc(%RBP), %RSI
        MOV (%RSI, %RCX), %BL                   # s1.vc[i]

        CMP %AL, %BL                            # if (s.vc[i] < s1.vc[i])
        JLE fine_if

        LEA cla(%RBP), %RSI
        MOV (%RSI, %RCX), %BL                   # cla.s.vc[i]

        MOV %BL, (%RDI, %RCX)                   # s.vc[i] = cla.s.vc[i];

fine_if:
        MOV this(%RBP), %RDI
        MOV 8(%RDI, %RCX, 8), %RAX              # v[i]

        LEA cla(%RBP), %RSI
        MOV 8(%RSI, %RCX, 8), %RBX              # cla.v[i]

        CMP %RAX, %RBX
        JL fine_if2

        ADD %RBX, %RAX                          # += cla.v[i]

        MOV %RAX, 8(%RDI, %RCX, 8)              # v[i] += cla.v[i];


fine_if2:
        INCL i(%RBP)
        JMP for2
        
fine_for2:
        LEAVE
        RET










