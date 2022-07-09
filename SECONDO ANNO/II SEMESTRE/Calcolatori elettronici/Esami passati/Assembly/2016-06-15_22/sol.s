.global _ZN2clC1EcR3st1
_ZN2clC1EcR3st1:

#         s.vc[]->0
# v[1]->+12 v[0]->+8
# v[3]->+20 v[2]->+16




#      ind s2->-24    
# i->-12    c->-16
#        this->-8

.set this, -8
.set i, -12
.set c, -16
.set s2, -24

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $32, %RSP

        MOV %RDI, this(%RBP)
        MOV %SIL, c(%RBP)
        MOV %RDX, s2(%RBP)

        MOVL $0, i(%RBP)

for:    
        CMPL $8, i(%RBP)
        JGE fine_for

        MOVSLQ i(%RBP), %RCX            # i

        MOV c(%RBP), %AL                # c

        ADD %CL, %AL                    # c+i

        MOV this(%RBP), %RDI

        MOV %AL, (%RDI, %RCX)            # s.vc[i] = c + i;

        INCL i(%RBP)
        JMP for

fine_for:
        MOVL $0, i(%RBP)
for2:
        CMPL $4, i(%RBP)
        JGE fine_for2

        MOVSLQ i(%RBP), %RCX

        MOV s2(%RBP), %RSI
        MOVSBQ (%RSI, %RCX), %RAX       # s2.vc[i]

        MOVSBQ (%RDI, %RCX), %RBX       # s.vc[i];

        SUB %RBX, %RAX                  #  s2.vc[i] - s.vc[i];

        MOV %RAX, 8(%RDI, %RCX, 4)      # v[i] = s2.vc[i] - s.vc[i];

        INCL i(%RBP)
        JMP for2

fine_for2:
        LEAVE 
        RET



.global _ZN2cl5elab1E3st1R3st2
_ZN2cl5elab1E3st1R3st2:


#         s.vc[]->0
# v[1]->+12 v[0]->+8
# v[3]->+20 v[2]->+16

# ############################

#  cla    s.vc[]->-56
# v[1]->+12 v[0]->-48
# v[3]->+20 v[2]->-40
#      i->-32
#     s2->-24 [indirizzo]
#     s1->-16 [valore, non indirizzo]
#   this-> -8

.set this, -8
.set s1, -16
.set s2, -24
.set i, -32
.set cla, -56

        PUSH %RBP
        MOV %RSP, %RBP
        SUB $64, %RSP

        MOV %RDI, this(%RBP)
        MOV %RSI, s1(%RBP)
        MOV %RDX, s2(%RBP)

        LEA cla(%RBP), %RDI
        MOV $'f', %SIL
        LEA s1(%RBP), %RDX

        CALL _ZN2clC1EcR3st1

        MOVL $0, i(%RBP)

for3:   CMPL $4, i(%RBP)
        JGE fine_for3

        MOVSLQ i(%RBP), %RCX

        MOV s1(%RBP, %RCX), %AL         # s1.vc[i]

        MOV this(%RBP), %RDI

        MOV (%RDI, %RCX), %BL           # s.vc[i]

        CMP %AL, %BL
        JGE fine_if

        LEA cla(%RBP), %RSI

        MOV (%RSI, %RCX), %AL           # cla.s.vc[i]

        MOV %AL, (%RDI, %RCX)           # s.vc[i] = cla.s.vc[i];

fine_if:
        MOV 8(%RSI, %RCX, 4), %EAX      # cla.v[i]

        MOV 8(%RDI, %RCX, 4), %EBX      # v[i]


        CMP %EAX, %EBX
        JGE fine_if2

        ADD %ECX, %EAX                  # cla.v[i] + i

        MOV %EAX, 8(%RDI, %RCX, 4)      # v[i] = cla.v[i] + i

fine_if2:
        INCL i(%RBP)
        JMP for3

fine_for3:

        LEAVE
        RET







