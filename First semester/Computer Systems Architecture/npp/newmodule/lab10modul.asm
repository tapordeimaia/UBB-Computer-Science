bits 32                         
segment code use32 public code
global factorial

factorial:
    ; factorial(n) return result in eax
	mov eax, 1
	mov ecx, [esp + 4] ; the first argument
	
	repeat: 
		mul ecx ; edx:eax = eax*ecx
	loop repeat ; ecx-1
	ret 4 ; in this case, 4 represents the number of bytes that need to be cleared from the stack (the parameter of the function)
