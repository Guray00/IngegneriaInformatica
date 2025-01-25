.include "./files/utility.s"

.data
array: .byte 0x1A, 0x47, 0x34, 0xC5, 0x9B, 0x02, 0x6D, 0x8E, 0x9B, 0x1D, 0x47, 0x60, 0x29, 0x3A, 0x9B, 0x11
n:  .byte 16

current_search_item: .byte 0x0
current_search_position: .long 0x0
current_search_count: .byte 0

mess_search_next_report_1: .ascii "Trovata occorrenza di \r"
mess_search_next_report_2: .ascii "Conteggio attuale: \r"

mess_search_report_1: .ascii "Scansione array terminata.\r"
mess_search_report_2: .ascii "Totale:\r"
mess_search_report_3: .ascii "occorrenze di\r"

.text
_main:  
    nop
    
command_loop:
    call inchar

command_test_search_new:
    cmp $'s', %al
    jne command_test_search_new_next
    call outchar
    call search_new
command_test_search_new_next:

command_test_search_next:
    # il comando non è attivo se non c'è una ricerca in corso
    movl current_search_position, %ebx
    cmp $0, %ebx
    je command_test_search_next_next
    # solo se il comando è attivo, n è un carattere valido
    cmp $'n', %al
    jne command_test_search_next_next
    call outchar
    call search_next
command_test_search_next_next:

command_test_fine:
    cmp $'f', %al
    jne command_test_fine_next
    call outchar
    jmp fine
command_test_fine_next:

    jmp command_loop

# Prepara una nuova ricerca, poi chiama la ricerca del primo elemento
search_new:
    push %eax
    push %edi

    mov $' ', %al
    call outchar
    call inbyte
    movb %al, current_search_item
    lea array, %edi
    movl %edi, current_search_position
    movb $0, %al
    movb %al, current_search_count
    call search_next

    pop %edi
    pop %eax
    ret

# Cerca la prossima occorrenza dell'elemento, stampa un rapporto corrente o conclusivo
search_next:
    push %eax
    push %ebx
    push %ecx
    push %edi

    call newline
    lea array, %ebx
    movl current_search_position, %edi
    movl %edi, %eax
    subl %ebx, %eax   # eax contiene il numero di posizioni già scansionate
    movl $0, %ecx
    movb n, %cl
    subl %eax, %ecx   # ecx contiene il numero di posizioni ancora da scansionare
    movl %ecx, %eax
    movb current_search_item, %al
    
    repne scasb

    # se l'ultimo confronto è un successo, incrementiamo il contatore
    jne search_next_after
    incb current_search_count

search_next_after:
    cmp $0, %ecx
    jne search_next_continue
search_next_last:
    # ricerca terminata, stampa del rapporto conclusivo e reinizializzazione
    lea mess_search_report_1, %ebx
    call outline
    lea mess_search_report_2, %ebx
    call outline
    movb current_search_count, %al
    call outdecimal_byte
    call newline
    lea mess_search_report_3, %ebx
    call outline
    movb current_search_item, %al
    call outbyte
    call newline
    call newline

    movl $0, %eax
    movb %al, current_search_item
    movl %eax, current_search_position
    movb %al, current_search_count
    
    jmp search_next_end

search_next_continue:
    # ricerca ancora in corso, salvataggio dello stato e stampa del rapporto corrente
    movl %edi, current_search_position

    lea mess_search_next_report_1, %ebx
    call outline
    movb current_search_item, %al
    call outbyte
    call newline
    lea mess_search_next_report_2, %ebx
    call outline
    movb current_search_count, %al
    call outdecimal_byte
    call newline
    call newline

    jmp search_next_end

search_next_end:
    pop %edi
    pop %ecx
    pop %ebx
    pop %eax
    ret

fine:
    call newline
    ret
