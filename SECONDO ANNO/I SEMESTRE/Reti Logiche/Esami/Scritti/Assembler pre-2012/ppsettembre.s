# Si scriva un programma assembler che si comporta come segue:
# 1) richiede in ingresso due numeri naturali a due cifre A e B
# 2) controlla che entrambi i numeri siano compresi nell'intervallo
#    [2,16]. Se non è così, termina.
# 3) richiede un numero naturale X di 4 cifre in base A, 
#    svolgendo gli opportuni controlli.
# 4) calcola la rappresentazione Y del numero X in base B e la stampa.
# 
# Es:
# A? 05
# B? 03
# X? 1342
# Y: 22020

.GLOBAL _main

.DATA

messaggio:	.ASCII "A? B? X? Y: "
A:		.BYTE 0
B:		.BYTE 0



.TEXT

_main:		NOP


punto1:		LEA messaggio, %EBX
		MOV $3, %CX
		CALL outmess
		MOV $2, %CX
		CALL inDANB16_eco
		MOV %AL, A
		ADD $3, %EBX
		CALL newline
		MOV $3, %CX
		CALL outmess
		MOV $2, %CX
		CALL inDANB16_eco
		MOV %AL, B
		ADD $3, %EBX
		CALL newline

punto2:		CMPB $2, A
		JB fine
		CMPB $16, A
		JA fine
		CMPB $2, B
		JB fine
		CMPB $16, B
		JA fine		

punto3:		MOV $3, %CX
		CALL outmess
		MOV $4, %CX
		MOV A, %DL
		MOV $0, %DH
		MOV %DX, %SI
		CALL in_4baseSI_eco
		ADD $3, %EBX
		CALL newline
		MOV $3, %CX
		CALL outmess

punto4:		MOV B, %DL
		MOV $0, %DH
		MOV %DX, %SI
		CALL B16_baseSI_out
		CALL newline
		CALL newline
		JMP punto1

fine:		RET



###############################################
# sottoprogramma in_4baseSI_eco
# richiede 4 cifre in base DX e ne fa l'eco
# in: SI, base delle cifre (2-16)
# out: AX, numero digitato convertito in base 2
###############################################


in_4baseSI_eco: PUSH  %CX
		PUSH  %DX
                MOV   $0x0000,%AX
                MOV   $4,%CH
ciclo_in:       CMP   $0,%CH
                JE    fine_in
                DEC   %CH
                PUSH  %AX
check_in:       CALL  input
		CMP   $'0',%AL	
		JB    check_in		
		CMP   $'F',%AL		
		JA    check_in
		CMP   $'9',%AL
		JBE   check2_in		
		CMP   $'A',%AL		
		JB    check_in
check2_in:	CALL HA1B4
		MOV $0, %AH
		CMP %AX, %SI
		JBE check_in

		CALL B4HA1
		CALL output
		CALL HA1B4
                MOV   %AL,%CL
                POP   %AX
                MUL   %SI
                MOV   %CL,%DL   
                AND   $0x000F,%DX
                ADD   %DX,%AX
                JMP   ciclo_in
fine_in:        POP   %DX
                POP   %CX	
		RET


###############################################
# sottoprogramma B16_baseSI_out
# stampa il numero contenuto in AX su N cifre 
# in base SI e ne fa l'eco
# in: AX, numero da stampare
#     SI, base delle cifre (2-16)
###############################################


B16_baseSI_out:	PUSH  %AX
		PUSH  %CX
		PUSH  %DX

		MOV $0x00, %CH
ciclodiv:   	MOV $0x0000,%DX  
		DIV   %SI
		CMP $9, %DL
		JA non_decimale
		ADD $0x30,%DL
		JMP avanti
non_decimale:	ADD $55, %DL

avanti:		PUSH  %DX
		INC %CH
		CMP $0, %AX
		JNE ciclodiv

ciclostampa:	POP   %AX		
		CALL output
		DEC   %CH
		JNZ   ciclostampa   

		POP   %DX		
		POP   %CX		
		POP   %AX
		RET



.INCLUDE "C:/GAS/utility"
