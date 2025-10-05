;a - byte, b - word, c - double word, d - qword - Unsigned representation
;(b+b)+(c-a)+d
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 10
    b dw 2
    c dd 11
    d dq 3
segment code use32 class=code
    start: ;(b+b)+(c-a)+d
        ;b+b (word+word)
        mov CX, [b] ; AX=b
        add CX, CX ; CX=CX+CX=b+b=4
        
        ;c-a (doubleword-byte)
        mov AL, byte [a]
        mov AH, 0
        mov DX, 0 ;DX:AX=a
        push DX
        push AX
        pop EAX
        mov EBX, dword[c]
        sub EBX, EAX; EBX=EBX-EAX=c-a=1
        
        ;(b+b)+(c-a) (word+doubleword)
        mov AX, CX
        mov DX, 0 ;DX:AX=b+b
        push DX
        push AX
        pop ECX; ECX=b+b
        add ECX, EBX ; ECX=ECX+EBX=(b+b)+(c-a)=5
        mov EAX, ECX
        
        ;(b+b)+(c-a)+d (doubleword+quadword)
        mov EDX, 0 ; EDX:EAX=(b+b)+(c-a)
        mov EBX, dword[d]
        mov ECX, dword[d+4] ; ECX:EBX = d
        add EBX, EAX ; EBX=EBX+EAX and set carry flag to 0 or 1
        adc ECX, EDX ; ECX=ECX+EDX+CF
        
        
        
      
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
