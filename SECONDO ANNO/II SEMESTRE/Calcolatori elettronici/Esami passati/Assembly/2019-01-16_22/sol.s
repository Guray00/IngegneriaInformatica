.global _ZN2clC1EPKc3st2
_ZN2clC1EPKc3st2:

#   s.vc[]->0
#     v[0]->8
#     v[1]->16
#     v[2]->24
#     v[3]->32

#     i->-40  
#    s2->-32
#
#    c[]->-16
#   this->-8

.set this, -8
.set c, -16
.set s2, -32
.set i, -40

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $48, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, c(%RBP)
        MOV %RDX, s2(%RBP)
        MOV %RCX, s2+8(%RBP)

        MOVL $0, i(%RBP)
for:
        CMPL $4, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX

        MOV c(%RBP), %RSI
        MOV this(%RBP), %RDI

        MOV (%RSI, %RCX), %AL               # c[i]
        MOV %AL, (%RDI, %RCX)               # s.vc[i] = c[i]

        LEA s2(%RBP), %RSI
        MOV (%RSI, %RCX, 4), %EBX           # s2.vd[i]     
        MOVSBL %Al, %EAX

        ADD %EBX, %EAX                      # s2.vd[i] + s.vc[i]
        
        MOVSLQ %EAX, %RAX

        MOV %RAX, 8(%RDI, %RCX, 8)          # v[i] = s2.vd[i] + s.vc[i]

        INCL i(%RBP)
        JMP for


fine_for:
        LEAVE
        RET


.global _ZN2cl5elab1E3st13st2
_ZN2cl5elab1E3st13st2:

#   s.vc[]->-72
#     v[0]->-64
#     v[1]->-56
#     v[2]->-48
#     v[3]->-40

#          s2[]->-32
#
# i->-12   vc[]->-16
#          this->-8 MOV 

.set this, -8
.set s1, -16
.set i, -12
.set s2, -32
.set cla, -72

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $80, %RSP

        MOV %RDI, this(%RBP)
        MOV %ESI, s1(%RBP)
        MOV %RDX, s2(%RBP)
        MOV %RCX, s2+8(%RBP)

        LEA cla(%RBP), %RDI
        LEA s1(%RBP), %RSI
        MOV s2(%RBP), %RDX
        MOV s2+8(%RBP), %RCX

        CALL _ZN2clC1EPKc3st2

        MOVL $0, i(%RBP)
for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        LEA s1(%RBP), %RSI
        MOV (%RSI, %RCX), %AL               # s1.vc[i]

        MOV this(%RBP), %RDI
        MOV (%RDI, %RCX), %BL               # s.vc[i]

        CMP %BL, %AL
        JLE fine_if

        LEA cla(%RBP), %RSI
        MOV (%RSI, %RCX), %AL               # cla.s.vc[i]

        MOV %AL, (%RDI, %RCX)               # s.vc[i] = cla.s.vc[i];

fine_if:
        LEA cla(%RBP), %RSI
        MOV 8(%RSI, %RCX, 8), %RAX          # cla.v[i]
        MOV 8(%RDI, %RCX, 8), %RBX

        CMP %RBX, %RAX
        JL fine_if2
        LEA cla(%RBP), %RSI
        MOV this(%RBP), %RDI

        MOV 8(%RSI, %RCX, 8), %RAX          # cla.v[i]
        ADD %RAX, 8(%RDI, %RCX, 8)          # v[i] += cla.v[i];

fine_if2:
        INCL i(%RBP)
        JMP for2

fine_for2:
        LEAVE
        RET





