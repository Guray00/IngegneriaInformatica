.INCLUDE "./files/utility.s" 

.DATA
X:  .FILL 8,1,0
Y:  .FILL 8,1,0
Z:  .FILL 8,1,0

.TEXT
_main:
    NOP

# ingresso dati

punto1:		
    LEA X, %EBX
    CALL in8b6
    MOV %DL, %DH
    CALL newline
    LEA Y, %EBX
    CALL in8b6
    CALL newline

    OR %DL, %DH
    JNZ fine

# ciclo di somma con riporto delle cifre, a partire dalle meno significative
			
punto2:		
    MOV $7, %ECX
    MOV $0, %DL			# DL contiene i riporti. Inizialmente il riporto entrante e' 0.
ciclo:		
    MOV X(%ECX), %AL
    MOV Y(%ECX), %AH
    CALL sumb6
    MOV %AL, Z(%ECX)	
    SUB $1, %ECX		# non DEC, perche' DEC non setta il carry
    JNC ciclo

# stampa del risultato a partire dalla cifra piu' significativa
			
    MOV $0, %ECX
stampa:		
    MOV Z(%ECX), %AL
    ADD $'0', %AL
    CALL outchar
    INC %ECX
    CMP $8, %ECX
    JB stampa

    MOV $' ', %AL
    CALL outchar
    MOV %DL, %AL
    ADD $'0', %AL
    CALL outchar
    CALL newline
    CALL newline
    JMP punto1
			
fine:
    RET

# =========== sottoprogramma incifra =========== 
# richiede l'ingresso di una cifra in base 6 con eco sul terminale video
# out: AL, cifra digitata			
			
incifrab6:	CALL inchar
			CMP $'0', %AL
			JB incifrab6
			CMP $'5', %AL
			JA incifrab6
			CALL outchar
			SUB $'0', %AL
			RET

# =========== sottoprogramma in8b6 =========== 
# richiede l'ingresso di 8 cifre in base 6
# e le mette in memoria a partire dall'indirizzo contenuto in %EBX
# lascia DL a 1 se tutte le cifre inserite sono 0
# in: %EBX, puntatore a buffer di 8 byte
# out: DL, usato come zero flag 
# uses: incifrab6

in8b6:		PUSH %ECX
			PUSH %AX
			MOV $0,%ECX
            MOV $1,%DL
ciclo8:		CALL incifrab6
            MOV %AL,(%ECX,%EBX,1)
			CMP $0, %AL
            JE ciclo8_post
            MOV $0, %DL
ciclo8_post: 
            INC %ECX
			CMP $8, %ECX
			JNE ciclo8
			
            POP %AX
			POP %ECX
			RET

# =========== sottoprogramma sumb6 =========== 
# somma due cifre in base 6, contenute in %AL ed %AH, 
# ed un riporto entrante in %DL, e mette la somma in %AL
# ed il riporto uscente in %DL
# in: AL, AH (cifre), DL (Cin)
# out: AL (risultato), DL (Cout)			
			
sumb6:		ADD %AH, %AL
			ADD %DL, %AL
			MOV $0, %DL
			CMP $6, %AL
			JB  finesumb6	
			SUB $6, %AL
			MOV $1, %DL
finesumb6:	RET
