;a - byte, b - word, c - double word, d - qword - Signed representation
;(c+b)-a-(d+d)
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 6
    b dw 8
    c dd 2
    d dq 9
    e dd 0
segment code use32 class=code
    start: ;(c+b)-a-(d+d)
        ;c+b (doubleword+word)
        mov AX, [b]
        cwde; EAX=b
        mov EDX, EAX
        add EDX, dword[c] ; EDX=EDX+c=b+c=10
        mov dword[e], EDX ; e=b+c
        
        ;d+d (quadword, quadword)
        mov EBX, dword[d]
        mov ECX, dword[d+4] ; ECX:EBX=d
        add EBX, EBX ; EBX=EBX+EBX and set carry flag to 0 or 1 
        add ECX, ECX; ECX=ECX+ECX+CF ; ECX:EBX=d+d=18
        
        ;(c+b)-a (doubleword-byte)
        mov AL, [a]
        cbw
        cwde ; EAX=a
        mov EDX, [e]
        sub EDX, EAX ; EDX=EDX-EAX=(c+b)-a=4
        mov EAX, EDX ; EAX=(c+b)-a
        
        ;(c+b)-a-(d+d) (doubleword-quadword)
        cdq; EDX:EAX=(c+b)-a
        sub EAX, EBX ; EAX=EAX-EBX and set CF to 0 or 1 
        sub EDX, ECX ; EDX=EDX-ECX-CF ;EDX:EAX=-14
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
