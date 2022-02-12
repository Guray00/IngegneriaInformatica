###########################################
# Si scriva un programma Assembler che compie le seguenti operazioni:
# 1)	richiede in ingresso un numero intero A a 4 cifre in base 10, in modulo e segno, svolgendo gli opportuni controlli
# 2)	richiede in ingresso un numero naturale B a due cifre
# 3)	calcola AB . Se tale risultato sta su 32 bit, stampa il numero in base 10 in modulo e segno, altrimenti stampa la scritta “overflow” e termina
# 4)	ritorna al punto 1
# 
# NB: non verranno considerate in alcun modo soddisfacenti soluzioni che stampano solo numeri a 16 bit.
# 
# Esempio:
# +0100
# 04
# +100000000
# 
# -0012
# 03
# -1728
# 
# +0100
# 15
# overflow
#
###########################################

.GLOBAL _main

.DATA

overflow: 	.ASCII "overflow\n\r"

.TEXT

_main:		NOP
		CALL leggi_ms
		CALL newline
		CMP $1, %BX
		JNE base_pos
		NEG %AX
base_pos:	CWDE 
		MOV %EAX, %EDX
		MOV $2, %CX
		CALL inDANB16_eco
		CALL newline
		MOV %AX, %CX
		MOV $1, %EAX

ciclo:		CMP $0, %CX
		JE stampa
		PUSH %EDX
		IMUL %EDX
		JO ovflw
		POP %EDX
		DEC %CX
		JMP ciclo


#il numero da stampare è in %EAX. Può stare su 9 cifre in base 10, e quindi
#per stamparlo devo ricorrere a divisioni successive (a 64bit)
#metto i resti di ciascuna divisione nello stack, e li prelevo in ordine inverso


stampa:         CMP $0, %EAX
		JL negativo
		PUSH %EAX
		MOV $'+', %AL
		CALL output
		POP %EAX
		JMP stampa2
		
negativo:	NEG %EAX
		PUSH %EAX
		MOV $'-', %AL
		CALL output
		POP %EAX
stampa2:	MOV $10, %EBX
                MOV $0, %EDX
                MOV $0, %CL

ciclo_div:      DIV %EBX
                PUSH %DX
                INC %CL   
                CMP $0, %EAX
                JE ciclo_pop
                MOV $0, %EDX
                JMP ciclo_div

ciclo_pop:      POP %AX
                ADD $'0', %AL
                CALL output
                DEC %CL
                JNZ ciclo_pop

		CALL newline
		CALL newline
		JMP _main

		.balign 16
ovflw:		MOV $overflow, %EBX
		CALL outline
		CALL newline
		CALL pause
		RET



################################################################
# sottoprogramma che accetta un intero a quattro cifre in modulo e segno
# OUTPUT:
# AX: modulo 
# BX: segno (0->"+", 1->"-")
################################################################

leggi_ms:	PUSH %CX
		MOV $0, %BX
leggi_segno:	CALL input
		CMP $'+', %AL
		JE poi
		CMP $'-', %AL
		JNE leggi_segno
		MOV $1, %BX
poi:		CALL output
		MOV $4, %CX
		CALL inDANB16_eco
		POP %CX
		RET


.INCLUDE "C:/GAS/utility"
