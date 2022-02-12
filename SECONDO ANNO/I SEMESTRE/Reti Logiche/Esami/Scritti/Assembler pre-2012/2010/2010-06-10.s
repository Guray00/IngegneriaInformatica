#######################################################################################
#
# Scrivere un programma in Assembler che svolge i seguenti compiti
# 1) richiede in ingresso un numero naturale X in base 16 a una cifra,
#    svolgendo gli opportuni controlli
# 2) se X=0 termina, altrimenti
# 3) stampa le prime X righe del triangolo di Tartaglia (v.sotto)
# 4) ritorna al punto uno
#
# Il triangolo di Tartaglia e' caratterizzato dalle seguenti
# proprieta'. Detto a(i,j) l'elemento j-simo della riga i, con i,j>=1
# si ha che:
# a) la riga i ha i elementi
# b) per ogni i, a(i,1)=a(i,i)=1
# c) per ogni j>1, i>1, j<>i, a(i,j)=a(i-1,j)+a(i-1,j-1)
#
# Esempio:
#
# ?F
# 1
# 1 1
# 1 2 1
# 1 3 3 1
# 1 4 6 4 1
# 1 5 10 10 5 1
# 1 6 15 20 15 6 1
# 1 7 21 35 35 21 7 1
# 1 8 28 56 70 56 28 8 1
# 1 9 36 84 126 126 84 36 9 1
# 1 10 45 120 210 252 210 120 45 10 1
# 1 11 55 165 330 462 462 330 165 55 11 1
# 1 12 66 220 495 792 924 792 495 220 66 12 1
# 1 13 78 286 715 1287 1716 1716 1287 715 286 78 13 1
# 1 14 91 364 1001 2002 3003 3432 3003 2002 1001 364 91 14 1
#
#
#######################################################################################



riga_vecchia: 	.FILL 15,2
riga_nuova: 	.FILL 15,2

_main:  	NOP

punto1:		MOV $0, %EAX
		CALL newline
		MOV $'?', %AL
		CALL output
		CALL inHA1_eco
		CALL HA1B4
		CALL newline

punto2:		CMP $0,%AL
		JNE punto3
		RET

# ECX contiene il numero di righe da stampare

punto3:		MOV %EAX, %ECX
		MOV $2, %ESI

# inizializzo i due vettori in modo che contengano un "1" e 14 "0"

		MOVW $1, riga_nuova
		MOVW $1, riga_vecchia
ciclo_init:	MOVW $0, riga_nuova(%ESI)
		MOVW $0, riga_vecchia(%ESI)
		ADD $2, %ESI
		CMP $30,%ESI
		JNE ciclo_init

		MOV $riga_nuova, %EBX
		MOV $riga_vecchia, %EBP


# EDX contiene l'indice di riga corrente (i)
# ESI l'elemento corrente nella riga (j)

		MOV $0, %EDX

nuova_riga:	MOV $0, %ESI

# scambio le righe "vecchia" e "nuova", ed uso la riga "vecchia" per costruire la "nuova"
# EBX contiene l'indirizzo base della "nuova" riga

		XCHG %EBX, %EBP

ciclo_riga:	MOV %ESI, %EDI
		SHL %EDI

		CMP $0, %ESI
		JE stampa

		MOVW (%EBP,%EDI), %AX
		SUB $2, %EDI
		ADDW (%EBP,%EDI), %AX
		ADD $2, %EDI
		MOVW %AX, (%EBX,%EDI)

stampa:		MOVW (%EBX,%EDI), %AX
		CALL B16DAN_out
		MOV $' ', %AL
		CALL output

		INC %ESI
		CMP %ESI, %EDX
		JAE ciclo_riga

		CALL newline
		INC %EDX
		CMP %EDX, %ECX
		JA nuova_riga

punto4:		CALL newline
		JMP _main

.INCLUDE "C:/GAS/utility" 

