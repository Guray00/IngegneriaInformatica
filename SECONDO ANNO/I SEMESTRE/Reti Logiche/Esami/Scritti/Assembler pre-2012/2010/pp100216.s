########################################################
# Scrivere un programma Assembler che si comporta come segue:
# 1) accetta in ingresso un numero A a 5 cifre in base 2, 
#     (SVOLGENDO GLI OPPORTUNI CONTROLLI), che interpreta 
#    come la rappresentazione dell'intero a in C2 su 5 cifre
# 2) se a=0, termina, altrimenti
# 3) stampa su una nuova riga la seguente sequenza di simboli
#    <+++...+++>
#    <---...--->
#    dove il NUMERO di simboli stampati tra <> e' pari al
#    VALORE ASSOLUTO di a, mentre il simbolo da stampare
#    e'il SEGNO di a.
# 4) ritorna al punto 1
#
# Esempio
# ?01001
# <+++++++++>
#
# ?11001
# <------->
#
########################################################

.GLOBAL _main

.TEXT

_main:		NOP

#punto 1		
		CALL newline
		MOV $'?', %AL
		CALL output
		MOV $5, %CL
		MOV $0, %DL
ciclo_in:	CALL input
		CMP $'0', %AL
		JB ciclo_in
		CMP $'1', %AL
		JA ciclo_in
		CALL output
		SHR %AL
		RCL %DL
		DEC %CL
		JNZ ciclo_in

#punto 2
		CMP $0, %DL
		JE fine

#punto 3
		MOV $'+', %AL
		MOV %DL, %BL
		AND $0x10, %BL
		JZ positivo
		OR $0xF0, %DL
		NEG %DL
		MOV $'-', %AL

positivo:	CALL newline
		PUSH %AX
		MOV $'<', %AL
		CALL output
		POP %AX
		
ciclo:		CALL output
		DEC %DL
		JNZ ciclo

		MOV $'>', %AL
		CALL output
		CALL newline

#punto 4
		JMP _main

fine:		RET
		
.INCLUDE "C:/GAS/utility"
