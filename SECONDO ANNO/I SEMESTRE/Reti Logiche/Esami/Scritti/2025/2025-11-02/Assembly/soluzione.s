.include "./files/utility.s"

.data
in_v:   .fill 6, 1, 0
out_v:   .fill 7, 1, 0

.text

_main:
    nop

punto_0:
    mov $' ', %al
    call outchar
    
punto_1:
    cld
    lea in_v, %edi
    mov $6, %ecx
ingresso:
    cmp $0, %ecx
    je ingresso_fine
    call indigit
    stosb
    dec %ecx
    jmp ingresso
ingresso_fine:
    call newline

punto_2:
    std
    lea in_v, %esi
    add $5, %esi
    lea out_v, %edi
    add $6, %edi
    mov $6, %ecx
    mov $0, %dl     # riporto entrante
ciclo_double:
    cmp $0, %ecx
    je ciclo_double_fine
    lodsb
    call double_base5
    stosb
    dec %ecx
    jmp ciclo_double
ciclo_double_fine:
    mov %dl, out_v  # riporto uscente

punto_3:
    cld
    lea out_v, %esi
    mov $7, %ecx
stampa:
    cmp $0, %ecx
    je fine
    lodsb
    call outdecimal_byte
    dec %ecx
    jmp stampa

fine:
    call newline
    ret

# Legge e fa eco di una cifra in base 5, lasciandone il valore in %al.
# Ignora caratteri inattesi.
indigit:
    call inchar
    cmp $'0', %al
    jb indigit
    cmp $'4', %al
    ja indigit
    call outchar
    sub $'0', %al
    ret

# Argomenti: una cifra x in base 5 in %al, un riporto entrante in %dl.
# Output: il risultato di x*2, come cifra in base 5 in %al e riporto uscente in %dl.
double_base5:
    shl %al
    add %dl, %al
    cmp $5, %al
    jae double_base5_carry
double_base5_no_carry:
    mov $0, %dl
    jmp double_base5_fine
double_base5_carry:
    sub $5, %al
    mov $1, %dl
    jmp double_base5_fine
double_base5_fine:
    ret
