# Scrivere un programma che si comporta come segue:
# 1) stampa un punto interrogativo e legge con eco da tastiera
#    un numero naturale A di 5 cifre in base 10
# 2) se il numero è minore o uguale ad 1, termina
# 3) altrimenti, stampa la sua scomposizione in fattori primi,
#    cioe' una lista di righe x^y, intendendo che il fattore primo x
#    e' contenuto in A alla sua potenza y-esima, con x>1, y>=1.
# 4) attende la pressione di un tasto e termina.
#
# NB: si faccia l'ipotesi che il numero A sia rappresentabile su 16 bit.
#
# Esempio:
#
#?00338
#2^1
#13^2
#
#?00199
#199^1
#
#?0001
#[terminazione]


_main:     NOP

#punto 1
inizio:    MOV $'?',%AL
           CALL output
           MOV $5,%CX
           CALL inDANB16_eco
           CALL newline

#punto 2
           CMP  $1,%AX
           JBE  termina

#punto 3
#          AX contiene il numero da dividere (inizialmente A) su 16 bit. BX contiene il divisore da
#          inizializzarsi a 2. CX contiene il numero di istanze del divisore 
#          contenuto in BX trovate finora. 
#          SI contiene A 

           MOV  $2,%BX

ciclo:     CMP %BX, %AX
	   JB termina
	   MOV $0,%CX

ciclo2:    MOV  $0,%DX       # [DX,AX] contiene il numero A su 32 bit
           MOV  %AX,%SI	     # salvo AX in SI perche' la divisione lo sporca.
           DIV  %BX

           CMP  $0,%DX       # DX contiene il resto della divisione
           JNE  prossimo     # A ha BX come divisore

	   INC %CX
	   JMP ciclo2

prossimo:  MOV %SI, %AX
	   CMP $0, %CX
	   JE fine

           PUSH %AX		#stampa una riga
	   MOV %BX, %AX
	   CALL B16DAN_out
	   MOV $'^', %AL
	   CALL output
	   MOV %CX, %AX
	   CALL B16DAN_out
 	   CALL newline
	   POP %AX

fine:	   INC  %BX
           JMP  ciclo



termina:   CALL pause
	   RET

.INCLUDE "C:/GAS/utility" 

