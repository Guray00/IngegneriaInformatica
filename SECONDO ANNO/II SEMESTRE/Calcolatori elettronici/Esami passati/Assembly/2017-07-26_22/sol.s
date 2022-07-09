.global _ZN2clC1E
_ZN2clC1E:

#                vv2[0]->0
#                vv2[1]->+8
#                vv2[2]->+16
#                vv2[3]->+24
#  b->+37 a->+36  vv1[]->+32


# this->-8

.set this, -8
        PUSH %RBP
        MOV %RSP, %RBP
        SUB $16, %RSP

        LEAVE
        RET


.global _ZN2clC1EPc
_ZN2clC1EPc:
#                vv2[0]->0
#                vv2[1]->+8
#                vv2[2]->+16
#                vv2[3]->+24
#                 vv1[]->+32
#              b->+41 a->+40  

#    i->-24
#  v[]->-16
# this->-8

.set a, 40
.set b, 41

.set this, -8
.set v, -16
.set i, -24

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, v(%RBP)

        MOV (%RSI), %AL                  # v[0]
        MOV %AL, a(%RDI)                  # a = v[0]

        INCB (%RSI)                       # v[0]++

        MOV (%RSI, 1), %AL                  # v[1]

        MOV %AL, b(%RDI)                    # b = v[1];

        MOVL $0, i(%RBP)

for:
        CMPL $4, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX

        MOV v(%RBP), %RSI

        MOV (%RSI, %RCX), %AL               # v[i]

        MOV a(%RDI), %BL                    # a

        ADD %AL, %BL                        # v[i] + a

        MOV %BL, 32(%RDI, %RCX)             # s.vv1[i] = v[i] + a

        MOVSBQ (%RSI, %RCX), %RAX            # v[i]

        MOVSBQ b(%RDI), %RBX                # b

        ADD %RBX, %RAX                      # v[i] + b

        MOV %RAX, (%RDi, %RCX, 8)           # s.vv2[i] = v[i] + b

        INCL i(%RBP)
        JMP for
fine_for:
        LEAVE
        RET


.global _ZN2cl5elab1ER2sti
_ZN2cl5elab1ER2sti:

#                vv2[0]->0
#                vv2[1]->+8
#                vv2[2]->+16
#                vv2[3]->+24
#                 vv1[]->+32
#              b->+41 a->+40

#    i->-20 d->-24 
#         ss->-16
#       this->-8

.set a, 40
.set b, 41

.set this, -8
.set ss, -16
.set i, -20
.set d, -24

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, ss(%RBP)
        MOV %EDX, d(%RBP)

        MOVL $0, i(%RBP)

for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX
        MOVSLQ d(%RBP), %RAX                # d

        MOV ss(%RBP), %RSI                  

        MOV (%RSI, %RCX, 8), %RBX           # ss.vv2[i]

        CMP %RBX, %RAX                      # if (d >= ss.vv2[i])

        JL fine_if

        MOV 32(%RSI, %RCX), %AL             # ss.vv1[i]

        MOV this(%RBP), %RDI
        ADD %AL, 32(%RDI, %RCX)             # s.vv1[i] += ss.vv1[i]; 

fine_if:
        MOVSBQ a(%RDI), %RAX                # a
        MOVSLQ d(%RBP), %RBX                # d

        ADD %RBX, %RAX                      # a + d

        SUB %RCX, %RAX                      # a + d - i
.global _ZN2clC1E
_ZN2clC1E:

#                vv2[0]->0
#                vv2[1]->+8
#                vv2[2]->+16
#                vv2[3]->+24
#  b->+37 a->+36  vv1[]->+32


# this->-8

.set this, -8
        PUSH %RBP
        MOV %RSP, %RBP
        SUB $16, %RSP

        LEAVE
        RET


.global _ZN2clC1EPc
_ZN2clC1EPc:
#                vv2[0]->0
#                vv2[1]->+8
#                vv2[2]->+16
#                vv2[3]->+24
#                 vv1[]->+32
#              b->+41 a->+40  

#    i->-24
#  v[]->-16
# this->-8

.set a, 40
.set b, 41

.set this, -8
.set v, -16
.set i, -24

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, v(%RBP)

        MOV (%RSI), %AL                  # v[0]
        MOV %AL, a(%RDI)                  # a = v[0]

        INCB (%RSI)                       # v[0]++

        MOV (%RSI, 1), %AL                  # v[1]

        MOV %AL, b(%RDI)                    # b = v[1];

        MOVL $0, i(%RBP)

for:
        CMPL $4, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX

        MOV v(%RBP), %RSI

        MOV (%RSI, %RCX), %AL               # v[i]

        MOV a(%RDI), %BL                    # a

        ADD %AL, %BL                        # v[i] + a

        MOV %BL, 32(%RDI, %RCX)             # s.vv1[i] = v[i] + a

        MOVSBQ (%RSI, %RCX), %RAX            # v[i]

        MOVSBQ b(%RDI), %RBX                # b

        ADD %RBX, %RAX                      # v[i] + b

        MOV %RAX, (%RDi, %RCX, 8)           # s.vv2[i] = v[i] + b

        INCL i(%RBP)
        JMP for
fine_for:
        LEAVE
        RET


.global _ZN2cl5elab1ER2sti
_ZN2cl5elab1ER2sti:

#                vv2[0]->0
#                vv2[1]->+8
#                vv2[2]->+16
#                vv2[3]->+24
#                 vv1[]->+32
#              b->+41 a->+40

#    i->-20 d->-24 
#         ss->-16
#       this->-8

.set a, 40
.set b, 41
s.vv2[i] = a + d - i;
.set this, -8
.set ss, -16
.set i, -20
.set d, -24

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, ss(%RBP)
        MOV %EDX, d(%RBP)

        MOVL $0, i(%RBP)

for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX
        MOVSLQ d(%RBP), %RAX                # d

        MOV ss(%RBP), %RSI                  

        MOV (%RSI, %RCX, 8), %RBX           # ss.vv2[i]

        CMP %RBX, %RAX                      # if (d >= ss.vv2[i])

        JL fine_if

        MOV 32(%RSI, %RCX), %AL             # ss.vv1[i]

        MOV this(%RBP), %RDI
        ADD %AL, 32(%RDI, %RCX)             # s.vv1[i] += ss.vv1[i]; 

fine_if:
        MOVSBQ a(%RDI), %RAX                # a
        MOVSLQ d(%RBP), %RBX                # d

        ADD %RBX, %RAX                      # a + d

        SUB %RCX, %RAX                      # a + d - i

        MOV %RAX, (%RDI, %RCX, 8)           # s.vv2[i] = a + d - i;

        INCL i(%RBP)
        JMP for2

fine_for2:
        LEAVE
        RET

















        JMP for2

fine_for2:
        LEAVE
        RET
















