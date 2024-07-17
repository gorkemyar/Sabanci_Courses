// Gorkem Yar

#ifndef DynQueue_h
#define DynQueue_h

#include <iostream>
#include <string>
#include <fstream>

using namespace std;
template <class type>
struct node{
    type info;
    node* next;
    node(type i, node<type>* n=nullptr){
        next=n;
        info=i;
    };
};

template <class type>
class DynQueue{
    public:
        DynQueue(); // default constructor
        DynQueue(const DynQueue<type>&); // copy constructor
        ~DynQueue(); //destructor
        bool isEmpty(void) const; // checking  whether the list is empty or not
        void enqueue(type); // add new elements to end of linked list
        void dequeue(type&); // return the first (front) element of the linked list and delete it from the list
        void clear(void); // deletes all the list
        const DynQueue& operator=(const DynQueue<type>&); // returns a copy of rhs
        const DynQueue& operator+=(type); // similar with enqueue just the syntax is different
        const DynQueue& operator*=(int); // multiplies every nodes info with given int num
        DynQueue operator+(const DynQueue&) const; // add rhs to lhs and returns a new linkedlist
        
        template <class types> friend ifstream& operator>>(ifstream& is, DynQueue<types>&); // operator overloading for cin
        template <class typee> friend ostream& operator<<(ostream& os, const DynQueue<typee>&);// operator overloading for cout
    private:
        node<type>* front; // first element of the linkedlist
        node<type>* rear; //last element of the linkedlist
};

template <class type>
DynQueue<type>::DynQueue(){
    front=nullptr;
    rear=nullptr;
    //cout<<"Inside constructor"<<endl;
}

template <class type>
DynQueue<type>::DynQueue(const DynQueue<type>& copy){
    //cout<<"Inside copy constructor"<<endl;
    if (copy.isEmpty()){
        //empty case
        front=nullptr;
        rear=nullptr;
    }
    else{
        // first node need to be allocated manually
        front= new node<type>(copy.front->info, nullptr);
        rear=front;
        node<type>* ptrCopy=copy.front->next;
        while (ptrCopy!=nullptr){
            // add new node to next of rear and update the rear
            rear->next=new node<type>(ptrCopy->info,nullptr);
            rear=rear->next;
            ptrCopy=ptrCopy->next;
        }
    }
    
}
template <class type>
DynQueue<type>::~DynQueue(){
    type num;
    //cout<<"Inside destructor"<<endl;
    while (!isEmpty()){
        dequeue(num);
    }
    
}


template <class type>
bool DynQueue<type>::isEmpty(void) const{
    //if front equals to nullptr it is empty linkedlist
    return front==nullptr;
}
template <class type>
void DynQueue<type>::enqueue(type data){
    //classic enqueue
    if (isEmpty()){
        front= new node<type>(data, nullptr);
        rear=front;
    }
    else{
        rear->next=new node<type>(data,nullptr);
        rear=rear->next;
        }
}
template <class type>
void DynQueue<type>::dequeue(type& toReturn){
    //classic dequeue
    if (!isEmpty()){
        toReturn=front->info;
        node<type>* temp=front->next;
        delete front;
        front=temp;
    }
    else{
        cout<<"Queue is empty..";
    }
}
template <class type>
void DynQueue<type>::clear(void){
    // empties the list by dequeueing all the elements
    type num;
    while (!isEmpty()){
        dequeue(num);
    }
}
template <class type>
const DynQueue<type>& DynQueue<type>::operator=(const DynQueue<type>& rhs){
    // return a copy of rhs
    if (front!=rhs.front){
        clear();
        if (rhs.isEmpty()){
            front=nullptr;
            rear=nullptr;
        }
        else{
            front= new node<type>(rhs.front->info, nullptr);
            rear=front;
            node<type>* ptrCopy=rhs.front->next;
            while (ptrCopy!=nullptr){
                rear->next=new node<type>(ptrCopy->info,nullptr);
                rear=rear->next;
                ptrCopy=ptrCopy->next;
            }
        }
    }
    return *this;
}
template <class type>
const DynQueue<type>& DynQueue<type>::operator+=(type value){
    // similar to enqueue
    enqueue(value);
    return *this;
}


template <class type>
const DynQueue<type>& DynQueue<type>::operator*=(int num){
    // multiplies the object
    node<type>* ptr= front;
    while(ptr!=nullptr){
        type temp=ptr->info; //type
        for (int i=0;i<num-1;i++){
            ptr->info+=temp;
        }
        ptr=ptr->next;
    }
    return *this;
}

template <class type>
DynQueue<type> DynQueue<type>::operator+(const DynQueue<type>&rhs) const{
    // sum the datas of two linkedlists and return a new linkedlist
    
    // this version of it not necessary but if the size of linkedlists are not equal this one is the correct one
    DynQueue temp;
    
    if (front!=nullptr&&rhs.front!=nullptr){
        temp.front=new node<type>(front->info+rhs.front->info, nullptr);
        temp.rear=temp.front;
    }
    else if(front!=nullptr){
        temp.front=new node<type>(front->info, nullptr);
        temp.rear=temp.front;
    }
    else if (rhs.front!=nullptr){
        temp.front=new node<type>(rhs.front->info, nullptr);
        temp.rear=temp.front;
    }
    node<type>* ptrLhs=nullptr;
    node<type>* ptrRhs=nullptr;
    if (front!=nullptr){
        ptrLhs=front->next;
    }
    if (rhs.front!=nullptr){
        ptrRhs=rhs.front->next;
    }
    while (ptrLhs!=nullptr||ptrRhs!=nullptr){
        if (ptrLhs!=nullptr&&ptrRhs!=nullptr){
            temp.enqueue(ptrRhs->info+ptrLhs->info);
        }
        else if(ptrLhs!=nullptr){
            temp.enqueue(ptrLhs->info);
        }
        else if (ptrRhs!=nullptr){
            temp.enqueue(ptrRhs->info);
        }
        if (ptrLhs!=nullptr){
            ptrLhs=ptrLhs->next;
        }
        if (ptrRhs!=nullptr){
            ptrRhs=ptrRhs->next;
        }
    }
    
    //cout<< temp<<endl;
    // this part would be enough if the size of the lists are same
    
    /*
     node<type>* ptrLhs=nullptr;
     node<type>* ptrRhs=nullptr;
     if (front!=nullptr&&rhs.front!=nullptr){
         temp.front=new node<type>(front->info+rhs.front->info, nullptr);
         temp.rear=temp.front;
         ptrLhs=front->next;
         ptrRhs=rhs.front->next;
     }
     while (ptrLhs!=nullptr){
         if (ptrLhs!=nullptr){
             temp.enqueue(ptrRhs->info+ptrLhs->info);
         }
         if (ptrLhs!=nullptr){
             ptrLhs=ptrLhs->next;
             ptrRhs=ptrRhs->next;
         }
     }
     
     */
     
    return temp;
}


template <class type>
ifstream& operator>>(ifstream& file, DynQueue<type>& rhs){
    // read from file and write to link list
    type temp;// type
    while(!file.eof()){
        file>>temp;
        rhs.enqueue(temp);
    }
    return file;
}

template <class type>
ostream& operator<<(ostream& os, const DynQueue<type>& rhs){
    // return the output
    node<type>* ptr=rhs.front;
    while (ptr!=nullptr){
        os<<ptr->info<< " ";
        ptr=ptr->next;
    }
    return os;
}

#endif


template <class type>
const DynQueue<type>& DynQueue<type>::operator=(const DynQueue<type>& rhs){
    // return a copy of rhs
    if (front!=rhs.front){
        clear();
        if (rhs.isEmpty()){
            front=nullptr;
            rear=nullptr;
        }
        else{
            front= new node<type>(rhs.front->info, nullptr);
            rear=front;
            node<type>* ptrCopy=rhs.front->next;
            while (ptrCopy!=nullptr){
                rear->next=new node<type>(ptrCopy->info,nullptr);
                rear=rear->next;
                ptrCopy=ptrCopy->next;
            }
        }
    }
    return *this;
}

const DynIntMatrix& DynIntMatrix::operator=(const DynQueue<type>& rhs){
    // return a copy of rhs
    if (front!=rhs.front){
        clear();
        if (rhs.isEmpty()){
            front=nullptr;
            rear=nullptr;
        }
        else{
            front= new node<type>(rhs.front->info, nullptr);
            rear=front;
            node<type>* ptrCopy=rhs.front->next;
            while (ptrCopy!=nullptr){
                rear->next=new node<type>(ptrCopy->info,nullptr);
                rear=rear->next;
                ptrCopy=ptrCopy->next;
            }
        }
    }
    return *this;
}


