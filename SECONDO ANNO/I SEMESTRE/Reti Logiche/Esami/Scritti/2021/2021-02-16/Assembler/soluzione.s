cifra_X: .FILL 1, 6
Y: .FILL 1, 1

_main:  NOP

punto1:	MOV $6, %CX
		LEA cifra_X, %EBX
		CALL leggi_cifre
		CALL newline

		MOV $1, %CX
		LEA Y, %EBX
		CALL leggi_cifre
		CALL newline

punto2:	CMPB $0, Y
		JNE punto3
		RET


#ESI contiene la variabile per il ciclo. 


punto3:	MOV $0, %ESI
		MOVB $10, %BL
		MOV $0, %AL


ciclo:	MOV $0, %AH
		MUL %BL
		MOVB cifra_X(%ESI), %DL
		ADD %DL, %AL 

		PUSH %AX
			MOV $0, %AH
			CALL outdecimal_byte
			MOV $'/', %AL
			CALL outchar
			MOV Y, %AL
			OR $0x30, %AL
			CALL outchar
			MOV $':', %AL
			CALL outchar
			MOV $' ', %AL
			CALL outchar
			MOV $'q', %AL
			CALL outchar
			MOV $'=', %AL
			CALL outchar
		POP %AX

		MOVB Y, %DL
		DIV %DL

		PUSH %AX
			OR $0x30, %AL
			CALL outchar
			MOV $',', %AL
			CALL outchar
			MOV $' ', %AL
			CALL outchar
			MOV $'r', %AL
			CALL outchar
			MOV $'=', %AL
			CALL outchar
		POP %AX

		MOV %AH, %AL

		PUSH %AX
     		OR $0x30, %AL
	    	CALL outchar
		POP %AX

		CALL newline
		
		INC %ESI
		CMP $6, %ESI
		JNE ciclo

punto4:	JMP punto1


# sottoprogramma che legge CX cifre in base 10 e mette ciascuna cifra 
# in un vettore di indirizzo %EBX

leggi_cifre:   CMP   $0,%CX
               JE    fine
               PUSH  %CX
			   PUSH  %EBX
               PUSH  %AX
cicla:         CALL  inchar
			   CMP $'0', %AL
			   JB cicla
			   CMP $'9', %AL
			   JA cicla
			   CALL outchar
			   AND $0x0F, %AL
               MOV   %AL,(%EBX)
    	       INC   %EBX
               DEC   %ECX
               JNZ   cicla
               POP   %AX
               POP   %EBX
               POP   %CX
fine:          RET


.INCLUDE "C:/amb_GAS/utility" 
