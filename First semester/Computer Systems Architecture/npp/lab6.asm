;Problem. A string of quadwords is given. Compute the number of multiples of 8 from
;the string of the low bytes of the high word of the high doubleword from the elements of the quadword string 
;and find the sum of the digits (in base 10) of this number. ; unsigned

;Solution: We first parse the quadword string and obtain the number of multiples of 8
;from the string of the low bytes of the high word of the high doubleword from the elements of the quadword string.
;Then we obtain the digits of this number by successive divisions to 10 and then compute the sum of these digits
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir  dq  00123110110abcb0h,1116adcb5a051ad2h,4120ca11d730cbb0h
	len equ ($-sir)/8;the length of the string (in quadwords) 
	opt db 8;variabile used for testing divisibility to 8
	zece dd 10;variabile used for determining the digits in base 10 of a number by successive divisions to 10
	suma dd  0;variabile used for holding the sum of the digits
segment code use32 class=code
    start:
        mov bl, 0
        mov esi, sir
        mov ecx, len
        jecxz end_loop
        repeat:
            lodsd ; eax = low dword and increments esi with 4 ; 110abcb0
            lodsw ; ax = low word of high dword and ic esi with 2 ; 3110
            lodsw ; ax = 0012 high word from the double word and inc esi with 2
            ; AL contains low byte of the high word of the high doubleword
            mov AH, 0 ; AX = AL unsigned conversion
            div byte[opt] ; AL=AX/opt, AH=AX%opt
            cmp AH, 0
            JNE dont_increment
                inc bl ; found a multiple of 8
            dont_increment:
        loop repeat
        end_loop:
        
        ; sum of digits of bl
        mov al, bl
        mov bl, 0
        sum_loop:
            mov ah, 0 ; ax=bl
            div byte[zece] ; al=bl/10, ah=bl%10
            add bl, ah
            cmp al, 0
            je out_of_loop
        jmp sum_loop
        out_of_loop:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
