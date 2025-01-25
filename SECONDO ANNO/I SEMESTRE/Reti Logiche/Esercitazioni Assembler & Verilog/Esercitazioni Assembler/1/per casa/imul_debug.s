# leggere 2 numeri interi in base 10, calcolarne il prodotto, e stampare il risultato.

# lettura:
# come primo carattere leggere il segno del numero, cioè un '+' o un '-'
# segue il modulo del numero, minore di 256

# stampa:
# stampare prima il segno del numero (+ o -), poi il modulo in cifre decimali

# la soluzione proposta ha uno o piu' errori: trovarli e correggerli.

.include "./files/utility.s"

mess1:  .asciz "inserire il primo numero intero:\r" 
mess2:  .asciz "inserire il secondo numero intero:\r"
mess3:  .asciz "il prodotto dei due numeri e':\r"
a:      .word 0
b:      .word 0

_main:      
        nop
        lea mess1, %ebx
        call outline
        call in_intero
        mov %ax, a

        lea mess2, %ebx
        call outline
        call in_intero
        mov %ax, b

        mov a, %ax
        mov b, %bx
        imul %bx

        lea mess3, %ebx
        call outline
        call out_intero
        ret

# legge un intero composto da segno e modulo minore di 256
# ne lascia la rappresentazione in complemento alla radice base 2 in ax
in_intero:
        push %ebx
        mov $0, %bl
in_segno_loop:   
        call inchar
        cmp $'+', %al
        je in_segno_poi
        cmp $'-', %al
        jne in_segno_loop
        mov $1, %bl
in_segno_poi:
        call outchar
        call indecimal_word
        call newline
        cmp $1, %bl
        jne in_intero_fine
        neg %ax
in_intero_fine:
        pop %ebx
        ret

# legge la rappresentazione di un numero intero in complemento alla radice base 2 in eax
# lo stampa come segno seguito dalle cifre decimali
out_intero:
        push %ebx
        mov %eax, %ebx
        cmp $0, %ebx
        ja out_intero_pos
        jmp out_intero_neg
out_intero_pos:
        mov $'+', %al
        call outchar
        jmp out_intero_poi
out_intero_neg:
        mov $'-', %al
        call outchar
        neg %ebx
        jmp out_intero_poi
out_intero_poi:
        mov %ebx, %eax
        call outdecimal_long
        pop %ebx
        ret
