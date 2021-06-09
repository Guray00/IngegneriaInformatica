buffer:	    .FILL 10, 1

_main:     NOP

#punto 1
			MOV $10, %ECX
			LEA buffer, %EBX
ingresso:	CALL indigit
			CALL outchar
			MOV %AL, (%EBX)
			INC %EBX
			LOOP ingresso

			LEA buffer, %EBX	#EBX punta al primo elemento del buffer
			MOV $0, %ESI	    #ESI contiene l'indice del primo elemento da stampare

comandi:	CALL inchar
			CMP $'s', %AL
			JE sinistra
			CMP $'d', %AL
			JE destra
			CMP $'r', %AL
			JE reverse
			CMP $'q', %AL
			JE fine
			JMP comandi
			
sinistra:	CMP $9, %ESI
			JE resets
			INC %ESI
			JMP stampa
resets:		MOV $0, %ESI
			JMP stampa

destra:		CMP $0, %ESI
			JE resetd
			DEC %ESI
			JMP stampa
resetd:		MOV $9, %ESI
			JMP stampa

reverse:	MOV %EBX, %EDI
			MOV $10, %ECX
cicla:		PUSHW (%EDI)
			INC %EDI
			LOOP cicla
			MOV %EBX, %EDI
			MOV $10, %ECX
ricicla:	POP %AX
			MOV %AL, (%EDI)
			INC %EDI
			LOOP ricicla
			
			#calcolo nuovo ESI
			CMP $0, %ESI
			JE fine_reverse
			MOV $10, %ECX
			SUB %ESI, %ECX
			MOV %ECX, %ESI

fine_reverse:
			JMP stampa


stampa:		CALL newline
			MOV %ESI, %EDI
			MOV $10, %ECX
scrivi:		MOV (%EBX, %EDI), %AL
			CALL outchar
			CMP $9, %EDI
			JE resetp
			INC %EDI
			JMP chiudi
resetp: 	MOV $0, %EDI
chiudi:		LOOP scrivi
			JMP comandi

fine:		RET

indigit:	CALL inchar
			CMP $'0', %AL
			JB indigit
			CMP $'9', %AL
			JA indigit
			RET

.INCLUDE "C:/amb_GAS/utility"
