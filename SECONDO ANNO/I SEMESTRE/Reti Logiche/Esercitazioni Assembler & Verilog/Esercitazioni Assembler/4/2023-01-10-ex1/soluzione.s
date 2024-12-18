.include "./files/utility.s"

.data
x:  .word 0 # xh, xl
y:  .word 0 # yh, yl
z:  .long 0 

.text

_main:
    nop

    call indecimal_word
    movw %ax, x
    call newline

    call indecimal_word
    movw %ax, y
    call newline

    mov $0, %eax
    movw x, %ax
    movw y, %bx
    # al = xl, bl = yl
    mul %bl     
    # eax = xl * yl
    addl %eax, z

    mov $0, %eax
    movw x, %ax
    movw y, %bx
    shr $8, %bx
    # al = xl, bl = yh
    mul %bl     
    shl $8, %eax
    # eax = xl * yh * 8
    addl %eax, z

    mov $0, %eax
    movw x, %ax
    shr $8, %ax
    movw y, %bx
    # al = xh, bl = yl
    mul %bl    
    shl $8, %eax
    # eax = xh * yl * 8
    addl %eax, z

    mov $0, %eax
    movw x, %ax
    shr $8, %ax
    movw y, %bx
    shr $8, %bx
    # al = xl, bl = yl
    mul %bl     
    shl $16, %eax
    # eax = xh * yh * 16
    addl %eax, z

    movl z, %eax
    call outdecimal_long
    call newline
    ret
