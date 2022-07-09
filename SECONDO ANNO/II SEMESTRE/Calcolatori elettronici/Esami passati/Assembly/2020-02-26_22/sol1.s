.global _ZN2clC1ER3st1
_ZN2clC1ER3st1:

.text

.set this, -8
.set ss, -16
.set i, -20


#  v3[0]->+4  char v1 -> +0
#  v3[2] ->+12 v3[1]-> +8
#  -           v3[3]-> +16
#  v2[0] -> +24
#  v2[1] -> +32
#  v2[2] -> +40
#  v2[3] -> +48

# i -> -16  &ss -> -12
#       this -> -8
 
        # prologo
        PUSHQ %RBP
        MOVQ %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, ss(%RBP)

        MOVL $0, i(%RBP)

for:    CMPL $4, i(%RBP)
        JGE fine_for

        # v1[i] = ss.vi[i];
        MOVSLQ i(%RBP), %RCX
        MOV ss(%RBP), %RDI
        MOV (%RDI, %RCX), %AL
        MOV this(%RBP), %RDI
        MOV %AL, (%RDI, %RCX)

        # v2[i] = v1[i] / 2;
        XOR %EAX, %EAX
        MOV (%RDI, %RCX), %AL
        SAR %RAX
        MOVSBQ %AL, %RAX
       
       
        MOV %RAX, 24(%RDI, %RCX, 8)

        # v3[i] = 2 * v1[i];
        XOR %EAX, %EAX
        MOV (%RDI, %RCX), %AL
        MOV this(%RBP), %RDI
        SHL %EAX
        MOV %EAX, 4(%RDI, %RCX, 4)

        INCL i(%RBP)
        JMP for

fine_for:
        LEAVE
        RET


.global _ZN2cl5elab1EPc3st2

#  v3[0]->+4  char v1 -> +0
#  v3[2] ->+12 v3[1]-> +8
#  -           v3[3]-> +16
#  v2[0] -> +24
#  v2[1] -> +32
#  v2[2] -> +40
#  v2[3] -> +48

_ZN2cl5elab1EPc3st2:
# LEA
#   v3[0]->-92  v1[]-> -96
#  v3[2] ->-84 v3[1]-> -88
#  -           v3[3]-> -80
#  v2[0] -> -72
#  v2[1] -> -64
#  v2[2] -> -56
#  v2[3] -> -48
#               s1  -> -40
#   i->-28      s2  -> -32
#       ar1         -> -24
#   MOVE       this -> -16
# risultato         -> -8

.set indirizzo, -8
.set this, -16
.set ar1, -24
.set s2, -32
.set i, -28
.set s1, -40


        PUSHQ %RBP
        MOVQ %RSP, %RBP
        SUB $96, %RSP
        MOV %RDI, indirizzo(%RBP)
        MOV %RSI, this(%RBP)
        MOV %RDX, ar1(%RBP)
        MOV %ECX, s2(%RBP)

        MOVL $0, i(%RBP)

for2:   CMPL $4, i(%RBP)
        JGE fine_for2
        MOVSLQ i(%RBP), %RCX

        # s1.vi[i] = ar1[i] + i;
        MOV ar1(%RBP), %RDI
        MOV (%RDI, %RCX), %AL
        MOVSBL %AL, %EAX
        ADD %ECX, %EAX

        LEA s1(%RBP), %RDI
        MOV %AL, (%RDI, %RCX)

        INCL i(%RBP)
        JMP for2

fine_for2:

#       cl cla(s1);
        LEA -96(%RBP), %RDI
        LEA s1(%RBP), %RSI

        CALL _ZN2clC1ER3st1

        MOVL $0, i(%RBP)

for3:   CMPL $4, i(%RBP)
        JGE fine_for3
        MOVSLQ i(%RBP), %RCX

#       cla.v3[i] = s2.vd[i];       
        LEA s2(%RBP), %RDI
        MOV (%RDI, %RCX), %AL
        MOVSBL %AL, %EAX
        

        MOV %EAX, -92(%RBP, %RCX, 4)

        INCL i(%RBP)
        JMP for3
   
fine_for3:   

        LEA -96(%RBP), %RSI
        MOV indirizzo(%RBP), %RDI
        MOV $7, %RCX
        REP MOVSQ
        LEAVE
        RET


