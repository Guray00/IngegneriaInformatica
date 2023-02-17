
.DATA
stringa:	.FILL 32, 1, 0
inversa:	.FILL 32, 1, 0
lunghezza:  .BYTE 0

a:	.BYTE 0
b:  .BYTE 0

non_palindroma:		.ASCII "NON PALINDROMA\r"
palindroma:			.ASCII "PALINDROMA\r"

.TEXT
_main:		NOP

punto1:    	
			LEA stringa, %EBX
			MOV $32, %ECX
			CALL inline

# Calcolo lunghezza della stringa inserita
			MOV $0, %AL
			LEA stringa, %ESI
lunghezza_loop:
			CMPB $0x0D, (%ESI)
			JE lunghezza_fine
			INC %AL
			INC %ESI
			JMP lunghezza_loop

lunghezza_fine:
			CMP $0, %AL
			JE termina
			MOV %AL, lunghezza

# Inversione stringa
            MOV $0, %ECX
			MOV lunghezza, %CL
			LEA stringa, %ESI
			LEA inversa, %EDI
			ADD %ECX, %EDI
			DEC %EDI
inverti_loop:
			MOV (%ESI), %AL
			MOV %AL, (%EDI)
			INC %ESI
			DEC %EDI
			LOOP inverti_loop

			CALL newline

punto2:
			CALL indecimal_byte
			MOV %AL, %BL
			CALL newline
			
			CALL indecimal_byte
			MOV %AL, %BH
			CALL newline

punto3:
			CMP %BL, %BH
			JBE termina

			CMP lunghezza, %BH
			JA termina

			MOVB %BL, a
			MOVB %BH, b

punto4:
# stampa sottostringa
			MOV	$0, %EAX
			MOVB a, %AL
			LEA stringa(,%EAX), %EBX
			MOV %EBX, %ESI	# ESI puntera' al prossimo carattere della sottostringa
			MOV $0, %ECX
			MOVB b, %CL
			SUBB a, %CL
			CALL outmess
			CALL newline

# stampa sottostringa inversa
			MOV $0, %EAX
			MOVB lunghezza, %AL
			SUBB b, %AL
			LEA inversa(,%EAX), %EBX
			MOV %EBX, %EDI	# EDI puntera' al prossimo carattere della sottostringa inversa
			CALL outmess
			CALL newline

# controllo palindromia
			CLD
			REPE CMPSB
			JNE non_palindroma_stampa

# senza instruzioni stringa
#palindromia_loop:
#			MOVB (%ESI), %AL
#			CMPB %AL, (%EDI)
#			JNE non_palindroma_stampa
#			INC %ESI
#			INC %EDI
#			LOOP palindromia_loop

palindroma_stampa:
			LEA palindroma, %EBX
			CALL outline
			JMP ripeti

non_palindroma_stampa:
			LEA non_palindroma, %EBX
			CALL outline

ripeti:
			CALL newline
			JMP punto2

termina:	RET

.INCLUDE "C:/amb_GAS/utility" 
