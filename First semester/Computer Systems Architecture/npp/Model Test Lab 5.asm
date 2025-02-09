; se citeste de la tastatura un nume de fisier si un numar N (0<=N<=8). Programul va lua cel de al N-ulea bit din fiecare caracter (byte) din fisier si va numara bitii 1. Programul va afisa numarul de biti la consola.
bits 32 
global start        
extern exit, scanf, fread, fopen, fclose, printf               
import exit msvcrt.dll 
import scanf msvcrt.dll   
import fread msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
segment data use32 class=data
    N dd 0
    N_format db "%d", 0
    file_name resb 256
    file_name_format db "%s", 0
    file_descriptor dd 0
    length equ 1
    buffer dd 0
    acces_mode db "r", 0
    characters_list resd 3
    current_index dd 0
    number_characters dd 0
    bits_list resb length
    bits_counter dd 0
    print_format db "%d", 0
segment code use32 class=code
    start:
        push dword N
        push dword N_format
        call [scanf]
        add esp, 4*2
        
        push dword file_name
        push dword file_name_format
        call [scanf]
        add esp, 4*2
        
        push dword acces_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        cmp eax, 0
        je final
        
        mov [file_descriptor], eax
        
        reading_loop:
            push dword [file_descriptor]
            push dword length
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4
            
            cmp eax, 0 
            je end_reading_loop
            
            mov ebx, [current_index]
            mov eax, [buffer]
            mov [characters_list+ebx*4], eax
            add dword[current_index], 1
            add dword[number_characters], 1        

            
            jmp reading_loop
        
        end_reading_loop:
            
            push dword [file_descriptor]
            call [fclose]
            add esp, 4
            
        mov esi, characters_list
        add dword[number_characters], 1
        mov ecx, [number_characters]
        get_nth_bit:
            dec dword[number_characters]
            cmp dword[number_characters], 0
            je print
            lodsb
            sub dword[N], 1
            mov cl, [N]
            shl al, cl
            and al, 10000000b
            cmp al, 10000000b
            je add_counter
            jmp get_nth_bit
            add_counter:
                add dword[bits_counter], 1
                jmp get_nth_bit
        
        print:
            push dword [bits_counter]
            push dword print_format
            call [printf]
            add esp, 4*2
        
        
    final:    
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
