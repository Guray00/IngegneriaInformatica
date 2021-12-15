#------------------------------------------------------------------------
# Scrivere un programma assembler che si comporta come segue:
# 1. richiede da tastiera un numero naturale X a due cifre
#    in base 10, svolgendo gli opportuni controlli.

# 2. Se X è uguale a zero, termina, altrimenti:
# 3. Stampa l'X-simo termine S(X) della successione di Fibonacci 
#    (vedere sotto) purché S(X) sia rappresentabile su 32 bit,
#    altrimenti stampa "overflow".
# 4. Ritorna al punto 1.

# Nota 1: la successione di Fibonacci è così definita:
#         S(1)=S(2)=1;
#         S(i)=S(i-1)+S(i-2), i>=3
#
# Nota 2: data l'assoluta semplicità dell'algoritmo richiesto, 
#         una soluzione che riesca a stampare solo numeri che
#         stanno su 16 bit sarà considerata poco.

# Esempio:
# ?24
# 46368
#
# ?39

# 63245986
#
# ?48

# overflow

#------------------------------------------------------------------------

messaggio:	.ASCII "overflow\r"

_main:		CALL newline
		
punto1:         MOV $'?', %AL
		CALL output
                MOV $2, %CX
		CALL inDANB16_eco
                CALL newline
# controllo se X=0
punto2:         CMP $0,%AL
                JE fine

# controllo se X vale  1 o 2, nel qual caso conosco subito la soluzione 

punto3:         CMP $2,%AL
                JA maggiore_due

                MOV $1, %EAX
                JMP stampa

#CL tiene il conto delle iterazioni da fare
# EBX ed EDX contengono rispettivamente S(i-2) e S(i-1)
# EAX contiene S(i)

maggiore_due:   MOV %AL, %CL
                SUB $2, %CL
                MOV $1, %EDX
                MOV $1, %EBX

ciclo:          ADD %EDX, %EBX
                JC overflow
                MOV %EBX, %EAX                
                MOV %EDX, %EBX
                MOV %EAX, %EDX            
                DEC %CL
                JZ stampa
                JMP ciclo

overflow:       MOV $messaggio, %EBX
                CALL outline
                JMP _main


#il numero da stampare è in %EAX. Può stare su 9 cifre in base 10, e quindi
#per stamparlo devo ricorrere a divisioni successive (a 64bit)
#metto i resti di ciascuna divisione nello stack, e li prelevo in ordine inverso

stampa:         MOV $10, %EBX
                MOV $0, %EDX
                MOV $0, %CL

ciclo_div:      DIV %EBX
                PUSH %DX
                INC %CL   
                CMP $0, %EAX
                JE ciclo_pop
                MOV $0, %EDX
                JMP ciclo_div

ciclo_pop:      POP %AX
                ADD $'0', %AL
                CALL output
                DEC %CL
                JNZ ciclo_pop

punto4:         JMP _main

fine:		CALL newline
		CALL pause
		RET

.INCLUDE "C:/GAS/utility" 


