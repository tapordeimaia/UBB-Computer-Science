; Sa se calculeze cel mai lung subsir de numere pare, afisati-l in baza 16.
bits 32 
global start        
extern exit, fopen, fscanf, fclose               
import exit msvcrt.dll 
import fopen msvcrt.dll  
import fscanf msvcrt.dll 
import fclose msvcrt.dll
segment data use32 class=data
    acces_mode db "%r", 0
    file_name db "numbersList.txt", 0
    file_descriptor dd 0
    buffer dd 0
    reading_format db "%d", 0
    index_of_list dd 0
    numbers_list_length equ 10
    numbers_list resd numbers_list_length
    numbers_counter dd 0
    current_length dd 0
    other_buffer_list resd 10
    current_index dd 0
    other_buffer_list_length dd 0
    longest_buffer_list resd 10
    longest_buffer_list_length dd 0
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
            mov [numbers_list+ebx*4], eax 
            add dword [index_of_list], 1
            add dword [numbers_counter], 1
            
            jmp reading_loop
        
        end_reading_loop:
            push dword [file_descriptor]
            call [fclose]
            add esp, 4
         
        ; i have the list. i take the first element, if it is even, i add it to a buffer list, and i increase the length of longest even sublist. i take the next element, it is also even, i add it to the buffer list, and i increase the length of longest even sublist. (buffer: first element, second elemet; length of longest sublist: 2). I take the next element, it is odd. i take the next element, it is even, i add it to the other buffer list, i compare the length of it with the length of longeste evn sublist, if it is smaller, i take the next element, if it is bigger i put this other buffer list into the longest buffer list, and i move the current length to the longest length.
                 
        mov esi, numbers_list
        print_longest_even_sublist:
            cmp dword[current_index], dword[numbers_counter]
            jg finalize_longest_sublist
            lodsd
            
            test eax, 1
            jnz not_even
            
            mov [other_buffer_list+current_index*4], eax 
            add dword [other_buffer_list_length], 1
            add dword[current_index], 1
            
            jmp next_number
            
            not_even:
                cmp dword[other_buffer_list_length], dword[longest_buffer_list_length]
                jle reset_other_buffer
                mov dword[longest_buffer_list_length], dword[other_buffer_list_length]
                mov dword[current_index], 0
            copy_other_to_longest:
                cmp dword[current_index], dword [other_buffer_list_length]
                jge reset_other_buffer
                mov eax, [other_buffer_list+current_index*4]
                mov [longest_buffer_list+current_index*4], eax
                inc dword [current_index]
                jmp copy_other_to_longest
            reset_other_buffer:
                mov dword[current_index], 0
                mov dword[other_buffer_list_length], 0
            next_number:
                add dword[current_index], 1
                jmp print_longest_even_sublist
        finalize_longest_sublist:
            cmp dword[other_buffer_list_length], dword[longest_buffer_list_length]
            jle convert_to_hex
            mov dword[longest_buffer_list_length], dword[other_buffer_list_length]
            mov dword [current_index], 0
        copy_other_to_longest_final:
            cmp dword[current_index], dword [other_buffer_list_length]
            jge convert_to_hex
            mov eax, [other_buffer_list+current_index*4]
            mov [longest_buffer_list+current_index*4], eax
            inc dword [current_index]
            jmp copy_other_to_longest_final
            
        
             
             
        
        
            
                
                
                
        
            
        
    final:    
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
