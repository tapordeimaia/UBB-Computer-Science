; Sa se calculeze suma, produsul numerelor, pozitiile maximului. 
bits 32 
global start        
extern exit, fscanf, fopen, fclose, printf       
import exit msvcrt.dll  
import fscanf msvcrt.dll  
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
segment data use32 class=data
    file_name db "numbersList.txt", 0
    access_mode db "r", 0
    file_descriptor dd 0
    reading_format db "%d", 0
    buffer dd 0
    list_size equ 10
    numbers_list resd list_size
    index_of_list dd 0
    sum dd 0
    numbers_counter dd 0
    loop_iterator db 0
    max dd 0
    product dd 1
    output_format db "sum=%d, product=%d, maximum=%d", 0
segment code use32 class=code
    start:
        ; open the file
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        ; move the file address into file_descriptor
        mov [file_descriptor], eax
        
        ;check if we opened the file succesfully
        cmp eax, 0
        je final
        
        reading_loop:
            ; fscanf -> (file_descriptor, format, buffer)
            ; reading from the file
            push dword buffer
            push dword reading_format
            push dword [file_descriptor]
            call [fscanf]
            add esp, 4*3
            
            ; check if reading was successful
            cmp eax, 1
            jne end_reading_loop
            
            ; move the read numbers into numbers_list
            mov ebx, [index_of_list]
            mov eax, [buffer]
            mov [numbers_list + ebx*4] ,eax
            add dword [index_of_list], 1
            add dword [numbers_counter], 1
            
            ; jump to read the next number
            jmp reading_loop
        
        end_reading_loop:
            ;close the file
            push dword [file_descriptor]
            call [fclose]
            add esp, 4
            
        mov esi, numbers_list
        
        get_sum_product_maximum:
            mov bl, byte[loop_iterator]
            cmp bl, [numbers_counter]
            je print_sum_product_maximum
            
            lodsd
            
            cmp eax, [max] 
            jbe not_max
            mov [max], eax
            
            not_max:
                add dword[sum], eax
            
                mov ebx, [product]
                mul ebx
                mov [product], eax
                
                add byte[loop_iterator], 1
                jmp get_sum_product_maximum
        
        print_sum_product_maximum:
            push dword [max]
            push dword [product]
            push dword [sum]
            push dword output_format
            call [printf]
            add esp, 4*4
        
    final:
        push    dword 0      
        call    [exit]       
