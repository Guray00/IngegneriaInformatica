.global _ZN2clC1EPc
_ZN2clC1EPc:


# vv2[0]->0
# vv2[1]->8
# vv2[2]->16
# vv2[3]->24
#  vv1[]->32





#          i->-24 
#      ind v->-16
#       this->-8

.set this, -8
.set v, -16
.set i, -24

    PUSH %RBP
    MOV %RSP, %RBP
    SUB $32, %RSP

    MOV %RDI, this(%RBP)
    MOV %RSI, v(%RBP)

    MOVL $0, i(%RBP)

for:
    CMPL $4, i(%RBP)
    JGE fine_for

    MOV v(%RBP), %RDI

    MOVSLQ i(%RBP), %RCX

    MOV $3, %RAX

    SUB %RCX, %RAX                  # 3 - i

    MOV (%RDI, %RAX), %AL           # v[3 - i];

    MOV this(%RBP), %RDI

    MOVSBQ %AL, %RAX

    MOV %RAX, (%RDI, %RCX, 8)       # s.vv2[i] = v[3 - i];

    MOV %AL, 32(%RDI, %RCX)         # s.vv1[i] = s.vv2[i] = v[3 - i];

    INCL i(%RBP)
    JMP for
fine_for:
    LEAVE 
    RET



.global _ZN2cl5elab1ER2sti
_ZN2cl5elab1ER2sti:



#   i->-20   d->-24
#           ss->-16
#         this->-8


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

        MOV ss(%RBP), %RSI

        MOV (%RSI, %RCX, 8), %RAX               # ss.vv2[i]

        MOVSLQ d(%RBP), %RBX                    # d

        CMP %RBX, %RAX                          # if (d >= ss.vv2[i])
        JG fine_if

        MOV this(%RBP), %RDI
        MOV 32(%RSI, %RCX), %AL                 # ss.vv1[i];
        ADD %AL, 32(%RDI, %RCX)                 # s.vv1[i] += ss.vv1[i]; 

fine_if:
        MOV d(%RBP), %EAX
        MOV i(%RBP), %EBX

        SUB %EBX, %EAX                          # d - i

        MOVSLQ %EAX, %RAX
        MOV %RAX, (%RDI, %RCX, 8)               # s.vv2[i] = d - i;

        INCL i(%RBP)
        JMP for2
fine_for2:
        LEAVE
        RET




