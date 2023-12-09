.include "./files/utility.s"

.text
_main:     
    nop

punto1:
    mov $0, %ebx
    
    mov $6, %ecx
ingresso:
    mov $0, %eax
    call indigit
    xchg %eax, %ebx
    mov $7, %dx
    mul %dx
    shl $16, %edx
    mov %ax, %dx
    add %edx, %ebx
    loop ingresso

stampa:
    mov %ebx, %eax
    call newline
    call outdecimal_long
    call newline

    cmp $0, %eax
    je fine
    call newline
    jmp punto1

fine:
    ret

indigit:
    call inchar
    cmp $'0', %al
    jb indigit
    cmp $'6', %al
    ja indigit
    call outchar
    sub $'0', %al
    ret
