#----------------------------------------------------------------
#Scrivere un programma assembler che si comporta come segue:
#
#1. stampa un punto interrogativo e legge da tastiera una cifra decimale 
#2. se la cifra letta X e' uguale a 0 termina, altrimenti
#3. stampa un triangolo isoscele di base 2X, in cui la riga i-esima 
#   e' ottenuta stampando 2i-1 volte il carattere ASCII corrispondente 
#   al numero i, preceduto da un numero opportuno di spazi.
#4. ritorna al punto 1.
#
#Esempio:
#?5
#
#    1
#   222
#  33333
# 4444444
#555555555
#
#?3
#
#  1
# 222
#33333
#
#----------------------------------------------------------------

_main:     	NOP

punto1:		CALL newline
		MOV $'?', %AL
		CALL outchar
p1:		CALL inchar
		CMP     $'0',%AL
        JB      p1
        CMP     $'9',%AL
        JA      p1
        CALL    outchar
		MOV $0, %AH
		SUB $'0', %AL

punto2:		CMP $0, %AL
		JE fine

# SI contiene il numero di righe da stampare, e BX conta da 1 a SI
# CX viene inizializzato _prima_ al numero di spazi da stampare (SI-BX)
# e _poi_ al numero di cifre da stampare (2*BX-1), e viene decrementato ad ogni stampa
# AL contiene il codice ASCII dei caratteri da stampare (spazi prima, cifre poi) 

punto3:		MOV %AX, %SI
			MOV $1, %BX
		
riga:		CALL newline

spazi:		MOV %SI, %CX
			SUB %BX, %CX
			MOV $' ', %AL

ciclo_spazi:	CMP $0, %CX
		JE numeri
		CALL outchar
		DEC %CX
		JMP ciclo_spazi

numeri:		MOV %BX, %CX
		SHL $1, %CX
		DEC %CX

		MOV %BX, %AX

ciclo_numeri:	CALL outdecimal_tiny
		DEC %CX
		JNZ ciclo_numeri

		INC %BX
		CMP %BX, %SI		
		JAE riga

		CALL newline
		JMP punto1

fine:		RET


.INCLUDE "C:/amb_GAS/utility" 