# Scrivere un programma in assembler che si comporta come segue:
# 1) richiede l'ingresso di due numeri naturali A e B a 7 
#    cifre in base 10, svolgendo gli opportuni controlli
# 2) stampa, *in maniera incolonnata e scrivendo  
#    correttamente i prestiti sopra ciascuna coppia di cifre*,
#    la differenza dei due numeri A e B, su 7 cifre in base 10,
#    se questa e' un numero naturale. Se non lo e', svolge 
#    comunque i calcoli cifra per cifra e stampa un risultato, 
#    ma alla fine stampa il messaggio "non rappresentabile"
# 3) attende la pressione di un tasto e termina.
#
# NB: se non vengono stampati correttamente i prestiti,
#     l'esercizio si considera ***non svolto***.

# Esempio:
# A? 9080952
# B? 3592532
#
#   01110000
#
#    9080952-
#    3592532=
#   -------- 
#    5488420

# Esempio:
# A? 2080952
# B? 3592532
#
#   11110000
#
#    2080952-
#    3592532=
#   -------- 
#    8488420
#  non rappresentabile



prestito: .FILL 8, 1
cifra_A: .FILL 8, 1
cifra_B: .FILL 8, 1
cifra_ris: .FILL 8, 1
riga:  .ASCII "--------"
messaggio: .ASCII "non rappresentabile"

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
		MOVB $0, prestito(%ESI)


ciclo:		MOV cifra_B(%ESI), %AL 
		ADD prestito(%ESI), %AL 

#faccio puntare EBX al successivo prestito
		MOV $prestito, %EBX
		ADD %ESI, %EBX
		SUB $1, %EBX

		MOV cifra_A(%ESI), %DL
		CMP %DL, %AL
		JBE no_rip
		
		ADD $10, %DL
		MOVB $1, (%EBX)
		JMP fine_ciclo


no_rip:		MOVB $0, (%EBX)

fine_ciclo:	SUB %AL, %DL
		MOV %DL, cifra_ris(%ESI)
		CMP $0, %ESI
		JE converti
		DEC %ESI
		JMP ciclo

converti:	MOV (%EBX), %DL
		MOV $0, %ESI
		
		
ri_ciclo:	MOV prestito(%ESI),%AL
		CALL B4HA1
		MOV %AL,prestito(%ESI)

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
	        MOV  $prestito,%EBX
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
	        MOV $'-', %AL
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

	        MOV $' ', %AL
		CALL output
	        MOV  $cifra_ris,%EBX
		INC %EBX
	        MOV  $7, %CX
	        CALL outmess
	        CALL newline

		
		CMP $1, %DL
		JNE punto3

	        MOV  $messaggio,%EBX
	        MOV  $19, %CX
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
