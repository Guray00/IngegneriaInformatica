.include "./files/utility.s"

.text

_main:
    nop
# punto 1
    call indecimal_byte
    call newline
    mov %al, %bl
    call indecimal_byte
    call newline

punto_2:
    cmp $100, %al
    jae fine
    cmp $100, %bl
    jae fine

punto_3:
    cmp $50, %al
    jb punto_3_1
    sub $100, %al
punto_3_1:
    cmp $50, %bl
    jb punto_3_2
    sub $100, %bl
punto_3_2:
    imul %bl

punto_4:
    cmp $0, %ax
    jge punto_4_1
    add $10000, %ax
punto_4_1:
    call outdecimal_word
    call newline

fine:
    ret
