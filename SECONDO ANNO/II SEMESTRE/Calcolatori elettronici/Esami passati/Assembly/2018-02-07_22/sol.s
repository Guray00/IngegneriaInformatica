.global _ZN2clC1E3st1
_ZN2clC1E3st1:


#       cl.v2[0]->0
#       cl.v2[1]->8
#       cl.v2[2]->16
#       cl.v2[3]->24
#  v3[]->36 v1[]->32




#       i->-32
# ss.vi[]->-24  
#    
#    this-> -8

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

        MOV (%RSI, %RCX, 4), %EAX           # ss.vi[i]

        MOV this(%RBP), %RDI

        MOV %AL, 32(%RDI, %RCX)             # v1[i] = ss.vi[i]

        SAL %EAX

        MOVSLQ %EAX, %RAX                   # ss.vi[i] * 2

        MOV %RAX, (%RDI, %RCX, 8)           # v2[i] = ss.vi[i] * 2;

        MOV (%RSI, %RCX, 4), %EAX           # ss.vi[i]

        SAL %AL                             # 2 * ss.vi[i]

        MOV %AL, 36(%RDI, %RCX)             # v3[i] = 2 * ss.vi[i]

        INCL i(%RBP)
        JMP for

fine_for:
        LEAVE
        RET


.global _ZN2clC1ER3st1Pi
_ZN2clC1ER3st1Pi:


#       cl.v2[0]->0
#       cl.v2[1]->8
#       cl.v2[2]->16
#       cl.v2[3]->24
#  v3[]->36 v1[]->32

#    i->-32
# *ar2->-24
#  &s1->-16 
# this->-8

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
        MOV (%RSI, %RCX, 4), %EAX           # s1.vi[i]

        MOV this(%RBP), %RDI
        MOV %AL, 32(%RDI, %RCX)             # v1[i] = s1.vi[i];

        SAL $2, %EAX
        MOVSLQ %EAX, %RAX                   # s1.vi[i] * 4

        MOV %RAX, (%RDI, %RCX, 8)           # v2[i] = s1.vi[i] * 4

        MOV ar2(%RBP), %RSI
        MOV (%RSI, %RCX, 4), %EAX              # ar2[i]

        MOV %AL, 36(%RDI, %RCX)             # v3[i] = ar2[i]

        INCL i(%RBP)
        JMP for2
fine_for2:
        LEAVE
        RET


.global _ZN2cl5elab1EPc3st2
_ZN2cl5elab1EPc3st2:

#                 cl.v2[0]->-88
#                 cl.v2[1]->-80
#                 cl.v2[2]->-72
#                 cl.v2[3]->-64
#     v3[]->-52       v1[]->-56
# s1.vi[1]->-44   s1.vi[0]->-48
# s1.vi[1]->-36   s1.vi[0]->-40
#        i->-28         s2->-32
#                      ar1->-24   
#                     this->-16
#            ind. ritorno ->-8

.set indirizzo, -8
.set this, -16
.set ar1, -24
.set i, -28
.set s2, -32
.set s1, -48
.set cla, -88

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $96, %RSP

        MOV %RDI, indirizzo(%RBP)
        MOV %RSI, this(%RBP)
        MOV %RDX, ar1(%RBP)
        MOV %ECX, s2(%RBP)

        MOVL $0, i(%RBP)

for3:
        CMPL $4, i(%RBP)
        JGE fine_for3

        MOVSLQ i(%RBP), %RCX

        MOV ar1(%RBP), %RSI
        MOV (%RSI, %RCX), %AL               # ar1[i]

        ADD %CL, %AL                        # ar1[i] + i

        MOVSBL %AL, %EAX

        LEA s1(%RBP), %RDI
        MOV %EAX, (%RDI, %RCX, 4)           # s1.vi[i] = ar1[i] + i

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

        MOV (%RSI, %RCX), %AL                   # s2.vd[i]

        LEA cla(%RBP), %RDI

        MOV %AL, 36(%RDI, %RCX)                 # cla.v3[i] = s2.vd[i]

        INCL i(%RBP)
        JMP for4

fine_for4:
        MOV indirizzo(%RBP), %RDI
        LEA cla(%RBP), %RSI
        MOV $5, %RCX
        REP MOVSQ 

        LEAVE
        RET









