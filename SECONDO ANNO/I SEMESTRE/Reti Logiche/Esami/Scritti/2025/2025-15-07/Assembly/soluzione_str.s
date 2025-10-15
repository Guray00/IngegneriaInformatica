.include "./files/utility.s" 

# Questa soluzione utilizza le istruzioni stringa tramite un'allocazione efficiente dei vettori, ossia
# v1[0], v2[0], v1[1], v2[1], v1[2], v2[2], ...
# Così facendo, con una singla lodsw otteniamo entrambi gli operandi per il prodotto

.data
mess_n:                 .ascii "Inserire n: \r"
mess_v1:                .ascii "Inserire vettore v1: \r"
mess_v2:                .ascii "Inserire vettore v2: \r"
mess_prodotto_scalare:  .ascii "Il prodotto scalare è: \r"

n:                  .byte 0
vettori:            .fill 255, 2, 0
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

    lea vettori, %edi
    mov $0, %ecx    # indice v1
loop_write_v1:
    cmp n, %cl
    je loop_write_v1_fine

    call indecimal_byte
    mov %al, 0(%edi, %ecx, 2)   # Il byte v1[i] è a offset 0 dell'i-esima word

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
    mov %al, 1(%edi, %ecx, 2)   # Il byte v2[i] è a offset 1 dell'i-esima word

    mov $'\t', %al
    call outchar

    inc %ecx
    jmp loop_write_v2

loop_write_v2_fine:
    call newline

punto_4:
    mov $0, %ebx;  # accumulatore
    mov $0, %eax;

    lea vettori, %esi
    mov $0, %cl
loop_prodotto_scalare:
    cmp n, %cl
    je loop_prodotto_scalare_fine

    lodsw          # al = v1[i]; ah = v2[i]; i++;
    mul %ah        # ax = v1[i] * v2[i]
    add %eax, %ebx

    inc %cl
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
