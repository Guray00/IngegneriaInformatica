.text

# classe 
.set classe_vv2,0 # 32 long
.set classe_vv1,32 # 36 char

.global _ZN2clC1EPc

.set this,-8
.set v_pointer,-16
.set i,-20

_ZN2clC1EPc:    push %rbp
                mov %rsp,%rbp
                sub $32,%rsp

                movq %rdi,this(%rbp)
                movq %rsi,v_pointer(%rbp)
                movl $0,i(%rbp)

                for:    cmpl $4,i(%rbp)
                        je fine_funzione

                        movslq i(%rbp),%rcx
                        # s.vv2[i] = v[i];
                        movb (%rsi,%rcx),%al
                        movb %al,classe_vv1(%rdi,%rcx)
                        # s.vv1[i] = s.vv2[i]
                        movsbq %al,%rax
                        movq %rax,classe_vv2(%rdi,%rcx,8)

                        incl i(%rbp)
                        jmp for

                fine_funzione:  leave
                                ret

.global _ZN2cl5elab1ER2sti

.set this,-8
.set ss_pointer,-16
.set d,-20
.set i,-24

_ZN2cl5elab1ER2sti: push %rbp
                    mov %rsp,%rbp
                    sub $32,%rsp

                    movq %rdi,this(%rbp)
                    movq %rsi,ss_pointer(%rbp)
                    movl %edx,d(%rbp)
                    movslq d(%rbp),%rdx # d
                    movl $0,i(%rbp)

                    for2:   cmpl $4,i(%rbp)
                            je fine_funzione2

                            movslq i(%rbp),%rcx # i
                            cmpq classe_vv2(%rsi,%rcx,8),%rdx # d >= ss.vv2[i]
                            jl prossima_iterazione
                            
                            movb classe_vv1(%rsi,%rcx),%bl # ss.vv1[i]
                            subb %bl,classe_vv1(%rdi,%rcx) # s.vv1[i] -= ss.vv1[i]; 

                            prossima_iterazione:    # s.vv2[i] = i - d;
                                                    movq %rcx,%rbx # lo uso in prestito per evitare l'errore di segmentazione
                                                    subq %rdx,%rbx # i - d;
                                                    
                                                    movq %rbx,classe_vv2(%rdi,%rcx,8) # s.vv2[i] = i - d;
                                                    incl i(%rbp)
                                                    jmp for2

                    fine_funzione2: leave
                                    ret