.include "./files/utility.s"

.data
a: .long 0
b: .word 0

abs_a: .long 0
abs_b: .word 0

sgn_a: .byte 0
sgn_b: .byte 0

sgn_q: .byte 0
sgn_r: .byte 0

abs_q: .word 0
abs_r: .word 0

q: .word 0
r: .word 0

msg_no_div: .ascii "NO DIV\r"

.text

_main:
    nop

    call inlong
    call newline
    mov %eax, a
    call inword
    call newline
    mov %ax, b

# calcolo modulo e segno degli input
calcolo_modulo_segno_a:
    mov $0, %bl
    mov a, %eax
    cmp $0, %eax
    jge a_positivo
a_negativo:
    neg %eax
    inc %bl
a_positivo:
    mov %eax, abs_a
    mov %bl, sgn_a

calcolo_modulo_segno_b:
    mov $0, %bl
    mov b, %ax
    cmp $0, %ax
    jge b_positivo
b_negativo:
    neg %ax
    inc %bl
b_positivo:
    mov %ax, abs_b
    mov %bl, sgn_b

# q è negativo solo se a e b sono discordi
calcolo_segno_q:
    mov $0, %bl
    add sgn_a, %bl
    add sgn_b, %bl
    # bl è 0 o 2 se a e b sono concordi, 1 altrimenti
    and $0x01, %bl     # resetta tutti i bit tranne il bit 0
    mov %bl, sgn_q

# r è negativo solo se a è negativo
calcolo_segno_r:
    mov sgn_a, %bl
    mov %bl, sgn_r

# si può calcolare abs_q e abs_r come risultato della divisione fra naturali abs_a e abs_b
# tale divisione si può calcolare come ciclo di sottrazioni
calcolo_div_naturali:
    mov abs_a, %eax
    mov $0, %ebx
    mov abs_b, %bx
    mov $0, %cx
loop_div:
    cmp %eax, %ebx
    jg fine_div
    sub %ebx, %eax
    add $1, %cx    # Uso la add perché la inc non setta CF
    jc no_div      # Se abs_q non sta su 16 bit, la divisione non è fattibile
    jmp loop_div
fine_div:
    mov %ax, abs_r
    mov %cx, abs_q

calcolo_q:
    mov abs_q, %ax
    mov sgn_q, %bl
    cmp $0, %bl
    je q_positivo
q_negativo:
    # Se l'intero q = -abs_q non sta su 16 bit, la divisione non è fattibile
    cmp $0x8000, %ax
    ja no_idiv
    neg %ax
    jmp calcolo_q_fine
q_positivo:
    # Se l'intero q = abs_q non sta su 16 bit, la divisione non è fattibile
    shl %ax
    jc no_idiv
    shr %ax
calcolo_q_fine:
    mov %ax, q

calcolo_r:
    mov abs_r, %ax
    mov sgn_r, %bl
    cmp $0, %bl
    je r_positivo
r_negativo:
    neg %ax
r_positivo:
    mov %ax, r    

stampa:
    mov q, %ax
    call outword
    call newline
    mov r, %ax
    call outword
    call newline
    jmp fine

no_div:
no_idiv:
    lea msg_no_div, %ebx
    call outline

fine:
    ret
