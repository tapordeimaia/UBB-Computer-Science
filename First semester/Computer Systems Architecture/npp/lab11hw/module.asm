bits 32

global  _parse_numbers


segment data public data use32

segment code public code use32

    ; Function: parse_numbers
    ; Parses signed integers from a null-terminated string
    ; Inputs:
    ;   ecx - Address of the input buffer
    ;   edx - Address of the numbers array
    ;   edi - Address to store the count of parsed numbers
    _parse_numbers:
        push ebp                  ; Save base pointer
        mov ebp, esp              ; Set up stack frame

        mov ecx, [ebp + 8]        ; Address of input buffer
        mov edx, [ebp + 12]       ; Address of numbers array
        mov edi, [ebp + 16]       ; Address to store count of parsed numbers

        xor ebx, ebx              ; Counter for numbers (EBX = 0)
        xor esi, esi              ; Temporary variable for current number
        xor eax, eax              ; Clear EAX (used for digit processing)
        mov byte [edi], 0         ; Initialize num_count to 0

    _parse_loop:
        mov al, [ecx]             ; Load current character
        cmp al, 0                 ; Check for end of string
        je _parse_done            ; If null-terminator, finish parsing

        cmp al, 32                ; Check for space (ASCII: 32)
        je _save_number           ; If space, save the current number

        cmp al, '-'               ; Check for minus sign
        jne _check_digit          ; If not a minus sign, check if it's a digit
        test esi, esi             ; Check if we are already parsing a number
        jnz _next_char            ; Ignore '-' in the middle of a number
        mov esi, -1               ; Mark the number as negative
        jmp _next_char

    _check_digit:
        sub al, '0'               ; Convert ASCII to a digit (0-9)
        cmp al, 9
        ja _invalid_char          ; Ignore invalid characters
        test esi, esi             ; Check if we're starting a new number
        jz _start_number          ; If no number is being parsed, start one

        imul ebx, ebx, 10         ; Multiply current number by 10
        add ebx, eax              ; Add the digit to the current number
        jmp _next_char

    _start_number:
        mov ebx, eax              ; Start a new number with the current digit
        mov esi, 1                ; Mark number as positive (default)

    _next_char:
        inc ecx                   ; Move to the next character
        jmp _parse_loop

    _save_number:
        test esi, esi             ; Check if a number is being parsed
        jz _skip_save             ; If not, skip saving
        test esi, esi             ; Check if the number is negative
        jg _save_positive
        neg ebx                   ; If negative, negate the number

    _save_positive:
        mov [edx], ebx            ; Save the current number to the numbers array
        add edx, 4                ; Move to the next position in the array
        inc byte [edi]            ; Increment the number count
        xor ebx, ebx              ; Reset current number
        xor esi, esi              ; Reset sign flag
    _skip_save:
        inc ecx                   ; Skip the space
        jmp _parse_loop

    _invalid_char:
        inc ecx                   ; Ignore invalid characters
        jmp _parse_loop

    _parse_done:
        test esi, esi             ; Check if there's a number left to save
        jz _parse_exit            ; If not, exit
        jmp _save_number          ; Save the last number

    _parse_exit:
        mov esp, ebp
        pop ebp                   ; Restore base pointer
        ret