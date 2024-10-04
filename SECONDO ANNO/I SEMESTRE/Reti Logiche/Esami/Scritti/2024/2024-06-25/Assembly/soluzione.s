.include "./files/utility.s" 

.data
mess_n:         .ascii "Inserire n: \r"
mess_matrice:   .ascii "Inserire matrice: \r"
dominanza_diagonale:   .ascii "La matrice è diagonalmente dominante.\r"
no_dominanza_diagonale:   .ascii "La matrice non è diagonalmente dominante.\r"

n:              .byte 0
matrice:        .fill 65025, 1, 0    # 255 x 255

.text
_main:
    nop
    mov $0, %eax

punto_1:
    lea mess_n, %ebx
    call outline
    call indecimal_byte
    call newline

    cmp $0, %al
    je fine
    
    mov %al, n

punto_2:
    lea mess_matrice, %ebx
    call outline

    mov $0, %bl    # indice riga
    mov $0, %edi   # indirizzo base della riga
loop_righe:
    cmp n, %bl
    je loop_righe_fine
    
    mov $0, %ecx    # indice colonna, su 32 bit per formato indirizzamento
loop_colonne:
    cmp n, %cl
    je loop_colonne_fine

    call indecimal_byte
    mov %al, matrice(%edi, %ecx, 1)
    mov $'\t', %al
    call outchar

    inc %cl
    jmp loop_colonne

loop_colonne_fine:
    inc %bl
    movb n, %cl
    add %ecx, %edi     # avanza l'indirizzo base alla riga successiva
    call newline
    jmp loop_righe

loop_righe_fine:
    
punto_3:
    mov $0, %eax
    mov $0, %ecx
    mov $0, %edx

    mov $0, %bl # indice riga
    mov $0, %edi   # indirizzo base della riga
loop_test_righe:
    cmp n, %bl
    je fine_dominanza_diagonale

    mov %bl, %cl    
    mov matrice(%edi, %ecx, 1), %dl # elemento diagonale

    mov $0, %esi    # accumulatore somma elementi non-diagonali. basterebbero 16 bit
    
    mov $0, %ecx    # indice colonna, su 32 bit per formato indirizzamento
loop_test_colonne:
    cmp n, %cl
    je loop_test_colonne_fine

    cmp %bl, %cl
    je loop_test_colonne_poi   # salta elemento diagonale

    mov matrice(%edi, %ecx, 1), %al
    add %eax, %esi

loop_test_colonne_poi:
    inc %cl
    jmp loop_test_colonne

loop_test_colonne_fine:
    cmp %esi, %edx
    jb fine_no_dominanza_diagonale # corto circuito al primo confronto fallito

    inc %bl
    movb n, %cl
    add %ecx, %edi     # avanza l'indirizzo base alla riga successiva
    jmp loop_test_righe

fine_dominanza_diagonale:
    lea dominanza_diagonale, %ebx
    call outline
    jmp fine

fine_no_dominanza_diagonale:
    lea no_dominanza_diagonale, %ebx
    call outline
    jmp fine

fine:
    ret
