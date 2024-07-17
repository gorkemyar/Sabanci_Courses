#ifndef SeparateChaining_h
#define SeparateChaining_h

#include <iostream>
#include <string>
#include "Linked_Lists.h"
#include <vector>

using namespace std;

bool isPrime(int n){
    if( n == 2 || n == 3 )
        return true;

    if( n == 1 || n % 2 == 0 )
        return false;

    for( int i = 3; i * i <= n; i += 2 )
        if( n % i == 0 )
            return false;

    return true;
}

int nextPrime(int n){
    if (n%2==0){
        n++;
    }
    for (;!isPrime(n);n+=2){
        ;
    }
    return n;
}

template <class Type>
class HashTable{
public:
    HashTable(const Type& notFound, int size);
    HashTable(const HashTable<Type> & rhs): ITEM_NOT_FOUND(rhs.ITEM_NOT_FOUND), theLists(rhs.theLists){};
    
    const Type & find (const Type & x) const;
    void makeEmpty();
    void insert(const Type &x);
    void remove(const Type &x);
    
    const HashTable & operator=(const HashTable& rhs);
    
private:
    vector<List<Type>> theLists;
    Type ITEM_NOT_FOUND;
};
int hash(const string & key, int tableSize);
int hash(int key, int tableSize);

template <class Type>
HashTable<Type>::HashTable(const Type& notFound, int size): ITEM_NOT_FOUND(notFound), theLists(nextPrime(size)){};

template <class Type>
void HashTable<Type>::makeEmpty(){
    int size=theLists.size();
    int i=0;
    for (;i<size;i++){
        theLists[i].makeEmpty(); //destroys the list but not the vector
    }
}

template <class Type>
void HashTable<Type>::insert(const Type & x){
    // hash the given object and locate the list it should be on
    List<Type> & whichList= theLists[hash(x, theLists.size())]; // if we did not writr & then the whichList would be a deep copy of the hashed list;
    // locate the object şn the list (using list's find)
    ListItr<Type> Itr=whichList.find(x);
    if (Itr.isPastEnd()){
        whichList.insert(x, whichList.zeroth());
    }
}

template <class Type>
void HashTable<Type>::remove(const Type & x){
    theLists[hash(x, theLists.size())].remove(x); // firstly find the index of the linked list, then remove x from the linked list
}


template <class Type>
const Type& HashTable<Type>::find(const Type &x) const{
    ListItr<Type> itr;
    itr=theLists[hash(x, theLists.size())].find(x);
    if (itr.isPastEnd()){
        return ITEM_NOT_FOUND;
    }
    return itr.retrieve();
}
#endif
