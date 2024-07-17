// Gorkem Yar

#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <thread>
#include <chrono>

using namespace std;

// mutex global_mutex; //used for some debugging

ifstream openFile(){ //this functions asks user the filename until user enters a valid filename and compiler opens it. İt returns opened file
    ifstream input;
    
    do{
        cout<<"Please enter a file name for the matrix:"<<endl;
        string filename;
        cin>>filename;
        //filename="/Users/gorkemyar/Downloads/matrix1.txt";
        input.open(filename.c_str());
    }while (input.fail());
    return input;
}
int** returnDynArray(int& row, int& column){
    // this function reads data from an opened file and generate a dynamic 2D Array and returns it
    // with the reference parameters row and column it returns row size and column size as well
    ifstream input=openFile();
    string firstline;
    getline(input,firstline);
    istringstream firstlineStream(firstline);
    firstlineStream>>row>>column;
    int** dynArray=new int*[row];
    string line;
    int i=0;
    while (getline(input, line)){
        istringstream linestream(line);
        int tmp;
        dynArray[i]= new int[column];
        int j=0;
        while(linestream>>tmp){
            dynArray[i][j]=tmp;
            j++;
        }
        i++;
    }
    return dynArray;
}
mutex** createMutexes(int row, int column){
    // after the generation of 2D dynamic array this function create 2D dynamic mutex with the same sizes (row and column)
    mutex** mymutexes= new mutex* [row];
    for (int i=0;i<row;i++){
        mymutexes[i]=new mutex[column];
    }
    return mymutexes;
}

void printDynArray(const int * const * const dynArray, const int & row, const int & column){
    //this function prints the matrix no change
    for (int k=0;k<row;k++){
        for (int p=0;p<column;p++){
            cout<<setw(5)<<dynArray[k][p];
        }
        cout<<endl;
    }
    cout<<"-----"<<endl;
}


bool exists(const int & row, const int & column, int rowIndex, int columnIndex){
    //row and column is size
    // return whether the point exists or not
    return (0<=rowIndex&&rowIndex<row&&0<=columnIndex&&columnIndex<column);
}

struct existingNeighbour{
    // a struct that create linkedlist which includes existing main neighbours of a point
    int row;
    int column;
    existingNeighbour* next;
    existingNeighbour(int r=-1, int c=-1, existingNeighbour* n=nullptr): row(r), column(c), next(n){};
};

void deleteall(existingNeighbour* head){
    // a delete function which deletes the existingNeighbour linkedlist
    existingNeighbour* ptr=head;
    while(ptr!=nullptr){
        ptr=ptr->next;
        delete head;
        head=ptr;
    }
    head=nullptr;
    
}
existingNeighbour* neighbours(const int & row, const int & column, int rowIndex, int columnIndex){
    // a function that checks whether the main neighbours exist. if they are exist, the function add neighbours to a linked list and return the linkedlist's head
    existingNeighbour* head= new existingNeighbour(rowIndex, columnIndex, nullptr);
    existingNeighbour* ptr=head;
    if (exists(row, column, rowIndex-1, columnIndex)){
        ptr->next=new existingNeighbour(rowIndex-1, columnIndex);
        ptr=ptr->next;
    }
    if (exists(row, column, rowIndex+1, columnIndex)){
        ptr->next=new existingNeighbour(rowIndex+1, columnIndex);
        ptr=ptr->next;
    }
    if (exists(row, column, rowIndex, columnIndex-1)){
        ptr->next=new existingNeighbour(rowIndex, columnIndex-1);
        ptr=ptr->next;
    }
    if (exists(row, column, rowIndex, columnIndex+1)){
        ptr->next=new existingNeighbour(rowIndex, columnIndex+1);
        ptr=ptr->next;
    }
    return head;
}

bool lockExistingPoints(existingNeighbour* head, mutex** mutexes){
    // a function that locks existing points in the linkedlist
    // if the function succesfully lock everypoint in the linkedlist return true, otherwise return false
    // if the function could not succesfully lock everypoint in the linkedlist it reopens the one which the function already locked
    bool notFailed=true;
    existingNeighbour* ptr=head;
    //global_mutex.lock();
    while (ptr!=nullptr&&notFailed){
        notFailed=mutexes[ptr->row][ptr->column].try_lock(); // try locking an existing point in the linked list
        //cout<<notFailed<<endl;
        //cout<<ptr->row<<" "<<ptr->column<<" is gonna locked"<<endl;
        if (notFailed){
            //cout<<ptr->row<<" "<<ptr->column<<" is locked"<<endl;
            ptr=ptr->next;
            //cout<<notFailed<<endl;
        }
    }
    
    //global_mutex.unlock();
    existingNeighbour* ptrFailed=head;
    // if we are failed to lock every point in the linkedlist we locked the mutexes until the ptr so we need to reopen them
    // this while loop does this
    if (!notFailed){
        while(ptrFailed!=ptr){
            mutexes[ptrFailed->row][ptrFailed->column].unlock();
            //global_mutex.lock();
            //cout<<ptrFailed->row<<" "<<ptrFailed->column<<" is unlocked FFF"<<endl;
            //global_mutex.unlock();
            ptrFailed=ptrFailed->next;
        }
    }
    //cout<<"out"<<endl;
    //global_mutex.unlock();
    return notFailed;
}

void unlockPoints(existingNeighbour* head, mutex** mutexes){
    // if every node in the linkedlist succesfully locked this function unlock them after the change operations
    existingNeighbour* ptr=head;
    while (ptr!=nullptr){
        mutexes[ptr->row][ptr->column].unlock();
        //global_mutex.lock();
        //cout<<ptr->row<<" "<<ptr->column<<" is unlocked"<<endl;
        //global_mutex.unlock();
        ptr=ptr->next;
    }
}
template <class type>
void deleteDynamicArray(type** dynArray, int row){
    // will delete integer dynamic array and mutex dynamic array, to free memory
    for (int i=0;i<row;i++){
        delete[] dynArray[i];
    }
    delete[]dynArray;
}

void changer(int * const * const dynArray, const int & row, const int & column, int rowIndex, int columnIndex, mutex** mutexes, int &changeCounter){
    // change the cells values
    
    bool whiletrue=true;
    existingNeighbour* head=neighbours(row, column,rowIndex, columnIndex);
    // the while loop will continue until the all neighbours are locked by lockExistingPoints()
    while(whiletrue){
        bool notFailed = lockExistingPoints(head, mutexes);
        if (notFailed){
            whiletrue=false; //end of whileloop every mutex is locked
            
            //to find max point and max value
            int max=-1, maxRow=-1, maxColumn=-1;
            existingNeighbour* ptr=head;
            while (ptr!=nullptr){
                if (dynArray[ptr->row][ptr->column]>max){
                    max=dynArray[ptr->row][ptr->column];
                    maxRow=ptr->row;
                    maxColumn=ptr->column;
                }
                ptr=ptr->next;
            }
            
            // if the condition is true than there is a change
            if (max>=2*dynArray[rowIndex][columnIndex]){
                int temp=dynArray[rowIndex][columnIndex]/3;
                changeCounter++; // max bigger than 2*cell there is a change;
                // changeCounter decides continuation of the while loop in the main
                if(temp!=dynArray[rowIndex][columnIndex]/3.0){
                    temp++;
                }
                
                // the place of the maximum value
                string word;
                if (maxRow>rowIndex){
                    word="above";
                }
                else if (maxRow<rowIndex){
                    word="below";
                }
                else if (maxColumn>columnIndex){
                    word="to the right";
                }
                else if (maxColumn<columnIndex){
                    word="to the left";
                }
                
                //printing and the change
                ostringstream os;
                os<<"Row-"<<rowIndex<<",Col-"<<columnIndex<<" ("<<dynArray[rowIndex][columnIndex]<<") is incremented by "<<temp
                <<" by stealing from the cell to the "<<word<<" ("<<max<<")."<<endl;
                cout<<os.str();
                dynArray[maxRow][maxColumn]-=temp;
                dynArray[rowIndex][columnIndex]+=temp;
                
                // some debugging
                //global_mutex.lock();
                //cout << "\t\t\t ----" << this_thread::get_id()<<endl;
                //global_mutex.unlock();
            }
            unlockPoints(head, mutexes); // unlock points
            deleteall(head); // delete the linkedlist to prevent memory leak
        }
        else{
            // if not all points successfully locked
            this_thread::yield();
        }
    }
    //cout<<this_thread::get_id()<<"This thread out"<<endl;
}

int main() {
    int row, column;
    int** dynArray=returnDynArray(row, column);
    cout<<"Welcome to the last assignment :("<<endl;
    cout<<"-----"<<endl;
    cout<<"Printing the original matrix:"<<endl;
    printDynArray(dynArray, row, column);
    
    int numberThreads=row*column;
    mutex** mutexes=createMutexes(row, column);
    thread* threads= new thread[numberThreads];
    
    int changeCounter=-1;
    while (changeCounter!=0){
        cout<<"A new round starts"<<endl;
        changeCounter=0;
        for (int i=0;i<row;i++){
            for (int j=0; j<column;j++){
                threads[i*column+j]=thread(&changer, dynArray, row, column, i, j, mutexes, ref(changeCounter));
            }
        }
        for (int k=0;k<numberThreads;k++){
            threads[k].join();
            //cout<< "joined " << k <<endl;
        }
        if (changeCounter>0)
            cout<<"The round ends with updates."<<endl;
            cout<<"Printing the matrix after the updates: "<<endl;
            printDynArray(dynArray, row, column);
        cout<<"The round ends without updates."<<endl;
    }
    //memory freed
    delete [] threads;
    
    deleteDynamicArray(dynArray, row);
    deleteDynamicArray(mutexes, row);

    cout<<"-----"<<endl;
    cout<<"Program is exiting..."<<endl;

    return 0;
}
