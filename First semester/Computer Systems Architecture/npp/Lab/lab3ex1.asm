; Write a program in assembly language which computes one of the following arithmetic expressions, considering the following domains for the variables: 
; a - doubleword; b, d - byte; c - word; e - qword
; a + b / c - d * 2 - e (unsigned)
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 100
    b db 10
    d db 5
    c dw 2
    e dq 50
segment code use32 class=code
    start:
        ; b from byte to DX:AX
        mov AL, [b]
        mov AH, 0 ; AX=b
        mov DX, 0 ; DX:AX = b
        ;b/c
        div word[c]; AX = b/c 
        ; AX -> EBX
        mov EBX, 0
        mov BX, AX ; EBX = AX = b/c
        ;a+b/c
        mov EAX, [a]
        add EAX, EBX ; EAX = a+b/c
        mov EBX, EAX ; EBX = a+b/c
        mov AL, 2
        mul byte [d]; AX=d*2
        ; AX tp DX:AX then EAX using stack
        mov DX, 0
        push DX
        push AX
        pop EAX ; EAX = d*2
        sub EBX, EAX; EBX = a+b/c-d*2
        ;EBX - e(quad)
        mov ECX, 0 ; ECX:EBX = a+b/c-d*2
        ; e in EDX:EAX
        mov EAX, dword [e]
        mov EDX, dword [e+4] ; EDX:EAX = e
        ;ECX:EBX - EDX:EAX
        sub EBX, EAX ; EBX = EBX-EAX and set CF to 0 or 1
        sbb ECX, EDX ; ECX = ECX-EDX-CF
        ; final result is in ECX:EBX
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
