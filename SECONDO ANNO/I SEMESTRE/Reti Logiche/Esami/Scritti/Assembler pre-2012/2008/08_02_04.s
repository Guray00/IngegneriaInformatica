#----------------------------------------------------------------
#
# prova pratica Febbraio 2008 (2o appello)
#
#----------------------------------------------------------------

#Scrivere un programma assembler che si comporta come segue:
#
#1. legge da tastiera, effettuando gli opportuni controlli, un numero 
#   naturale A a 8 cifre in base 10
#2. se A e' nullo, termina, altrimenti:
#3. stampa A in tutte le basi da 2 a 16 su righe successive, 
#   premettendo a ciascuna sequenza di cifre la base cui si riferisce
#4. torna al punto 1.
#
#Esempio:
#?00065536
#2: 10000000000000000
#3: 10022220021
#4: 100000000
#5: 4044121
#6: 1223224
#7: 362032
#8: 200000
#9: 108807
#10: 65536
#11: 45269
#12: 31B14
#13: 23AA3
#14: 19C52
#15: 14641
#16: 10000

#----------------------------------------------------------------


A:		.FILL 1,4

_main:     	NOP

punto1:		CALL newline
		MOV $'?', %AL
		CALL output
		MOV $8, %CX
		CALL leggi_cifre
		CALL newline

		MOV %EAX, A
punto2:		CMP $0, %EAX
		JE fine_prog

# ESI contiene la base, CX il numero di cifre da stampare

punto3:		MOV $2, %ESI

ciclo_est:	CMP $16, %ESI
		JA punto1
		
		MOV %SI, %AX
		CALL B16DAN_out
		MOV $':', %AL
		CALL output
		MOV $' ', %AL
		CALL output
		MOV A, %EAX
		MOV $0, %EDX
		MOV $0, %CX

#mette nello stack le cifre di A in base SI, tramite divisioni successive

ciclo_int:	DIV %ESI
		PUSH %DX
		MOV $0, %EDX
		INC %CX
		CMP $0, %EAX
		JNE ciclo_int

ciclo_st:	POP %AX
		CALL B4HA1
		CALL output
		DEC %CX
		JNZ ciclo_st

		INC %SI
		CALL newline
		JMP ciclo_est


fine_prog:	RET


#sottoprogramma che legge CX cifre in base 10 e mette in EAX il risultato (se ci sta)

leggi_cifre:   CMP   $0,%CX
               JE    fine
               PUSH  %CX
               PUSH  %EDX
               PUSH  %ESI
               MOV   $10, %ESI  
               MOV   $0, %EAX
cicla:         MUL   %ESI
               PUSH  %EAX
               CALL  inDA1_eco
               MOV   %AL,%DL
               POP   %EAX
               AND   $0x0000000F,%EDX
               ADD   %EDX,%EAX
               DEC   %CX
               JNZ   cicla
               POP   %ESI
               POP   %EDX
               POP   %CX
fine:          RET


.INCLUDE "C:/GAS/utility" 
