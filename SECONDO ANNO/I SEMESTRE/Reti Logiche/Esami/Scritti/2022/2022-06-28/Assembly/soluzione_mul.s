.include "./files/utility.s"

.data
x: .long 0
n: .byte 0
radice_non_naturale_mess: .ASCIZ "RADICE NON NATURALE\r"

.text
_main:
    nop

    mov $0, %dl

    call indecimal_long
    call newline
    cmp $1, %eax
    ja x_fine
    mov $1, %dl
x_fine:
    mov %eax, x

    call indecimal_byte
    call newline
    cmp $1, %al
    ja n_fine
    or $1, %dl
n_fine:
    mov %al, n

    cmp $0, %dl
    je punto_3
    ret

punto_3:
    mov $2, %ebx    # candidata radice. 
                    # sta su 16 bit, ma ne usiamo 32 per la MUL.

# testa se ebx^n = x
radice_loop:
    mov %ebx, %eax
    mov $1, %cl

# calcola ebx^n
exp_loop:
    cmp n, %cl
    je exp_fine
    mul %ebx
    # se ebx^k > x, per k <= n, la radice non può essere naturale
    cmp $0, %edx
    jnz radice_non_naturale
    cmp x, %eax
    ja radice_non_naturale
    
    inc %cl
    jmp exp_loop 
    
exp_fine:
    cmp x, %eax
    je radice_fine

    inc %bx
    jmp radice_loop

radice_fine:
    mov %bx, %ax
    call outdecimal_word
    call newline
    ret

radice_non_naturale:
    lea radice_non_naturale_mess, %ebx
    call outline
    ret
