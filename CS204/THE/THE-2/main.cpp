// Gorkem Yar

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>

using namespace std;

struct songInfo{
    string songName;
    string singer;
    string songGenre;
    int listenerCount;
    int duration;
    songInfo* next;
    songInfo* prev;
    songInfo(string _songName="", string _singer="", string _songGenre="", int _listenerCount=0, int _duration=0, songInfo* _next=nullptr, songInfo* _prev=nullptr): songName(_songName), singer(_singer), songGenre(_songGenre), listenerCount(_listenerCount), duration(_duration), next(_next), prev(_prev) {};
};

void InputCorrection(string & word){
    // make all of the letters uppercase and make one space between words
    string temp1="", temp2;
    istringstream wordstream(word);
    while (wordstream>>temp2){
        for (int i=0;i<temp2.length();i++){
            if ('a'<=temp2[i]&&temp2[i]<='z'){
                temp1+=((char) temp2[i]-'a'+'A');
            }
            else{
                temp1+=temp2[i];
            }
        }
        temp1+=" ";
    }
    wordstream.clear();
    word=temp1.substr(0,temp1.length()-1);
}

bool checkEmptyList(songInfo* head){
    // return true if the list is empty
    return head==nullptr;
}

// ı used do while loop to start from head and to end in head for all functions

bool checkSongExist(songInfo* head, string song){
    // return false if there is no such song in the list
    bool flag=false;
    songInfo* ptr=head;
    if (head!=nullptr){ //in case if we call this before calling check empty list
        do{
            if(ptr->songName==song){
                flag=true;
            }
            ptr=ptr->next;
        }while (ptr!=head);
    }
    return flag;
}
bool isAlpha(string word1, string word2){
    // takes two string if the first one (word1) comes previously in alphabetical order returns true otherwise return false
    int min= (int) word1.length();
    if (word2.length()<min){
        min=  (int) word2.length();
    }
    // tracer is for very edge case i mentioned at the bottom
    bool tracer=false; // this one is keeping whether there is a presedence among them only remains false if one of the words consist other one such as; ara and araba
    bool flag=false;
    for (int i=0;i<min;i++){
        if (word2[i]>word1[i]){
            flag=true;
            tracer=true;
            break;
        }
        else if (word2[i]<word1[i]){
            flag=false;
            tracer=true;
            break;
        }
    }
    // this line is too much edge case but i thought about it.
    // if one of the words consist other one such as; ara and araba. ara is the smallest one this line is for this
    if(tracer==false){
        if (word1.length()<word2.length()){
            flag=true;
        }
    }
    return flag;
}
void addInorder(songInfo* &head, string addSongName, string addSingername, string addGenre, int addListenercount, int addDuration){
    // before using this function in the main part one should use the checksongexist in order to get correct output
    // if the list is empty
    if(head==nullptr){
        // in case you forgot which one was the first; first addition address is for the next pointer, second one is for the previous one
        head=new songInfo(addSongName, addSingername, addGenre, addListenercount, addDuration, head, head); //next and prev is nullptr
        head->next=head; //they both showing head now
        head->prev=head;
    }
    else if ((head->listenerCount<addListenercount)||(head->listenerCount==addListenercount&&isAlpha(addSongName,head->songName))){
        //if added node is previous than head
        songInfo* temp=new songInfo(addSongName, addSingername, addGenre, addListenercount, addDuration, head, head->prev);
        head->prev->next=temp; //this one have to come first since if we change ptr next firstly we can never access ptr next prev
        // this one makes tail to show new head
        head->prev=temp;
        head=temp;
    }
    // before anything ı would like to say that ı could not compound the first two options due to the prev node part
    
    
    // hocam bunun kodla alakasi yok ama eger failletebilirseniz helal olsun :D
    // bu satira baya ugrastim cunku
    else {
        songInfo* ptr=head;
        while (ptr->next!=head&&ptr->next->listenerCount>=addListenercount){
            ptr=ptr->next;
        }
        while (ptr->listenerCount==addListenercount&&isAlpha(addSongName, ptr->songName)){
            ptr=ptr->prev;
        }
        songInfo* temp=new songInfo(addSongName,addSingername, addGenre, addListenercount, addDuration,ptr->next,ptr );
        ptr->next->prev=temp;  //this one have to come first since if we change ptr next firstly we can never access ptr next prev
        ptr->next=temp;
    }
};

void deleteSong(songInfo* &head, string toDeleteSong){
    // assume that if we use this function the list is already consist of at least one song
    // before using this ı used checkemptylist function in main and checkemptylist function is used under every operation
    
    // after that checkSongExist function should be used in the main in order to ensure whether the song in the list
    
    // song exist and list is not empty
    songInfo* ptr=head;
    
    do{
        if (ptr->songName==toDeleteSong){
            if (ptr==head){
                if (head==head->next){ //if there is one node
                    head=nullptr;
                }
                else {
                    head=head->next;
                }
            }
            ptr->prev->next=ptr->next; // change the previous and next nodes pointers
            ptr->next->prev=ptr->prev;
            
            delete ptr;
            ptr=nullptr;
            break;
        }
        ptr=ptr->next;
        
    }while (ptr!=head);
    
  
};

void printdecending(songInfo* head){ // prints in descending order via using next
    songInfo* ptr=head;
    do{
        cout<<"Song Name: "<<ptr->songName<<endl;
        cout<<"Singer Name: "<<ptr->singer<<endl;
        cout<<"Genre: "<<ptr->songGenre<<endl;
        cout<<"Duration: "<<ptr->duration<<endl;
        cout<<"Listener Count: "<<ptr->listenerCount<<endl;
        cout<<"---"<<endl;
        ptr=ptr->next;
    }while (ptr!=head);
};

void printascending(songInfo* head){ //prints in ascending order via using prev
    songInfo* ptr=head->prev;
    do{
       
        cout<<"Song Name: "<<ptr->songName<<endl;
        cout<<"Singer Name: "<<ptr->singer<<endl;
        cout<<"Genre: "<<ptr->songGenre<<endl;
        cout<<"Duration: "<<ptr->duration<<endl;
        cout<<"Listener Count: "<<ptr->listenerCount<<endl;
        cout<<"---"<<endl;
        ptr=ptr->prev;
    }while (ptr!=head->prev);
};

int totalDuration(songInfo* head){ //return the total duration of the songs in the linked list
    int sum=0;
    songInfo* ptr=head;
    do{
        sum+=ptr->duration;
        ptr=ptr->next;
    }while (ptr!=head);
    return sum;
};

void printSameGenre(songInfo* head, string genreName){ //prints the genre's songs in the descending order of listener count
    songInfo* ptr=head;
    do{
        if (ptr->songGenre==genreName){
            cout<<"- "<<ptr->songName<<" from "<<ptr->singer<<endl;
        }
        ptr=ptr->next;
    }while (ptr!=head);
};

void printSameSinger(songInfo* head, string singerName){ //prints the singer's songs in the descending order of listener count
    songInfo* ptr=head;
    do{
        if (ptr->singer==singerName){
            cout<<"- "<<ptr->songName<<endl;
        }
        ptr=ptr->next;
    }while (ptr!=head);
    
};

void  deleteall(songInfo* &head){
    if (head!=nullptr){
        head->prev->next=nullptr;
        head->prev=nullptr; //after this 2 operations the list is no more circular it is straight but there are two ways
       
        while (head->next!=nullptr){
            songInfo* temp=head->next;
            head->next->prev=nullptr;
            delete head;
            head=temp;
        }
        delete head;
        head =nullptr;
    }
};

int main() {

    cout<<"This program helps to create a music list and suggest you songs that you might like!"<<endl;
    cout<<"---\n"<<"MENU"<<endl;
    cout<<"1. Add a song to the list"<<endl;
    cout<<"2. Delete a song from the list"<<endl;
    cout<<"3. Print the song list"<<endl;
    cout<<"4. Print the song list in reverse order"<<endl;
    cout<<"5. Show total duration of the list"<<endl;
    cout<<"6. Print songs from the same genre"<<endl;
    cout<<"7. Print songs from the same singer"<<endl;
    cout<<"8. Exit"<<endl;
    cout<<"---"<<endl;
    
    bool flag=true;
    string choice;
    songInfo* mysongs= nullptr;
    while (flag){
        cout<<"Enter your choice: ";
        //cin.ignore();
        getline(cin,choice);
        cout<<"---"<<endl;
        if (choice=="1"){
            string songName, singer, genre;
            int duration, listenercount;
            cout<<"Enter the name of the song: ";
            //cin.ignore();
            getline(cin,songName);
            InputCorrection(songName);
            if (!checkSongExist(mysongs,songName)){
                cout<<"Enter singer name of the song: ";
                getline(cin,singer);
                InputCorrection(singer);
                cout<<"Enter genre of the song: ";
                getline(cin,genre);
                InputCorrection(genre);
                cout<<"Enter the listener count of the song: ";
                cin>>listenercount;
                cout<<"Enter the duration of the song: ";
                cin>>duration;
                cout<<"---"<<endl;
                addInorder(mysongs, songName, singer, genre, listenercount, duration);
                cout<<"The song "<<songName <<" from "<<singer<<" is added to the song list."<<endl;
                cout<<"---"<<endl;
                cin.ignore();
            }
            else{
                cout<<"---"<<endl;
                cout<<"The song "<<songName<<" is already in the song list."<<endl;
                cout<<"---"<<endl;
            }
        }
        
        else if (choice=="2"){
            string song;
            if (!checkEmptyList(mysongs)){
                cout<<"Enter the name of the song: ";
                //cin.ignore();
                getline(cin,song);
                InputCorrection(song);
                if (checkSongExist(mysongs, song)){
                    deleteSong(mysongs, song);
                    cout<<"---"<<endl;
                    cout<<"The song "<<song<<" is deleted from the list."<<endl;
                    cout<<"---"<<endl;
                }
                else{
                    cout<<"---"<<endl;
                    cout<<"The song "<<song<<" could not be found in the list."<<endl;
                    cout<<"---"<<endl;
                }
            }
            else{
                cout<<"The song list is empty."<<endl;
                cout<<"---"<<endl;
            }
        }
        
        else if (choice=="3"){
            if (!checkEmptyList(mysongs)){
                printdecending(mysongs);
            }
            else{
                cout<<"The song list is empty."<<endl;
                cout<<"---"<<endl;
            }
        }
        
        else if (choice=="4"){
            if (!checkEmptyList(mysongs)){
                printascending(mysongs);
            }
            else{
                cout<<"The song list is empty."<<endl;
                cout<<"---"<<endl;
            }
        }
        
        else if (choice=="5"){
            if (!checkEmptyList(mysongs)){
                cout<<"Enjoy your next "<<totalDuration(mysongs)<<" minutes with the songs in the list."<<endl;
                cout<<"---"<<endl;
            }
            else{
                cout<<"The song list is empty."<<endl;
                cout<<"---"<<endl;
            }
        }
        
        else if (choice=="6"){
            if (!checkEmptyList(mysongs)){
                cout<<"Please enter the genre of the songs you want to list: ";
                string genreToPrint;
                //cin.ignore();
                getline(cin,genreToPrint);
                InputCorrection(genreToPrint);
                cout<<"---"<<endl;
                cout<<"List of All the Songs from Genre "<<genreToPrint<<endl;
                cout<<"---"<<endl;
                
                printSameGenre(mysongs, genreToPrint);
                cout<<"---"<<endl;
            }
            else{
                cout<<"The song list is empty."<<endl;
                cout<<"---"<<endl;
            }
        }
        
        else if (choice=="7"){
            if (!checkEmptyList(mysongs)){
                cout<<"Please enter the singer name of the songs you want to list: ";
                string singerToPrint;
                //cin.ignore();
                getline(cin,singerToPrint);
                InputCorrection(singerToPrint);
                cout<<"---"<<endl;
                cout<<"List of All the Songs from Singer "<<singerToPrint<<endl;
                cout<<"---"<<endl;
                printSameSinger(mysongs, singerToPrint);
                cout<<"---"<<endl;
            }
            else{
                cout<<"The song list is empty."<<endl;
                cout<<"---"<<endl;
            }
        }
        
        else if (choice=="8"){
            flag=false;
            deleteall(mysongs);
            cout<<"Deleting song list..."<<endl;
            cout<<"Exiting the program..."<<endl;
        }
        
        else{
            cout<<"Not a valid option."<<endl;
            cout<<"---"<<endl;
        }
        //cin.ignore();

    }
    return 0;
}
