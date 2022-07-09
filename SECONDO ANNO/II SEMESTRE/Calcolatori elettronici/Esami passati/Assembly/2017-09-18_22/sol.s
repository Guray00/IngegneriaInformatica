.global _ZN2clC1EcR3st2

#    cl.s ->+0
# cl.v[0] ->+8
# cl.v[1] ->+16
# cl.v[2] ->+24
# cl.v[3] ->+32


#              i->-32 
#   indirizzo s2->-24
#              c->-16
#           this->-8
_ZN2clC1EcR3st2:
.set this, -8
.set c, -16
.set s2, -24
.set i, -32

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

        MOV c(%RBP), %AL                # c
        MOVSLQ i(%RBP), %RCX            # i
        ADD %CL, %AL                    # c + i

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX, 1)        # s.vc[i] = c + i;


        MOVSBQ (%RDI, %RCX, 1), %RAX    # s.vc[i]
        MOV s2(%RBP), %RSI

        MOV (%RSI, %RCX, 4), %EBX    # s2.vd[i]
        MOVSLQ %EBX, %RBX
        ADD %RBX, %RAX                  # s2.vd[i] + s.vc[i]

        MOV %RAX, 8(%RDI, %RCX, 8)      # v[i] = s2.vd[i] + s.vc[i]

        INCL i(%RBP)
        JMP for

fine_for:
        LEAVE
        RET


.global _ZN2cl5elab1E3st13st2
_ZN2cl5elab1E3st13st2:

#    cl.s ->-72
# cl.v[0] ->-64
# cl.v[1] ->-56
# cl.v[2] ->-48
# cl.v[3] ->-40
#        st2->-32
#       
# i->-12  st1->-16
# this       ->-8

.set cla, -72
.set s2, -32
.set s1, -16
.set i, -12
.set this, -8

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $80, %RSP

        MOV %RDI, this(%RBP)
        MOV %ESI, s1(%RBP)
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

        MOV s1(%RBP, %RCX), %AL         # s1.vc[i]
        MOV this(%RBP), %RDI
        MOV (%RDI, %RCX), %BL           # s.vc[i]

        CMP %BL, %AL
        JL pre_finefor2

        LEA cla(%RBP), %RSI

        MOV (%RSI, %RCX), %BL           # cla.s.vc[i];

        ADD %CL, %BL                    # i + cla.s.vc[i];

        MOV %BL, (%RDI, %RCX)           # s.vc[i] = i + cla.s.vc[i];

        MOV 8(%RSI, %RCX, 8), %RBX      # cla.v[i];

        MOV %RCX, %RDX

        SUB %RBX, %RDX                  # i - cla.v[i]

        MOV %RDX, 8(%RDI, %RCX, 8)      # v[i] = i - cla.v[i];
		




pre_finefor2:
        INCL i(%RBP)
        JMP for2

fine_for2:

        LEAVE
        RET





