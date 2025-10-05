#include <stdio.h>
#include <stdlib.h>

// Declare external functions implemented in Assembly
void parse_numbers(const char* buffer, int* numbers, unsigned char* num_count);

int main() {
    char buffer[100] = {0};       // Space for input string (null-terminated)
    int numbers[50] = {0};        // Array to store parsed numbers
    unsigned char num_count = 0;  // Count of parsed numbers

    // Prompt the user for input
    printf("Enter a string of signed numbers (e.g., -12 34 -56): ");
    scanf("%99[^\n]", buffer); 
    
    // Call the Assembly function to parse numbers
    parse_numbers(buffer, numbers, &num_count);
    
    // Output the parsed numbers
    printf("Parsed %d numbers:\n", (int)num_count);
    for (int i = 0; i < num_count; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}




