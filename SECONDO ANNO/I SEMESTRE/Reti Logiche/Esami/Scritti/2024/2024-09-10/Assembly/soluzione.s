.include "./files/utility.s" 

.data
x: .byte 0
y: .byte 0

mess_fine: .ascii "ERR\r"

.text
_main:
    nop

punto_1:
    call in_number
    mov %al, x

    mov $' ', %al
    call outchar

    call in_op
    mov %al, %bl

    mov $' ', %al
    call outchar

    call in_number
    mov %al, y

punto_2:
    call newline
    mov $'=', %al
    call outchar
    mov $' ', %al
    call outchar

    cmp $'+', %bl
    je do_sum

    cmp $'-', %bl
    je do_sub

    cmp $'*', %bl
    je do_mul

    cmp $'/', %bl
    je do_div

do_sum:
    mov y, %al
    cbw
    mov %ax, %bx
    mov x, %al
    cbw

    add %bx, %ax
    jmp fine_calcolo

do_sub:
    mov y, %al
    cbw
    mov %ax, %bx
    mov x, %al
    cbw

    sub %bx, %ax
    jmp fine_calcolo

do_mul:
    mov x, %al
    mov y, %bl

    imul %bl
    jmp fine_calcolo

do_div:
    mov x, %al
    cbw
    mov y, %bl

    cmp $0, %bl # la divisione per zero non è definita
    je fine

    idiv %bl    # lascia quoziente in AL e resto in AH
    cbw         # estendiamo il quoziente ad AX, per usare la stessa routine di output
    jmp fine_calcolo

fine_calcolo:
    # il risultato è in AX
    mov %ax, %bx
    cmp $0, %bx
    jl negativo
    jmp positivo
negativo:
    mov $'-', %al
    call outchar
    neg %bx
    jmp modulo
positivo:
    mov $'+', %al
    call outchar
    jmp modulo
modulo:
    mov %bx, %ax
    call outdecimal_word

    call newline
    call newline
    jmp punto_1

fine:
    lea mess_fine, %ebx
    call outline
    ret

# Legge un numero intero su 8 bit, costituito da segno (+ o -) seguito dal modulo (usando indecimal)
# Lo memorizza in AL
in_number:
loop_segno:
    call inchar
    cmp $'+', %al
    je in_number_positivo
    cmp $'-', %al
    je in_number_negativo
    jmp loop_segno

in_number_positivo:
    call outchar
    call indecimal_byte
    ret

in_number_negativo:
    call outchar
    call indecimal_byte
    neg %al
    ret

# Legge un carattere operazione, +, -, * o /
# Lascia il carattere in AL
in_op:
in_op_loop:
    call inchar
    cmp $'+', %al
    je in_op_fine
    cmp $'-', %al
    je in_op_fine
    cmp $'*', %al
    je in_op_fine
    cmp $'/', %al
    je in_op_fine
    jmp in_op_loop
in_op_fine:
    call outchar
    ret
