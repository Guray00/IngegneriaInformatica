# Conteggio del numero di occorrenze di un numero in un array

.GLOBAL _main
.INCLUDE "C:/amb_GAS/utility"

.DATA
array:      .WORD 1, 256, 256, 512, 42, 2048, 1024, 1, 0
array_len:  .LONG 9

numero:     .WORD 1
conteggio:  .BYTE 0x00

.TEXT

_main:      NOP
            MOV $0, %CL
            MOV numero, %AX
            MOV $0, %ESI        # esi = 0

comp:       CMP array_len, %ESI      # while (esi != array_len ) {
            JE fine

            CMPW array(, %ESI, 2), %AX   # if( array[esi] == numero )
            JNE poi

            INC %CL             

poi:        INC %ESI            # esi++
            JMP comp            # }

fine:       MOV %CL, %AL
            CALL outdecimal_byte
            RET
