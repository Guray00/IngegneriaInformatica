#######################################################################################
#
# Scrivere un programma in Assembler che svolge i seguenti compiti
# 1) richiede in ingresso due numeri naturali x ed Y in base 10, X a 6 cifre,
#    ed Y a una cifra, svolgendo gli opportuni controlli.
# 2) se Y=0 termina, altrimenti
# 3) esegue la *divisione in base 10* di X per Y, per passaggi successivi,
#    stampando i risultati intermedi come scritto nell'esempio sottostante.
# 4) ritorna al punto precedente
#
# NB: se il candidato svolge la divisione in base 2 senza scrivere i risultati
#     intermedi, l'esercizio viene considerato NULLO
#
#
# Esempio:
#
# X? 012594
# Y? 3
#
#  0/3: q=0, r=0
#  1/3: q=0, r=1
# 12/3: q=4, r=0
#  5/3: q=1, r=5
# 29/3: q=9, r=2
# 24/3: q=8, r=0
#
#
#######################################################################################

cifra_X: .FILL 1, 6
Y: .FILL 1, 1

_main:  NOP

punto1:		CALL newline
		MOV $'X', %AL
		CALL output
		MOV $'?', %AL
		CALL output
		MOV $6, %CX
		MOV $cifra_X, %EBX
		CALL leggi_cifre
		CALL newline

		MOV $'Y', %AL
		CALL output
		MOV $'?', %AL
		CALL output
		MOV $1, %CX
		MOV $Y, %EBX
		CALL leggi_cifre
		CALL newline

punto2:		CMP $0, Y
		JNE punto3
		RET


#ESI contiene la variabile per il ciclo. 


punto3:		MOV $0, %ESI
		MOVB $10, %BL
		MOV $0, %AL


ciclo:		MOV $0, %AH
		MUL %BL
		MOVB cifra_X(%ESI), %DL
		ADD %DL, %AL 

		PUSH %AX
			MOV $0, %AH
			CALL B16DAN_out
			MOV $'/', %AL
			CALL output
			MOV Y, %AL
			OR $0x30, %AL
			CALL output
			MOV $':', %AL
			CALL output
			MOV $' ', %AL
			CALL output
			MOV $'q', %AL
			CALL output
			MOV $'=', %AL
			CALL output
		POP %AX

		MOVB Y, %DL
		DIV %DL

		PUSH %AX
			OR $0x30, %AL
			CALL output
			MOV $',', %AL
			CALL output
			MOV $' ', %AL
			CALL output
			MOV $'r', %AL
			CALL output
			MOV $'=', %AL
			CALL output
		POP %AX

		MOV %AH, %AL

		PUSH %AX
			OR $0x30, %AL
			CALL output
		POP %AX

		CALL newline
		
		INC %ESI
		CMP $6, %ESI
		JNE ciclo

punto4:		JMP punto1


# sottoprogramma che legge CX cifre in base 10 e mette ciascuna cifra 
# in un vettore di indirizzo %EBX

leggi_cifre:   CMP   $0,%CX
               JE    fine
               PUSH  %CX
	       PUSH  %EBX
               PUSH  %AX
cicla:         CALL  inDA1_eco
	       CALL  HA1B4
               MOV   %AL,(%EBX)
	       INC   %EBX
               DEC   %ECX
               JNZ   cicla
               POP   %AX
               POP   %EBX
               POP   %CX
fine:          RET


.INCLUDE "C:/GAS/utility" 
