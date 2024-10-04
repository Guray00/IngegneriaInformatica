.include "./files/utility.s" 

.data
x:  .fill 8, 1, 0
y:  .fill 8, 1, 0
z:  .fill 8, 1, 0

.text
_main:
    nop

# ingresso dati

punto1:		
    lea x, %ebx
    call in8b8
    mov %dl, %dh
    call newline
    lea y, %ebx
    call in8b8
    call newline

    or %dl, %dh
    jnz fine

# ciclo di somma con riporto delle cifre, a partire dalle meno significative
			
punto2:		
    mov $7, %ecx
    mov $0, %dl			# DL contiene i riporti. Inizialmente il riporto entrante e' 0.
ciclo:		
    mov x(%ecx), %al
    mov y(%ecx), %ah
    call sumb8
    mov %al, z(%ecx)	
    sub $1, %ecx		# non DEC, perche' DEC non setta il carry
    jnc ciclo

# stampa del risultato a partire dalla cifra piu' significativa
			
    mov $0, %ecx
stampa:		
    mov z(%ecx), %al
    add $'0', %al
    call outchar
    inc %ecx
    cmp $8, %ecx
    jb stampa

    mov $' ', %al
    call outchar
    mov %dl, %al
    add $'0', %al
    call outchar
    call newline
    call newline
    jmp punto1
			
fine:
    ret

# =========== sottoprogramma incifrab8 =========== 
# richiede l'ingresso di una cifra in base 8 con eco sul terminale video
# out: AL, cifra digitata			
			
incifrab8:	call inchar
			cmp $'0', %al
			jb incifrab8
			cmp $'7', %al
			ja incifrab8
			call outchar
			sub $'0', %al
			ret

# =========== sottoprogramma in8b8 =========== 
# richiede l'ingresso di 8 cifre in base 8
# e le mette in memoria a partire dall'indirizzo contenuto in %EBX
# lascia DL a 1 se tutte le cifre inserite sono 0
# in: %EBX, puntatore a buffer di 8 byte
# out: DL, usato come zero flag 
# uses: incifrab8

in8b8:		push %ecx
			push %ax
			mov $0, %ecx
            mov $1, %dl
ciclo8:		call incifrab8
            mov %al, (%ecx, %ebx, 1)
			cmp $0, %al
            je ciclo8_post
            mov $0, %dl
ciclo8_post: 
            inc %ecx
			cmp $8, %ecx
			jne ciclo8
			
            pop %ax
			pop %ecx
			ret

# =========== sottoprogramma sumb8 =========== 
# somma due cifre in base 8, contenute in %AL ed %AH, 
# ed un riporto entrante in %DL, e mette la somma in %AL
# ed il riporto uscente in %DL
# in: AL, AH (cifre), DL (Cin)
# out: AL (risultato), DL (Cout)			
			
sumb8:		add %ah, %al
			add %dl, %al
			mov $0, %dl
			cmp $8, %al
			jb  finesumb8	
			sub $8, %al
			mov $1, %dl
finesumb8:	ret
