bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 10, 11, 13, 27, 28, 40
    l equ $-a
    b times l db 0
    two db 2
segment code use32 class=code
    start: ; given array of bytes compute array b containing only odd numbers ; unsigned
        
        mov esi, a
        mov edi, b
        mov ecx, l
        jecxz end_loop
        myrepeat:
           ;mov AL, [esi]
           lodsb ; load al and inc esi
           mov AH, 0 ; AX = element
           div byte [two] ; AH = AX%2
           cmp AH, 0
           je skip
               mov AL, [esi]
               ;mov [edi], AL
               stosb ; byte[edi] and inc edi
               ;inc edi
           skip:
           ;inc esi
        loop myrepeat
        end_loop:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
