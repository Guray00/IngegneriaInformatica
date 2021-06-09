_main:			MOV $0, %CL			# CL tiene la somma dei segni di a, b, c (0=negativo, 1=positivo)
   			    CALL legginumero	
				MOV %AX, %BX
				CMP $4, %BH
				JA negativo
				INC %CL

negativo:    	CALL legginumero
				CMP $4, %AH
				JA negativo2
				INC %CL

negativo2:		ADD %AL, %BL
				CMP $9, %BL
				JBE no_carryL
				INC %BH
				SUB $10, %BL

no_carryL:		ADD %AH, %BH
				CMP $9, %BH
				JBE no_carryH
				SUB $10, %BH

no_carryH:		CMP $1, %CL
				JE stamparis	# a e b sono discordi, quindi il risultato è rappresentabile
				CMP $4, %BH
				JA negativo3
				INC %CL			# CL contiene 3 o 0 se a, b, c sono concordi 

negativo3:		CMP $3, %CL
				JE stamparis
				CMP $0, %CL
				JE stamparis
				RET				
				
stamparis:		MOV %BH, %AL	# BH e BL contengono le due cifre da stampare	
				OR $0x30, %AL
				CALL outchar
				MOV %BL, %AL
				OR $0x30, %AL
				CALL outchar
				CALL newline
				CALL newline
				JMP _main
		
# sottoprogramma "legginumero": legge due cifre decimali con eco e ne ritorna il valore in %AH, %AL
legginumero:	
primacifra:		CALL inchar
				CMP $'9', %AL
				JA primacifra
				CMP $'0', %AL
				JB primacifra
				CALL outchar
				AND $0x0F, %AL
				MOV %AL, %AH

secondacifra:	CALL inchar
				CMP $'9', %AL
				JA secondacifra
				CMP $'0', %AL
				JB secondacifra
				CALL outchar
				AND $0x0F, %AL
				CALL newline
				RET

.INCLUDE "C:/amb_GAS/utility" 

