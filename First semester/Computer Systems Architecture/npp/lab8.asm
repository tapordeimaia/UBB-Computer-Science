bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declaring extern functions used in the program
extern exit, printf, scanf            
import exit msvcrt.dll     
import printf msvcrt.dll     ; indicating to the assembler that the printf fct can be found in the msvcrt.dll library
import scanf msvcrt.dll      ; similar for scanf

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    n dd 0       ; this is the variable where we store the number read from keyboard
	message  db "Numarul citit este n= %d", 0  
	format  db "%d", 0  ; %d <=> a decimal number (base 10)
segment code use32 class=code
    start:
        ; calling scanf(format, n) => we read the number and store it in the variable n
        ; push parameters on the stack from right to left
        push  dword n       ; ! address of n, not the value
        push  dword format
        call  [scanf]       ; call scanf for reading
        add  esp, 4 * 2     ; taking parameters out of the stack; 4 = dimension of a dword; 2 = nr of parameters
        
        ;convert n to dword for pushing its value on the stack 
        mov  eax,0
        mov  al,[n]
        
        ;print the message and the value of n
        ;printf(message, eax)
        push  eax
        push  dword message 
        call  [printf]
        add  esp,4*2
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
