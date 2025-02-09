; A text file is given. Read the content of the file, count the number of consonants and display the result on the screen. The name of text file is defined in the data segment.
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, fprintf, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "lab8hw2text.txt", 0
    access_mode db "r", 0
    file_descriptor dd -1
    len equ 100
    text2 times len db 0
    msg db "The file contains %d consonants", 0
    number_read_char dd 0
    x dd 0
segment code use32 class=code
    start:
        ; open a file
        push dword access_mode     
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        
        ; see if creating the file was successful
        cmp eax, 0
        je final
              
        
        ; read from a file
        read_loop:
            push dword [file_descriptor]
            push dword len
            push dword 1
            push dword text2       
            call [fread]
            add esp, 4*4
            
            cmp eax, 0
            je display_result
            
            mov [number_read_char], eax
            
            
            mov esi, text2
            mov ecx, [number_read_char]
            jecxz final
            count_loop:
                lodsb
                cmp al, 0
                je skip_char
                cmp al, ' '
                je skip_char
                cmp al, 'a'
                je skip_char
                cmp al, 'e'
                je skip_char
                cmp al, 'i'
                je skip_char
                cmp al, 'o'
                je skip_char
                cmp al, 'u'
                je skip_char
                cmp al, 'A'
                je skip_char
                cmp al, 'E'
                je skip_char
                cmp al, 'I'
                je skip_char
                cmp al, 'O'
                je skip_char
                cmp al, 'U'
                je skip_char
                cmp al, 65              
                jl skip_char
                cmp al, 90
                jle is_consonant
                cmp al, 97              
                jl skip_char
                cmp al, 122
                jg skip_char
            is_consonant:
                add dword[x], 1
            skip_char:
                loop count_loop
                jmp read_loop
          
        display_result:  
            push dword[x]
            push dword msg
            call [printf]
            add esp, 4*2
          
        clean_up:
            push dword [file_descriptor]
            call [fclose]
            add esp, 4
            
        final:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
