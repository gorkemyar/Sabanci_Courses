#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <stdbool.h>

int main(int argc, char *argv[]) {
    
    printf("I’m SHELL process, with PID: %d - Main command is: man ls | grep -e -a\n", (int)getpid());

    //PIPE
    int fd[2];
    pipe(fd);

    // First fork for MAN
    int rc = fork();
    if (rc < 0) {
        // fork failed  
        fprintf(stderr, "fork failed\n");
        exit(1);
    } else if (rc == 0) {
        
        close(fd[0]);

        printf("I’m MAN process, with PID: %d - My command is: man ls\n",(int)getpid());
        
        // CREATE MYARGS FOR MAN
        char *myargs[3];
        myargs[0] = strdup("man");
        myargs[1] = strdup("ls");
        myargs[2] = NULL;
        dup2(fd[1], STDOUT_FILENO);
        close(fd[1]);
        execvp(myargs[0], myargs); 
    } else {
        // Second fork for GREP
        int rc_2 = fork();
        if (rc_2 < 0){
            fprintf(stderr, "fork failed\n");
            exit(1);
        }
        else if (rc_2 == 0){
            waitpid(rc, NULL,0);
            close(fd[1]);
            printf("I’m GREP process, with PID: %d - My command is: grep -e -a\n",(int)getpid());
            dup2(fd[0], STDIN_FILENO);
            close(fd[0]);

            int newFile = open("output.txt", O_CREAT|O_WRONLY, 0777);
            dup2(newFile, STDOUT_FILENO);
            // CREATE MYARGS FOR GREP
            char *myargs[4];
            myargs[0] = strdup("grep");
            myargs[1] = strdup("-e");
            myargs[2] = strdup("-a");
            myargs[3] = NULL;
            execvp(myargs[0], myargs);  
        }else{
            close(fd[0]);
            close(fd[1]);
            wait(NULL);
            printf("I’m SHELL process, with PID: %d - execution is completed, you can find the results in output.txt\n", (int)getpid());
        }
    }
    return 0;
}