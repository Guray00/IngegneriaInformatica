.global _ZN2clC1ER3st1
_ZN2clC1ER3st1:

# v3[]->4  v1[]->0
#         v2[0]->8
#         v2[1]->16  
#         v2[2]->24 
#         v2[3]->32  

#    i->-24   
#   ss->-16
# this->-8

.set this, -8
.set ss, -16
.set i, -24

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, ss(%RBP)

        MOVL $0, i(%RBP)

for:
        CMPL $4, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX

        MOV ss(%RBP), %RSI

        MOV (%RSI, %RCX, 4), %EAX           # ss.vi[i]

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)               # v1[i] = ss.vi[i];

        MOVSLQ %EAX, %RAX

        SAR %RAX                            # v1[i] / 2;

        MOV %RAX, 8(%RDI, %RCX, 8)          # v2[i] = v1[i] / 2;

        MOV (%RSI, %RCX, 4), %EAX           # ss.vi[i]

        SAL %EAX                            # 2 * v1[i]

        MOV %AL, 4(%RDI, %RCX)              # v3[i] = 2 * v1[i]

        INCL i(%RBP)
        JMP for
fine_for:
        LEAVE
        RET


.global _ZN2clC1E3st1Pi
_ZN2clC1E3st1Pi:

# v3[]->4  v1[]->0
#         v2[0]->8
#         v2[1]->16  
#         v2[2]->24 
#         v2[3]->32 

#                      i->-40
#                  ar2[]->-32
# s1.vi[1]->-20 s1.vi[0]->-24
# s1.vi[3]->-12 s1.vi[2]->-16
#                   this->-8

.set this, -8
.set s1, -24
.set ar2, -32
.set i, -40

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $48, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, s1(%RBP)
        MOV %RDX, s1+8(%RBP)
        MOV %RCX,  ar2(%RBP)

        MOVL $0, i(%RBP)
for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX
        LEA s1(%RBP), %RSI

        MOV (%RSI, %RCX, 4), %EAX                   # s1.vi[i]

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)                       # v1[i] = s1.vi[i]

        SAR $2, %EAX                                # v1[i] / 4

        MOVSLQ %EAX, %RAX

        MOV %RAX, 8(%RDI, %RCX, 8)                  # v2[i] = v1[i] / 4

        MOV ar2(%RBP), %RSI

        MOV (%RSI, %RCX, 4), %EAX                   # ar2[i];

        SAL %EAX                                    # 2 * ar2[i];

        MOV %AL, 4(%RDI, %RCX)                      # v3[i] = 2 * ar2[i]

        INCL i(%RBP)
        JMP for2
fine_for2:
        LEAVE
        RET


.global _ZN2cl5elab1EPc3st2
_ZN2cl5elab1EPc3st2:


#     v3[]->-84     v1[]->-88
#                  v2[0]->-80
#                  v2[1]->-72 
#                  v2[2]->-64
#                  v2[3]->-56 
# s1.vi[1]->-44 s1.vi[0]->-48
# s1.vi[3]->-36 s1.vi[2]->-40
#        i->-28       s2->-32         
#                    ar1->-24
#                   this->-16
#              indirizzo->-8


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
        MOV %EAX, (%RDI, %RCX, 4)               # s1.vi[i] = ar1[i] + i;

        INCL i(%RBP)
        JMP for3
fine_for3:

        LEA cla(%RBP), %RDI
        LEA s1(%RBP), %RSI

        CALL _ZN2clC1ER3st1

        MOVL $0, i(%RBP)

for4:
        CMPL $4, i(%RBP)
        JGE fine_for4

        MOVSLQ i(%RBP), %RCX

        LEA s2(%RBP), %RSI

        MOV (%RSI, %RCX), %AL               # s2.vd[i]

        LEA cla(%RBP), %RDI
        MOV %AL, 4(%RDI, %RCX)              # cla.v3[i] = s2.vd[i];

        INCL i(%RBP)
        JMP for4

fine_for4:
        LEA cla(%RBP), %RSI
        MOV indirizzo(%RBP), %RDI
        MOV $5, %RCX
        REP MOVSQ 

        LEAVE
        RET


