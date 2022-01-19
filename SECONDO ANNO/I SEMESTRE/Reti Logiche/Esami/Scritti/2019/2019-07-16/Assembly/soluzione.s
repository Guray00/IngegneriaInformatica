# ===========================================================
# Scrivere un programma Assembler che si comporta come segue:
# 1. richiede in ingresso un numero decimale X, assumendo che stia su
#    16 bit.
# 2. Se X=0 termina, altrimenti
# 3. Stampa X in base 4 e ritorna al punto 1
#
# Es: 
# ?48
# 300
#
# ?65535
# 33333333
# ===========================================================


.TEXT
_main: 		NOP
punto1:		MOV $'?', %AL
			CALL outchar
			CALL indecimal_short
punto2:		CMP $0, %AX
			JE fine
punto3:		MOV $8, %CX
			MOV $0, %DL		#serve per non stampare zeri in cima al numero.
			MOV %AX, %BX
			CALL newline

# una cifra in base 4 Ã¨ data da due bit consecutivi della rappresentazione
# in base 2 del numero, che Ã¨ giÃ  contenuta in %BX.
# Quindi, per stampare il contenuto di BX in base 4 basta prenderne i bit a 
# due a due, partendo dai piÃ¹ significativi, metterli in AL e stamparli come cifra. 
			
ciclo:		MOV $0, %AL
			SHL %BX
			RCL %AL
			SHL %BX
			RCL %AL			#AL contiene la cifra in base 4 da stampare
			ADD %AL, %DL	#se DL>0 ho incontrato una cifra non zero.
			JZ dopo			#non stampo finchÃ© non ho trovato una cifra non zero
			CALL outdecimal_tiny
dopo:		DEC %CX
			JNZ ciclo
			
			CALL newline
			JMP punto1

fine:		RET
			
.INCLUDE "C:/amb_GAS/utility" 