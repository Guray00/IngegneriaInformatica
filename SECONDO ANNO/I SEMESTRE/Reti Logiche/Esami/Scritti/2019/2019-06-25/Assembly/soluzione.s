# Scrivere un programma che si comporta come segue:
# 1. emette ? e legge con eco da tastiera un numero naturale in base dieci 
#    che sta su un byte;
# 2. se il numero è compreso fra 0 e 19:
#     a. stampa su una nuova riga il nome del numero;
#     b. torna al punto 1;
# 3. altrimenti, se il numero è maggiore di 19, termina.
#
# Esempio:
#13
#tredici
#0
#zero
#214
# --------------------------------------------------------------------------

# stringhe dei nomi dei numeri
str00: .ASCII "zero\r"
str01: .ASCII "uno\r"
str02: .ASCII "due\r"
str03: .ASCII "tre\r"
str04: .ASCII "quattro\r"
str05: .ASCII "cinque\r"
str06: .ASCII "sei\r"
str07: .ASCII "sette\r"
str08: .ASCII "otto\r"
str09: .ASCII "nove\r"
str10: .ASCII "dieci\r"
str11: .ASCII "undici\r"
str12: .ASCII "dodici\r"
str13: .ASCII "tredici\r"
str14: .ASCII "quattordici\r"
str15: .ASCII "quindici\r"
str16: .ASCII "sedici\r"
str17: .ASCII "diciassette\r"
str18: .ASCII "diciotto\r"
str19: .ASCII "diciannove\r"

# vettore contenente gli offset delle stringhe dei nomi
vett_nomi:  .LONG str00,str01,str02,str03,str04,str05,str06,str07,str08,str09
            .LONG str10,str11,str12,str13,str14,str15,str16,str17,str18,str19

_main:   NOP

inizio:  MOV  $'?',%AL
         CALL outchar
         CALL indecimal_tiny
         CALL newline

# verifico condizione di terminazione
         CMP  $19,%AL
         JA   fine

# immetto in EBX l'indirizzo della stringa con il nome del numero
         AND  $0x0000FFFF,%EAX
         MOV  %EAX,%ESI
         SAL  $2,%ESI   # ricordare che vett_nomi e' un vettore di long
         MOV  vett_nomi(%ESI),%EBX
# stampo il nome
stampa:  CALL outline
         CALL newline
         JMP  inizio

fine:    CALL pause
         RET


.INCLUDE "C:/amb_GAS/utility" 
