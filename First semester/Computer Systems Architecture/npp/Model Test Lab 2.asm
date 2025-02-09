; Sa se sorteze sirul de numere.
bits 32 
global start        
extern exit, fopen, fscanf, fclose, printf            
import exit msvcrt.dll 
import fopen msvcrt.dll
import fscanf msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
segment data use32 class=data
    numbers_file db "numbersList.txt", 0
    acces_mode db "r", 0
    file_descriptor dd 0
    buffer dd 0
    reading_format db "%d", 0
    index_of_list dd 0
    numbers_list_length equ 10
    numbers_list resd numbers_list_length 
    numbers_counter dd 0
    loop_counter dd 0
    writing_format db "%d ", 0
    newline db 0x0A, 0
segment code use32 class=code
    start:
        push dword acces_mode
        push dword numbers_file
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        
        cmp eax, 0
        je final
        
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
          
        mov ecx, [numbers_counter]
        dec ecx
        bubble_sort_outer:
            mov esi, 0
            mov edx, ecx
            
            bubble_sort_inner:
                mov eax, [numbers_list + esi*4]
                mov ebx, [numbers_list + esi*4 + 4]
                cmp eax, ebx
                jle no_swap
                mov [numbers_list+esi*4], ebx
                mov [numbers_list + esi*4 + 4], eax
                
                no_swap:
                    inc esi
                    dec edx
                    jnz bubble_sort_inner
                    dec ecx
                    jnz bubble_sort_outer
         
        mov ebx, [numbers_counter]
        mov esi, numbers_list
        print_sorted_numbers:
            lodsd
            push eax 
            push dword writing_format
            call [printf]
            add esp, 4*2
            dec ebx
            jnz print_sorted_numbers
            
     final:   
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
