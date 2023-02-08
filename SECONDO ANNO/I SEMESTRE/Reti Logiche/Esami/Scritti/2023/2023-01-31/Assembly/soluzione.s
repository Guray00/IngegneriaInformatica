.include "./files/utility.s"

.global _main

.data

matrix:	.fill 16,1,0

.text

_main:		
        nop

punto2:		

input_letter:		
        call inchar
        cmp $0x0d, %al
        je punto4
		cmp $'a', %al
		jb input_letter
		cmp $'d', %al
		ja input_letter
		call outchar
		
        sub $'a', %al
		mov $0, %ebx
		mov %al, %bl

input_digit:
		call inchar
		cmp $'0', %al
		jb input_digit
		cmp $'3', %al
		ja input_digit
		call outchar
        
        sub $'0', %al
		mov %eax, %esi

        call newline

punto3:		
        incb matrix(%ebx,%esi,4)
		jmp punto2
		
punto4:	
        mov $0, %al
		mov $0, %ebx
		mov $16, %cl

punto4_loop:
        lea matrix(%ebx), %esi
		cmpb (%esi), %al
		ja not_new_max
new_max:        
		mov %bl, %dl
		mov (%esi), %al
not_new_max:		
        inc %ebx
		dec %cl
		jnz punto4_loop
		
punto4_loop_end:
        call newline
		mov %dl, %al
        and $0x03, %al
        add $'a', %al
		call outchar
		mov %dl, %al
		and $0x0c, %al
		shr $2, %al
        add $'0', %al
		call outchar
        call newline

fine:        		
		ret
