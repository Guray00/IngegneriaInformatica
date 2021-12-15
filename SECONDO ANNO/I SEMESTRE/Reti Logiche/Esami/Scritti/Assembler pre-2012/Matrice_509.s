#############################################################
#
#Scrivere un programma Assembler che si comporta come segue:                     #                                                           
#1.	definisce un vettore di memoria di 256 doppie locazioni inizializzate a # zero. Si assuma che il primo elemento del vettore abbia offset 0, il secondo 1, 
#         …, e l’ultimo 255.
#2.	accetta in ingresso (su righe separate e svolgendo gli opportuni 
#       controlli) coppie di numeri N, X in base 10, con:                   
#   i.	N: naturale su 3 cifre,                               
#  ii.	X: numero intero su 4 cifre in modulo e segno                      
#3.	se N >= 256 termina (NB: dopo aver letto anche X);
#4.	se N = 0, stampa su una nuova riga il numero di occorrenze del valore X 
#       nel vettore. 
#5.	altrimenti, setta ad X gli elementi del vettore di offset multiplo di N 
#       (cioè quelli di offset 0*N, 1*N, 2*N, … etc.);
#6.	stampa una riga vuota e ritorna al punto 2.

#############################################################


.GLOBAL _main

.DATA

vettore:	.FILL 256,2,0
N:		.WORD 0

.TEXT

_main:		NOP

punto2:		MOV $3, %CX
		CALL inDANB16_eco
		MOV %AX, N		
		CALL newline
		CALL leggi_ms	# risultato in AX

		CALL newline

		CMPW $256, N
		JAE fine 

		CMPW $0, N
		JE cerca

		MOV $0, %EBX
		XOR %ESI, %ESI
		MOV N, %SI		
		SHL %SI
		
accesso:	MOV %AX, vettore(%EBX)
		ADD %ESI, %EBX
		CMP $512, %EBX
		JB accesso
		
		CALL newline
		JMP punto2
		

cerca:		MOV $0, %EDI
		MOV $0, %DX

ciclo:		CMP vettore(,%EDI,2), %AX
		JNE falso
		INC %DX
falso:		INC %EDI		
		CMP $256, %EDI
		JNE ciclo

dopo:		MOV %DX, %AX
		CALL B16DAN_out
		CALL newline
		CALL newline
		JMP punto2
		
fine:		RET



################################################################
# sottoprogramma che accetta un intero a 4 cifre in modulo e segno
# OUTPUT:
# AX: numero in complemento a 2
################################################################


leggi_ms:	PUSH %CX
leggi_segno:	CALL input
		CMP $'+', %AL
		JE poi
		CMP $'-', %AL
		JNE leggi_segno
poi:		PUSH %AX
		CALL output
		MOV $4, %CX
		CALL inDANB16_eco
		POP %CX
		CMP $'+', %CL
		JE fine_leggi
		NEG %AX
fine_leggi:	POP %CX
		RET


.INCLUDE "C:/GAS/utility" 
