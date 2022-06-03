.text
static_init:
	pushl %ebx
	movl $start_of_array, %ebx
2:	movl (%ebx), %eax
	cmpl $0, %eax
	je 1f
	call *%eax
	addl $4, %ebx
	jmp 2b
1:
	popl %ebx
	ret
.section .init_array
	.global static_init
start_of_array:
