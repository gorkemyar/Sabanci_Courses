#include <iostream>
#include <vector>
#include <string>
#include <string.h>
#include <pthread.h>
#include <fstream>
#include <sstream>
#include <fcntl.h>
#include <sys/wait.h>
#include <unistd.h>

using namespace std;
// Global lock for threads
pthread_mutex_t global_mutex;


// thread function: prints the results of commands to the console
void* printPipe(void* args){
    int *fd = (int*)args;

    string s;
    char ch[2];

    //lock mutex to get a print statement without interleaving the results
    pthread_mutex_lock(&global_mutex);
    FILE *output = fdopen(*fd, "r");
    fsync(*fd);
    // write results to the console
    cout<<"---- "<<pthread_self()<<endl;
    while (fgets(&ch[0], 2, output)){
        if (ch[0] != '\n'){
            s.push_back(ch[0]);
        }else{
            cout<<s<<endl;
            s.clear();
        }
    }
    cout<<"---- "<<pthread_self()<<"\n\n\n\n"<<endl;
    // sync the console
    fsync(STDOUT_FILENO);
    fsync(*fd);
    fflush(NULL);
    //unlock mutex to avoid deadlocks
    pthread_mutex_unlock(&global_mutex);
    return NULL;
}

int main() {
    // initialize mutex
    if (pthread_mutex_init(&global_mutex, NULL) != 0) {
        cout<<"\n mutex init has failed\n";
        return 1;
    }
    // input and parse file
    ifstream input;
    string filename = "command.txt";
    input.open(filename.c_str());
    ofstream out("parse.txt");

    // holds the ids of the threads for joining them
    vector<pthread_t> threads;

    string line;
    while (getline(input, line)){ // read command file line by line
        
        istringstream linestream(line); // create string stream to read words in line
        string word;
        vector<string> commands;
        while(linestream>>word){
            commands.push_back(word); //push words in a vector
        }
        int count = 1; // number of arguments in command
        string command = commands[0], input = "", options = "", redirection = "-", background = "", filename = "";
        for (int i = 1; i < commands.size(); i++){ //find the keywords
            string com = commands[i];
            if (com == ">" || com == "<"){ // if redirection
                redirection = com;
                filename = commands[i+1];
                i++;
            }else if (com == "&"){ // if background
                background = com;
            }else if (com[0] == '-'){ // if an option
                options = com;
                count++;
            }else{ // otherwise it is an input
                input = com;
                count++;
            }
        }
        // print keywords to the parse.txt
        out<<"----------\n";
        out<<"Command: "<<command<<endl;
        out<<"Input: "<<input<<endl;
        out<<"Options: "<<options<<endl;
        out<<"Redirection: "<<redirection<<endl;
        out<<"Background Job: "<<background<<endl;
        out<<"----------\n";

        // check whether the command is wait or not
        if (commands[0] != "wait"){
            int* fd = new int[2]; // first create a pipe
            pipe(fd);
            int rc = fork(); 
        
            if (rc < 0) {
                // Fork Failed
                fprintf(stderr, "fork failed\n");
                exit(1);
            } else if (rc == 0) { // child process
                
                if (redirection == "<"){//check for redirection and if there is change the stdin as input file
                    int file = open(filename.c_str(),
                                O_RDONLY);
                    dup2(file, STDIN_FILENO);
                }

                close(fd[0]);
                char *myargs[count+1]; // number of arguments + 1 for the NULL at the end
                int pos = 0;


                // add arguments to argument array
                char *cstr = new char[command.length() + 1]; 
                strcpy(cstr, command.c_str());
                myargs[pos++] = cstr; 
                if (count > pos && input != ""){
                    char *nstr = new char[input.length() +1];
                    strcpy(nstr,input.c_str());
                    myargs[pos++] = nstr;
                }
                if (count > pos && options != ""){
                    char *ostr = new char[options.length()+1];
                    strcpy(ostr, options.c_str());
                    myargs[pos++] = ostr;
                }
                // last position need to be null
                myargs[pos] = NULL;
                // if there is an output redirection directly redirect output to that file
                if (redirection == ">"){
                    int outFile = open(filename.c_str(), O_CREAT|O_WRONLY, 0777);
                    dup2(outFile, STDOUT_FILENO);
                }else{ // otherwise we need to write result to the write end of the pipe
                    dup2(fd[1], STDOUT_FILENO);
                }
                // execute command
                execvp(myargs[0], myargs);

            }else{ // we are in the parent process
                close(fd[1]); 
                if (background != "&" && redirection == ">"){ // if it is not background and there is a output redirection
                    // just need to wait to write results to the output file
                    waitpid(rc, NULL, 0); 
                }else if(background != "&" && redirection != ">"){ // if it is not background and not redirected to an output
                    // create thread and wait for the result
                    pthread_t newThread; 
                    pthread_create(&newThread, NULL, &printPipe ,(void*)&fd[0]); 
                    pthread_join(newThread, NULL);
                }else if(background == "&" && redirection != ">"){ // if it is background and not redirected to an output
                    // create thread and do not wait
                    pthread_t newThread;
                    pthread_create(&newThread, NULL, &printPipe ,(void*)&fd[0]);
                    threads.push_back(newThread);
                }
            }

        }else{ // if command is wait
            // wait for the all of the running threads
            for (auto thread: threads){
                pthread_join(thread,NULL);
            }
            threads.clear();
        }
    }
    // all of the commands are finished
    // need to wait for all of the threads
    for (auto thread: threads){
        pthread_join(thread,NULL);
    }
    threads.clear();
    
    return 0;
}
