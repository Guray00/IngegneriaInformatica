# si scriva un programma in linguaggio Assembler che:
# 1) richiede l'ingresso di due numeri naturali A e B a 5 
#    cifre in base 10, svolgendo gli opportuni controlli
# 2) applica l'algoritmo di somma e shift per calcolare 
#    iterativamente il prodotto P=AxB:
#    P(0)=0;   P(i+1)= b_i*10^i*A+P(i)
#    dove b_i e' la cifra di posto i del numero B
# 3) stampa tutti i numeri P(i), sotto l'ipotesi che A e B
#    siano rappresentabili su 16 bit.
# 4) attende la pressione di un tasto e termina.
#
# NB: se viene stampato solo il risultato finale
#     l'esercizio viene considerato NULLO.
#
#
# Esempio:
#
# A? 11130
# B? 00121
# P(0)=0
# P(1)=11130
# P(2)=233730
# P(3)=1346730
# P(4)=1346730
# P(5)=1346730
#



A: 		.FILL 1,2
cifra_B: 	.FILL 1,5
P:		.FILL 1,4
dieci:		.FILL 1,4

_main:  NOP

punto1:		CALL newline
		MOV $'A', %AL
		CALL output
		MOV $'?', %AL
		CALL output
		MOV $5, %CX
		CALL inDANB16_eco
		MOV %AX, A
		CALL newline

		MOV $'B', %AL
		CALL output
		MOV $'?', %AL
		CALL output
		MOV $5, %CX
		MOV $cifra_B, %EBX
		CALL leggi_cifre
		CALL newline


punto2:		MOVL $0, P
		MOV $cifra_B, %EBX
		ADD $4, %EBX
		MOV $0, %CL
		MOVL $1, dieci
		MOV $0, %EAX

ciclo:		MOV $'P', %AL
		CALL output
		MOV $'(', %AL
		CALL output
		MOV %CL, %AL
		ADD $'0', %AL
		CALL output
		MOV $')', %AL
		CALL output
		MOV $'=', %AL
		CALL output

		MOV P, %EAX
punto3:		CALL stampa_cifre
		CALL newline

		MOV $0, %EAX
		MOV A, %AX
		MULL dieci
		
		MOV $0, %EDX
		MOV (%EBX), %DL
		MUL %EDX

		ADD P, %EAX
		MOV %EAX, P


	
# calcola 10 alla %CL
		MOV dieci, %EAX
		MOV $10, %EDX
		MULL %EDX
		MOV %EAX, dieci

		DEC %EBX
		INC %CL
		CMP $5, %CL
		JBE ciclo

		CALL newline
punto4:		CALL pause
		RET



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



# sottoprogramma che stampa un numero in base 10  
# contenuto nel registro %EAX

stampa_cifre: 	PUSH  %EAX
		PUSH  %CX
	        PUSH  %EDX
		PUSH  %ESI

		MOV $0,%CL
		MOV $10, %ESI

ciclo_div:	MOV $0, %EDX
		DIV %ESI
		ADD $'0', %DL
		PUSH %DX
		INC %CL
		CMP $0, %EAX
		JE fuori
		JMP ciclo_div

fuori:		POP %AX
		CALL output
		DEC %CL
		JNZ fuori

		POP %ESI
		POP %EDX
		POP %CX
		POP %EAX
		RET



.INCLUDE "C:/GAS/utility" 
