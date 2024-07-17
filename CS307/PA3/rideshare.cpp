#include <iostream>
#include <vector>
#include <string>
#include <pthread.h>
#include <stdlib.h>
#include <semaphore.h>
#include <unistd.h>

using namespace std;

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
pthread_barrier_t barrier;
sem_t* home = new sem_t;
sem_t* rival = new sem_t;
sem_t all;

int * fanCount = new int(0);
int * rivalCount = new int(0);

bool isCar = false;

void* audience(void* argv){ 
    bool isFan = (bool)argv; // argv is a boolean. If it is a fan thread it is true otherwise false 

    //decide which counts and semaphores we are going to use.
    int *own = isFan ? fanCount : rivalCount; 
    int *enemy = isFan ? rivalCount : fanCount; 
    sem_t * homeSem = isFan ? home : rival;
    sem_t * rivalSem = isFan ? rival : home;
    string audienceType = isFan ? "A" : "B";

    // captain flag for each thread it will be true for only the last thread
    bool isCaptain = false; 

    // total threads that are waiting for a car
    int total = 0; 

    // initially all semaphore assigned to 4
        // first 4 cars will pass this semaphore
        // others will wait for a signal
    sem_wait(&all);
    
    //FIRST PHASE:

    pthread_mutex_lock(&lock); //acquire lock for incrementing operations and for printing

    //say I am looking for a car since we just entered the first phase of the program
    cout<<"Thread ID: "<<pthread_self()<<", Team:"<<audienceType<<", I am looking for a car"<<endl;

    // increment own count by 1 (either fan or rival)
    *own = (*own) + 1;

    // this is the case when there is exactly 4 cars and there is not any valid combination to send the car
    if (((*own) + (*enemy) == 4) && !((*own == 4) || ((*own) == 2 && (*enemy) >= 2))){    
        sem_post(&all); // we need to send a signal to all semaphore to get a new car
        pthread_mutex_unlock(&lock);
        sem_wait(homeSem);
    }else if ((*own == 4) || ((*own) == 2 && (*enemy) >= 2)){ // if we have enough and valid threads to start a car
        isCaptain = true; // since this is last thread it is captain
        total = *own + *enemy; // total number of threads that is waiting in semaphores
        int wake = *enemy; 

        // this is an edge case if enemy team has 3 threads in waiting list, and 2 threads in our team. 
        // One of the enemy threads should not wake up.
        if (wake % 2 == 1){ // check whether it is 3
            wake = wake - 1; // if it is wake up 2 of them
        }
        for (int i = 0; i <  wake; i++){
            sem_post(rivalSem);
            *enemy = (*enemy) - 1;
        }
        
        for (int i = 0; i <  (*own) -1; i++){ // wake up all the same teams semaphore
            sem_post(homeSem);
        }
        *own = 0;       
        pthread_mutex_unlock(&lock);
    }else{ // if we have not got enough threads to start a car
        pthread_mutex_unlock(&lock);
        sem_wait(homeSem); // wait in semaphore
    }
    
    //SECOND PHASE:
    // At this point captain thread wake up 3 threads and captain thread is also a thread. So there is exactly 4 threads reached to car.
    // They will print the following in a mutex.
    pthread_mutex_lock(&lock);
    cout<<"Thread ID: "<<pthread_self()<<", Team:"<<audienceType<<", I have found a spot in a car"<<endl;
    pthread_mutex_unlock(&lock);

    //Wait for other threads to come here
    pthread_barrier_wait(&barrier);

    //THIRD PHASE:
    // all of the threads passed the barrier there is only one captain thread
    if (isCaptain){
        pthread_mutex_lock(&lock);     
     
        cout<<"Thread ID: "<<pthread_self()<<", Team:"<<audienceType<<", I am the captain and driving the car"<<endl;
        
        // This is another edge case if there were 5 threads looking for a car
            // send 3 signals to general semaphore since one thread is already sleeping in one of the team semaphores.
            // otherwise send 4 signals
        int wake = (total == 5) ? 3 : 4; 
        for (int i = 0; i < wake; i++){
            sem_post(&all);
        }
        pthread_mutex_unlock(&lock);
    }
    
    return NULL;
}   


int main(int argc, char** argv ){
    //Take the parameters from command line.
    int fan = atoi(argv[1]), enemy = atoi(argv[2]);
  
    // Check whether the number of fan and enemy threads are even. Also the total number should be divisible by 4
    if (fan % 2 == 0 && enemy % 2 == 0 && (fan+enemy) % 4 == 0) { 
        // Initialize barrier with 4 since there will exactly 4 threads in the car
        pthread_barrier_init (&barrier, NULL, 4); 

        // This is a general semaphore to keep track of the threads which is looking for a car. Acts as a barrier.
        sem_init(&all, 0, 4); 

        // These 2 semaphores are used like a conditional variable to sleep threads that looking for a car.
        sem_init(home, 0, 0);  
        sem_init(rival, 0, 0);  

        // Initial counts are 0
        *fanCount = 0; 
        *rivalCount = 0; 

        // Initialize threads
        pthread_t* threads = new pthread_t[fan + enemy]; 
        for (int i = 0; i < fan; i++){
            pthread_create(&threads[i], NULL, &audience, (void*)true);
        }for (int i = 0; i < enemy; i++){
            pthread_create(&threads[fan + i], NULL, &audience, (void*)false);
        }

        // Join threads
        for (int i = 0; i < fan + enemy; i++){ 
            pthread_join(threads[i], NULL);
        }
    }
    
    cout<<"The main terminates"<<endl; // execution ended
    return 0;
}
