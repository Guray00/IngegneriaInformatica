.include "./files/utility.s"

.data
msg_in: .ascii "Numero n:\r"
msg_big_endian: .ascii "Rappresentazione big-endian:\r"
msg_little_endian: .ascii "Rappresentazione little-endian:\r"
n: .long 0

.text
_main:
    nop
    
punto_1:
    lea msg_in, %ebx
    call outline

    call indecimal_long
    mov %eax, n
    call newline

punto_2:
    lea msg_big_endian, %ebx
    call outline
    // eax contiene la rappresentazione di n su 32 bit
    // stampa_bytes ne stampa i byte in ordine little-endian
    // dovendo stampare prima in big-endian, ne inverto prima l'ordine dei byte
    call inverti_endianness
    call stampa_bytes
    call newline

punto_3:
    lea msg_little_endian, %ebx
    call outline
    // per la stampa little-endian, mi basta recuperare la rappresentazione originale e chiamare stampa_bytes
    mov n, %eax
    call stampa_bytes
    call newline
fine:
    ret

// Sottoprogramma che stampa in notazione esadecimale, e separati da spazi, 
// i 4 byte contenuti in eax in ordine little-endian, 
// ossia partendo dal byte meno significativo e finendo con il più significativo.
stampa_bytes:
    push %eax
    push %ebx
    push %ecx

    mov $4, %ecx
stampa_bytes_loop:
    cmp $0, %ecx
    je stampa_bytes_loop_fine
    // l'attuale byte meno significativo è in al
    call outbyte
    mov %eax, %ebx
    mov $' ', %al
    call outchar
    mov %ebx, %eax
    dec %ecx
    // il seguente shift porta il prossimo byte da stampare in al
    shr $8, %eax
    jmp stampa_bytes_loop

stampa_bytes_loop_fine:
    pop %ecx
    pop %ebx
    pop %eax
    ret

// Sottoprogramma che inverte l'ordine dei byte contenuti in eax,
// ossia passando da una rappresentazione big-endian a una little-endian o viceversa
inverti_endianness:
    push %ebx
    # eax contiene i 4 byte di cui devo invertire l'ordine
    # la parte difficile è lavorare con la parte alta di eax, perché non può essere manipolata direttamente
    # sia eax = {x3, x2, x1, x0}; ora ax = {x1, x0}
    mov %eax, %ebx
    xchg %ah, %al
    shl $16, %eax
    # ora eax = { x0, x1, 16'b0 }
    shr $16, %ebx
    xchg %bh, %bl
    # ora ebx = { 16'b0, x2, x3 }
    mov %bx, %ax
    # ora eax = { x0, x1, x2, x3 }
    pop %ebx
    ret
