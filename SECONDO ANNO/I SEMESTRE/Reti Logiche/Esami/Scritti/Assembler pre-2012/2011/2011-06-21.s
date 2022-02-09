#############################################################
# Scrivere un programma Assembler che si comporta come segue:
# 1) definisce una matrice di 5x5 naturali a 16 bit
#    inizializzati a zero
# 2) accetta in ingresso tre caratteri alfanumerici
#    cosi' composti:
#    - un COMANDO, scelto tra i caratteri: +, -, *, S
#    - una coppia di COORDINATE. 
#    Le coordinate sono date da una *lettera maiuscola*,
#    ed una cifra in base 10. La lettera individua la colonna,
#    il numero individua la riga. La entry (1,1) della matrice 
#    ha coordinate A0, la (1,2) ha coordinate B0 e così via.
#    Si controlli che in input possano essere inseriti *solo* 
#    un comando, una lettera maiuscola ed una cifra in base 10 
# 3) Se le coordinate sono fuori dal range della matrice, il 
#    programma termina. 
# 4) Altrimenti esegue il comando come segue, va a capo
#    e ritorna al punto 2
#    - "+": aggiunge 1 all'elemento alle coordinate fornite
#    - "-": sottrae 1 all'elemento alle coordinate fornite.
#	    Se il risultato e' <0, il numero resta pari a zero.
#    - "*": calcola il quadrato dell'elemento alle coordinate 
#           fornite, ove questo stia su 16 bit
#    - "S": stampa l'elemento alle coordinate fornite
#
#
#############################################################


.GLOBAL _main

.DATA

.set	N, 5
.set	Nquadro, N*N

matrice:	.FILL Nquadro,2,0
comando:	.BYTE 0
finito:		.BYTE 0
riga:		.BYTE 0
colonna:	.BYTE 0
elemento:	.WORD 0

.TEXT

_main:		NOP
		FINIT


punto2:		MOV $0, %EAX
		MOVB $0, finito


in_comando:	CALL input
		CMP $'+', %AL
		JE comando_ok
		CMP $'-', %AL
		JE comando_ok
		CMP $'*', %AL
		JE comando_ok
		CMP $'S', %AL
		JNE in_comando
comando_ok:	CALL output
		MOV %AL, comando

in_lettera:	CALL input
		CMP $'A', %AL
		JB in_lettera
		CMP $'Z', %AL
		JA in_lettera
		CALL output
		SUB $'A', %AL
		MOV %AL, colonna
		CMP $N, %AL
		JB in_numero
		ADDB $1, finito

in_numero:	CALL inDA1_eco
		SUB $'0', %AL
		MOV %AL, riga
		CMP $N, %AL
		JB punto3
		ADDB $1, finito

punto3:		CALL newline
		CMPB $0, finito
		JE punto4
		RET

#calcolo indice dell'elemento nel vettore in %EDX:
punto4:		MOV $0, %EAX
		MOV $0, %EBX
		MOV riga, %AL
		MOV $N, %BL
		MUL %BL
		ADD colonna, %AL
		MOV %EAX, %EDX

		CMPB $'S', comando
		JNE piu
		MOV matrice(,%EDX,2), %AX
		CALL B16DAN_out
		CALL newline
		JMP punto2

piu:		CMPB $'+', comando
		JNE meno
		ADDW $1, matrice(,%EDX,2)
		JMP punto2		

meno:		CMPB $'-', comando
		JNE per
		CMP $0, matrice(,%EDX,2)
		JE punto2
		SUBW $1, matrice(,%EDX,2)
		JMP punto2		

per:		MOV matrice(,%EDX,2)
		MULW matrice(,%EDX,2)
		MOV %AX, matrice(,%EDX,2)
		JMP punto2

.balign 16
.INCLUDE "C:/GAS/utility" 
