.global _ZN2clC1E3st1
_ZN2clC1E3st1:

# v3[]->4   v1[]->0
#          v2[0]->8
#          v2[1]->16
#          v2[2]->24
#          v2[3]->32


#         i->-32 
#   ss.vi[]->-24 
#
#      this->-8

.set this, -8
.set vi, -24
.set i, -32

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, vi(%RBP)
        MOV %RDX, vi+8(%RBP)

        MOVL $0, i(%RBP)
for:
        CMPL $4, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX

        LEA vi(%RBP), %RSI

        MOV (%RSI, %RCX, 4), %EAX               # ss.vi[i]

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)                   # v1[i] = ss.vi[i]

        MOVSLQ %EAX, %RAX                        # ss.vi[i]

        SAR %RAX                                # ss.vi[i] / 2

        MOV %RAX, 8(%RDI, %RCX, 8)              # v2[i] = ss.vi[i] / 2

        MOV (%RSI, %RCX, 4), %EAX               # # ss.vi[i]

        SAL %EAX                                # 2 * ss.vi[i]

        MOV %AL, 4(%RDI, %RCX)

        INCL i(%RBP)
        JMP for

fine_for:
        LEAVE
        RET


.global _ZN2clC1ER3st1Pi
_ZN2clC1ER3st1Pi:

# v3[]->4   v1[]->0
#          v2[0]->8
#          v2[1]->16
#          v2[2]->24
#          v2[3]->32

#          i->-32
#   ind. ar2->-24
#   ind. s1 ->-16
#       this->-8


.set this, -8
.set s1, -16
.set ar2, -24
.set i, -32

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, s1(%RBP)
        MOV %RDX, ar2(%RBP)
        MOVL $0, i(%RBP)

for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        MOV s1(%RBP), %RSI                             
        MOV (%RSI, %RCX, 4), %EAX               # s1.vi[i]

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)                   # v1[i] = s1.vi[i]

        MOVSLQ %EAX, %RAX                       # s1.vi[i]

        SAR $2, %RAX

        MOV %RAX, 8(%RDI, %RCX, 8)              # v2[i] = s1.vi[i] / 4;

        MOV ar2(%RBP), %RSI
        MOV (%RSI, %RCX, 4), %EAX               # ar2[i]

        MOV %AL, 4(%RDi, %RCX)

        INCL i(%RBP)
        JMP for2
fine_for2:
        LEAVE
        RET

.global _ZN2cl5elab1EPc3st2
_ZN2cl5elab1EPc3st2:


#  v3[]->4   v1[]->-88
#           v2[0]->-80
#           v2[1]->-72
#           v2[2]->-64
#           v2[3]->-56
#              s1->-48

#       i->-28 s2->-32
#         ind ar1->-24  
#            this->-16
#       indirizzo->-8

.set indirizzo, -8
.set this, -16
.set ar1, -24
.set i, -28
.set s2, -32
.set s1, -40
.set cla, -88

        PUSH %RBP
        MOV %RSp, %RBP
        SUB $96, %RSP

        MOV %RDI, indirizzo(%RBP)
        MOV %RSI, this(%RBP)
        MOV %RDX, ar1(%RBP)
        MOV %RCX, s2(%RBP)

        MOVL $0, i(%RBP)

for3:
        CMPL $4, i(%RBP)
        JGE fine_for3

        MOVSLQ i(%RBP), %RCX

        MOV ar1(%RBP), %RSI

        MOV (%RSI, %RCX), %AL


        MOVSBL %AL, %EAX

        ADD %ECX, %EAX

        LEA s1(%RBP), %RDI

        MOV %EAX, (%RDI, %RCX, 4)

        INCL i(%RBP)
        JMP for3
fine_for3:
        LEA cla(%RBP), %RDI
        MOV s1(%RBP), %RSI
        MOV s1+8(%RBP), %RDX

        CALL _ZN2clC1E3st1

        MOVL $0, i(%RBP)

for4:  
        CMPL $4, i(%RBP)
        JGE fine_for4

        MOVSLQ i(%RBP), %RCX

        LEA s2(%RBP), %RSI
        MOV (%RSI, %RCX), %AL

        LEA cla(%RBP), %RDI

        MOV %AL, 4(%RDI, %RCX)

        INCL i(%RBP)
        JMP for4
fine_for4:
    LEA cla(%RBP), %RSI
    MOV indirizzo(%RBP), %RDI
    MOV $5, %RCX
    REP MOVSQ

    LEAVE 
    RET




