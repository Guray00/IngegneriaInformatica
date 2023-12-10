.include "./files/utility.s"

.data
array: .fill 8,1,0
index: .long 0

.text
_main:
    nop
    
main_loop:
    call print
command_loop:
    call inchar
    cmp $'a', %al
    je move_left
    cmp $'d', %al
    je move_right
    cmp $'s', %al
    je main_end
    cmp $'0', %al
    jb command_loop
    cmp $'9', %al
    ja command_loop
    jmp write_number

move_left:
    mov index, %eax
    cmp $0, %eax
    je command_loop
    dec %eax
    mov %eax, index
    jmp main_loop

move_right:
    mov index, %eax
    cmp $7, %eax
    je command_loop
    inc %eax
    mov %eax, index
    jmp main_loop

write_number:
    sub $'0', %al
    lea array, %edi
    mov index,%ecx
    movb %al, (%edi,%ecx,1)
    jmp main_loop

main_end:
    mov $0, %al
    mov $0, %ecx
    lea array, %esi
sum_loop:
    cmp $8, %ecx
    jae sum_loop_end
    addb (%esi,%ecx,1), %al
    inc %ecx
    jmp sum_loop
sum_loop_end:
    call outdecimal_byte
    ret

print:
    push %eax
    push %ecx
    push %esi
    lea array, %esi
    mov $0, %ecx
print_loop:
    cmp $8, %ecx
    jae print_end
    cmp index, %ecx
    je print_selected
print_non_selected:
    movb (%esi,%ecx,1), %al
    call outdecimal_byte
    jmp print_loop_end
print_selected:
    movb $'(', %al
    call outchar 
    movb (%esi,%ecx,1), %al
    call outdecimal_byte
    movb $')', %al
    call outchar
    jmp print_loop_end
print_loop_end:
    inc %ecx
    jmp print_loop
print_end:
    call newline
    pop %esi
    pop %ecx
    pop %eax
    ret
