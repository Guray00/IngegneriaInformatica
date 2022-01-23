##############################################################
#
# Scrivere un programma assembler che si comporta come segue:
# 1) richiede in ingresso due numeri naturali J e K a 5 cifre
#    in base 10 (assumendo che stiano su 16 bit)
# 2) se uno dei due numeri e' inferiore a 2, esce.
# 3) calcola se J e' uguale alla SOMMA DEI DIVISORI di K 
#    (da 1 incluso a K escluso) e viceversa, nel qual caso
#    stampa la stringa "AMICABILI" e va a capo.
# 4) ritorna al punto 1).
#
# NB: si assuma che la somma dei divisori stia su 16 bit.
#
# ESEMPIO:
# J? 00220
# K? 00284
# AMICABILI
# 
# J? 00220
# K? 00220
#
# J? 01184
# K? 01210
# AMICABILI
# 
# J? 02620
# K? 02924
# AMICABILI
#
##############################################################


.GLOBAL _main

.DATA 
J:		.WORD 1
K:		.WORD 1
somma_J:	.WORD 1
somma_K:	.WORD 1

stringa:	.ASCII "AMICABILI\n\r"
stringa_init:	.ASCII "J? K?"

.TEXT

_main:		NOP
punto1:		CALL newline
		MOV $stringa_init, %EBX
		MOV $3, %CX
		CALL outmess
		MOV $5, %CX
		CALL inDANB16_eco
		CALL newline
		MOV %AX, J
		ADD $3, %EBX
		MOV $3, %CX
		CALL outmess
		MOV $5, %CX
		CALL inDANB16_eco
		CALL newline
		MOV %AX, K

punto2:		CMPL $2, J
		JB fine
		CMPL $2, K
		JB fine


punto3:		MOV J, %AX
		CALL somma_div
		MOV %DX, somma_J

		MOV K, %AX
		CALL somma_div
		MOV %DX, somma_K

		CMP J, %DX
		JNE punto1
		
		MOV K, %AX
		CMP somma_J, %AX
		JNE punto1

		MOV $stringa, %EBX
		CALL outline
punto4:		JMP punto1

fine:		CALL pause
		RET


#sottoprogramma somma_div
#par ingresso: 	AX <- numero la somma dei cui divisori va calcolata, supposto >=2
#par uscita:	DX <- somma dei divisori di AX (se c'entra)

somma_div:	PUSH %BX
		PUSH %CX

		MOV $1, %CX		# contiene la somma dei divisori
		MOV $2, %BX		# contiene il divisore corrente

ciclo:		CMP %AX, %BX
		JE fineciclo
		
		PUSH %AX
		MOV $0, %DX
		DIV %BX
		CMP $0, %DX
		JNE dopo
		ADD %BX, %CX
dopo:		INC %BX
		POP %AX
		JMP ciclo
	
fineciclo:	MOV %CX, %DX

		POP %CX
		POP %BX
		RET


.INCLUDE "C:/GAS/utility"
