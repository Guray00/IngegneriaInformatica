.include "./files/utility.s" 

.data
b: .word 0
c: .word 0

l: .byte 0
r: .byte 0

.text

_main:
    nop

punto_1:
    call indecimal_word
    neg %ax
    mov %ax, b  # salva b come intero negativo 
    call newline
    
    call indecimal_word
    neg %ax
    mov %ax, c  # salva c come intero negativo
    call newline

punto_2:
    call indecimal_byte
    mov %ax, l
    call newline
    
    call indecimal_byte
    mov %ax, r
    call newline

punto_3:
    call stampa_intervallo

// se l'intervallo è di dimensione 1, la radice x_0 non è intera
    mov l, %al
    inc %al
    cmp %al, r
    je fine

// calcolo di m
    mov l, %al
    add r, %al
    rcr $1, %al

    mov %al, %bl    # m = (l + r)/2 in bl
    call calcola_f  # f(m) in eax
    
    cmp $0, %eax
    je radice_trovata
    jl radice_destra
    jmp radice_sinistra

radice_trovata:
    mov %bl, %al
    call outdecimal_byte
    call newline
    jmp fine

radice_destra:
    mov %bl, l
    jmp punto_3

radice_sinistra:
    mov %bl, r
    jmp punto_3

fine:
    ret

# stampa l'intervallo corrente
stampa_intervallo:
    mov $'[', %al
    call outchar
    mov l, %al
    call outdecimal_byte
    mov $',', %al
    call outchar
    mov $' ', %al
    call outchar
    mov r, %al
    call outdecimal_byte
    mov $']', %al
    call outchar
    call newline
    ret

# data la coordinata x salvata in bl, e i parametri b e c
# calcola f(x) = x^2 + b*x + c
# lascia il risultato in eax
calcola_f:
    push %ebx
    push %ecx
    push %edx

    mov %bl, %al
    mul %bl        # x^2 in ax
    mov $0, %ecx    
    mov %ax, %cx    # x^2 in ecx

    mov $0, %bh     # x in bx
    mov b, %ax
    imul %bx        # b*x in dx_ax
    shl $16, %edx
    mov %ax, %dx    # b*x in edx
    add %edx, %ecx  # x^2 + b*x in ecx

    mov c, %ax
    cwde
    add %ecx, %eax  # x^2 + b*x + c in eax

    pop %edx
    pop %ecx
    pop %ebx

    ret
