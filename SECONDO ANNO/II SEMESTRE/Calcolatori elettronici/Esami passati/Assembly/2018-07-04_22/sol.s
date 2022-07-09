.global _ZN2clC1E3st1
_ZN2clC1E3st1:

#  v2[]->4   v1[]->0
#           v3[0]->8
#           v3[1]->16
#           v3[2]->24
#           v3[3]->32


# i->-12 ss.vi->-16  
#         this->-8

.set this, -8
.set vi, -16
.set i, -12

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $16, %RSP

        MOV %RDI, this(%RBP)
        MOV %ESI, vi(%RBP)

        MOVL $0, i(%RBP)
for:
        CMPL $4, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX

        LEA vi(%RBP), %RSI

        MOV (%RSI, %RCX), %AL           # ss.vi[i];

        MOV this(%RBP), %RDI

        MOV %AL, 4(%RDI, %RCX)          # v2[i] = ss.vi[i]

        MOV %AL, (%RDI, %RCX)           # v1[i] = v2[i] = ss.vi[i

        ADD %AL, %AL                    # ss.vi[i] + ss.vi[i] // ss.vi[i]*2

        MOVSBQ %AL, %RAX

        MOV %RAX, 8(%RDI, %RCX, 8)      # v3[i] = ss.vi[i] + ss.vi[i]

        INCL i(%RBP)
        JMP for
fine_for:
        LEAVE
        RET

.global _ZN2cl5elab1EPc3st1
_ZN2cl5elab1EPc3st1:


#  v2[]->4   v1[]->-80
#           v3[0]->-72
#           v3[1]->-64
#           v3[2]->-56
#           v3[3]->-48
#             s1 ->-40  
#     i->-28  s2 ->-32
#          ar1[] ->-24
#           this ->-16
#     indirizzo  ->-8

.set indirizzo, -8
.set this, -16
.set ar1, -24
.set i, -28
.set s2, -32
.set s1, -40
.set cla, -80

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $80, %RSP
        
        MOV %RDI, indirizzo(%RBP)
        MOV %RSI, this(%RBP)
        MOV %RDX, ar1(%RBP)
        MOV %ECX, s2(%RBP)

        MOVL $0, i(%RBP)
for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        MOV ar1(%RBP), %RSI
        LEA s1(%RBP), %RDI

        MOV (%RSI, %RCX), %AL               # ar1[i]

        MOV %AL, (%RDI, %RCX)                # s1.vi[i] = ar1[i]

        INCL i(%RBP)
        JMP for2

fine_for2:
        LEA cla(%RBP), %RDI
        MOV s1(%RBP), %ESI

        CALL _ZN2clC1E3st1
this
        MOVL $0, i(%RBP)
for3:
        CMPL $4, i(%RBP)
        JGE fine_for3

        MOVSLQ i(%RBP), %RCX
        LEA s2(%RBP), %RSI

        MOV (%RSI, %RCX), %AL               # s2.vi[i]

        MOVSBQ %AL, %RAX

        LEA cla(%RBP), %RDI

        MOV %RAX, 8(%RDI, %RCX, 8)          # cla.v3[i] = s2.vi[i]

        INCL i(%RBP)
        JMP for3

fine_for3:
        LEA cla(%RBP), %RSI
        MOV indirizzo(%RBP), %RDI
        MOVQ $5, %RCX
        REP MOVSQ 

        LEAVE
        RET



