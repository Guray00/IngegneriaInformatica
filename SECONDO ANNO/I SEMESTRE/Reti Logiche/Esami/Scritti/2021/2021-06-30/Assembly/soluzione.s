

_main:		NOP
			XOR %ECX, %ECX
			CALL in_2_cifre
			MOV %AL, %AH
			CALL in_2_cifre
			MOV %AL, %CL

			CMP $3, %AH
			JB fine
			CMP $20, %AH
			JA fine
			CMP $3, %CL
			JB fine
			CMP $20, %CL
			JA fine
			
			MOV $'0', %AL
			CMP %CL, %AH
			JAE stampa
			MOV $'1', %AL

stampa:		CALL newline
			SUB $2, %CL
			CALL header
righe:		CALL line
			LOOP righe
			CALL header
			CALL newline
			JMP _main

fine:		RET

# sottoprogramma "in_2_cifre"
# legge due cifre decimali, effettuando i controlli, le stampa a video, e mette il risultato in %AL

in_2_cifre:		PUSH %BX
in_cifra_1:   	CALL inchar
				CMP $'9', %AL
				JA in_cifra_1
				CMP $'0', %AL
				JB in_cifra_1
				CALL outchar
				AND $0x0F, %AL
				MOV %AL, %BL
				SHL $3, %BL
				SHL %AL
				ADD %AL, %BL		# %BL contiene 10 x %AL
in_cifra_2:		CALL inchar
				CMP $'9', %AL
				JA in_cifra_2
				CMP $'0', %AL
				JB in_cifra_2
				CALL outchar
				AND $0x0F, %AL
				ADD %AL, %BL
				MOV %BL, %AL
				CALL newline
				POP %BX
				RET


# sottoprogramma "header"
# stampa una riga di %AH caratteri. Il codice ASCII del carattere stampato è contenuto in %AL

header:	 	PUSH %ECX
			XOR %ECX, %ECX
			MOV %AH, %CL
go:			CALL outchar
			LOOP go
			CALL newline
			POP %ECX
			RET

# sottoprogramma "line"
# stampa una riga di %AH caratteri. Il codice ASCII del primo/ultimo carattere stampato è contenuto in %AL
# i caratteri intermedi sono invertiti rispetto al primo/ultimo

line:	 	PUSH %ECX
			XOR %ECX, %ECX
			MOV %AH, %CL
			CALL outchar			#stampa il primo carattere
			XOR $0x01, %AL			#inverte l'ultimo bit di %AL (cambia '0' in '1' e viceversa)
			SUB $2, %ECX
go2:		CALL outchar
			LOOP go2
			XOR $0x01, %AL
			CALL outchar			#stampa l'ultimo carattere
			CALL newline
			POP %ECX
			RET

.INCLUDE "C:/amb_GAS/utility" 
