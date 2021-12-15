##################################################################
#
# Scrivere un programma assembler che si comporta come segue:
# 1) accetta in ingresso un numero naturale X in base 10 con un numero
#    di cifre qualunque da 1 a 100
# 2) se il numero ha una sola cifra, termina, altrimenti
# 3) scrive se il numero X è divisibile per 2, 3, 5, 11
# 4) ritorna al punto 1
#
# NB: un numero è divisibile per 11 se la somma delle sue cifre,
#     considerate a segni alternati, è divisibile per 11
# 
# Es:
# ?123332
# 2: sì
# 3: no
# 5: no
# 11: sì
#
##################################################################



mess_no:	.ASCII ": no\n\r"
mess_si:        .ASCII ": si'\n\r"


_main:		CALL newline
		MOV $'?', %AL
		CALL output

		MOV $0, %CL		#contatore cifre
		MOV $0, %EAX
		MOV $0, %EBX		#collettore per 3
		MOV $0, %EDX		#collettore per 11
		MOV $0, %SI		#ultima cifra

punto1:
ingresso:	CALL input

		CMP $13, %AL
		JE fineingresso
		CMP $'0', %AL
		JB ingresso
		CMP $'9', %AL
		JA ingresso

		CALL output
		CALL HA1B4
		MOV %AX, %SI
		ADD %EAX, %EBX

		PUSH %CX
		SHR $1, %CL
		JC piu
		SUB %EAX, %EDX
		JMP continua
piu:		ADD %EAX, %EDX
continua:	POP %CX
		INC %CL
		CMP $100, %CL
		JE fineingresso
		JMP ingresso

punto2:
fineingresso:	CMP $2, %CL
		JB fine

punto3:

# test di divisibilita' per 2 (guardo l'ultima cifra)
verifica2:	CALL newline

		MOV $'2', %AL
		CALL output


		PUSH %EBX
		MOV %SI, %AX
		SHR $1, %AX
		JNC ok2
		MOV $mess_no, %EBX 
		JMP stampa2
ok2:		MOV $mess_si, %EBX
stampa2:	CALL outline
		POP %EBX

# test di divisibilita' per 3 (guardo la somma delle cifre)


verifica3:	MOV $'3', %AL
		CALL output

		PUSH %EAX
		PUSH %EDX
		
		MOV $0, %EDX
		MOV %EBX, %EAX
		MOV $3, %EBX
		DIV %EBX
		CMP $0, %EDX
		JE ok3
		MOV $mess_no, %EBX 
		JMP stampa3

ok3:		MOV $mess_si, %EBX 
stampa3:	CALL outline

fine3:		POP %EDX
		POP %EAX


# test di divisibilita' per 5 (guardo l'ultima cifra)
verifica5:	MOV $'5', %AL
		CALL output

		MOV %SI, %AX
		CMP $5, %AL
		JE ok5
		CMP $0, %AL
		JE ok5
		
		MOV $mess_no, %EBX
		JMP stampa5

ok5:		MOV $mess_si, %EBX
stampa5:	CALL outline


# test di divisibilita' per 11 (guardo la somma delle cifre a segni alternati)
verifica11:	MOV $11, %AX
		CALL B16DAN_out

		MOV %EDX, %EAX
		SHR $16, %EDX

		MOV $11, %BX
		IDIV %BX
		CMP $0, %DX
		JE ok11

		MOV $mess_no, %EBX
		JMP stampa11

ok11:		MOV $mess_si, %EBX
stampa11:	CALL outline

punto4:
finelavoro:	CALL newline
		JMP _main 

fine:		RET

.INCLUDE 	"C:/GAS/utility"
