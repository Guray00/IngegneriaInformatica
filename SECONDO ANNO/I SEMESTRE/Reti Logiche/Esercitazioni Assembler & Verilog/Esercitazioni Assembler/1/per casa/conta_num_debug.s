# contare il numero di occorrenze del numero nell'array, e stamparlo

# la soluzione proposta ha uno o piu' errori: trovarli e correggerli.

.include "./files/utility.s"

.data
array:      .word 1, 256, 256, 512, 42, 2048, 1024, 1, 0
array_len:  .long 9
numero:     .word 1

.text

_main:
        nop
        mov $0, %cl
        mov numero, %ax
        mov $0, %esi

comp: 
        cmp array_len, %esi
        je fine
        cmpw array(%esi), %ax
        jne poi
        inc %cl

poi:  
        inc %esi
        jmp comp

fine: 
        mov %cl, %al
        call outdecimal_byte
        ret
