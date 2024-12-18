# leggere messaggio da terminale
# convertire le lettere maiuscole in minuscolo
# stampare messaggio modificato

.include "./files/utility.s"

.data

msg_in: .fill 80, 1, 0
msg_out: .fill 80, 1, 0

.text
_main:  
        nop

        mov $80, %cx
        lea msg_in, %ebx
        call inline

        cld
        lea msg_in, %esi
        lea msg_out, %edi
        mov $0, %ecx

loop:   
        movb (%esi, %ecx), %al

        cmp $'a', %al
        jb fine_loop
        cmp $'z', %al
        ja fine_loop

        # convertire in minuscolo
        or $0x20, %al      # 0010 0000 -> l'or setta il bit 5
        # add $32, %al

fine_loop:
        movb %al, (%edi, %ecx)
        inc %ecx

        cmp $0x0d, %al      # carattere di fine riga (nella nostra libreria)
        jne loop

fine:
        lea msg_out, %ebx
        call outline
        ret
