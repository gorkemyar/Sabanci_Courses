#ifndef HASHTABLE_H
#define HASHTABLE_H
#include <vector>
#include <string>

//hash class implemented by me in the second assignment (with a little bit modifications)

using namespace std;
bool isPrime( int n )
{
    if( n == 2 || n == 3 )
        return true;

    if( n == 1 || n % 2 == 0 )
        return false;

    for( int i = 3; i * i <= n; i += 2 )
        if( n % i == 0 )
            return false;

    return true;
}

int nextPrime( int n )
{
    if( n % 2 == 0 )
        n++;

    for( ; !isPrime( n ); n += 2 )
        ;
    return n;
}

template <class value, class code>
class Hashtable{
public:

    explicit Hashtable(const value& notFound, const int & size); // constructor with a fixed size
    Hashtable(const Hashtable& rhs): ITEM_NOT_FOUND(rhs.ITEM_NOT_FOUND) ,hashArr(rhs.hashArr), currentSize(rhs.currentSize){}; //copy constructor

    const value find(const value & x) const; // find the element or return ITEM_NOT_FOUND
    bool isActive(const int & currentPos) const; // return whether the given position is occupied by a value or not

    bool insert(const value & a, const code & b); // insert the value by hashing
    void remove(const value &);
    void makeEmpty(); // converts enum to EMPTY for every element in the array
    code Retrieve(const value &); // retrieve a code given the value // pre: assuming the value is in the hashtable
    bool isFull(); // checks whether the list is full or not
    const Hashtable & operator=(const Hashtable & rhs); // creating a copy of rhs
    enum EntryType {ACTIVE, DELETED, EMPTY};
    
    private:
    struct HashEntry{
        value element;
        code element_code;
        EntryType info;
        HashEntry(const value & e=value(), code c=-1, EntryType i=EMPTY): element(e), element_code(c), info(i){};
    };

    vector <HashEntry> hashArr;
    const value ITEM_NOT_FOUND;
    int currentSize;
    
    int findPos(const value& x) const; // find position for the given value or find the first empty space
    void rehash(); // no need for rehash our size is fixed t
};
// hash function for string
int hash(const string & key, int tableSize){
    int len= (int)key.length(), i=0, sum=0;
    for (;i<len;i++){
        unsigned char tmp=key[i];
        sum+=(int)tmp;
    }
    return sum%tableSize;
}

int hash(int key, int tableSize){
    return (key&tableSize);
}


template<class value, class code>
Hashtable<value, code>::Hashtable(const value& notFound, const int & s): ITEM_NOT_FOUND(notFound), hashArr(s){
    makeEmpty();
    currentSize=0;
}

template<class value, class code>
int Hashtable<value, code>::findPos(const value& x) const{
   
    int arrSize=(int)hashArr.size();
    int idx=::hash(x, arrSize); // be aware x is type and we have only two types of hash functions which are string and int
    while (hashArr[idx].info!=EMPTY && hashArr[idx].element!=x){
        idx++; //linear probing
        //cout<< " IAM IN LINEAR PROBİNG"<<endl;
        if (idx>=arrSize){ // manual modulus
            idx-=arrSize;
        }
    }
    return idx;
}
 
template<class value, class code>
bool Hashtable<value, code>::isActive(const int & currentpos) const{
    return hashArr[currentpos].info==ACTIVE;
}

template<class value, class code>
const value Hashtable<value, code>::find(const value & x) const{
    int idx=findPos(x);
    if (hashArr[idx].info==ACTIVE){
        return hashArr[idx].element;
    }
    return ITEM_NOT_FOUND;
}

// make every index empty
template<class value, class code>
void Hashtable<value, code>::makeEmpty(){
    int i=0, arrSize=(int)hashArr.size();
    for (;i<arrSize;i++){
        hashArr[i].info=EMPTY;
    }
}

template<class value, class code>
bool Hashtable<value, code>::insert(const value& x, const code& e_code){
    //cout<<x<<" "<<e_code<<std::endl;

    int idx=findPos(x);
    if (isActive(idx)){
        return false;
    }

    if (hashArr[idx].info==EMPTY){ // we are checking in case if it is deleted (it is not possible)
        hashArr[idx].element=x;
        hashArr[idx].info=ACTIVE;
        hashArr[idx].element_code=e_code;
        //cout<<hashArr[idx].element<<" "<<hashArr[idx].element_code<<endl;
        currentSize++;
        //cout<<currentSize<<endl;
    }
    if(++currentSize >= (int)hashArr.size()/2)
        rehash( );
    
    return true;
}

// operator overloading for =, create a copy
template<class value, class code>
const Hashtable<value, code>& Hashtable<value,code>::operator=(const Hashtable& rhs){
    if (this!=&rhs){
        Hashtable tmp(rhs.ITEM_NOT_FOUND);
        tmp.hashArr=rhs.hashArr;
        tmp.currentSize=rhs.currentSize;
        return tmp;
    }
    return *this;
}

// retrieve a code given the value // pre: assuming the value is in the hashtable
template<class value, class code>
code Hashtable<value, code>::Retrieve(const value & x){
    return hashArr[findPos(x)].element_code;
}

template<class value, class code>
bool Hashtable<value, code>::isFull(){
    return currentSize>=hashArr.size()-1;
}

template<class value, class code>
void Hashtable<value, code>::remove(const value & x){
    int idx=findPos(x);
    hashArr[idx].info=DELETED;
    currentSize--;
}

template <class value, class code>
void Hashtable<value, code>::rehash( )
{
    vector<HashEntry> oldArray = hashArr;

    // Create new double-sized, empty table
    hashArr.resize( nextPrime( 2 * ((int)oldArray.size( ))));

    for( int j = 0; j < hashArr.size( ); j++ )
        hashArr[j].info = EMPTY;

    // Copy table over
    currentSize = 0;
    for( int i = 0; i < oldArray.size( ); i++ ){
        if( oldArray[ i ].info == ACTIVE )
            insert( oldArray[ i ].element,i);
    }
}
/*
template <class value>
int Hashtable<value>::Size( ){
    return ((int)hashArr.size());
}
 */
#endif
