.include "./files/utility.s"

.data
buffer_s:   .fill 80, 1, 0
buffer_r:   .fill 80, 1, 0

.text
_main:
    nop

punto_1:
    lea buffer_s, %ebx
    mov $80, %ecx
    call inline

    # extra: controllo che ci siano 2 marcatori
    # step 1: calcolo il numero di caratteri in s
    lea buffer_s, %edi
    mov $'\r', %al
    mov $80, %ecx
    repne scasb # ora edi ed ecx si riferiscono al carattere *dopo* \r
    mov $80, %edx
    sub %ecx, %edx # ora %edx contiene il numero di caratteri in s, terminatore \r incluso
    dec %edx # - , terminatori esclusi
    
    # step 2: cerco il primo marcatore
    lea buffer_s, %edi
    mov $'*', %al
    mov %edx, %ecx
    repne scasb
    # se %ecx è 0, il primo marcatore non è stato trovato
    cmp $0, %ecx
    je check_marcatori_fail
    # step 3: cerco il secondo marcatore. I registri edi ed ecx sono già pronti
    repne scasb
    # se %ecx non è 0, il secondo marcatore è stato trovato
    cmp $0, %ecx
    jne punto_2
    # se %ecx non è 0, il secondo marcatore potrebbe essere l'ultimo carattere
    mov $'*', %al
    cmp %al, -1(%edi)
    je punto_2
    
check_marcatori_fail:
    lea buffer_s, %ebx
    call outline
    jmp fine

punto_2:
    lea buffer_s, %eax
    lea buffer_r, %ebx
    call substring_copy
    call outline

fine:
    ret

# Input:
# - In eax indirizzo stringa s: terminata da \r, contiene esattamente due marcatori '*'
# - In ebx indirizzo buffer r, di dimensioni sufficienti per contenere la sottostringa + '\r' di terminazione
# Output:
# - Ricopia la sottostringa di s delimitata da marcatori in r
# Registri modificati: nessuno 
# Ottimizzazione: uso rep per evitare cicli in software
substring_copy:
    push %eax
    push %ecx
    push %edx
    push %esi
    push %edi

    mov %eax, %edi
    # step 1: trovare inizio sottostringa
    mov $'*', %al
    mov $80, %ecx
    repne scasb
    push %edi # metto da parte l'indirizzo del primo carattere della sottostringa
    # step 2: calcolo lunghezza sottostringa
    mov %edi, %edx
    repne scasb # edi contiene l'indirizzo del carattere dopo il secondo marcatore
    # dato che 1 carattere = 1 byte, la differenza tra indirizzi è da' numero di caratteri
    sub %edx, %edi 
    dec %edi

    # step 3: ricopio
    mov %edi, %ecx # lunghezza sottostringa
    pop %esi # inizio sottostringa
    mov %ebx, %edi # destinazione sottostringa
    rep movsb
    
    # step 4: aggiungo il terminatore
    mov $'\r', %al
    mov %al, (%edi)

    pop %edi
    pop %esi
    pop %edx
    pop %ecx
    pop %eax
    ret
