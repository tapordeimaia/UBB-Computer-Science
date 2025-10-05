bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0000000001011110b
    b dw 1010110110011111b
    c dd 0
segment code use32 class=code
    start:
        mov BX, 0
        
        ;the bits 0-3 of C are the same as the bits 5-8 of B
        mov AX, [b]
        and AX, 0000000111100000b ; AX=0000000110000000
        mov CL, 5
        rol AX, CL ; AX=0000000000001100
        or BX, AX ; BX=0000000000001100
        
        ;the bits 4-8 of C are the same as the bits 0-4 of A
        mov AX, [a]
        and AX, 0000000000011111b ; AX = 0000000000011110
        mov CL, 4
        ror AX, CL ; AX = 0000000111100000
        or BX, AX ; BX = 0000000111101100
        
        ;the bits 9-15 of C are the same as the bits 6-12 of A
        mov AX, [a]
        and AX, 0001111111000000b ; AX = 0000000001000000
        mov CL, 3
        ror AX, CL ; AX = 0000001000000000
        or BX, AX ; BX = 0000001111101100
        
        ;the bits 16-31 of C are the same as the bits of B
        mov AX, BX
        mov DX, 0
        push DX
        push AX
        pop EAX
        mov EBX, EAX
        mov AX, [b]
        mov DX, 0 ; DX:AX = 00000000000000001010110110011111
        push DX
        push AX
        pop EAX
        mov CL, 16
        ror EAX, CL ; EAX = 10101101100111110000000000000000
        or EBX, EAX ; EBX = 10101101100111110000001111101100
        mov [c], EBX
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
