.global _ZN2clC1EPc
_ZN2clC1EPc:
    

#       vv1[]->0
#      vv2[0]->8
#      vv2[1]->16 
#      vv2[2]->24
#      vv2[3]->32

#          i->-24 
#        v[]->-16  
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

        MOVSLQ i(%RBP), %RCX

        MOV v(%RBP), %RSI

        MOV (%RSI, %RCX), %AL                   # v[i]

        MOVSBQ %AL, %RBX

        MOV this(%RBP), %RDI
        MOV %RBX, 8(%RDI, %RCX, 8)              # s.vv2[i] = v[i]

        MOV %AL, (%RDI, %RCX)                   # s.vv1[i] = s.vv2[i] = v[i]

        INCL i(%RBP)
        JMP for
fine_for:
        LEAVE
        RET


.global _ZN2cl5elab1EiR2st
_ZN2cl5elab1EiR2st:

#       vv1[]->0
#      vv2[0]->8
#      vv2[1]->16 
#      vv2[2]->24
#      vv2[3]->32

#          ss->-24
# i->-12    d->-16
#        this->-8

.set this, -8
.set d, -16
.set i, -12
.set ss, -24


        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %ESI, d(%RBP)
        MOV %RDX, ss(%RBP)

        MOVL $0, i(%RBP)
for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        MOV ss(%RBP), %RSI

        MOV 8(%RSI, %RCX, 8), %RAX                   # ss.vv2[i]

        MOV d(%RBP), %EBX

        MOVSLQ %EBX, %RBX

        CMP %RBX, %RAX                               # if (d >= ss.vv2[i])

        JG fine_if

        MOV (%RSI, %RCX), %AL                       # ss.vv1[i]

        ADD %AL, (%RDI, %RCX)                       # s.vv1[i] += ss.vv1[i];

fine_if:
        MOV d(%RBP), %EBX

        ADD %ECX, %EBX

        MOVSLQ %EBX, %RBX

        MOV %RBX, 8(%RDI, %RCX, 8)

        INCL i(%RBP)
        JMP for2
fine_for2:
        LEAVE
        RET



