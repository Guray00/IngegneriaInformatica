.global _ZN2cl5elab1ER3st1R3st2
.set cla, -64
.set s2, -24
.set s1, -16
.set this, -8

.set s, 0
.set v, 8
_ZN2cl5elab1ER3st1R3st2:    nop
prologo:
    push %rbp
    movq %rsp, %rbp
    # spazio per cl     40 byte
    # spazio per st1&   8 byte
    # spazio per st2&   8 byte
    # spazio per this   8 byte
    # aggiungo 8 byte per mantenere l'allineamento a 16 byte di %rsp
    # prima di ogni call è opportuno che %rsp sia allineato a 16byte
    subq $72, %rsp
    movq %rdi, this(%rbp)
    movq %rsi, s1(%rbp)
    movq %rdx, s2(%rbp)
corpo:
costruttorecl:
    # passo parametri
    lea cla(%rbp), %rdi # indirizzo di costruzione cl (è il this per il costruttore)
    movb $'a', %sil # carattere a
    # s2 passato per valore, st2 è da 16 byte: %rdx e %rcx
    # in %rdx la prima parte della struttura, in %rcx la seconda
    movq s2(%rbp), %rax # indirizzo di s2
    movq (%rax), %rdx
    movq 8(%rax), %rcx
    # chiamo
    call _ZN2clC1Ec3st2

for:
    xorq %rcx, %rcx
    movq this(%rbp), %rdi
    movq %rbp, %rsi
    # addq $cla, %rsi # ora %rsi punta a cl cla
    subq $64, %rsi
corpofor:

if:
    # // if (this->s.vc[i] < s1.vc[i])
    movq s1(%rbp), %rax
    movb (%rax,%rcx,1), %al
    cmpb s(%rdi,%rcx,1), %al # cmp this, vc
    jle finefor
corpoif:
    # this->s.vc[i] = cla.s.vc[i];
    movb s(%rsi, %rcx, 1), %al
    movb %al, s(%rdi, %rcx,1)
    # this->v[i] = cla.v[i];
    movq v(%rsi, %rcx, 8), %rax
    movq %rax, v(%rdi, %rcx,8)

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
    |          padding              | -72
    ---------------------------------
    |            cla                | -64
    ---------------------------------
    |                               | -56
    ---------------------------------
    |                               | -48
    ---------------------------------
    |                               | -40
    ---------------------------------
    |                               | -32
    ---------------------------------
    |            *s2                | -24
    ---------------------------------
    |               *s1             | -16
    ---------------------------------
    |            this               | -8
    ---------------------------------
    |            old rbp            | 0
    ---------------------------------
*/
