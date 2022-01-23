#######################################################################################
#
# Scrivere un programma in Assembler che svolge i seguenti compiti
# 1) richiede in ingresso un numero intero x in base 10 a 5 cifre,
#    rappresentato in MODULO E SEGNO, svolgendo gli opportuni controlli,
#    e dando per scontato che ABS(x) stia su 16 bit.
# 2) se ABS(x)=0 termina, altrimenti
# 3) stampa la (parte intera della) MEDIA ARITMETICA dei numeri digitati finora,
#    sempre in modulo e segno.
# 4) ritorna al punto 1)
#
# 
#
# Esempio:
#
# ?+00003
# 3
# ?-00005
# -1
# ?+00012
# 3
#
#
#######################################################################################



somma: 	.FILL 1,4
enne: 	.FILL 1,4


_main:  	NOP

		MOVW $0, somma
		MOVW $0, enne
		
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

punto3:		PUSH %AX
		MOV $0, %EAX
		POP %AX
		INCL enne
		CMP $'-', %BL
		JNE positivo
		SUB %EAX, somma
		JMP stampa

positivo:	ADD %EAX, somma

stampa:		MOV somma, %EAX
		CDQ
		IDIVL enne
		CALL C2_MS
		
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

