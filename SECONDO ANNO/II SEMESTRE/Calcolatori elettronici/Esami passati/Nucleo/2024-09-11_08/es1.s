.global _ZN2cl5elab1ER2sti
.set this, -8
.set ss, -16
.set d, -24

.set vv1, 0 # scala = 1aa
.set vv2, 8 # scala = 8
_ZN2cl5elab1ER2sti: nop
prologo:
    push %rbp
    movq %rsp, %rbp
    subq $24, %rsp
parametri:
    movq %rdi, this(%rbp) # puntatore this
    movq %rsi, ss(%rbp) # puntatore ss
    movslq %edx, %rax
    movq %rax, d(%rbp) # dato int d, # convertito a quad

corpo:

for:
    xorq %rcx, %rcx
    movq ss(%rbp), %rsi # rsi contiene l'indirizzo di ss
    movq this(%rbp), %rdi # rdi contiene il puntatore this
corpofor:
if:
# // if (d < ss.vv2[i])
    movq d(%rbp), %rax
    # cmpq d, ss.vv2[i]
    cmpq %rax, vv2(%rsi, %rcx, 8) # vv2( ss+8 + rcx*8)
    jle fineif
corpoif:
    # s.vv1[i] += ss.vv1[i]; 
    # addb ss.vv1[i], this->s.vv1[i]
    movb vv1(%rsi, %rcx, 1), %al
    addb %al, vv1(%rdi, %rcx, 1)
fineif:
# s.vv2[i] = d + i;
    movq d(%rbp), %rax
    addq %rcx, %rax
    # movq %rax, this->s.vv2[i]
    movq %rax, vv2(%rdi, %rcx, 8)

finefor:
    incq %rcx
    cmpq $4, %rcx
    jne corpofor

epilogo:
    leave
    ret

/*
    7   6   5   4   3   2   1   0
    ---------------------------------
    |                               | -40
    ---------------------------------
    |                               | -32
    ---------------------------------
    |               d               | -24
    ---------------------------------
    |             *ss               | -16
    ---------------------------------
    |             this              | -8
    ---------------------------------
    |           old rbp             | 0
    ---------------------------------
*/
