;2/(a+b*c-9)+e-d
; a,b,c-byte; d-doubleword; e-qword
;unsigned
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 5
    b db 9
    c db 8
    d dd 59
    e dq 582
    x dd 0
segment code use32 class=code
    start: ;2/(a+b*c-9)+e-d
        ;b*c (byte*byte)
        mov AL, [b]
        mul byte[c] ; AX=AL*c=b*c=72
        mov BX, AX ; BX=b*c
        
        ;a+b*c (byte+word)
        mov AL, [a]
        mov AH, 0 ; AX=a 
        add AX, BX ; AX=AX+BX=a+b*c=77
        
        ;a+b*c-9 (word-constant)
        sub AX, 9 ; AX=AX-9=a+b*c-9=68
        mov BX, AX ; BX=a+b*c-9
        
        ;2/(a+b*c-9) (constant/word)
        mov AX, 2
        mov DX, 0 ; DX:AX=2
        div BX ; AX=DX:AX/BX=0 ; DX=DX:AX%BX=2
        
        ;2/(a+b*c-9)+e (word+quadword)
        mov EAX, [d]
        ; mov word[x], AX
        ; mov word[x+2], DX
        ; mov EAX, x
        mov EDX, 0 ; EDX:EAX = 2/(a+b*c-9)
        mov ECX, dword[e]
        mov EBX, dword[e+4] ; EBX:ECX=e
        add ECX, EAX ; ECX=ECX+EAX and set CF to 0 or 1
        adc EBX, EDX; EBX=EDX+EBX+CF ; EBX:ECX=2/(a+b*c-9)+e=582
        
        ;2/(a+b*c-9)+e-d (quadword-doubleword)
        mov EAX, [d]
        mov EDX, 0 ; EDX:EAX=d 
        sub ECX, EAX ; ECX=ECX-EAX and set CF to 0 or 1
        sbb EBX, EDX ; EBX=EBX-EDX-CF ; EBX:ECX=e-d=523
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
