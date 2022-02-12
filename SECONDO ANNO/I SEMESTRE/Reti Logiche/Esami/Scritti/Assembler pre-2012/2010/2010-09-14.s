#############################################################
# Scrivere un programma Assembler che si comporta come segue:
# 1) definisce una matrice di 4x4 locazioni da un byte
#    inizializzate a zero
# 2) accetta in ingresso una coppia di COORDINATE. 
#    Le coordinate sono date da una *lettera maiuscola*,
#    ed una cifra in base 10. La lettera individua la colonna,
#    il numero individua la riga. La entry (1,1) della matrice 
#    ha coordinate A0, la (1,2) ha coordinate B0 e così via.
#    Si controlli che in input possano essere inseriti solo una 
#    lettera maiuscola ed una cifra decimale.
# 3) Se le coordinate sono entro il range della matrice 4x4, viene 
#    aggiunto uno alla locazione corrispondente, si va a capo
#    e si torna al punto 2. 
# 4) Altrimenti il programma stampa su una nuova riga 
#    il carattere '>' seguito dalle coordinate della locazione
#    che contiene il valore massimo e termina.
#
#############################################################


.GLOBAL _main

.DATA

matrice:	.FILL 16,1,0
finito:		.BYTE 0
indice:		.BYTE 0

.TEXT

_main:		NOP


punto2:	MOV $0, %EAX
		MOVB $0, finito
		CALL input
		CMP $'A', %AL
		JB punto2
		CMP $'Z', %AL
		JA punto2
		CALL output
		CMP $'D', %AL
		JBE letteraok
		ADDB $1, finito


letteraok:	SUB $'A', %AL
		MOV $0, %EBX
		MOV %AL, %BL

in_numero:		CALL input
		CMP $'0', %AL
		JB in_numero
		CMP $'9', %AL
		JA in_numero
		CALL output
		CMP $'3', %AL
		JBE numerook
		ADDB $1, finito

numerook:	SUB $'0', %AL
		MOV %EAX, %ESI
		CALL newline

		CMPB $0, finito
		JNE punto4
		

punto3:		INCB matrice(%EBX,%ESI,4)
		JMP punto2

		
punto4:	MOV $0, %AL
		MOV $0, %EBX
		MOV $16, %CL
itera:	CMP matrice(%EBX), %AL
		JAE minore
		MOV %BL, indice
		MOV matrice(%EBX), %AL
minore:	INC %EBX
		DEC %CL
		JNZ itera
		

		MOV $'>',%AL
		CALL output
		MOV indice, %AL
		AND $0x03, %AL
		ADD $'A', %AL
		CALL output
		MOV indice, %AL
		SHR $2, %AL
		AND $0x03, %AL
		ADD $'0', %AL
		CALL output
		
	
		RET

.INCLUDE "C:/GAS/utility" 
