# leggere messaggio da terminale
# convertire le lettere minuscole in maiuscolo
# stampare messaggio modificato

.include "./files/utility.s"

.data
msg_in: .fill 80, 1, 0
msg_out: .fill 80, 1, 0

.text
_main:
    nop

punto_1:
    mov $80, %cx
    lea msg_in, %ebx
    call inline

punto_2:
    lea msg_in, %esi
    lea msg_out, %edi
    mov $0, %ecx

loop:
    # offset(%base, %indice, scala[1/2/4...])
    movb (%esi, %ecx), %al

    cmp $'a', %al
    jb dopo
    cmp $'z', %al
    ja dopo

    # sub $32, %al
    # and $0xdf, %al # 1101 1111 
    xor $0x20, %al   # 0010 0000

dopo:
    movb %al, (%edi, %ecx)

    inc %ecx
    cmp $'\r', %al
    jne loop

punto_3:
    lea msg_out, %ebx
    call outline

    ret
