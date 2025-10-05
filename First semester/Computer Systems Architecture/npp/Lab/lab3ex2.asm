; Write a program in assembly language which computes one of the following arithmetic expressions, considering the following domains for the variables: 
; a - doubleword; b, d - byte; c - word; e - qword
; a + b / c - d * 2 - e (signed)
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
        cbw; AX=b
        cwd; DX:AX=b
        idiv byte [c]; AX = b/c
        cwde ; AX->EAX = b/c
        ; a+b/c
        add EAX, dword [a]; EAX = a+b/c
        mov EBX, EAX ; EBX = a+b/c
        ; d*2
        mov AL, 2
        imul byte [d] ; AX = d*2
        cwde; AX -> EAX = d*2
        ;a+b/c-d*2
        sub EBX, EAX; EBX = a+b/c-d*2
        ; EBX -> EDX-EAX
        mov EAX, EBX
        cdq ; EDX:EAX = a+b/c-d*2
        ; e in ECX:EBX
        mov EBX, [e]
        mov ECX, [e+4]
        ; a + b / c - d * 2 - e
        sub EAX, EBX; EAX = EAX - EBX and set carry flag to 0 or 1
        sbb EDX, ECX ;EDX = EDX-ECX-CF
        ; final result in EBX:ECX
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

