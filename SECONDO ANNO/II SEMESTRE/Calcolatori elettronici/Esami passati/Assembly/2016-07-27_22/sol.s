.global _ZN2clC1EPc

_ZN2clC1EPc:



# struttura della classe
# //////       b->+1 a->+0
#               vv1[] ->+8
#               vv2[0]->+16
#               vv2[1]->+24
#               vv2[2]->+32
#               vv2[3]->+40

# struttura di st        MOV %EAX

#               vv2[0]->+8
#               vv2[1]->+16
#               vv2[2]->+24
#               vv2[3]->+32


#                i  ->-24
# indirizzo di v[]  ->-16
#               this->-8

.set this, -8
.set v, -16
.set i, -24

.set a, 0
.set b, +1
.set vv1, +8
.set vv2, +16

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, v(%RBP)

        MOV v(%RBP), %RDI       # indirizzo di v[]

        MOV (%RDI), %AL         # recupero v[0]
        MOV this(%RBP), %RSI    

        MOV %AL, (%RSI)         # a = v[0]

        INCB (%RDI)             # v[0]++ incremento postfisso

        MOV (%RDI, 1), %AL      # recupero v[1]

        MOV %AL, b(%RSI)

        MOVL $0, i(%RBP)

for:    CMPL $4, i(%RBP)
        JGE fine_for


        MOVSLQ i(%RBP), %RCX
        MOV (%RDI, %RCX), %AL            # recupero v[i]

        ADD a(%RSI), %AL                 # v[i] + a

        MOV %AL, vv1(%RSI, %RCX)         # s.vv1[i] = v[i] + a;

        MOVSBQ (%RDI, %RCX), %RAX        # recupero v[i]

        MOVSBQ b(%RSI), %RBX             # recupero b

        ADD %RAX, %RBX                   # v[i] + b

        MOV %RBX, vv2(%RSI, %RCX, 8)     # s.vv2[i] = v[i] + b


        INCL i(%RBP)
        JMP for

fine_for:

        LEAVE
        RET




.global _ZN2cl5elab1ER2sti
_ZN2cl5elab1ER2sti:

# struttura della classe
# //////       b->+1 a->+0
#               vv1[] ->+8
#               vv2[0]->+16
#               vv2[1]->+24
#               vv2[2]->+32
#               vv2[3]->+40

# struttura di st
#               vv1[] ->+0
#               vv2[0]->+8
#               vv2[1]->+16
#               vv2[2]->+24
#               vv2[3]->+32



#   i ->-20      d  ->-24
# indirizzo di ss   ->-16
#               this->-8

.set this, -8
.set ss, -16
.set i, -20
.set d, -24 # è un valore!!


        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, ss(%RBP)
        MOV %EDX, d(%RBP)

        MOVL $0, i(%RBP)

for2:   CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        MOV ss(%RBP), %RDI
        MOV 8(%RDI, %RCX, 8), %RAX  # ss.vv2[i]

        MOVSLQ d(%RBP), %RBX        # d

        CMP %RAX, %RBX
        JL fine_if

        MOV (%RDI, %RCX), %AL       # ss.vv1[i];

        MOV this(%RBP), %RSI

        ADD %AL, 8(%RSI, %RCX)       # s.vv1[i] += ss.vv1[i]; 

fine_if:
        MOV (%RSI), %AL             # a
        MOV d(%RBP), %BL

        ADD %AL, %BL

        MOVSBQ %BL, %RBX

        MOV %RBX, 16(%RSI, %RCX, 8)

        INCL i(%RBP)
        JMP for2

fine_for2:
        LEAVE
        RET


