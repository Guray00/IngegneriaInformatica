.include "./files/utility.s"

.data
buffer:	    .fill 10, 1

.text
_main:     
	nop

#punto 1
	mov $10, %ecx
	lea buffer, %ebx
ingresso:	
	call indigit
	call outchar
	mov %al, (%ebx)
	inc %ebx
	loop ingresso
	call newline

	lea buffer, %ebx	#ebx punta al primo elemento del buffer
	mov $0, %esi	    #esi contiene l'indice del primo elemento da stampare

comandi:	
	call inchar
	cmp $'q', %al
	je sinistra
	cmp $'w', %al
	je destra
	cmp $'e', %al
	je swap
	cmp $'z', %al
	je fine
	jmp comandi
	
sinistra:	
	cmp $9, %esi
	je reset_s
	inc %esi
	jmp stampa
reset_s:		
	mov $0, %esi
	jmp stampa

destra:
	cmp $0, %esi
	je reset_d
	dec %esi
	jmp stampa
reset_d:
	mov $9, %esi
	jmp stampa

swap:
	add $5, %esi
	cmp $10, %esi
	jae reset_swap
	jmp stampa
reset_swap:
	sub $10, %esi
	jmp stampa

stampa:
	mov %esi, %edi
	mov $10, %ecx
scrivi:
	mov (%ebx, %edi), %al
	call outchar
	cmp $9, %edi
	je resetp
	inc %edi
	jmp chiudi
resetp:
	mov $0, %edi
chiudi:
	loop scrivi
	call newline
	jmp comandi

fine:
	ret

indigit:
	call inchar
	cmp $'0', %al
	jb indigit
	cmp $'9', %al
	ja indigit
	ret
