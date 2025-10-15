.include "./files/utility.s" 

.data
mess_n:                 .ascii "Inserire n: \r"
mess_v1:                .ascii "Inserire vettore v1: \r"
mess_v2:                .ascii "Inserire vettore v2: \r"
mess_prodotto_scalare:  .ascii "Il prodotto scalare è: \r"

n:                  .byte 0
v1:                 .fill 255, 1, 0
v2:                 .fill 255, 1, 0
prodotto_scalare:   .long 0

.text
_main:
    nop
    mov $0, %eax

punto_1:
    lea mess_n, %ebx
    call outline
    call indecimal_byte
    call newline

    cmp $0, %al
    je fine
    
    mov %al, n

punto_2:
    lea mess_v1, %ebx
    call outline

    mov $0, %ecx    # indice v1
loop_write_v1:
    cmp n, %cl
    je loop_write_v1_fine

    call indecimal_byte
    mov %al, v1(%ecx)

    mov $'\t', %al
    call outchar

    inc %ecx
    jmp loop_write_v1

loop_write_v1_fine:
    call newline

punto_3:
    lea mess_v2, %ebx
    call outline

    mov $0, %ecx    # indice v2
loop_write_v2:
    cmp n, %cl
    je loop_write_v2_fine

    call indecimal_byte
    mov %al, v2(%ecx)

    mov $'\t', %al
    call outchar

    inc %ecx
    jmp loop_write_v2

loop_write_v2_fine:
    call newline

punto_4:
    mov $0, %ebx;  # accumulatore
    mov $0, %eax;

    mov $0, %ecx   # indice vettori
loop_prodotto_scalare:
    cmp n, %cl
    je loop_prodotto_scalare_fine

    mov v1(%ecx), %al
    mov v2(%ecx), %ah
    mul %ah        # ax = v1[i] * v2[i]
    add %eax, %ebx

    inc %ecx
    jmp loop_prodotto_scalare

loop_prodotto_scalare_fine:    
    mov %ebx, prodotto_scalare

stampa:
    lea mess_prodotto_scalare, %ebx
    call outline

    mov prodotto_scalare, %eax
    call outdecimal_long
    call newline

fine:
    ret
