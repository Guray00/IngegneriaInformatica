#conteggio dei bit a 1 in un long

.GLOBAL _main

.DATA
dato:       .LONG 0x0F0F0101
conteggio:  .BYTE 0x00


.TEXT
_main:  NOP
        MOVB $0x00, %CL
        MOVL dato, %EAX

comp:   CMPL $0x00, %EAX    # while(eax != 0) {
        JE fine

        SHRL %EAX           # bit = eax[0]
        ADCB $0x00, %CL     # if(bit == 1) cl++;    

        JMP comp            # } 

fine:   MOVB %CL, conteggio
        RET
