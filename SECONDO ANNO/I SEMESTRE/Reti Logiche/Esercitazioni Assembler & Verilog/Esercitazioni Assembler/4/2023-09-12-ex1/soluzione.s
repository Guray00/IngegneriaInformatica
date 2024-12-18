.include "./files/utility.s"

.data
primi: .fill 50, 1, 0      # vettore contenente i primi trovati finora
count: .byte 0              # numero di primi trovati finora 

.text
_main: 
        nop

        # inizializzazione della lista con 2 e 3
        lea primi, %edi
        movb $2, (%edi)
        inc %edi
        movb $3, (%edi)
        movb $2, count

        call indecimal_byte     # al contiene il numero di primi da trovare
        call newline

trova_n_primi:
        cmpb %al, count
        je stampa_primi
        call find_next_prime
        jmp trova_n_primi

stampa_primi:
        mov $0, %ecx
stampa_primi_loop:
        cmpb %cl, count
        je fine
        movb primi(%ecx), %al
        call outdecimal_byte
        movb $' ', %al
        call outchar
        inc %ecx
        jmp stampa_primi_loop

fine:
        call newline
        ret

find_next_prime:
        push %eax
        push %ebx
        push %ecx
        push %edx

        mov $0, %ecx
        movb count, %cl
        dec %cl
        movb primi(%ecx), %bl   # lettura dell'ultimo primo trovato
        add $2, %bl             # primo candidato primo

test_candidato_primo:
        mov $0, %ecx            # indice del prossimo primo noto da usare per il test
test_primi_noti:
        cmpb count, %cl
        je candidato_primo_vero

        movb $0, %ah
        movb %bl, %al
        movb primi(%ecx), %dl
        div %dl                 # ah conterra' il resto della divisione

        cmpb $0, %ah
        je candidato_primo_falso

        inc %ecx
        jmp test_primi_noti

candidato_primo_falso:
        add $2, %bl             # prossimo candidato primo
        jmp test_candidato_primo

candidato_primo_vero:
        mov $0, %ecx        
        movb count, %cl       
        movb %bl, primi(%ecx)   # salva il primo trovato e incrementa count
        incb count

        pop %edx
        pop %ecx
        pop %ebx
        pop %eax
        ret
