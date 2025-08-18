.include "./files/utility.s" 

.data
n: .byte 0

.text
_main:
    nop
    call indecimal_byte
    call newline
    inc %al # devo calcolare e stampare N+1 numeri
    mov %al, n
    mov %al, %cl
    sub $2, %cl # i 2 numeri di partenza non vanno calcolati 

    # F_0
    mov $0, %eax
    push %eax

    # F_1
    mov $1, %ebx
    push %ebx

loop_calcolo:
    cmp $0, %cl
    je loop_calcolo_fine
    call calcola_F_n
    push %ebx
    dec %cl
    jmp loop_calcolo

loop_calcolo_fine:
    mov n, %cl
loop_stampa:
    cmp $0, %cl
    je loop_stampa_fine
    pop %eax
    call outdecimal_long
    call newline
    dec %cl
    jmp loop_stampa

loop_stampa_fine:
    ret

# Sottoprogramma che calcola F_n,
# Prende in input F_{n-1} in %ebx e F_{n-2} in %eax
# Lascia in output F_{n} in %ebx e F_{n-1} in %eax
calcola_F_n:
    add %ebx, %eax
    xchg %eax, %ebx
    ret
