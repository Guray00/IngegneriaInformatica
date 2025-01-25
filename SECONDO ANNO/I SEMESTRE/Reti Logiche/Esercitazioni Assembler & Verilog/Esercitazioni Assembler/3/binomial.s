# Leggere due numeri naturali, a e b, da input
# Controllare che siano tra 0 e 9, e a >= b
# Calcolare e stampare in output il coeff. binomiale ( a  b ) = a! / ( b! * (a - b)! )

# a, b => 8 bit
# a!, b!, (a - b)! => 32 bit
# denom. => 
        # (a b) in N
        # a! >= denom.
        # => denom. su 32 bit

# divisore 32 bit => dividendo 64 bit

#   a_fatt = fattoriale(a)
#   b_fatt = fattoriale(b) 
#   ab_fatt = fattoriale(a - b)
#   denom = b_fatt * ab_fatt
#   risultato = a_fatt / denom

.GLOBAL _main
.INCLUDE "C:/amb_GAS/utility"

.DATA
a:          .BYTE 0
b:          .BYTE 0
a_fatt:     .LONG 0
b_fatt:     .LONG 0
ab_fatt:    .LONG 0
denom:      .LONG 0
risultato:  .LONG 0

msg_1: .ASCII "Inserire i due naturali a e b, da 0 a 9:\r"
msg_2: .ASCII "Il coefficiente binomale (a b) e':\r"
msg_err: .ASCII "Input invalidi\r"

.TEXT

_main:
            NOP
        
            # lettura a e b
            LEA msg_1, %EBX
            MOV $80, %ECX
            CALL outline

            CALL indecimal_byte
            CALL newline
            MOV %AL, a

            CALL indecimal_byte
            CALL newline
            MOV %AL, b

            # controllo validita' a e b
            CMPB $9, a
            JA wrong_input
            CMPB $9, b
            JA wrong_input

            MOVB a, %AL
            MOVB b, %BL
            CMP %AL, %BL
            JA wrong_input

            # calcolo dei fattoriali
            MOV $0, %ECX
            MOVB a, %CL
            CALL factorial_inc
            MOV %EAX, a_fatt

            MOV $0, %ECX
            MOVB b, %CL
            CALL factorial_inc
            MOV %EAX, b_fatt

            MOV $0, %ECX
            MOVB a, %CL
            SUB b, %CL # cl -= b => cl = a - b
            CALL factorial_inc
            MOV %EAX, ab_fatt

            # calcolo del denominatore
            MOV b_fatt, %EAX
            MOV ab_fatt, %EBX
            MUL %EBX    # edx_eax = eax * ebx
            MOV %EAX, denom

            # divisione
            MOV $0, %EDX
            MOV a_fatt, %EAX
            MOV denom, %EBX
            DIV %EBX    # EAX = EDX_EAX / EBX
            MOV %EAX, risultato

            # stampa del risultato
            LEA msg_2, %EBX
            MOV $80, %ECX
            CALL outline

            MOV risultato, %EAX
            CALL outdecimal_long
            RET

wrong_input:
            LEA msg_err, %EBX
            MOV $80, %ECX
            CALL outline
            RET



# sottoprogramma fattoriale, da 2 a n
# input: ECX naturale da 0 a 9
# output: EAX fattoriale del numero (1 se invalido)
# sporca: EDX, BX
factorial_inc:
                MOV $1, %AX    # fara' da risultato e moltiplicando
                MOV $0, %DX

                # controllo validita'
                CMP $2, %ECX
                JB  fine_factorial_inc
                CMP $9, %ECX
                JA  fine_factorial_inc

                MOV $2, %BX

ciclo_factorial_inc:          
                # do {
                
                MUL %BX    # dx_ax = ax * bx
                
                CMP %BX, %CX
                JE fine_factorial_inc
                
                INC %BX
                JMP ciclo_factorial_inc  # } while( cl > 1 )
                
fine_factorial_inc:
                # edx = ?_rh
                # eax = ?_rl
                SHL $16, %EDX    # edx = rh_0
                MOV %AX, %DX    # edx = rh_rl
                
                MOV %EDX, %EAX  # eax = rh_rl
                RET
