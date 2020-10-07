

# conteggio dei bit a 1 in un long

.GLOBAL _main 


.DATA
dato:           .LONG 0x0f0f0101
conteggio:      .BYTE 0x00

.TEXT
_main:          NOP
                MOVB $0x00, %CL
                MOVL dato, %EAX

comp:           CMPL $0x00, %EAX # while (eax != 0){
                JE fine


                SHRL %EAX
                ADCB $0x00, %CL

                JMP  comp

fine:           MOVB %CL, conteggio
                RET
