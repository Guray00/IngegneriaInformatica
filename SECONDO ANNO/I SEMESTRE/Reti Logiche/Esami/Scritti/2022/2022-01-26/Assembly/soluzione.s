.INCLUDE "./files/utility.s"

.DATA
msg_colpito: .ASCII "colpito!\r"
msg_mancato: .ASCII "mancato!\r"
msg_vittoria: .ASCII "vittoria!\r"

.TEXT

_main:
    NOP

    CALL inword
    CALL newline
    MOV %AX, %DX    # in dx terremo le posizioni delle navi rimaste

ciclo_partita:
    CMP $0, %DX
    JE vittoria

    CALL in_lettera
    MOV %AL, %CL
    SHL $2, %CL # cl = cl * 4, ossia la dimensione di ogni riga
    CALL in_numero
    ADD %AL, %CL # cl contiene l'indice (da 0 a 15) della posizione bersagliata
    CALL newline

    MOV $1, %AX
    SHL %CL, %AX # ax contiene una maschera da 16 bit con 1 nella posizione bersagliata
    AND %DX, %AX # se abbiamo colpito qualcosa, ax rimane invariato. altrimenti varra' 0
    JZ mancato

colpito:
    LEA msg_colpito, %EBX
    CALL outline
    XOR %AX, %DX # togliamo il bersaglio colpito
    JMP ciclo_partita_fine

mancato:
    LEA msg_mancato, %EBX
    CALL outline

ciclo_partita_fine:
    JMP ciclo_partita

vittoria:
    LEA msg_vittoria, %EBX
    CALL outline
fine:
    RET

# Sottoprogramma per la lettura della lettera, da 'a' a 'd'
# Lascia l'indice corrispondente (da 0 a 3) in AL
in_lettera:
    CALL inchar
    CMP $'a', %AL
    JB in_lettera
    CMP $'d', %AL
    JA in_lettera
    CALL outchar
    SUB $'a', %AL
    RET

# Sottoprogramma per la lettura del numero, da '1' a '4'
# Lascia l'indice corrispondente (da 0 a 3) in AL
in_numero:
    CALL inchar
    CMP $'1', %AL
    JB in_numero
    CMP $'4', %AL
    JA in_numero
    CALL outchar
    SUB $'1', %AL
    RET
