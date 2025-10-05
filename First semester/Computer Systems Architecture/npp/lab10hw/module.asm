; Read from the keyboard a string of numbers, given in the base 10 as signed numbers (a string of characters is read from the keyboard and a string of numbers must be stored in the memory).

bits 32

extern scanf
import scanf msvcrt.dll

global read_input, parse_numbers

segment data public data use32
    format db "%99[^\n]", 0       ; Format for reading a line of input

segment code public code use32

; Function: read_input
read_input:
    push ebp
    mov ebp, esp
    push dword format        ; Push the format string ("%99[^\n]")
    push dword [ebp + 8]     ; Push the buffer address (argument from caller)
    call [scanf]             ; Call scanf
    add esp, 8               ; Clean up the stack (2 arguments)
    mov esp, ebp
    pop ebp
    ret

; Function: parse_numbers
parse_numbers:

    xor ebx, ebx              ; Counter for numbers (EBX = 0)
    xor esi, esi              ; Temporary variable for current number
    xor eax, eax              ; Clear EAX (used for digit processing)
    mov byte [edi], 0         ; Initialize num_count to 0

parse_loop:
    mov al, [ecx]             ; Load current character
    cmp al, 0                 ; Check for end of string
    je parse_done             ; If null-terminator, finish parsing

    cmp al, 32                ; Check for space (ASCII: 32)
    je save_number            ; If space, save the current number

    cmp al, '-'               ; Check for minus sign
    jne check_digit           ; If not a minus sign, check if it's a digit
    test esi, esi             ; Check if we are already parsing a number
    jnz next_char             ; Ignore '-' in the middle of a number
    mov esi, -1               ; Mark the number as negative
    jmp next_char

check_digit:
    sub al, '0'               ; Convert ASCII to a digit (0-9)
    cmp al, 9
    ja invalid_char           ; Ignore invalid characters
    test esi, esi             ; Check if we're starting a new number
    jz start_number           ; If no number is being parsed, start one

    imul ebx, ebx, 10         ; Multiply current number by 10
    add ebx, eax              ; Add the digit to the current number
    jmp next_char

start_number:
    mov ebx, eax              ; Start a new number with the current digit
    mov esi, 1                ; Mark number as positive (default)

next_char:
    inc ecx                   ; Move to the next character
    jmp parse_loop

save_number:
    test esi, esi             ; Check if a number is being parsed
    jz skip_save              ; If not, skip saving
    test esi, esi             ; Check if the number is negative
    jg save_positive
    neg ebx                   ; If negative, negate the number

save_positive:
    mov [edx], ebx            ; Save the current number to the numbers array
    add edx, 4                ; Move to the next position in the array
    inc byte [edi]            ; Increment the number count
    xor ebx, ebx              ; Reset current number
    xor esi, esi              ; Reset sign flag
skip_save:
    inc ecx                   ; Skip the space
    jmp parse_loop

invalid_char:
    inc ecx                   ; Ignore invalid characters
    jmp parse_loop

parse_done:
    test esi, esi             ; Check if there's a number left to save
    jz parse_exit             ; If not, exit
    jmp save_number           ; Save the last number

parse_exit:
    ret


    
        
        
        
             
        
            
            
        
        
        
    

        
        
        
