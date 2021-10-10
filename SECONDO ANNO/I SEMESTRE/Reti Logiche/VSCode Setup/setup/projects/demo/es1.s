.INCLUDE "./files/utility.s" 
.GLOBAL 	_main

.DATA
msg:		.ASCII "ok"

.TEXT
_main:		NOP

			# CALL inchar
			MOV $'A', %AL
			CALL outchar



termina:	RET
