; Read two numbers a and b (in base 10) from the keyboard and calculate a/b. This value will be stored in a variable called "result" (defined in the data segment). The values are considered in signed representation.
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
    a dd 0
    b dd 0
    format db "%d", 0
    msg1 db "The result of the division is: %d", 0
    result dd 0
segment code use32 class=code
    start:
        ; read from console a
        push dword a
        push dword format
        call [scanf]
        add esp, 4*2
        mov ebx, [a] ; ebx = a
        
        ; read from console b
        push dword b
        push dword format
        call [scanf]
        add esp, 4*2 
        mov ecx, [b] ; ecx = b
        
        ; divide a and b
        mov eax, ebx ; eax = a
        mov edx, 0 ; edx:eax = a 
        idiv ecx ; eax = a/b
        
        mov [result], eax ; result = a/b
        
        ; print result
        push dword [result]
        push dword msg1
        call [printf]
        add esp, 4*2
        
        
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
