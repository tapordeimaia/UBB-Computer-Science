bits 32
global start
extern exit, printf, fread, fopen, fclose, fscanf
import exit msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll

segment data use32 class=data
    print_message db "Nr citit este = %d", 10, 0
    input_file db "numbers_list.txt", 0
    read_mode db "r", 0
    format db "%d", 10, 0
    output_format db "sum = %d, product = %d, max = %d", 0
    output_file db "output.txt", 0
    write_mode db "w", 0
    file_descriptor dd 0
    buffer dd 0
    numbers_list resd 100
    index dd 0
    counter db 0
    iterator db 0
    sum dd 0
    product dd 1
    max dd 0
    
    
    
segment code use32 class=code
    start:
        ; eax = fopen(file_name, access_mode)
        push dword read_mode
        push dword input_file
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        
        cmp eax, 0
        je final

        mov esi, numbers_list
        
        read_loop:
            ; eax = fscanf(file_descriptor, read_format, buffer)
            push dword buffer
            push dword format
            push dword [file_descriptor]
            call [fscanf]
            add esp, 4*3
            
            cmp eax, 1
            jne end_read
            
            mov eax, [buffer]
            mov edx, [index]
            mov [esi+edx], eax
            add dword [index], 4
            add byte [counter], 1
            
            jmp read_loop
           
        end_read:
        
        push dword [file_descriptor]
            call [fclose]
            add esp, 4
            
        mov esi, numbers_list
        
        mov dword [index], 0
        iterate:
            mov bl, byte [iterator]
            cmp bl, [counter]
            je final
            
            lodsd
            
            ;push eax
            ;push dword format
            ;call [printf]
            ;add esp, 4*2
            
            cmp eax, [max]
            jbe not_max
                mov [max], eax
            not_max:
            
            add dword [sum], eax
            
            mov ebx, [product]
            xchg eax, ebx
            mul ebx
            mov [product], eax
            
            add dword [index], 4
            add byte [iterator], 1
            
            jmp iterate
        
        final:
        
        push dword [max]
        push dword [product]
        push dword [sum]
        push dword output_format
        call [printf]
        add esp, 4*4
        
        push dword 0
        call    [exit]
