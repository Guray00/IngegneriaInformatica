# Scrivere un programma Assembler che si comporta come segue:
# 1)	richiede in ingresso due numeri naturali A e B su 3 cifre in base 10, svolgendo gli opportuni controlli
# 2)	Se A oppure B non sono rappresentabili in base 2 su 8 bit, esce, altrimenti
# 3)	Moltiplica A per B secondo l’algoritmo spiegato sotto, stampando sia i risultati intermedi che quello finale, e ritorna al punto 1)
# 
# NB: se non vengono stampati i risultati intermedi, l’esercizio viene considerato nullo.
# 
# Algoritmo: al passo i viene calcolato il numero Pi come segue:  P0=A, P(i+1)=2*Pi,
# e si calcola  somma(0...7)[b(i)*P(i)], dove b(i) è la cifra i-sima della rappresentazione di B in base 2
# 
# Esempio
# A? 134
# B? 225
# i	P	b
# 0:	00134	1
# 1:	00268	0
# 2:	00536	0
# 3:	01072	0
# 4:	02144	0
# 5:	04288	1
# 6:	08576	1
# 7:	17152	1
# AxB:	30150	
####################################################



P: 	.FILL 1,2
B:	.FILL 1,2
result: .FILL 1,2


_main:  	NOP

		
punto1:		CALL newline
		MOV $'A', %AL
		CALL output
		MOV $'?', %AL
		CALL output
		MOV $3, %CX
		CALL inDANB16_eco
		MOV %AX, P

		CALL newline
		MOV $'B', %AL
		CALL output
		MOV $'?', %AL
		CALL output
		MOV $3, %CX
		CALL inDANB16_eco
		MOV %AX, B

		CALL newline

punto2:		CMPW $256,B
		JB ok1
		RET
ok1:		CMPW $256,P
		JB punto3
		RET


punto3:		MOVW $0, result
		MOV $0, %CL

ciclo:		CALL newline
		MOV %CL, %AL
		OR $48,%AL
		CALL output
		MOV $':', %AL
		CALL output
		MOV $' ',%AL
		CALL output

		PUSH %CX
		MOV $5, %CX
		MOV P, %AX
		CALL B16DAN_out

		MOV ' ',%AL
		CALL output

		MOV $0, %AX
		SHRW $1,B
		RCL $1,%AL
		MOV $1,%CX
		CALL B16DAN_out
		POP %CX

		CMP $0, %AX
		JE zero

		MOV P, %AX
		ADD %AX, result

zero:		SHLW $1,P
		INC %CL
		CMP $8, %CL
		JNE ciclo


		CALL newline
		MOV $'A', %AL
		CALL output
		MOV $'X', %AL
		CALL output
		MOV $'B',%AL
		CALL output
		MOV $':',%AL
		CALL output
		MOV $' ',%AL
		CALL output
		MOV $5, %CX
		MOV result, %AX
		CALL B16DAN_out
		CALL newline
		JMP punto1


.INCLUDE "C:/GAS/utility" 

