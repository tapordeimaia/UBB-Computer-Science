bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 20
    b dd 40
    s db 1, 2, 3 , 4, 5
    len equ $-s 
segment code use32 class=code
    sumarray:
        ; int sumarray (s[] - array, len - int)
        ; eax contains result (sum of all elements)
        ; free the stack in the procedure
        ; ret address - esp 
        ; s - esp+4
        ; len = esp+8
        mov ecx, [esp+8]
        mov esi, [esp+4]
        mov bl, 0
        jecxz .end_lopp
        .myrepeat: 
            lodsb
            add bl, al
        loop .myrepeat         
        .end_lopp:
        mov eax, 0
        mov al, bl
        ret 4*2
        
    sum: 
        ; int sum(int a, int b)
        ; params in rev oreder on stack
        ; result in eax (sum of numbers)
        ; procedure will free the stack for the 2 params (not the caller program)
        ; ret address - esp
        ; a - esp+4
        ; b = esp+8
        mov eax, [esp+4]
        add eax, [esp+8]
        ret 4*2 
    start:
        push dword [b]
        push dword [a]
        call sum
        ;add esp, 4*2
        
        
        
        ; eax contains sum
        
        push dword len
        push dword s
        call sumarray
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
