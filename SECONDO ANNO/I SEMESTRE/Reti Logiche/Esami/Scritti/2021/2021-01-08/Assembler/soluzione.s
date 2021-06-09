_main:     NOP

#punto 1
inizio:    CALL in_cifra

#punto 2
		   CMP $0, %AL
		   JE termina
		   MOV $0, %AH
           MOV %AX,%SI   #Il numero di righe da stampare va in SI

#punto 3   
		   CALL newline
		   CALL in_cifra
		   MOV $0, %AH
           MOV %AX,%DI   #Il passo va in DI

#punto 4
#          AX conterra' il prossimo numero da stampare
#          DI contiene il passo
#          SI conterra' il numero di righe rimaste da stampare
#          BX conterra' il numero di numeri da stampare sulla riga
#          DX servira' per contare da 0 a (contenuto di BX) - 1

           MOV $1,%AX
           MOV $0,%BX


nuovariga: CALL newline
           DEC %SI
           JS rigabianca
           INC %BX
           MOV $0,%DX
           JMP stampa

rigabianca:
           CALL newline
           JMP inizio

stampa:    CALL outdecimal_word
           PUSH %AX
           MOV $' ',%AL
           CALL outchar
           POP %AX
           
           ADD %DI,%AX
           INC %DX
           CMP %BX,%DX
           JE nuovariga
           JMP stampa

termina:   RET

#####################
# sottoprogramma "incifra"
# OUT: AL, contiene un numero da 0 a 9
#####################

in_cifra:  CALL inchar
		   CMP $'0', %AL
		   JB in_cifra
		   CMP $'9', %AL
		   JA in_cifra
		   CALL outchar
		   AND $0x0F, %AL
		   RET


.INCLUDE "C:/amb_GAS/utility" 
