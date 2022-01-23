#------------------------------------------------------------------------
# Scrivere un programma assembler che si comporta come segue:
# 1. include il file "buffer.s" dalla directory "C:/WORK".
#    Il file contiene la dichiarazione di un array "buffer" di 10000 byte.
# 2. Richiede in ingresso un numero naturale X in base 10 a tre cifre
# 3. Se X non sta su un byte, termina, altrimenti: 
# 4. calcola e stampa, su una nuova riga il numero di occorrenze di X nel buffer
# 5. Ritorna al punto 2.
#
# Esempio:
# 108
# 38
# 000
# 34
# 023
# 27
# 095
# 59
#------------------------------------------------------------------------



.INCLUDE "C:/WORK/buffer.s"


.DATA

occorrenze:	.WORD 0
X:		.BYTE 0

.TEXT

_main:		NOP

punto2:		MOV $3, %CX
		CALL inDANB16_eco
		CMP $255, %AX
punto3:		JBE ok
		RET

ok:		MOVW $0, occorrenze
		MOV $0, %EDI
		MOV %AL, X

ciclo:		CMPB buffer(%EDI), %AL
		JNE non_trovato
		INCW occorrenze
non_trovato:	INC %EDI
		CMP $10000, %EDI
		JE stampa
		JMP ciclo

stampa:		MOV occorrenze, %AX
		CALL newline
		CALL B16DAN_out
		CALL newline
		JMP punto2			

.INCLUDE "C:/GAS/utility" 
