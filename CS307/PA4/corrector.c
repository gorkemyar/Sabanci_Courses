
#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <fcntl.h>

char* read_words (FILE *f) {
    char *x = malloc(1024*sizeof(char));
    /* assumes no word exceeds length of 1023 */
    if (fscanf(f, " %1023s", x) == 1) {   
        return x;
    }
    return NULL;
}

void correctFile(FILE* current_file, FILE* database, char* directory){

    char* current_word = "";
    while (current_word != NULL){
        current_word = read_words(current_file); // read current word
        if (current_word != NULL){
            fseek(database, 0, SEEK_SET); // go to the beginning of the file
            char* database_word = "";
            while (database_word != NULL){ // read database
                database_word = read_words(database);
                if (database_word != NULL && strcmp(database_word, current_word) == 0){ // compare the word 

                    int word_size = strlen(current_word); 
                    fseek(current_file, -1*(word_size+4) ,SEEK_CUR); // go to the location where mr. writes
                    fseek(database, -1*(word_size+2) ,SEEK_CUR); // go to the location of gender

                    database_word = read_words(database); // read gender
                    char* title = strcmp(database_word, "f") == 0 ?  "Ms.": "Mr.";
                    fputs(title, current_file);
                    
                    fseek(current_file, word_size + 2, SEEK_CUR); // go to surname
                    fseek(database, word_size + 2, SEEK_CUR); // go to surname

                    database_word = read_words(database); 
                    fputs(database_word, current_file); // write surname
                    
                    free(database_word);
                    break;
                }
                free(database_word);
            }
        }
        free(current_word);
    } 
}

void openFiles(char* directory, char* database_name, FILE* database_file){ // open files recursively

    //Directory
    DIR *d; 
    struct dirent *dir;
    d = opendir(directory);
    if (d) 
    {
        char filename[500];
        while ((dir = readdir(d)) != NULL)
        {	
            memset(filename,'\0', 500);
            strcat(filename, directory);
            strcat(filename, dir->d_name);     
            char *path = ".txt";
            if (strcmp(filename, database_name) != 0){
                if (strstr(dir->d_name,path)){ // if a .txt file
                    
                    FILE *fptr;
                    fptr = fopen(filename, "r+"); // open txt file
                    if (fptr != NULL)
                    {
                        correctFile(fptr, database_file, filename); // correct txt file
                        fclose(fptr);
                    }
                }else if (strcmp(dir->d_name, ".") != 0 && strcmp(dir->d_name, "..") != 0){ // if not a txt file
                    DIR* tmp = opendir(filename);
                    if (tmp){ // if a directory
                        strcat(filename, "/"); 
                        openFiles(filename, database_name, database_file); // recursively call function
                    }
                }
            }
        }
        closedir(d);    
    }
}

int main(void)
{
    char* database_name = "./database.txt"; // location of database
    FILE* database_file; 
    database_file = fopen(database_name, "r"); 
    openFiles("./", database_name, database_file); 
    return(0);
}
