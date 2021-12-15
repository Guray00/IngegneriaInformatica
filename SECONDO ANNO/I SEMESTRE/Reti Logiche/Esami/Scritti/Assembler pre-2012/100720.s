#######################################################################################
#
# Scrivere un programma in Assembler che svolge i seguenti compiti
# 1) richiede in ingresso un vettore di 10 numeri naturali 
#     in base 10 a due cifre,
#    svolgendo gli opportuni controlli
# 2) se tutti i numeri immessi sono nulli termina, altrimenti
# 3) ordina il vettore in senso crescente e lo stampa
# 4) ritorna al punto uno
#
# Esempio:
#
#? 31 05 43 15 41 97 54 34 71 05
#  05 05 15 31 34 41 43 54 71 97
#
#######################################################################################


vettore: 	.FILL 10,1

_main:  	NOP

punto1:		MOV $0, %EDI
		mov $0, %DL
		MOV $'?', %AL
		CALL output
		MOV $' ', %AL
		CALL output
		MOV $2, %ECX
ingresso:	CALL inDANB16_eco
		MOV %AL, vettore(%EDI)
		ADD %AL, %DL
		MOV $' ', %AL
		CALL output
		INC %EDI
		CMP $10, %EDI
		JNE ingresso

		CALL newline

punto2:		CMP $0,%DL
		JNE punto3
		RET

# uso bubblesort per ordinare il vettore. 
# Ciclo esterno: %ESI, da 10 a 1
# ciclo interno: %EDI, da 0 a %ESI
# se vett(%ESI)>vett(%ESI+1) scambio i due.


punto3:	 	MOV $9, %ESI
		MOV $1, %EBX	# costante, serve per puntare il prox elemento.
riparti:	MOV $0, %EDI 

itera_interno:	MOV vettore(%EDI), %AL
		CMP vettore(%EBX,%EDI), %AL
		JBE avanti
		XCHG vettore(%EBX,%EDI), %AL
		MOV %AL, vettore(%EDI)

avanti:		INC %EDI
		CMP %EDI, %ESI
		JNE itera_interno
		DEC %ESI
		CMP $1, %ESI
		JNE riparti		


stampa:		MOV $0, %EDI
		MOV $0, %AH
ciclostampa:	MOV vettore(%EDI), %AL
		CALL B16DAN_out
		MOV $' ', %AL
		CALL output
		INC %EDI
		CMP $10, %EDI
		JNE ciclostampa
		
punto4:		CALL newline
		JMP punto1

.INCLUDE "C:/GAS/utility" 

