bits 32 
global start        
extern exit, fopen, fscanf, fclose, fread, printf               
import exit msvcrt.dll 
import fopen msvcrt.dll 
import fscanf msvcrt.dll
import fclose msvcrt.dll  
import fread msvcrt.dll
import printf msvcrt.dll
segment data use32 class=data
    file_name db "input_test.txt", 0
    acces_mode db "r", 0
    file_descriptor dd 0
    buffer resd 100
    reading_format dd "%s", 0
    index_of_list dd 0
    length dd 100
    words_list resd 100
    words_counter dd 0
    sentence_words_counter dd 0
    writing_format db "%d", 0
    printed_word dd 0
segment code use32 class=code
    start:
        push dword acces_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        cmp eax, 0
        je final
        
        mov [file_descriptor], eax
        
        reading_loop:
            push dword buffer
            push dword reading_format
            push dword [file_descriptor]
            call [fscanf]
            add esp, 4*3
            
            cmp eax, 1
            jne end_reading_loop
            
            mov ebx, [index_of_list]
            mov eax, [buffer]
            mov [words_list+ebx*4], eax
            add dword[index_of_list], 1
            add dword[words_counter], 1
            
            jmp reading_loop
            
        end_reading_loop:
            push dword [file_descriptor]
            call [fclose]
            add esp, 4
        
        ;mov esi, words_list  
        ;mov ecx, [words_counter]  
        ;mov edx, writing_format 
        ;xor eax, eax
        ;print_loop: 
        ;    push dword [words_counter]
        ;    push edx            
        ;    call [printf]       
        ;    add esp, 8          

        ;add esi, 4          
        ;loop print_loop   
        
        push dword [words_counter]
        push dword writing_format
        call [printf]
        add esp, 4*8
        
        
            
        
            
        
        
        
    final:    
        push    dword 0      
        call    [exit]       
