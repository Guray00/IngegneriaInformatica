.include "./files/utility.s" 

.data

# up to 15 rows, last one has 15 numbers.
# highest natural is 3432, which fits in 16 bits and not 8
# at each iteration, we will use one as the old one, the other as the new one, then exchange roles for the next iteration  
row1: .fill 15, 2
row2: .fill 15, 2

n_rows:     .byte 0

.text

_main:	
    nop

punto1:
    call indecimal_byte
    call newline
punto2:
    and $0x0f, %al
    jz punto1
    mov %al, n_rows

punto3:
    call newline

    # esi will act as old row,
    # edi as the new row    
    lea row1, %esi
    lea row2, %edi
    
    # the two rows are initialized with 1 as their first number, and 0 everywhere else
    movw $1, (%esi)
    movw $1, (%edi)

    mov $1, %ecx
init_loop:	
    movw $0, (%esi,%ecx,2)
    movw $0, (%edi,%ecx,2)
    inc %ecx
    cmp $15,%ecx
    jne init_loop

    # edx will contain the current row (i)
    mov $0, %edx
    
rows_loop:	
    # first, we change the role of the two arrays in memory
    xchg %esi, %edi

    # ecx will contain the current element of the row (j)
    mov $0, %ecx
row_loop:
    # print current element 
    # at start it's 1, then its the result of previous computation
    movw (%edi, %ecx, 2), %ax
    call outdecimal_word
    mov $' ', %al
    call outchar

    # exit loop if we printed the last one
    cmp %ecx, %edx
    je row_loop_end
    
    # Else, compute next element and start again to print
    movw (%esi, %ecx, 2), %ax    # ax = (i-1, j-1)
    inc %ecx
    addw (%esi, %ecx, 2), %ax    # ax = (i-1, j-1) + (i-1, j)
    movw %ax, (%edi, %ecx, 2)    # (i, j) = (i-1, j-1) + (i-1, j)

    jmp row_loop

row_loop_end:
    call newline
    # exit loop if we printed all the rows, else start again for the next one
    inc %edx
    cmp %edx, n_rows
    jne rows_loop

punto4:
    ret
