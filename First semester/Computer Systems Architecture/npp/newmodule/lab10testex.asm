bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 1000
segment code use32 class=code
    start:
        mov bl, 2
        mov ax, [a]
        div bl ; Runtime error, result does not fit in a byte
        
        ; 100/-2
        a dw 100
        mov bl, -2 ; FEH -> unsigned 254
        mov ax, [a]
        div bl ; should have been idiv
        
        ; 0 - start of data segment
        a dw 100 ; 2 bytes
        b equ 29  ; 0
        c dd 10, 20 ; 8 bytes
        d db $-a ; 10 
        
        ; [base+index*scale+displ]
        ; lea eax, ebx
        ; mov eax, ebx
        
        
        
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
