#ifndef Graph_h
#define Graph_h

//Gorkem Yar

#include <iostream>
#include <string>
#include "Hash.h"
#include "Heap.h"
using namespace std;


/*
bool isSimilar(const string & v,  const string & w) {
    int vlen=(int)v.length(), wlen=(int)w.length();
    int i=0, j=0, diff=0;
    for (;;){
        if (i==vlen || j==wlen){
            break;
        }
        if (v[i]==w[j]){
            i++;
            j++;
        }
        else{
            if (v[i+1]==w[j+1]){
                diff++;
                i++;
                j++;
            }
            else if(v[i+1]==w[j]){
                diff++;
                i++;
            }
            else if(v[i]==w[j+1]){
                diff++;
                j++;
            }
            else{
                diff++;
                i++;
                j++;
            }
        }
    }
    if (i<vlen){
        diff+=(vlen-i);
    }
    if (j<wlen){
        diff+=(wlen-j);
    }
    if (diff==1){
        return true;
    }
    return false;
}*/
//checks whether the two strings are same except one character
bool isSimilar(const string & v,  const string & w) {
    int vlen=(int)v.length(), wlen=(int)w.length();
    int i=0, j=0;
    if (vlen-wlen>1){
        return false;
    }
    if (wlen-vlen>1){
        return false;
    }
    for (;;){
        if (i==vlen || j==wlen){
            break;
        }
        if (v[i]==w[j]){
            i++;
            j++;
        }
        else{
            if (v.substr(i+1)==w.substr(j+1) || v.substr(i+1)==w.substr(j) || v.substr(i)==w.substr(j+1)){
                return true;
            }
            else{
                return false;
            }
        }
    }
    return true;
}

// graph node
struct node{
    string word;
    node* next;
    node(string w="", node* n=nullptr): word(w), next(n) {};
    bool known;
    int vpath;
    int dist;
};

class Graph{
public:
    Graph(const string &, const int); // constructor
    ~Graph();
    bool isConnected( string  v,string  w); // checks whether two strings (vertexes) connected
    void insert( string &);
    
    void unweighted(string start, string end); // find the smallest path
    void print(); // print the graph
    void makePathUnknown(); //resets all of the graph to create new paths
    string recursivePrint(int); // recursive print to print path
    
private:
    Hashtable<string, int> mytable;  // hashtable to store strings and indexes of the string in the node** head
    node** head; //stores the nodes
    const string NOT_A_VERTEX;
    int size;
    int currentSize;
};

//constructor
Graph::Graph(const string & N, const int s):mytable(N, 6*s), NOT_A_VERTEX(N){
    size=s;
    head= new node*[s];
	currentSize=0;
};
Graph::~Graph(){
    for (int i=0;i<currentSize;i++){
        node* ptr=head[i];
        while (ptr!=nullptr){
            node* temp=ptr;
            ptr=ptr->next;
            delete temp;
        }
    }
    delete[] head;
}
//insert function
void Graph::insert(string & word){

    //cout<<word<<" "<<currentSize<<endl;
    bool isInserted = mytable.insert(word,currentSize);
    if (isInserted){
        //cout<<word<<endl;
        head[currentSize]=new node(word, nullptr);
        for (int i=0; i<currentSize; i++){
            if (head[i]!=nullptr && isSimilar(head[i]->word, word)){
                head[i]->next=new node(word, head[i]->next);
                head[currentSize]->next=new node(head[i]->word, head[currentSize]->next);
            }
        }
        currentSize++;
    }
}
// checks whether two strings (vertexes) connected
bool Graph::isConnected(string  v, string w){
    if ((mytable.find(v)!=NOT_A_VERTEX) && (mytable.find(w)!=NOT_A_VERTEX) ){
        int vidx=mytable.Retrieve(v), widx=mytable.Retrieve(w);
        
        if (vidx<widx){
            node* ptr=head[vidx];
            while (ptr!=nullptr){
                if (ptr->word==w){
                    return true;
                }
                ptr=ptr->next;
            }
        }
        else{
            node* ptr=head[widx];
            while(ptr!=nullptr){
                if (ptr->word==v){
                    return true;
                }
                ptr=ptr->next;
            }
        }
    }
    return false;
}
// toprint graph
void Graph::print(){
    for (int i=0;i<currentSize;i++){
        node* ptr=head[i];
        while (ptr!=nullptr){
            cout<<ptr->word<<" ";
            ptr=ptr->next;
        }
        cout<<endl;
    }
}

void Graph::makePathUnknown(){
    for (int i=0;i<currentSize;i++){
        node* ptr=head[i]; //resets the parameters
        while (ptr!=nullptr){
            ptr->known=false;
            ptr->dist=INT_MAX-1;
            ptr->vpath=-1;
            ptr=ptr->next;
        }
    }
}
// helper print for recursive print
void diffprint(string first, string second){
    int flen=(int)first.length(), slen=(int)second.length();
    int i=0, j=0;
    for (;;){
        cout<<"h"<<endl;
        if (i==flen || j==slen){
            break;
        }
        if (first[i]==second[j]){
            i++;
            j++;
        }
        else{
            if (first[i+1]==second[j+1]){
                cout<<"(change "<<first[i]<<"  at position "<<i+1<<"  to "<<second[j]<<")"<<endl;
                return;
            }
            else if((flen>slen)&&(first[i+1]==second[j])){
                cout<<"(delete "<<first[i]<<" at position "<<i+1<<")"<<endl;
                return;
            }
            else if((slen>flen)&&(first[i]==second[j+1])){
                cout<<"(insert "<<second[j]<<" after position "<<i<<")"<<endl;
                return;
            }
        }
    }
    if (flen>slen){
        cout<<"(delete "<<first[flen-1]<<" at position "<<flen<<")"<<endl;
    }
    else if (slen>flen){
        cout<<"(insert "<<second[slen-1]<<" after position "<<slen-1<<")"<<endl;
    }
}

string Graph::recursivePrint(int a){
    if (a==-1){
        string tmp="";
        return tmp;
    }
    else{
        string first=recursivePrint(head[a]->vpath);
        string second=head[a]->word;
        if (first==""){
            cout<<second<<endl;
        }
        else{
            cout<<second<<" ";
            diffprint(first, second);
        }
        return second;
    }
}

void Graph::unweighted(string start, string end){
    makePathUnknown();
    BinaryHeap myheap(size*10);
    if (mytable.find(start)!=NOT_A_VERTEX && mytable.find(end)!=NOT_A_VERTEX){
        int first=mytable.Retrieve(start);
        //cout<<first<<endl;
        head[first]->dist=0;
        head[first]->vpath=-1;
        
        for (int i=0;i<currentSize;i++){
            heapStr tmp;
            tmp.dist=head[i]->dist;
            tmp.idx=i;
            myheap.insert(tmp);
        }
        
        heapStr tmp;
        tmp.dist=INT_MAX;
        tmp.idx=-1; //not a vertex
        myheap.insert(tmp);
        heapStr minimum;
        for (;;){
            minimum=myheap.findMin();
            myheap.deleteMin();
            //cout<<minimum.idx<<endl;
            if ((minimum.idx==-1)||(head[minimum.idx]==nullptr)){
                break;
            }
            
            head[minimum.idx]->known=true;
            node* ptr=head[minimum.idx]->next;
            //cout<<head[minimum.idx]->word<<endl;
            while (ptr!=nullptr){
                int pidx=mytable.Retrieve(ptr->word);
                if ((head[pidx]->known==false) && (head[pidx]->dist> head[minimum.idx]->dist+1)){
                    head[pidx]->dist=head[minimum.idx]->dist+1;
                    head[pidx]->vpath=minimum.idx;

                    //cout<<head[pidx]->word;
                    heapStr tmp;
                    tmp.dist=head[minimum.idx]->dist+1;
                    tmp.idx=mytable.Retrieve(ptr->word);
                    myheap.insert(tmp);
                }
                ptr=ptr->next;
            }
            //cout<<endl;
        }
        if (head[mytable.Retrieve(end)]->vpath==-1){
            cout<<"There is no way to convert "<<start<<" to "<<end<<endl;
            return;
        }
        
        recursivePrint(mytable.Retrieve(end));
        
    }
    else{
        if (mytable.find(start)==NOT_A_VERTEX){
            cout<<"First word is not in the words.txt"<<endl;
        }
        else{
            cout<<"Second word is not in the words.txt"<<endl;
        }
    }
    
}
#endif
