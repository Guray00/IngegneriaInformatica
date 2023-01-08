.include "./files/utility.s"

.data
matrice: .fill 88, 1, ' '

.text
_main:  nop

lettura:
        mov $0, %ebx    # parola -> colonna

lettura_loop_parole:
        cmp $8, %ebx    # max 8 parole
        jae lettura_fine_parole

        mov $0, %ecx    # lettera -> riga
lettura_loop_lettere:
        cmp $11, %ecx    # max 11 lettere
        jae lettura_fine_lettere

        call inchar
        cmp $' ', %al
        je lettura_fine_lettere
        cmp $0x0d, %al
        je lettura_fine_parole_nl
        
        call outchar
        movb %al, matrice(%ebx, %ecx, 8)

        inc %ecx
        jmp lettura_loop_lettere

lettura_fine_lettere:
        call newline
        inc %ebx
        jmp lettura_loop_parole

lettura_fine_parole_nl:
        call newline
lettura_fine_parole:
        call newline

stampa:
        
        mov $0, %ecx    # lettera -> riga

stampa_loop_lettere:
        cmp $11, %ecx    # max 11 lettere
        jae stampa_fine_lettere
        
        mov $0, %ebx    # parola -> colonna
stampa_loop_parole:
        cmp $8, %ebx    # max 8 parole
        jae stampa_fine_parole

        movb matrice(%ebx, %ecx, 8), %al
        call outchar
        mov $' ', %al
        call outchar
        
        inc %ebx
        jmp stampa_loop_parole
    
stampa_fine_parole:
        call newline
        inc %ecx
        jmp stampa_loop_lettere

stampa_fine_lettere:
        call newline

fine:
        ret
