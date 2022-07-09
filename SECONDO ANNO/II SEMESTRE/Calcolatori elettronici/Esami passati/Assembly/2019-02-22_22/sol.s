.global _ZN2clC1ER3st1
_ZN2clC1ER3st1:


# v3[]->4  v1[]->0
#         v2[0]->8     
#         v2[1]->16    
#         v2[2]->24   
#         v2[3]->32     

#       i->-24
#      ss->-16 
#    this->-8

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

        MOV (%RSI, %RCX, 4), %EAX               # ss.vi[i]

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)                   # v1[i] = ss.vi[i]

        SAR %AL                                 # v1[i] / 2

        MOVSBQ %AL ,%RAX

        MOV %RAX, 8(%RDI, %RCX, 8)                  # v2[i] = v1[i] / 2

        MOV (%RDI, %RCX), %BL                   # v1[i]

        SAL %BL                                 # 2 * v1[i]

        MOV %BL, 4(%RDI, %RCX)              # v3[i] = 2 * v1[i]

        INCL i(%RBP)
        JMP for
fine_for:
        LEAVE
        RET


.global _ZN2cl5elab1EPc3st2
_ZN2cl5elab1EPc3st2:

# v3[]->4  v1[] ->-88
#         v2[0] ->-80    
#         v2[1] ->-72    
#         v2[2] ->-64   
#         v2[3] ->-54     
#         s1    ->-48
#   
# i->-28  s2    ->-32  
# ar1           ->-24
# this          ->-16
# indirizzo     ->-8

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
        MOV %EDX, ar1(%RBP)
        MOV %ECX, s2(%RBP)

        MOVL $0, i(%RBP)
for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        MOV ar1(%RBP), %RSI

        MOVSBL (%RSI, %RCX), %EAX               # ar1[i]

        ADD %ECX, %EAX                        # ar1[i] + i

        LEA s1(%RBP), %RDI

        MOV %EAX, (%RDI, %RCX, 4)           # s1.vi[i] = ar1[i] + i;

        INCL i(%RBP)
        JMP for2

fine_for2:
        LEA cla(%RBP), %RDI
        LEA s1(%RBP), %RSI

        CALL _ZN2clC1ER3st1

        MOVL $0, i(%RBP)
for3:
        CMPL $4, i(%RBP)
        JGE fine_for3

        MOVSLQ i(%RBP), %RCX
        XOR %RAX, %RAX

        MOV s2(%RBP, %RCX), %AL

        LEA cla(%RBP), %RDI

        MOV %AL, 4(%RDI, %RCX)

        INCL i(%RBP)
        JMP for3

fine_for3:
        LEA cla(%RBP), %RSI
        MOV indirizzo(%RBP), %RDI
        MOV $5, %RCX
        REP MOVSQ 

        LEAVE
        RET







