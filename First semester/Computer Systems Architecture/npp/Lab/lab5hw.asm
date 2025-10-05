;Given a character string S, obtain the string D containing all special characters (!@#$%^&*) of the string S.
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db '+', '4', '2', 'a', '@', '3', '$', '*'
    l equ $-s
    d times l db 0
    specialChars db "!@#$%^&*"
    charLen equ $-specialChars
segment code use32 class=code
    start:
        mov  esi, s
        mov edi, d
        mov ecx, l
        jecxz end_loop      
        next_char:
            mov AL, [esi] 
            mov ebx, specialChars
            mov edx, charLen          
        check_special:
            mov AH, byte[ebx]
            cmp AL, AH
            je is_special
            inc ebx ; Go to next character in string
            dec edx
            cmp edx, 0
            jz next_iteration
            jmp check_special          
        is_special:
            mov byte[edi], AL
            inc edi  
        next_iteration:
            inc esi        
            loop next_char
        end_loop:
            
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
