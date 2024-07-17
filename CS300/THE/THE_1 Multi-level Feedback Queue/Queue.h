#ifndef Queue_h
#define Queue_h

#include <iostream>
using namespace std;

template <class type>
class Queue{
    public:
        Queue(void);
        ~Queue(void);
        
        bool isEmpty(void) const; // check whether empty or not
        void enqueue(const type &, const string&); // adding a node at the end
        void dequeue(type &, string&); // deleting a node from the front
        void clear(void); //deleting every node in the queue
        
    private:
		template <class type>
		struct qnode{
			string pro_name; //process number
			type data; 
			qnode* next;
			qnode(type d,string p, qnode* n=nullptr):data(d), pro_name(p), next(n) {};
		};
        qnode<type>* front;
        qnode<type>* end;
};

template<class type>
Queue<type>::Queue(void){
    front=nullptr;
    end=nullptr;
}

template<class type>
bool Queue<type>::isEmpty(void) const{
    return (front==nullptr);
}

template<class type>
void Queue<type>::enqueue(const type & data, const string& pname){
    if (isEmpty()){
        front=new qnode<type>(data, pname, nullptr);
        end=front;
    }
    else{
        end->next=new qnode<type>(data, pname, nullptr);
        end=end->next;
    }
}
template<class type>
void Queue<type>::dequeue(type& data, string & pname){
    if (!isEmpty()){
        qnode<type>* temp =front;
        front=front->next;
        data=temp->data;
		pname=temp->pro_name;
        delete temp;
    }
    else{
        cout<<"Queue is empty.."<<endl;
    }
}

template<class type>
void Queue<type>::clear(void){
    type temp1;
	string temp2;
    while (!isEmpty()){
        dequeue(temp1, temp2);
    }
}

template<class type>
Queue<type>::~Queue(){
    clear();
}
#endif
