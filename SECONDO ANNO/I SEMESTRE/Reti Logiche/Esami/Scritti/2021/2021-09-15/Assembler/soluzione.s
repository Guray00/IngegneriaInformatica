.INCLUDE "C:/amb_GAS/utility" 
# .INCLUDE "./files/utility.s"

.data
stringa:	.FILL 82, 1
conteggi:	.FILL 16, 1

.text
_main:     
		nop

punto_1:		
		lea stringa, %ebx
		mov $80, %ecx
		call inline

		mov $16, %ecx
		lea conteggi, %edi
loop_azzera_conteggi:
		movb $0, (%edi)
		inc %edi
		loop loop_azzera_conteggi

		lea stringa, %esi
		lea conteggi, %edi
		mov $0, %eax
loop_lettura:
		movb (%esi), %al
		cmp $0x0d, %al
		je stampa_conteggi
		
cmp_09:
		cmp $'0', %al
		jb cmp_af
		cmp $'9', %al
		ja cmp_af
		sub $'0', %al
		jmp incrementa_conteggio

cmp_af: 
		cmp $'a', %al
		jb cmp_AF
		cmp $'f', %al
		ja cmp_AF
		sub $'a', %al
		add $10, %al
		jmp incrementa_conteggio

cmp_AF:
		cmp $'A', %al
		jb loop_lettura_fine
		cmp $'F', %al
		ja loop_lettura_fine
		sub $'A', %al
		add $10, %al
		jmp incrementa_conteggio

incrementa_conteggio:
		incb (%edi,%eax)	# AL contiene l'indice della cifra di cui incrementare il conto

loop_lettura_fine:
		inc %esi
		jmp loop_lettura

stampa_conteggi:
		mov $0, %bl			# fara' da flag. se vale 0, non si è stampato nulla
		lea conteggi, %esi
		mov $0, %ecx
loop_stampa_conteggi:
		movb (%esi), %dl
		cmp $0, %dl
		je loop_stampa_conteggi_fine
		inc %bl
		mov %cl, %al
		call stampa_carattere_hex
		mov $' ', %al
		call outchar
		mov %dl, %al
		call outdecimal_byte
		call newline

loop_stampa_conteggi_fine:
		inc %esi
		inc %ecx
		cmp $16, %ecx
		jb loop_stampa_conteggi

stampa_conteggi_fine:
		cmp $0, %bl
		je fine
		call newline
		jmp punto_1
		
fine:
		ret

# assume che AL contenga un numero a 0 a 15
# stampa quindi il carattere esadecimale corrispondente
stampa_carattere_hex:
		push %eax
		cmp $9, %al
		ja stampa_carattere_hex_af
		add $'0', %al
		jmp stampa_carattere_hex_fine
	
stampa_carattere_hex_af:
		sub $10, %al
		add $'a', %al

stampa_carattere_hex_fine:
		call outchar
		pop %eax
		ret
