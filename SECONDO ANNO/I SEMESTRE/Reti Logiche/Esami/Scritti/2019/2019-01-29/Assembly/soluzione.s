#Scrivere un programma che si comporta come segue:
#
#1. legge con eco da tastiera una stringa di lettere minuscole 
#   terminata da ritorno carrello;
#2. legge con eco da tastiera una lettera minuscola;
#3. stampa sulla riga il numero di occorrenze nella stringa della lettera;
#4. se il numero di occorrenze Ã¨ maggiore di uno torna al passo 2, altrimenti termina.
#
#Esempio:
#aabcdddhbbc
#a 2
#d 3
#f 0


vett:    .FILL 26,1,0    #ogni elemento del vettore, inizializzato a 0, conta le occorrenze della lettera

_main:  NOP
        MOV     $0,%EAX      #dovremo usare EAX come registro puntatore,  e solo AL sara' significativo

punto1: CALL    inchar
#========================== verifica fine stringa ==========================
        CMP     $0xD,%AL
        JNE     lab1         # salta se stringa non terminata
        CALL    newline
        JMP     punto2

#========================== verifica se carattere alfabetico minuscolo ==========================
lab1:   CMP     $'a',%AL
        JB      punto1
        CMP     $'z',%AL
        JA      punto1
        CALL    outchar

#========================== aggiornamento contatore occorrenze ==========================
        SUB     $'a',%AL     #in AL va 0 se conteneva la codifica di a;
                             #in AL va 1 se conteneva la codifica di b, ecc., ecc.
        INCB    vett(%EAX)
        JMP     punto1

punto2: CALL    inchar
        CMP     $'a',%AL
        JB      punto2
        CMP     $'z',%AL
        JA      punto2
        CALL    outchar

#==========================   lettura ed emissione numero occorrenze ==========================
punto3: SUB     $'a',%AL
		MOV     %EAX, %EBX
        MOV     $' ',%AL    #si sposta il cursore
        CALL    outchar
        MOV     vett(%EBX),%AL
        CALL    outdecimal_tiny
        CALL    newline

punto4: CMP     $1,%AL
        JA      punto2
        RET

.INCLUDE "C:/amb_GAS/utility" 
