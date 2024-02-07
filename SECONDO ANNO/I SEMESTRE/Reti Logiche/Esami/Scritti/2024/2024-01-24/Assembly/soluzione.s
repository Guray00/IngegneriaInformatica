.include "./files/utility.s" 

.data
buf_1: .FILL 12, 1, 0
bug_2: .FILL 12, 1, 0

.text

_main:
    nop

    lea buf_1, %esi  # esi è il buffer contenente la riga corrente
    lea bug_2, %edi  # edi è il buffer di appoggio per le trasformazioni

    call leggi_riga

loop_comando:
    call inchar

    cmp $'f', %al
    je fine
non_f:

    cmp $'c', %al
    jne non_c
comando_c:
    call all_caps
    call stampa_riga
    jmp loop_comando
non_c:

    cmp $'l', %al
    jne non_l
comando_l:
    call all_lows
    call stampa_riga
    jmp loop_comando
non_l:

    cmp $'r', %al
    jne non_r
comando_r:
    call reverse
    call stampa_riga
    jmp loop_comando
non_r:

    cmp $'n', %al
    jne non_n
comando_n:
    call leggi_riga
    jmp loop_comando
non_n:

    jmp loop_comando

fine:
    call newline
    xor %eax, %eax
    ret

# sottoprogramma che trasforma tutti i caratteri nella riga in minuscoli
# l'indirizzo del buffer attuale e' in esi, quello del buffer d'appoggio e' in edi
# il sottoprogramma lavora sul buffer d'appoggio e, infine, ne scambia i ruoli
all_lows:
    push %eax
    push %ecx
    push %esi
    push %edi

    mov $12, %ecx
    cld
all_lows_loop:
    cmp $0, %ecx
    je all_lows_loop_fine
    lodsb
    cmp $'A', %al
    jb all_lows_loop_poi
    cmp $'Z', %al
    ja all_lows_loop_poi
    or $0x20, %al
all_lows_loop_poi:
    stosb
    dec %ecx
    jmp all_lows_loop

all_lows_loop_fine:
    pop %edi
    pop %esi
    pop %ecx
    pop %eax
    xchg %esi, %edi
    ret

# sottoprogramma che trasforma tutti i caratteri nella riga in maiuscoli
# l'indirizzo del buffer attuale e' in esi, quello del buffer d'appoggio e' in edi
# il sottoprogramma lavora sul buffer d'appoggio e, infine, ne scambia i ruoli
all_caps:
    push %eax
    push %ecx
    push %esi
    push %edi

    mov $12, %ecx
    cld
all_caps_loop:
    cmp $0, %ecx
    je all_caps_loop_fine
    lodsb
    cmp $'a', %al
    jb all_caps_loop_poi
    cmp $'z', %al
    ja all_caps_loop_poi
    and $0xDF, %al
all_caps_loop_poi:    
    stosb
    dec %ecx
    jmp all_caps_loop

all_caps_loop_fine:
    pop %edi
    pop %esi
    pop %ecx
    pop %eax
    xchg %esi, %edi
    ret

# sottoprogramma che inverte l'ordine dei caratteri nella riga
# l'indirizzo del buffer attuale e' in esi, quello del buffer d'appoggio e' in edi
# il sottoprogramma lavora sul buffer d'appoggio e, infine, ne scambia i ruoli
reverse:
    push %eax
    push %ecx
    push %esi
    push %edi

    mov $12, %ecx
    add %ecx, %edi
    dec %edi
    cld
reverse_loop:
    lodsb
    mov %al, (%edi)
    dec %edi
    
    dec %ecx
    cmp $0, %ecx
    jne reverse_loop

reverse_loop_fine:
    pop %edi
    pop %esi
    pop %ecx
    pop %eax
    xchg %esi, %edi
    ret

# sottoprogramma che legge una nuova riga
# l'indirizzo del buffer da popolare e' in esi
leggi_riga:
    push %eax
    push %ecx
    push %edi
    
    mov $12, %ecx
    cld
    mov %esi, %edi
leggi_riga_loop:
    cmp $0, %ecx
    je leggi_riga_loop_fine
    
leggi_riga_loop_char:
    call inchar

    cmp $'a', %al
    jb leggi_riga_loop_char_non_minusc
    cmp $'z', %al
    ja leggi_riga_loop_char_non_minusc

    jmp leggi_riga_loop_char_ok

leggi_riga_loop_char_non_minusc:
    cmp $'A', %al
    jb leggi_riga_loop_char_non_maiusc
    cmp $'Z', %al
    ja leggi_riga_loop_char_non_maiusc

    jmp leggi_riga_loop_char_ok

leggi_riga_loop_char_non_maiusc:    
    cmp $' ', %al
    jne leggi_riga_loop_char

    jmp leggi_riga_loop_char_ok

leggi_riga_loop_char_ok:
    call outchar
    stosb
    dec %ecx
    jmp leggi_riga_loop

leggi_riga_loop_fine:
    call newline
    pop %edi
    pop %ecx
    pop %eax
    ret

# sottoprogramma che stampa la riga attuale
# l'indirizzo del buffer attuale e' in esi
stampa_riga:
    push %ebx
    push %ecx
    push %esi

    mov $12, %ecx
    mov %esi, %ebx
    call outmess
    call newline

    pop %esi
    pop %ecx
    pop %ebx
    ret
