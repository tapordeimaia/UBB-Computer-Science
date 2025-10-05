bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dq 123456781122ABCDh
    b dq 2034FFEDAA11h
    c dd 10
    d dd 20
segment code use32 class=code
    start:
        ;a+b
        ;a in EDX:EAX
        mov EAX, dword [a] ; EAX = 11 22 AB CD
        mov EDX, dword [a+4] ; EDX = 12 34 56 78
        ;b in EBX:ECX
        mov ECX, dword [b] ; ECX = FF ED AA 11
        mov EBX, dword [b+4]
        ; a+b; add lower parts of number; keep result in EDX:EAX
        add EAX, ECX ; EAX = EAX + ECX and result sets carry flag to 0 or 1
        adc EDX, EBX ; EDX = EDX + EBX + CF
        ; EDX:EAX contains a+b
        ;c-d
        ; c in DX:AX
        mov AX, word [c]
        mov DX, word [c+2]
        ;d in BX:CX
        mov CX, word [d]
        mov BX, word [d+2]
        ;c-d
        sub AX, CX ; AX = AX-CX ; set carry flag to 0 or 1
        sbb DX, AX ; DX = DX-BX-CF
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
