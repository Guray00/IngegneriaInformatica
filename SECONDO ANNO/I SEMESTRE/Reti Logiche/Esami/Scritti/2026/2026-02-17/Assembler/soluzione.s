.include "./files/utility.s"

.data
vector: .FILL 10,2,0   # 10 word (16 bit)

.text

_main:
    nop

main_loop:
    call inchar
    cmp $'w', %al
    je do_write
    cmp $'s', %al
    je do_swap
    cmp $'p', %al
    je do_print
    cmp $'q', %al
    je fine
    jmp main_loop

# --- WRITE: w i v ---
do_write:
    call outchar
    call print_space
    mov $0, %eax
    call indecimal_byte    # index -> %al
    mov %eax, %ecx        # index in ecx
    call print_space
    call indecimal_word    # value in ax
    cmp $9, %cl
    ja invalid_write
    lea vector, %ebx
    call write_v
    call newline
    jmp main_loop
invalid_write:
    call newline
    jmp main_loop

# --- SWAP: s i j ---
do_swap:
    call outchar
    call print_space
    mov $0, %eax
    call indecimal_byte   # first index -> %al
    mov %eax, %esi
    call print_space
    call indecimal_byte   # second index -> %al
    mov %eax, %edi
    cmp $9, %esi
    jae invalid_swap
    cmp $9, %edi
    jae invalid_swap
    lea vector, %ebx
    call swap_v
    call newline
    jmp main_loop
invalid_swap:
    call newline
    jmp main_loop

# --- PRINT: p ---
do_print:
    call outchar
    call newline
    lea vector, %ebx
    mov $10, %ecx
    call print_v
    jmp main_loop

fine:
    call outchar
    call newline
    ret

# Sottoprogramma per la stampa di uno spazio
print_space:
    push %eax
    mov $' ', %al
    call outchar
    pop %eax
    ret

# --- Sottoprogrammi richiesti ---
# write_v: ebx=indirizzo vettore, ax=valore, ecx=indice
write_v:
    mov %ax, (%ebx,%ecx,2)
    ret

# swap_v: ebx=indirizzo vettore, esi,edi=indici
swap_v:
    push %ax
    mov (%ebx,%esi,2), %ax
    xchg %ax, (%ebx,%edi,2)
    mov %ax, (%ebx,%esi,2)
    pop %ax
    ret

# print_v: ebx=indirizzo vettore, ecx=numero elementi
print_v:
    push %esi
    push %ecx
    push %ax
    mov %ebx, %esi
    cld
print_v_loop:
    cmp $0, %ecx
    je print_v_end
    lodsw
    call outdecimal_word
    call print_space
    dec %ecx
    jmp print_v_loop
print_v_end:
    call newline
    pop %ax
    pop %ecx
    pop %esi
    ret
