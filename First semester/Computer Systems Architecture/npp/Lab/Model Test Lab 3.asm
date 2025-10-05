; Sa se scrie sirul de numere in baza doi intr-un alt fisier.
bits 32 
global start      
extern exit  , fopen , fscanf  , fclose, fprintf          
import exit msvcrt.dll
import fopen msvcrt.dll  
import fscanf msvcrt.dll  
import fclose msvcrt.dll
import fprintf msvcrt.dll
segment data use32 class=data
    acces_mode db "r", 0
    file_name db "numbersList.txt", 0
    file_descriptor dd 0
    buffer dd 0
    reading_format db "%d", 0
    index_of_list dd 0
    numbers_list_length equ 10
    numbers_list resd numbers_list_length
    numbers_counter dd 0
    output_file db "output3.txt", 0
    writing_acces_mode db "w",0
    output_buffer resb 33
    space db "%s ", 0
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
            mov [numbers_list + ebx*4], eax
            add dword [index_of_list], 1
            add dword [numbers_counter], 1
            
            jmp reading_loop
            
        end_reading_loop:
            push dword [file_descriptor]
            call [fclose]
            add esp, 4
            
        push writing_acces_mode
        push output_file
        call [fopen]
        add esp, 4*2
        
        cmp eax, 0
        je final
        
        mov [file_descriptor], eax 
        
        mov esi, numbers_list
        write_conversion_loop:
            lodsd
            push eax
            
            mov ebx, 32
            conversion_loop:
                dec ebx
                shr eax, 1
                jc set_one
                mov byte[output_buffer+ebx], "0"
                jmp check_end_conversion
                set_one:
                    mov byte[output_buffer+ebx], "1"
            check_end_conversion:
                test ebx, ebx
                jnz conversion_loop
                
                push dword output_buffer
                push dword space
                push dword [file_descriptor]
                call [fprintf]
                add esp, 4*2
                
                pop eax
                dec dword[numbers_counter]
                jnz write_conversion_loop
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:    
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
