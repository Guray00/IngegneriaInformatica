#------------------------------------------------------------------------
# Scrivere un programma che si comporta come segue:
#
# 1. legge con eco da tastiera una sequenza di cinque cifre binarie, da interpretare come
#    la rappresentazione di un numero intero n in complemento a due. Il programma deve fare
#    i necessari controlli in modo da accettare SOLTANTO le codifiche ASCII di ESATTAMENTE
#    5 cifre binarie;
# 2. se n Ã¨ positivo, stampa la riga
#    n = <+...+>
#    altrimenti, se n Ã¨ negativo, stampa la riga:
#    n = <-...->
#    dove il numero di caratteri '+' o '-' Ã¨ uguale a ABS(n);
# 3. se n Ã¨ uguale a zero termina, altrimenti torna al passo 1.
#
#------------------------------------------------------------------------

_main:			CALL newline
		
punto1:         MOV $'?', %AL
				CALL outchar
				MOV $5, %CX
				MOV $0, %BL
ingresso:		CALL inchar
				CMP $'1', %AL
				JA ingresso
				CMP $'0', %AL
				JB ingresso
				CALL outchar
				SUB $'0', %AL
				SHR %AL
				RCL %BL
				DEC %CX
                JNZ ingresso

# il numero in C2 si trova adesso in BL.  

punto2:         MOV $'+', %DL
				CMP $0x0F, %BL
                JBE positivo
				MOV $'-', %DL
				OR $0xE0, %BL		#estendo da 5 a 8 bit la rappresentazione del numero intero
				NEG %BL				
positivo:		MOV %BL, %CL
				CALL newline
				MOV $'<', %AL
				CALL outchar
				
				MOV %DL, %AL
ciclostampa:	CMP $0, %CL
				JE finestampa
				CALL outchar
				DEC %CL
				JMP ciclostampa
				
finestampa:		MOV $'>', %AL
				CALL outchar
				CALL newline
				
punto3:			CMP $0, %BL
				JNE punto1
				CALL pause
				RET

.INCLUDE "C:/amb_GAS/utility" 
