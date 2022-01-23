#######################################################################################
#
# Scrivere un programma in Assembler che svolge i seguenti compiti
# 1) richiede in ingresso un numero intero x in base 10 a 5 cifre,
#    rappresentato in MODULO E SEGNO, svolgendo gli opportuni controlli,
#    ed assumendo che ABS(x) stia su 16 bit.
# 2) se ABS(x)=0 termina, altrimenti
# 3) stampa l'intervallo in cui sono compresi i numeri digitati finora,
#    sempre in modulo e segno.
# 4) ritorna al punto uno
#
#
# Esempio:
#
# ?F
# +00003
# [3 ; 3]
# ?-00005
# [-5 ; 3]
# ?+15305
# [-5 ; 15305]
#
#
#######################################################################################



min: 	.FILL 1,4
max: 	.FILL 1,4


_main:  	NOP

		MOVL $+65535, min
		MOVL $-65535, max
		
punto1:		CALL newline
		MOV $'?', %AL
		CALL output
ripeti:		CALL input
		CMP $'+', %AL
		JE ok
		CMP $'-', %AL
		JNE ripeti
ok:		CALL output
		MOV %AL, %BL
		MOV $5, %CX
		CALL inDANB16_eco
		CALL newline

punto2:		CMP $0,%AX
		JNE punto3
		RET

# min e max sono in complemento a due. Porto anche AX in complemento a 2

punto3:		PUSH %AX
		MOV $0, %EAX
		POP %AX
		CMPB $'-', %BL
		JNE poi
		NEG %EAX

poi:		CMP %EAX, max
		JGE no_max
		MOV %EAX, max

no_max:		CMP %EAX, min
		JLE stampa
		MOV %EAX, min
		
stampa:		MOV $'[', %AL
		CALL output
		MOV min, %EAX
		CALL C2_MS

		MOV $' ', %AL
		CALL output
		MOV $';', %AL
		CALL output
		MOV $' ', %AL
		CALL output
		
		MOV max, %EAX
		CALL C2_MS
		
		MOV $']', %AL
		CALL output
	
punto4:		CALL newline
		JMP punto1


# sottoprogramma che stampa un numero in EAX in C2 come modulo e segno

C2_MS:		PUSH %EAX
		PUSH %EBX
		MOV %EAX, %EBX
		CMP $0, %EBX
		JL negativo

		MOV %EBX, %EAX
		CALL B16DAN_out
		JMP fine

negativo:	MOV $'-', %AL
		CALL output
		MOV %EBX, %EAX
		NEG %EAX
		CALL B16DAN_out
		JMP fine

fine:		POP %EBX
		POP %EAX
		RET



.INCLUDE "C:/GAS/utility" 

