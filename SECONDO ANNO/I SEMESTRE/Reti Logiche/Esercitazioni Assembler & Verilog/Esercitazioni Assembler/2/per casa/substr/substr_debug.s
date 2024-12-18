# Leggere una riga dal terminale, che DEVE contenere almeno 2 caratteri '_'
# Identificare e stampa la sottostringa delimitata dai primi due caratteri '_'

# La soluzione proposta ha uno o piu' errori: trovarli e correggerli.

.include "./files/utility.s"

.data

msg_in: .fill 80, 1, 0

.text
_main:  
    nop
    mov $80, %cx
    lea msg_in, %ebx
    call inline

    cld
    mov $'_', %al
    lea msg_in, %esi
    mov $80, %ecx

    repne scasb
    mov %esi, %ebx
    repne scasb
    mov %esi, %ecx
    sub %ebx, %ecx
    call outline

    ret
