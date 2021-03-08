# conteggio del numero di occorrenze di una lettera in una stringa

.GLOBAL _main

.DATA
stringa:    .ASCIZ "Questa e' la stringa di caratteri ASCII che usiamo come esempio"
lettera:    .BYTE 'e'
conteggio:  .BYTE 0x00

.TEXT
_main:      NOP
            MOV $0x00, %CL
            LEA stringa, %ESI
            MOV lettera, %AL

comp:       CMPB $0x00, (%ESI)  # while (c != '\0') {
            JE fine

            CMP (%ESI), %AL
            JNE poi             # if(c == 'e') { 
            INC %CL             #    CL++ 
                                # }
                                
poi:        INC %ESI            # c = stringa[i++]
            JMP comp            # }


fine:       MOV %CL, conteggio
            RET
