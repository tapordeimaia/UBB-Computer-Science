; An array of words is given. Write an asm program in order to obtain an array of doublewords, where each doubleword will contain each nibble unpacked on a byte (each nibble will be preceded by a 0 digit), arranged in an ascending order within the doubleword.
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 5218h, 2546h, 5876h
    lena equ ($-a)/2 
    b times lena dd 0
    c dd 0
segment code use32 class=code
    start:        
        mov esi, a
        mov edi, b 
        mov ecx, lena 
        jecxz end_loop
        my_loop:
           ; Take each word from a, and put a 0 between each digit
           lodsw ; AX = a word from a and increments esi with 2 ; 5218 ; AH = 52, AL = 18 = 00011000
           mov bl, al 
           and bl, 0x0F ; BL = 00001000 = 08
           mov Dh, al 
           and dh, 0xF0 ; DH = 00010000 = 10
           ror Dh, 4 ; DH = 00000001 = 01
           mov DL, BL ; DX = 0108
           shl EDX, 16 ; EDX = 01080000
           mov bl, ah
           and bl, 0x0F ; BL = 00000010 = 02
           mov dh, ah
           and dh, 0xF0 ; DH = 01010000 = 50
           ror dh, 4 ; DH = 00000101 = 05           
           mov DL, BL ; EDX = 01080502
           mov BX, DX; EBX = 00000502
           shr EDX, 16 ; EDX = 00000108
           cmp DH, DL
           jna skip_change_edx 
           mov AL, DL
           mov DL, DH
           mov DH, AL
           skip_change_edx: ; DX = 0108
               cmp BH, BL
               jna skip_change_ebx 
               mov AL, BL 
               mov BL, BH
               mov BH, AL
               skip_change_ebx: ; BX = 0205
                   cmp Dl, BH
                   jna skip_next_change
                   mov AL, BH
                   mov BH, DL
                   mov DL, AL
                   skip_next_change: ; DX = 0102, BX = 0805
                       cmp DH, DL
                       jna skip_change_edx2 
                       mov AL, DL
                       mov DL, DH
                       mov DH, AL
                       skip_change_edx2: ; DX = 0102
                           cmp BH, BL
                           jna skip_change_ebx2 
                           mov AL, BL 
                           mov BL, BH
                           mov BH, AL
                           skip_change_ebx2: ; BX = 0508
                               cmp DH, BL
                               jna skip_next_change2
                               mov AL, BL
                               mov BL, DH
                               mov DH, AL
                               skip_next_change2: ;DX = 0102, BX = 0508
                                   shl EDX, 16
                                   mov DX, BX 
                                   mov EAX, EDX
                                   stosd ; store a string of doublewords from EAX                                    
        loop my_loop  
        end_loop:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
