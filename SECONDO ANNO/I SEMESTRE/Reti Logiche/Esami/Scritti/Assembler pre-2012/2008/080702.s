# Scrivere un programma assembler che si comporta come segue
#  1) Emette un punto interrogativo e richiede in ingresso, effettuando gli 
#     opportuni controlli, un numero naturale X di 2 cifre in base 12, 
#     con eco sullo schermo
#  2) Se X e' non nullo e <= 20(b12), allora stampa un triangolo isoscele 
#     i cui lati obliqui sono costituiti da X caratteri "+", altrimenti termina
#  3) ritorna al punto 1
#
#
# Esempio:
# ?04
#     +
#    + +
#   +   +
#  +++++++
#
# ?06
#      +
#     + +
#    +   +
#   +     +
#  +       +
# +++++++++++
#
# ?01
# +
#




spazi:    .FILL 43,1,' '    #vettore di 43 spazi bianchi consecutivi
segni:    .FILL 47,1,'+'    #vettore di 47 segni '+' consecutivi

_main:     NOP
inizio:	   CALL newline
           MOV  $'?',%AL 
           CALL output

# punto 1
# alla fine DX contiene il numero X convertito in base 2

	    MOV $0,%EAX
	    MOV $12, %DX
	    CALL ingresso
	    MUL %DL
	    MOV  %AX, %DX
	    CALL ingresso
	    MOV $0, %AH
	    ADD %AX, %DX

	    CMP $0, %DX
	    JE fine
	    CMP $24, %DX
	    JA fine

# DX contiene il numero di righe da stampare
# AX contiene il contatore della riga corrente

	    CALL newline
	    MOV $spazi, %EBX
	    MOV $1, %AX

nuovariga:  CMP %DX, %AX
	    JE ultima

#stampa di una riga intermedia

	    MOV %DX, %CX
	    SUB %AX, %CX
	    CALL outmess

	    PUSH %AX
	    MOV $'+', %AL
            CALL output
	    POP %AX

	    CMP $1, %AX
	    JE fineriga

	    MOV %AX, %CX
	    SUB $1, %CX
	    SHL %CX
	    SUB $1, %CX
	    CALL outmess
	    
	    PUSH %AX
	    MOV $'+', %AL
            CALL output
	    POP %AX

fineriga:   INC %AX
	    CALL newline
	    JMP nuovariga


#stampa dell'ultima riga

ultima:	    MOV $segni, %EBX
	    MOV %DX, %CX
	    SHL %CX
	    DEC %CX
	    CALL outmess

	    CALL newline
	    CALL newline
            JMP inizio

fine:	    RET


	


# sottoprogramma che legge una cifra in base 12 e la mette in %AL

ingresso:   CALL input
            CMP  $'0',%AL
            JB   ingresso
            CMP  $'B',%AL
            JA   ingresso
            CMP  $'9',%AL
            JBE  cifra_OK
            CMP  $'A',%AL
            JB   ingresso
cifra_OK:   CALL output
            CALL HA1B4        # Converte la cifra da ASCII in binario
	    RET


.INCLUDE "C:/GAS/utility" 
