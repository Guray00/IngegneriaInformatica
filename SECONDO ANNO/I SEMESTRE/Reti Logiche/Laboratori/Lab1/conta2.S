# conta il numero di occorrenze in una stringa di un char


.GLOBAL _main
.DATA
stringa:    .ASCII "Questa e' la frase di test"
lettera:    .BYTE 'e'
conteggio:  .BYTE 0x00


.TEXT
_main:      NOP
            MOV $0x00, %CL
            LEA stringa, %ESI
            MOV lettera, %AL

# while (c != '\0')


comp:       CMPB $0x00, (%ESI)       # quando finisco
            JE fine                 # esco

            # ora siamo dentro il ciclo
            CMP (%ESI), %AL
            JNE then

            # se sono uguali
            INC %CL

            # se non sono uguali, scorro la stringa incrementando il registro
then:       INC %ESI
            JMP comp

            # spostiamo il file in conteggio
fine:       MOV %CL, conteggio
            RET
