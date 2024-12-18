# Leggere messaggio da terminale, di sole lettere
# Convertire in minuscolo
# Stampare messaggio modificato
#
# Bonus: usare istruzioni stringa

.GLOBAL _main
.INCLUDE "C:/amb_GAS/utility"

.DATA
msg_in:     .FILL 80, 1, 0  # numero, dimensione, valore
msg_out:    .FILL 80, 1, 0

.TEXT
_main:      NOP

            # lettura da terminale
            MOV $80, %CX
            LEA msg_in, %EBX
            CALL inline

            CLD
            LEA msg_in, %ESI
            LEA msg_out, %EDI

inizio: 	LODSB                   # do {
                                    # al = *esi

            # elaborazione
            CMP $0x41, %AL          # if ( al >= 'A' && al <= 'Z')
            JB poi
            CMP $0x5A, %AL
            JA poi
            
            OR $0x20, %AL
            
poi:        STOSB

            CMP $0x0D , %AL         # while ( al != '\r' )
            JNE inizio

fine:       LEA msg_out, %EBX
            CALL outline
            RET

