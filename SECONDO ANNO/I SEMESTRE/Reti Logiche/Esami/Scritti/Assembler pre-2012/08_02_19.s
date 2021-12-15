# Scrivere un programma in assembler che si comporta come segue:
# 1) richiede l'ingresso di due numeri naturali A e B a 7 
#    cifre in base 10, svolgendo gli opportuni controlli
# 2) stampa, *in maniera incolonnata e scrivendo  
#    correttamente i riporti sopra ciascuna coppia di cifre*,
#    la somma dei due numeri A e B, su 8 cifre in base 10
# 3) attende la pressione di un tasto e termina.
#
# NB: se non vengono stampati correttamente i riporti,
#     l'esercizio si considera ***non svolto***.

# Esempio:
# A? 9080952
# B? 3592532
#
#   10101000
#
#    9080952+
#    3592532=
#   -------- 
#   12673484


riporto: .FILL 8, 1
cifra_A: .FILL 8, 1
cifra_B: .FILL 8, 1
cifra_ris: .FILL 8, 1
riga:  .ASCII "--------"

#NB: A e B vengono estesi su 8 cifre, con la cifra piu' 
#    significativa uguale a 0, per comodita'


_main:  NOP

punto1:		CALL newline
		MOV $'A', %AL
		CALL output
		MOV $'?', %AL
		CALL output
		MOV $7, %CX
		MOVB $0, cifra_A
		MOV $cifra_A, %EBX
		INC %EBX
		CALL leggi_cifre
		CALL newline

		MOV $'B', %AL
		CALL output
		MOV $'?', %AL
		CALL output
		MOV $7, %CX
		MOVB $0, cifra_B
		MOV $cifra_B, %EBX
		INC %EBX
		CALL leggi_cifre
		CALL newline

#ESI contiene la variabile per il ciclo. 


punto2:		MOV $7, %ESI
		MOVB $0, riporto(%ESI)


ciclo:		MOV cifra_A(%ESI), %AL 
		ADD cifra_B(%ESI), %AL 
		ADD riporto(%ESI), %AL 

#faccio puntare EBX al successivo riporto
		MOV $riporto, %EBX
		ADD %ESI, %EBX
		SUB $1, %EBX

		CMPB $10, %AL
		JB no_rip
		
		SUB $10, %AL
		MOVB $1, (%EBX)
		JMP fine_ciclo


no_rip:		MOVB $0, (%EBX)

fine_ciclo:	MOV %AL, cifra_ris(%ESI)
		CMP $0, %ESI
		JE converti
		DEC %ESI
		JMP ciclo

converti:	MOV $0, %ESI
		
		
ri_ciclo:	MOV riporto(%ESI),%AL
		CALL B4HA1
		MOV %AL,riporto(%ESI)

		MOV cifra_A(%ESI),%AL
		CALL B4HA1
		MOV %AL,cifra_A(%ESI)

		MOV cifra_B(%ESI),%AL
		CALL B4HA1
		MOV %AL,cifra_B(%ESI)

		MOV cifra_ris(%ESI),%AL
		CALL B4HA1
		MOV %AL,cifra_ris(%ESI)
	
		INC %ESI
		CMP $8, %ESI
		JNE ri_ciclo		


stampa:		CALL newline
	        MOV  $riporto,%EBX
	        MOV  $8, %CX
	        CALL outmess
	        CALL newline
	        CALL newline
	        MOV $' ', %AL
		CALL output
	        MOV  $cifra_A,%EBX
		INC  %EBX
	        MOV  $7, %CX
	        CALL outmess
	        MOV $'+', %AL
		CALL output
	        CALL newline
	        MOV $' ', %AL
		CALL output
	        MOV  $cifra_B,%EBX
		INC  %EBX
	        MOV  $7, %CX
	        CALL outmess
	        MOV $'=', %AL
		CALL output
	        CALL newline
	        MOV  $riga,%EBX
	        MOV  $8, %CX
		CALL outmess
		CALL newline
	        MOV  $cifra_ris,%EBX
	        MOV  $8, %CX
	        CALL outmess
	        CALL newline

punto3:		CALL pause0

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


.INCLUDE "C:/GAS/utility" 
