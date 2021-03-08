# Leggere numero naturale, sia n, da input
# Controllare che sia tra 0 e 9
# Calcolare e stampare in output il fattoriale n!
#
# Extra: organizzare il codice di calcolo del fattoriale come sottoprogramma

# n! = n * n - 1 * .... * 1

# n = indecimal_byte()
# # if( n > 9 )
    # return;
# 
# fattoriale = 1;
# 
# for( int i = 2; i <= n; i++)
     # fattoriale = fattoriale * i;
# 
# 8 bit: da 0 a 255
# 16 bit: da 0 a 65535
# 
# 2       x   1       =   2       (8 x 8 -> 16)
# 3       x   2       =   6       (8 x 8 -> 16)
# 4       x   6       =   24      (8 x 8 -> 16)
# 5       x   24      =   120     (8 x 8 -> 16)
# 6       x   120     =   720     (8 x 8 -> 16)
# 7       x   720     =   5040    (16 x 16 -> 32)
# 8       x   5040    =   40320   (16 x 16 -> 32)
# 9       x   40320   =   362880  (16 x 16 -> 32)
# 
# for( int i = n; i >= 2; i--)
    # fattoriale = fattoriale * i;
# 
# 9       x   1       =   9       (8 x 8 -> 16)
# 8       x   9       =   72      (8 x 8 -> 16)
# 7       x   72      =   504     (8 x 8 -> 16)
# 6       x   504     =   3024    (16 x 16 -> 32)
# 5       x   3024    =   15120   (16 x 16 -> 32)
# 4       x   15120   =   60480   (16 x 16 -> 32)
# 3       x   60480   =   181440  (16 x 16 -> 32)
# 2       x   181440  =   362880  (32 x 32 -> 64)
# 
# outdecimal(fattoriale);
#

.GLOBAL _main
.INCLUDE "C:/amb_GAS/utility"

.DATA

n:  .BYTE   0
risultato:  .LONG   1

msg_1:          .ASCII "Inserire naturale n da tra 0 e 9:\r"
msg_2:          .ASCII "Il fattoriale di n (n!) e':\r"

.TEXT

_main:          NOP

                LEA msg_1, %EBX
                MOV $80, %ECX
                CALL outline

                CALL indecimal_byte
                CALL newline
                MOV %AL, n

                MOV $0, %ECX
                MOVB n, %CL
               
                CALL factorial_inc
                MOV %EAX, risultato

fine:           LEA msg_2, %EBX
                MOV $80, %ECX
                CALL outline

                MOV risultato, %EAX
                CALL outdecimal_long
                RET

# sottoprogramma fattoriale, da n a 2 
# input: ECX naturale da 0 a 9
# output: EAX fattoriale del numero (1 se invalido)
# sporca: EDX
factorial_dec:
                MOV $1, %EAX    # fara' da risultato e moltiplicando

                # controllo validita'
                CMP $2, %ECX
                JB  fine_factorial_dec
                CMP $9, %ECX
                JA  fine_factorial_dec
                               
ciclo_factorial_dec:          
                CMP $1, %CL     # while( cl > 1) {
                JE fine_factorial_dec

                MUL %ECX    # edx_eax = eax * ecx
                DEC %CL
                JMP ciclo_factorial_dec   # }
                
fine_factorial_dec:
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
