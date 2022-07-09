.global _ZN2clC1E3st1
.text
.set v1, 0
.set v2, 4
.set v3, 8


#   i-20 st1 ss     -16  
#   THIS            -8
#   vecchio RBP     0

.set this, -8
.set ss, -16
.set i, -12


_ZN2clC1E3st1:

    PUSH %RBP
    MOVQ %RSP, %RBP
    SUBQ $16, %RSP

    MOVQ %RDI, this(%RBP)
    MOVL %ESI, ss(%RBP)

    MOVL $0, i(%RBP)

for:
    CMPL $4, i(%RBP)
    JGE fine_for

    MOVSLQ i(%RBP), %RCX
    LEA ss(%RBP), %RDI
    MOV (%RDI, %RCX, 1), %AL
    
    MOV this(%RBP), %RDX

    MOV %AL, v2(%RDX, %RCX, 1)
    MOV %AL, v1(%RDX, %RCX, 1)


    ADD %AL, %AL

    MOVSBQ %AL, %RAX
    MOV %RAX, v3(%RDX, %RCX, 8)


    INCL i(%RBP)
    JMP for

fine_for:

    LEAVE
    RET


.GLOBAL _ZN2clC1E3st1Pl


_ZN2clC1E3st1Pl:
.set this, -8
.set s1, -16
.set ar2, -24
.set i, -12


#
#   ar2 -24
#   st1 -16
#   i -12
#   this -8
    PUSH %RBP
    MOVQ %RSP, %RBP
    SUBQ $32, %RSP

    MOV %RDI, this(%RBP)
    MOV %ESI, s1(%RBP)
    MOV %RDX, ar2(%RBP)

    MOVL $0, i(%RBP)
for2:
    CMPL $4, i(%RBP)
    JGE fine_for

    MOVSLQ i(%RBP), %RCX
    LEA s1(%RBP), %RDI
    MOV (%RDI, %RCX), %AL

    MOV this(%RBP), %RDX

    MOV %AL, v2(%RDX, %RCX)
    MOV %AL, v1(%RDX, %RCX)
    

    MOV ar2(%RBP), %RSI
    MOV (%RSI, %RCX, 8), %RAX

    MOV %RAX, v3(%RDX, %RCX, 8)
    INCL i(%RBP)
    JMP for2

fine_for2:
    LEAVE
    RET

.global _ZN2cl5elab1EPc3st2

_ZN2cl5elab1EPc3st2:
.set indirizzo, -8
.set this, -16
.set ar1, -24
.set s2, -40
.set i, -44
.set s1, -48
.set cl, -88


    PUSH %RBP
    MOV %RSP, %RBP
    SUB $96, %RSP

    MOV %RDI, indirizzo(%RBP)
    MOV %RSI, this(%RBP)
    MOV %RDX, ar1(%RBP)
    MOV %RCX, s2(%RBP)
    MOV %R8,  s2+8(%RBP)

    MOVL $0, i(%RBP)
for3:
    CMPL $4, i(%RBP)
    JGE fine_for3
    MOVSLQ i(%RBP), %RCX

    MOV ar1(%RBP), %RDI
    MOVB (%RDI, %RCX), %AL

    LEA s1(%RBP), %RSI

    MOV %AL, (%RSI, %RCX)
    INCL i(%RBP)
    JMP for3
    
fine_for3:
    LEA cl(%RBP), %RDI
    MOV s1(%RBP), %ESI

    CALL _ZN2clC1E3st1
    MOVL $0, i(%RBP)
 
for4:
    CMPL $4, i(%RBP)
    JGE fine_for4
    
    MOVSLQ i(%RBP), %RCX

    LEA s2(%RBP), %RDI
    MOV (%RDI, %RCX, 4), %EAX

    LEA cl+8(%RBP), %RSI

    MOVSLQ %EAX, %RAX
    MOV %RAX, (%RSI, %RCX, 8)

    INCL i(%RBP)
    JMP for4 

fine_for4:

    LEA cl(%RBP), %RSI
    MOV indirizzo(%RBP), %RDI
    MOV $5, %RCX
    REP MOVSQ

    LEAVE 
    RET

    








