;a,b,c,d-byte, e,f,g,h-word
;(a+b)*(c+d)
bits 32 
global start        
extern exit               
import exit msvcrt.dll    
segment data use32 class=data
        a db 6
        b db 7
        c db 8
        d db 9
segment code use32 class=code
    start: ;(a+b)*(c+d)
        mov AL, byte [a]
        mov BL, byte [b]
        mov CL, byte [c]
        mov DL, byte [d]
        add AL, BL ;AL = BL+AL = 6+7 = 13
        add CL, DL ;CL = CL+DL = 8+9 = 17
        mul CL; AX = CL*AL = 13*17 = 221
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
