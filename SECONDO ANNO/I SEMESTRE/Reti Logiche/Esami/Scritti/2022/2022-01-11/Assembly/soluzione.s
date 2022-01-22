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
        LEA X, %EDI
        CALL in8b16
        MOV %DL, %DH
        CALL newline
        LEA Y, %EDI
        CALL in8b16
        CALL newline

        OR %DL, %DH
        JNZ fine

# ciclo di somma con riporto delle cifre, a partire dalle meno significative

punto3:
        MOV $8, %ECX
        LEA X(%ECX), %EBX
        DEC %EBX
        LEA Y(%ECX), %EDX
        DEC %EDX
        LEA Z(%ECX), %EDI
        DEC %EDI
        CLC # clear carry flag. in alternativa, ADD $0, %AL
        STD
punto3_ciclo:
        MOV (%EBX), %AL
        MOV (%EDX), %AH
        ADC %AH, %AL
        STOSB
        DEC %EBX
        DEC %EDX
        LOOP punto3_ciclo

# salva l'ultimo carry in DL
        JC carry
        MOV $0, %DL
        JMP stampa
carry:  
        MOV $1, %DL

# stampa del risultato a partire dalla cifra piu' significativa
stampa:
        MOV $8, %ECX
        LEA Z, %ESI
        CLD
stampa_ciclo:
        LODSB
        CALL outbyte
        LOOP stampa_ciclo

# stampa del carry
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

# =========== sottoprogramma in8b16 =========== 
# richiede l'ingresso di 8 byte, in 16 cifre in base 16
# e le mette in memoria a partire dall'indirizzo contenuto in %EDI
# lascia DL a 1 se tutte le cifre inserite sono 0
# in: %EDI, puntatore a buffer di 8 byte
# out: %DL, usato come zero flag

in8b16:
        PUSH %ECX
        PUSH %AX
        MOV $1,%DL
        MOV $8,%ECX
        CLD
in8b16_ciclo:
        CALL inbyte
        STOSB
        CMP $0, %AL
        JE in8b16_ciclo_fine
        MOV $0, %DL
in8b16_ciclo_fine:
        LOOP in8b16_ciclo

        POP %AX
        POP %ECX
        RET
