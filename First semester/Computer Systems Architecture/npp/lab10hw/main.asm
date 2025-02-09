; Read from the keyboard a string of numbers, given in the base 10 as signed numbers (a string of characters is read from the keyboard and a string of numbers must be stored in the memory).

bits 32
global start        

extern exit, printf           
import exit msvcrt.dll
import printf msvcrt.dll

extern read_input
extern parse_numbers
import read_input msvcrt.dll
import parse_numbers msvcrt.dll

segment data public data use32
    prompt db "Enter a string of signed numbers (e.g., -12 34 -56): ", 0
    parsed_msg db "Parsed numbers: ", 0
    buffer db 100, 0           ; Space for input string (null-terminated)
    numbers times 50 dd 0           ; Array for storing the parsed numbers
    num_count db 0                 ; To store the count of parsed integers
    num_format db "%d ", 0         ; Format for printing numbers

segment code public code use32
start:
    ; Prompt the user
    push dword prompt
    call [printf]
    add esp, 4

    ; Call read_input to get the string from the user
    push dword buffer
    call read_input
    add esp, 4

    ; Call parse_numbers to process the string
    mov ecx, buffer         ; Address of the input buffer
    mov edx, numbers        ; Address of the numbers array
    mov edi, num_count      ; Address to store the count of parsed numbers
    call parse_numbers

    ; Print "Parsed numbers: "
    push dword parsed_msg
    call [printf]
    add esp, 4

    ; Print each parsed number
    
    movzx ecx, byte[num_count]    ; Load num_count into ECX
    test ecx, ecx                  ; Check if any numbers were parsed
    jz end_program                 ; If no numbers, skip to the end

    mov esi, numbers               ; Point to the numbers array
    print_loop:
        mov eax, [esi]                 ; Load the current number
        push eax                       ; Push the number to the stack
        push dword num_format          ; Push the format string
        call [printf]                  ; Call printf to print the number
        add esp, 8                     ; Clean up the stack (2 arguments)
        add esi, 4                     ; Move to the next number
        dec ecx                        ; Decrement the counter
        jnz print_loop                 ; Repeat if more numbers remain

end_program:
    ; Exit the program
    push dword 0
    call [exit]




