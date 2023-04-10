# se mettete cout << "  " invece di cout << '\t', vedrete che la stampa è corretta con boot
# altrimenti usate g++ cc.h prova1.cpp es1.s e poi ./a.out
.text

# classe

.set classe_vv1,0 # char 6
.set classe_vv2,8 # long 3 * 8 = 24
# 24

.global _ZN2clC1EPc

.set this,-8
.set i,-12
.set v_pointer,-24


_ZN2clC1EPc:    pushq %rbp
                movq %rsp,%rbp
                sub $32, %rsp

                movq %rdi,this(%rbp)
                movq %rsi,v_pointer(%rbp)
                movl $0,i(%rbp)

                for:    cmpl $3,i(%rbp)
                        je fine_funzione

                        movslq i(%rbp),%rcx
                        movb (%rsi,%rcx),%al
                        # s.vv1[i] = s.vv1[i + 3] = s.vv2[i] = v[i];
                        movsbq %al,%rax
                        movq %rax,classe_vv2(%rdi,%rcx,8)
                        movb %al,classe_vv1(%rdi,%rcx)
                        add $3,%rcx
                        movb %al,classe_vv1(%rdi,%rcx)
                        sub $3,%rcx

                        incl i(%rbp)
                        jmp for

                fine_funzione:  leave
                                ret


.global _ZN2cl5elab1EiR2st

.set this,-8
.set i,-12
.set d,-16
.set ss_pointer,-24

_ZN2cl5elab1EiR2st: pushq %rbp
                    movq %rsp,%rbp
                    sub $48, %rsp

                    # per fortuna, in questo esercizio i registri non devono essere usate
                    # per chiamate di funzione, per cui sappiamo che li possiamo utilizzare 
                    # direttamente.
                    # 3 istruzioni, dunque, inutili
                    movq %rdi,this(%rbp)
                    movl %esi,d(%rbp)
                    movq %rdx,ss_pointer(%rbp)
                    movl $0,i(%rbp)
                    
                    for2:   cmpl $3,i(%rbp)
                            je fine_funzione2

                            movslq i(%rbp),%rcx
                            movslq d(%rbp),%r8
                            movb classe_vv1(%rdx,%rcx),%al # ss.vv1[i]
                            cmpq classe_vv2(%rdx,%rcx,8),%r8 # ss.vv2[i]
                            jl else_move

                            addb %al,classe_vv1(%rdi,%rcx)
                            subq %r8,classe_vv2(%rdi,%rcx,8)
                            jmp next_move

                            else_move:  add $3,%rcx
                                        subb %al,classe_vv1(%rdi,%rcx)
                                        sub $3,%rcx 
                                        addq %r8,classe_vv2(%rdi,%rcx,8) 

                            next_move:  incl i(%rbp)
                                        jmp for2

                    fine_funzione2: leave
                                    ret
