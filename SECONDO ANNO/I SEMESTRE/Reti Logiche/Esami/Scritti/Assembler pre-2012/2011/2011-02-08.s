##########################################
# Scrivere un programma Assembler che si comporta come segue:
# 1) accetta in ingresso da tastiera 16 numeri naturali in base 10 
#    su due cifre, che interpreta come gli 
#    elementi di una matrice 4x4 inseriti per riga
# 2) calcola la "norma-uno" della matrice, definita come il MASSIMO 
#    delle somme per COLONNA degli elementi
# 3) stampa a video su una nuova riga la norma-uno
# 4) se la norma e' minore o uguale a cinque termina, altrimenti 
#    va a capo e ritorna al punto uno.
##########################################


.GLOBAL _main

.DATA

matrix: 	.FILL 16, 2
col_sum:	.FILL 4, 2
norm:		.WORD 0

.TEXT

_main:		NOP

		MOV $0, %ESI
		MOV $2, %CX

ingresso:	CALL inDANB16_eco
		MOV %AX, matrix(%ESI)
		CALL newline
		ADD $2, %ESI
		CMP $32, %ESI
		JB ingresso		


#EBX contiene l'indice di colonna, ESI quello di riga

		MOV $0, %EBX
nuova_col:	MOV $0, %ESI
		MOV $4, %CX
		MOV $0, %AX

somma_col:	ADD matrix(%EBX, %ESI), %AX
		ADD $8, %ESI
		DEC %CX
		JNZ somma_col

		MOV %AX, col_sum(%EBX)
		ADD $2, %EBX
		CMP $8, %EBX
		JB nuova_col

#col_sum contiene le quattro somme per colonna, delle quali adesso troviamo il massimo.
		
ciclo:		MOVW $0, norm
		MOV $0, %ESI

confronta:	MOV col_sum(%ESI), %AX
		CMP norm, %AX
		JBE fineciclo
		MOV %AX, norm

fineciclo:	ADD $2, %ESI
		CMP $8, %ESI
		JB confronta

norma:		MOV norm, %AX
		CALL B16DAN_out
		CALL newline
		
		CMPW $5, norm
		JA _main
		CALL pause
		RET

.INCLUDE "C:/GAS/utility"
