bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        


; declaring extern functions used in the program
extern exit, printf, scanf            
import exit msvcrt.dll     
import printf msvcrt.dll     ; indicating to the assembler that the printf fct can be found in the msvcrt.dll library
import scanf msvcrt.dll      ; similar for scanf

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir db 10, 4, 8, 3, 2, 11 ; unsigned numbers
    ls equ $-sir
    msg db "%d", 0
segment code use32 class=code
    start:
        mov ecx, ls
        mov esi, sir
        jecxz end_loop
        repeat:
            
            mov eax, 0
            lodsb ;al=sir(i) and esi += 1
            
            pushad
            
            ;printf(msg, sir(i))
            push dword eax
            push dword msg
            call [printf]
            add esp, 4*2
            
            popad
            
        loop repeat
        end_loop:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
