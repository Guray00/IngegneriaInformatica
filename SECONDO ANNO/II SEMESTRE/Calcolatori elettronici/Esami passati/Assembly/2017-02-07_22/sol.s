.global _ZN2clC1E3st1
_ZN2clC1E3st1:


# v3[0]->+4   v1[]->+0
# v3[2]->+12 v3[1]->+8
#            v3[3]->+16
#            v2[0]->+24
#            v2[1]->+32
#            v2[2]->+40
#            v2[3]->+48




# i->-12  ss.vi[]->-16     
#            this->-8   

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

    MOV vi(%RBP, %RCX), %AL             # ss.vi[i]

    MOV this(%RBP), %RDI

    MOV %AL, (%RDI, %RCX)               # v1[i] = ss.vi[i];

    MOVSBQ %Al, %RAX

    MOV %RAX, 24(%RDI, %RCX, 8)         # v2[i] = ss.vi[i];

    MOV vi(%RBP, %RCX), %AL             # ss.vi[i]

    SHL $2, %AL                         # 4 * ss.vi[i];

    MOVSBL %AL, %EAX

    MOV %EAX, 4(%RDI, %RCX, 4)          # v3[i] = 4 * ss.vi[i];

    INCL i(%RBP)
    JMP for
fine_for:
    LEAVE
    RET


.global _ZN2clC1ER3st1Pi
_ZN2clC1ER3st1Pi:

# v3[0]->+4   v1[]->+0
# v3[2]->+12 v3[1]->+8
#            v3[3]->+16
#            v2[0]->+24
#            v2[1]->+32
#            v2[2]->+40
#            v2[3]->+48

#                   i->-32
#       indirizzo ar2->-24
#        indirizzo s1->-16
#                this->-8

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
    MOV (%RSI, %RCX), %AL           # s1.vi[i];
    
    MOV this(%RBP), %RDI
    MOV %AL, (%RDI, %RCX)           # v1[i] = s1.vi[i]; 

    MOVSBQ (%RSI, %RCX), %RAX       # s1.vi[i];

    NEG %RAX                        # -s1.vi[i];

    MOV %RAX, 24(%RDI, %RCX, 8)

    MOV ar2(%RBP), %RSI             

    MOV (%RSI, %RCX, 4), %EAX       # ar2[i]

    MOV %EAX, 4(%RDI, %RCX, 4)      # v3[i] = ar2[i];

    INCL i(%RBP)
    JMP for2
fine_for2:

    LEAVE
    RET


.global _ZN2cl5elab1EPcRK3st2
_ZN2cl5elab1EPcRK3st2:

# v3[0]->+4   v1[]->-88
# v3[2]->+12 v3[1]->-80
#            v3[3]->-72
#            v2[0]->-64
#            v2[1]->-56
#            v2[2]->-48
#            v2[3]->-40
#    i->-28   st1->-32
#        rif.st2 ->-24 
# puntatore ar1[]->-16
#            this->-8  

.set indirizzo, -8
.set this, -16
.set ar1, -24
.set s2, -32
.set i, -36
.set s1, -40
.set cla, -96

    PUSH %RBP
    MOV %RSP, %RBP
    SUB $96, %SP

    MOV %RDI, indirizzo(%RBP)
    MOV %RSI, this(%RDI)
    MOV %RDX, ar1(%RBP)
    MOV %RCX, s2(%RBP)

    MOVL $0, i(%RBP)

for3:
    CMPL $4, i(%RBP)
    JGE fine_for3

    MOVSLQ i(%RBP), %RCX

    MOV ar1(%RBP), %RSI
    MOV (%RSI, %RCX), %AL

    SUB %CL, %AL

    MOV %AL, s1(%RBP, %RCX)


    INCL i(%RBP)
    JMP for3
fine_for3:

    MOV s1(%RBP), %ESI
    LEA cla(%RBP), %RDI
    CALL _ZN2clC1E3st1

    MOVL $0, i(%RBP)
for4:
    CMPL $4, i(%RBP)
    JGE fine_for4

    MOVSLQ i(%RBP), %RCX

    MOV s2(%RBP), %RSI
    MOV (%RSI, %RCX, 8), %RAX
    LEA cla(%RBP), %RDI

    MOV %EAX, 4(%RDI, %RCX, 4)

    INCL i(%RBP)
    JMP for4 

fine_for4:
    LEA cla(%RBP), %RSI
    MOV indirizzo(%RBP), %RDI
    MOV $5, %RCX
    REP MOVSQ

    LEAVE 
    RET



