.include "./files/utility.s" 

.data
n_0:    .byte   0
k:      .byte   0
msg_punto_3: .ascii "Numero iterazioni (k):\r"

.text
_main:
    nop
    
punto_1:
    call indecimal_byte
    movb %al, n_0
    movb $0, %ah    # ax = n_i
    call newline

punto_2:
    cmp $1, %ax
    je punto_3
    # safe guard: se k raggiunge il valore di soglia, qualcosa è andato storto
    cmpb $255, k
    je fine
    call compute_n_next
    call outdecimal_word
    call newline
    incb k
    jmp punto_2

punto_3:
    lea msg_punto_3, %ebx
    call outline
    movb k, %al
    call outdecimal_byte
    call newline

fine:
    ret

# Prende n_i in %ax e calcola n_{i+1}, lasciando il risultato di nuovo in %ax.
# Nota: questo perché, per dimensionamento dell'esercizio, tutti gli n_i stanno su 16 bit.
compute_n_next:
    shr %ax # CF = ax[0], ax = ax / 2
    jc compute_n_next_dispari
compute_n_next_pari:
    # ax contiene già il risultato
    ret
compute_n_next_dispari:
    push %dx
    rcl %ax # ax = ax*2, ax[0] = CF. Inverte lo shr precedente.
    mov $3, %dx
    mulw %dx    # dx_ax = 3 * ax, sappiamo per dimensionamento che dx = 0
    inc %ax
    pop %dx
    ret
