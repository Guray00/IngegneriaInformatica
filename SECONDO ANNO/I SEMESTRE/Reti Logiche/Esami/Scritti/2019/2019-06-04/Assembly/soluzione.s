#Scrivere un programma che si comporta come segue:
#
#1. legge con eco da tastiera una stringa di lettere minuscole di al piu' 256 caratteri
#   terminata da ritorno carrello;
#2. se la stringa è vuota, termina. 
#3. Altrimenti, se la stringa non è vuota
#   a. stampa la vocale che occorre il maggior numero di volte nella stringa (in caso
#      di ugual numero di occorrenze, vale l'ordine alfabetico);
#   b. torna al punto 1.
#   
#Esempio
#aabcddedhebbeecuuuu
#e

buf1:    .FILL 256,1   #Vi immetteremo la stringa di ingresso,
                       #compreso il ritorno carrello finale 

occ_a:   .FILL 1,1    #Vi immetteremo il numero delle occorrenze di a
occ_e:   .FILL 1,1    #Vi immetteremo il numero delle occorrenze di e
occ_i:   .FILL 1,1    #Vi immetteremo il numero delle occorrenze di i
occ_o:   .FILL 1,1    #Vi immetteremo il numero delle occorrenze di o
occ_u:   .FILL 1,1    #Vi immetteremo il numero delle occorrenze di u

vocale:  .FILL 1,1     #Vi immetteremo la vocale con maggior occorrenze

_main:      NOP
start:      MOVB    $0,occ_a
            MOVB    $0,occ_e
            MOVB    $0,occ_i
            MOVB    $0,occ_o
            MOVB    $0,occ_u

#           Prelievo e memorizzazione in buf1 della stringa
            LEA     buf1,%ESI   # ESI sara' il registro puntatore
            MOV     $0,%CX       # CX sara' il contatore del numero di lettere prelevate
punto1:     CALL    inchar
            CMP     $0xD,%AL     # Verifica fine stringa
            JNE     continua 
            MOV     %AL,(%ESI)   # Memorizzazione in buf1 del carattere ritorno carrello       
            JMP     punto2
#           Stringa non finita e quindi verifica se
#           trattasi di carattere alfabetico minuscolo
continua:   CMP     $'a',%AL
            JB      punto1
            CMP     $'z',%AL
            JA      punto1
            CALL    outchar
            MOV     %AL,(%ESI)  # Memorizzazione in buf1 del carattere
            INC     %ESI
            INC     %CX
vedi_a:     CMP     $'a',%AL     # Aggiornamento contatore occorrenze
            JNE     vedi_e
            INCB    occ_a
            JMP     punto1
vedi_e:     CMP     $'e',%AL
            JNE     vedi_i
            INCB    occ_e
            JMP     punto1
vedi_i:     CMP     $'i',%AL
            JNE     vedi_o
            INCB    occ_i
            JMP     punto1
vedi_o:     CMP     $'o',%AL
            JNE     vedi_u
            INCB    occ_o
            JMP     punto1
vedi_u:     CMP     $'u',%AL
            JNE     punto1
            INCB    occ_u
            JMP     punto1

#           Se la stringa e' vuota termina
punto2:     CALL    newline
            CMP     $0,%CX
            JNE     punto3
            CALL    pause
            RET

#           Determina per confronto la vocale con il maggior numero di occorrenze
punto3:     MOVB    $'a',vocale
            MOV     occ_a, %DL

cmp_e:      CMP     occ_e, %DL
            JAE     cmp_i
            MOVB    $'e',vocale
            MOV     occ_e,%DL
cmp_i:      CMP     occ_i, %DL
            JAE     cmp_o
            MOVB    $'i',vocale
            MOV     occ_i,%DL
cmp_o:      CMP     occ_o,%DL
            JAE     cmp_u
            MOVB    $'o',vocale
            MOV     occ_o,%DL
cmp_u:      CMP     occ_u, %DL
            JAE     out_vocale
            MOVB    $'u',vocale

#           Stampa la vocale 
out_vocale: MOV     vocale, %AL
            CALL    outchar
            CALL    newline

            JMP     start

.INCLUDE "C:/amb_GAS/utility" 






