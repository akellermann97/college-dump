#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

void make_all_lower(char * string_to_convert);

int main(int argc, char ** argv){

    char * intro_message = "Insert string to be deciphered\n";
    char input_buffer[1024];

    // prints the intro message to stdout
    fputs(intro_message, stdout);

    // gets the text entered by the user, max of 1023 characters, the program
    // will not support lines any longer than that. This prevents buffer
    // overflows
    fgets(input_buffer, 1023, stdin);

    make_all_lower(input_buffer);
    fputs(input_buffer, stdout);

    for(int i = 0; i < 26; i++){
        // do all 26 rotations
        int y = 0;
        while(input_buffer[y] != '\0')
        {
            if(input_buffer[y] == 'z')
            {
                input_buffer[y] = 'a';
            } else {
                input_buffer[y] += 1;
            }
            y++;
        }
        // prints the contents of the rotated buffer
        fputs(input_buffer, stdout);
        printf("\n");
    }

    return EXIT_SUCCESS;
}

void make_all_lower(char * string_to_convert){
    int i = 0;
    while(string_to_convert[i] != '\0'){
        string_to_convert[i] = tolower(string_to_convert[i]);
        i++;
    }

}
