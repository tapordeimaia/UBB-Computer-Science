;a,b,c - byte, d - word
;d*(d+2*a)/(b*c)
bits 32 
global start        
extern exit               
import exit msvcrt.dll    
segment data use32 class=data
        a db 10
        b db 5
        c db 7
        d dw 9
        e dw 8
segment code use32 class=code
    start: ;d*(d+2*a)/(b*c)
        mov AL, byte [a]
        mov BX, word [d]
        mov DL,2
        mul DL ;AX = DL*AL = 2*10 = 20 = 2*a
        add AX, BX ;AX = AX+BX = 20+9 = 29 = (d+2*a)
        mul BX ;DX:AX = BX*AX = 9*29 = 261 = d*(d+2*a)
        mov BX, DX
        mov CX, AX
        mov AL , byte [c]
        mul byte [b] ;AX = BL*AL = 5*7 = 35 = (b*c)
        mov word [e], AX
        mov DX, BX
        mov AX, CX
        div word [e];AX = EAX/CX = 7 ;DX = EAX%CX = 16
    
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
