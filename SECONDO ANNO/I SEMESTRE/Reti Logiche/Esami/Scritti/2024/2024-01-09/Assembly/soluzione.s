.include "./files/utility.s" 

.data
msg_dentro: .ascii "dentro\r"
msg_fuori: .ascii "fuori\r"

.text

_main:
    nop

punto1:
    call inword
    call abs
    mov %ax, %cx    # cx contiene |x|
    call newline

    call inword
    call abs
    mov %ax, %dx    # dx contiene |y|
    call newline

punto2:
    // termina se (|x|, |y|) == (0, 0)
    cmp $0, %cx
    jne punto2_modulo
    cmp $0, %dx
    jne punto2_modulo

    jmp fine

punto2_modulo:
    cmp $500, %cx
    ja fine 
    cmp $500, %dx
    ja fine

punto3:
    add %cx, %dx    # dx contiene |x| + |y|
    cmp $128, %dx
    ja fuori
    # |x| + |y| <= 128
    cmp $64, %dx
    jb fuori
    # 64 <= |x| + |y| <= 128

dentro:
    lea msg_dentro, %ebx
    call outline
    jmp punto4

fuori:
    lea msg_fuori, %ebx
    call outline

punto4:
    call newline
    jmp punto1

fine:
    ret

// Interpretando ax come un numero intero, lo sostituisce con il suo valore assoluto
abs:
    cmp $0, %ax
    jge abs_fine
    neg %ax
abs_fine:
    ret
