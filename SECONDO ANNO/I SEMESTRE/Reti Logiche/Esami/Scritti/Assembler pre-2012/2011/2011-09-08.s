#############################################################
# Scrivere un programma Assembler che si comporta come segue:
# 
# 1) va a capo e richiede in ingresso un numero naturale N 
#    su 2 cifre in base 10
# 2) se N>20 o N<2, termina, altrimenti:
# 3) stampa su una nuova riga una griglia (2N-1)x(2N-1) di caratteri '.'
#    nella quale e' inscritto un rombo di lato N cosi' composto:
#    - le diagonali sono perpendicolari ai lati dello schermo 
#    - un vertice si trova sul lato sinistro dello schermo,
#    - i lati sono definiti dal carattere '*',
#    come nell'esempio sotto riportato, valido per N=4
# 4) torna al punto 1.
#
#...*...
#..*.*..
#.*...*.
#*.....*
#.*...*.
#..*.*..
#...*...
#
#############################################################


.GLOBAL _main

.DATA
blank: .FILL 37,1,'.'	# 37 caratteri '.'

.TEXT

_main:		NOP
		MOV $blank, %EBX

punto1:		CALL newline
		MOV $2, %CX
		CALL inDANB16_eco
		
punto2:		CMP $20, %AX
		JA fine
		CMP $2, %AX
		JB fine

punto3:		CALL newline
		MOV $0, %DX
		MOV %AX, %CX
		DEC %CX

ciclomeno:	CALL stampariga
		ADD $2, %DX
		DEC %CX
		JNZ ciclomeno

ciclopiu:	CALL stampariga
		SUB $2, %DX
		INC %CX
		CMP %AX, %CX
		JNE ciclopiu

punto4:		JMP punto1

fine:		RET


# subroutine "stampariga"
# stampa:
# - N caratteri da un buffer ed un '*'
# - (se M <> 0), M-1 caratteri da un buffer ed un '*'
# - N caratteri da un buffer
# in: N -> CX,  M-> DX, indirizzo buffer-> %EBX

stampariga:	PUSH %AX
		PUSH %CX
		CALL outmess 
		MOV $'*', %AL
		CALL output
		CMP $0, %DX
		JE fineriga
		MOV %DX, %CX
		DEC %CX
		CALL outmess 
		CALL output
fineriga:	POP %CX
		CALL outmess 
		CALL newline
		POP %AX
		RET


.INCLUDE "C:/GAS/utility" 
