STD_OUTPUT_HANDLE   equ -11
NULL                equ 0

global Start
extern ExitProcess, GetStdHandle, WriteConsoleA

section .bss
msg 	resb 	2

; The Output of this program should Be 45

section .text

Start:
	mov 	ebx,0x45

	; passing the value of ebx as an argument to C8toAsci
	push 	ebx

	; C8toAsci converts the contents of a register or memory location (8 bits) to an ASCII value that encodes the hexadecimal representaion of the value 
	; inside the regiter or memory Location 
	call 	C8toAsci

	;Exiting Process
	push 	NULL
	call 	ExitProcess



C8toAsci:
	; Function Start
	push 	ebp 
	mov 	ebp,esp
	
	; accepting the argument 
	movzx 	ebx , byte [esp + 8]  
	mov	    byte [msg], bl   
	
	; storing the hight order nibble in dl 
	mov 	dl, byte [msg]
	shr		dl,4
	
	; converting dl (High Order bit ) to ASCII
	push edx 
	call C4toAsci
	
	; storing the low order nibble in dl
	mov dl,byte[msg]
	shl dl,4
	shr dl,4
	
	; converting dl (Low order bit) to ASCII
	push edx 
	call C4toAsci
	
	; Funcion end
	mov 	esp, ebp
	pop 	ebp
	ret





; Convert nibble to ASCII
C4toAsci:
	; Function Start
	push 	ebp 
	mov 	ebp,esp
	
	
	; accepting the argument 
	movzx 	ebx	 ,	byte [esp + 8]
	mov	    byte [msg + 1], bl        
	
	
	; checking if the nibble is bigger than 
	cmp 	byte [msg + 1],0x0A
	jge		bta
	
	; adding 0x30 to the 4bit number (which will result in the ASCII code for that bit if less then 0x0A )
	mov 	ebx,0x30
	add 	ebx,[msg + 1]
	
	mov 	[msg + 1],ebx
	
	printmsg :
		; eax = handle
		push    STD_OUTPUT_HANDLE
		call    GetStdHandle
		
		; WriteConsoleA System call 
		push    NULL
		push    1
		push    msg + 1
		push    eax
		call    WriteConsoleA 
		
			
		; Funcion end
		mov 	esp, ebp
		pop 	ebp
		ret

	bta :
		; adding 0x30 to the nibble (which will result in the ASCII code for that bit if biiger then 0x0A )
		mov 	ebx,0x57
		add 	ebx,[msg + 1]
		
		mov 	[msg + 1],ebx
		jmp		printmsg
		