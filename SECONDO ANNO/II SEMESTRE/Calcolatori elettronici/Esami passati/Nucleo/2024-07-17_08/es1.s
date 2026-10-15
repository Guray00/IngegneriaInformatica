.global _ZN2cl5elab1ER2sti
.set vv2, 0 # scala 8, 4 elementi
.set vv1, 32 # scala 1, 4 elementi

.set this, 0 # puntatore
.set ss, -8 # puntatore a st ss
.set d, -16 # int, 4 byte, long

_ZN2cl5elab1ER2sti: nop 
prologo:
    push %rbp
    movq %rsp, %rbp
    subq $24, %rsp
parametri:
    movq %rdi, this(%rbp)
    movq %rsi, ss(%rbp)
    movslq %edx, %rax
    movq %rax, d(%rbp)
corpo:
for:
    xorq %rcx, %rcx
    movq this(%rbp), %rdi
    movq ss(%rbp), %rsi
    movq d(%rbp), %rdx
corpofor:
if:
    # // if (d > ss.vv2[i])
    cmpq %rdx, vv2(%rsi, %rcx, 8)
    jge fineif
corpoif:
	# s.vv1[i] += ss.vv1[i];
    movb vv1(%rsi, %rcx, 1), %al
    addb %al, vv1(%rdi, %rcx, 1)
fineif:
    # s.vv2[i] = d + i;
    movq d(%rbp), %rax
    addq %rcx, %rax
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
    |               |       int d   | -24
    ---------------------------------
    |             st*ss             | -16
    ---------------------------------
    |             this              | -8
    ---------------------------------
    |           old rbp             | 0
    ---------------------------------
*/
