#ifndef Linked_Lists_h
#define Linked_Lists_h
using namespace std;
class BadIterator{
    public:
        BadIterator(){ cout<<"Cannot retrieve of a nullptr.\n";}
};

template<class Type>
class List;

template<class Type>
class ListItr;

template<class Type>
class ListNode{
    Type element;
    ListNode* next;
    ListNode(const Type & e=Type(), ListNode* n=nullptr): element(e), next(n){} ;
    friend class ListItr<Type>;
    friend class List<Type>;
};

template <class Type>
class ListItr{
    public:
        ListItr(): current(nullptr){};
        bool isPastEnd() const {
            return current==nullptr;
        }
        void advance() {
            if (!isPastEnd()){
                current=current->next;
            }
        }
        const Type& retrieve() const{
            if (isPastEnd()){
                throw BadIterator();
            }
            return current->element;
        }
    private:
        ListNode<Type>* current;
        ListItr(ListNode<Type>* c): current(c){};
    friend class List<Type>;
};

template<class Type>
class List{
public:
    List();
    List(const List & rhs);
    ~List();
    bool isEmpty() const;
    void makeEmpty();
    ListItr<Type> zeroth() const;
    ListItr<Type> first() const;
    void insert(const Type & x, const ListItr<Type> & p);
    ListItr<Type> find(const Type & x) const;
    ListItr<Type> findPrevious(const Type & x) const;
    void remove(const Type & x);
    void reverse();
    
    const List& operator=(const List& rhs);
private:
    ListNode<Type>* header;
};

template <class Type>
List<Type>::List(){
    header=new ListNode<Type>;
}

template <class Type>
bool List<Type>::isEmpty() const{
    return header->next==nullptr;
}

template <class Type>
void List<Type>::insert(const Type & x, const ListItr<Type> &p){
    if (p.current!=nullptr){
        p.current->next=new ListNode<Type>(x, p.current->next);
    }
}

template <class Type>
ListItr<Type> List<Type>::find(const Type & x) const {
    ListNode<Type>* itr =header->next;
    while (itr!=nullptr && itr->element!=x){
        itr=itr->next;
    }
    return ListItr<Type>(itr);
}

template <class Type>
ListItr<Type> List<Type>::findPrevious(const Type & x) const {
    ListNode<Type>* itr =header;
    while (itr->next!=nullptr && itr->next->element!=x){
        itr=itr->next;
    }
    return ListItr<Type>(itr);
}

template <class Type>
void List<Type>::remove(const Type & x){
    ListItr<Type> p=findPrevious(x);
    if (p.current->next!=nullptr){
        ListNode<Type>* tmp= p.current->next;
        p.current->next=p.current->next->next;
        delete tmp;
    }
}

template <class Type>
ListItr<Type> List<Type>::zeroth() const {
    return ListItr<Type>(header);
}

template <class Type>
ListItr<Type> List<Type>::first() const {
    return ListItr<Type>(header->next);
}

template <class Type>
void List<Type>::makeEmpty(){
    while (!isEmpty()){
        remove(first().retrieve()); // same as header->next->element
    }
}
template <class Type>
const List<Type>& List<Type>::operator=(const List<Type> & rhs){
    if (this != &rhs){
        makeEmpty();
        ListItr<Type> itr= zeroth();
        ListItr<Type> ritr= rhs.first();
        while (!ritr.isPastEnd()){
            insert(ritr.retrieve(), itr);
            ritr.advance();
            itr.advance();
        }
    }
    return *this;
}

template <class Type>
List<Type>::List(const List & rhs){
    header=new ListNode<Type>;
    *this=rhs;
}

template <class Type>
List<Type>::~List(){
    makeEmpty();
    delete header;
}

template <class Type>
void printList(const List<Type> & myList){
    if (myList.isEmpty()){
        cout<<"Empty list"<<endl;
    }
    else{
        ListItr myItr= myList.first();
        while (!myItr.isPastEnd()){
            cout<<myItr.retrieve()<<endl;
            myItr.advance();
        }
    }
}

template <class Type>
void List<Type>::reverse(){
    if (!isEmpty()){
        ListNode<Type>* current=nullptr;
        ListNode<Type>* previous=nullptr;
        while (header->next!=nullptr){
            current=header->next;
            header->next=header->next->next;
            current->next=previous;
            previous=current;
        }
        header->next=previous;
    }
}
#endif
