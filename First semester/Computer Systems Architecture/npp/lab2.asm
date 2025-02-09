; Write a program in the assembly language that computes the following arithmetic expression, considering the following data types for the variables:
; a - byte, b - word
; (b / a * 2 + 10) * b - b * 15;
bits 32 
global start        
extern exit               
import exit msvcrt.dll    
segment data use32 class=data
    a db 10
    b dw 40
    
; our code starts here
segment code use32 class=code
    start:
        mov AX, word [b]
        div byte [a] ;AL = AX/a = b/a = 40/10 = 4
        mov BL, 2
        mul BL ; AX = BL*AL = 4*2 = 8
        add AX, 10; AX = 8+10 = 18
        ;(....)*b -> word*word
        mul word [b]; DX:AX = AX*b = (b / a * 2 + 10) * b = 18*41
        ;DX:AX -> EBX
        push DX
        push AX
        pop EBX ;EBX = 18*41
        mov AX, 15
        mul word [b] ; DX;AX = b*AX = b*15
        push DX
        push AX
        pop EAX ; EAX = b*15
        sub EBX, EAX ; EBX = (b / a * 2 + 10) * b - b * 15;
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
