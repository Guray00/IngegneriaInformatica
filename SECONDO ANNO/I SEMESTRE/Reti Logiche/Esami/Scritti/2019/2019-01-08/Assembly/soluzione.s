# =========================================================================
#
# Scrivere un programma che:
# 1. legge con eco da tastiera una stringa di max 20 caratteri
#   terminata da un ritorno carrello;
# 2. stampa la stringa sostituendo ogni cifra decimale
#   con il nome della cifra, contornato da uno o piu' spazi; es. la stringa
#     a12bc
#   viene stampata come
#     a uno     due     bc
# 3. se la stringa inserita conteneva almeno un numero torna al passo 1,
#   altrimenti termina.
# NB: Si consiglia di allineare tutte le stringhe da stampare sullo stesso numero di caratteri 
#     calcolato sul testo di lunghezza massima
# 

#############################
# soluzione uno, che ignora il consiglio
#############################

.DATA
zero:       .ASCII " zero "
uno:		.ASCII " uno "
due:		.ASCII " due "
tre:		.ASCII " tre "
quattro:    .ASCII " quattro "
cinque:		.ASCII " cinque "
sei:		.ASCII " sei "
sette:      .ASCII " sette "
otto:       .ASCII " otto "
nove:       .ASCII " nove "

numeri:     .LONG zero, uno, due, tre, quattro, cinque, sei, sette, otto, nove
lunghezze:  .BYTE 6, 5, 5, 5, 9, 8, 5, 7, 6, 6
stringa:	.FILL 22, 1

.TEXT
_main:     	NOP
punto1:		MOV $22, %CX
			LEA stringa, %EBX
			CALL inline

punto2:		MOV $0, %ESI
			MOV $0, %CX
			MOV $0, %DX
ciclo:		MOV $0, %EAX
			MOVB stringa(%ESI), %AL
			CMP $13, %AL
			JE  fineciclo
			CMP $'0', %AL
			JB niente
			CMP $'9', %AL
			JA niente
			MOV $1, %DX				# e' necessario tornare al punto 1 a fine ciclo
			SUB $'0', %AL
			MOVL numeri(,%EAX,4), %EBX
			MOVB lunghezze(%EAX), %CL
			CALL outmess
			JMP next
niente:		CALL outchar
next:		INC %ESI
			JMP ciclo

fineciclo:	CALL newline
			CMP $0, %DX
			JNE punto1
			XOR %EAX, %EAX
			RET
			
.INCLUDE "C:/amb_GAS/utility" 