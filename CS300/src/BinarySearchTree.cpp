#ifndef BinarySearchTree_h
#define BinarySearchTree_h
#include <iostream>
using namespace std;

template <class Type>
class BinarySearchTree;

template <class Type>
class BinaryNode{
    Type element;
    BinaryNode* left;
    BinaryNode* right;
    
    BinaryNode(Type e=Type(), BinaryNode<Type>* l=nullptr, BinaryNode<Type>* r=nullptr ): element(e), left(l), right(r){};
    
    friend class BinarySearchTree<Type>;
};

template <class Type>
class BinarySearchTree{
public:
    explicit BinarySearchTree(const Type & notFound); //
    BinarySearchTree(const BinarySearchTree & rhs);
    ~BinarySearchTree(); //
    
    const Type & findMin() const; //
    const Type & findMax() const; //
    const Type & find(const Type & x) const; //
    bool isEmpty() const; //
    void printTree() const; //
    
    void makeEmpty(); //
    void insert(const Type & x); //
    void remove(const Type & x); //
    
    const BinarySearchTree& operator=(const BinarySearchTree& rhs);
private:
    BinaryNode<Type>* root; //
    const Type ITEM_NOT_FOUND; //
    
    const Type & elementAt(BinaryNode<Type>* t) const; //
    void insert(const Type& x, BinaryNode<Type>* &t) const; //
    void remove(const Type& x, BinaryNode<Type>* &t) const; //
    BinaryNode<Type>* findMin(BinaryNode<Type>* t) const; //
    BinaryNode<Type>* findMax(BinaryNode<Type>* t) const; //
    BinaryNode<Type>* find(const Type& x,BinaryNode<Type>* t) const; //
    
    void makeEmpty(BinaryNode<Type>* & t) const; //
    void printTree(BinaryNode<Type>* t) const; //
    BinaryNode<Type>* clone(BinaryNode<Type>* t) const;
};

template <class Type>
BinarySearchTree<Type>::BinarySearchTree(const Type & notFound): ITEM_NOT_FOUND(notFound), root(nullptr) {};

template <class Type>
const Type & BinarySearchTree<Type>::elementAt(BinaryNode<Type>* t) const{
    return t==nullptr ? ITEM_NOT_FOUND: t->element;
}

template <class Type>
const Type& BinarySearchTree<Type>::find(const Type & x) const{
    return elementAt(find(x, root));
}

template <class Type>
BinaryNode<Type>* BinarySearchTree<Type>::find(const Type&x, BinaryNode<Type>* t) const{
    if (t==nullptr){
        return nullptr;
    }
    else if (x<t->element){
        return find(x, t->left);
    }
    else if (x>t->element){
        return find(x, t->right);
    }
    else {
        return t;
    }
}
/*
// non-recursive
template <class Type>
BinaryNode<Type>* BinarySearchTree<Type>::find(const Type&x, BinaryNode<Type>* t) const{
    while (t!=nullptr){
        if (x<t->element){
            t=t->left;
        }
        else if (x>t->element){
            t=t->right;
        }
        else {
            return t;
    }
    return nullptr;
}
*/
template <class Type>
const Type& BinarySearchTree<Type>::findMin() const{
    return elementAt(findMin(root));
}

template <class Type>
BinaryNode<Type>* BinarySearchTree<Type>::findMin(BinaryNode<Type>* t) const{
    if (t==nullptr){
        return nullptr;
    }
    if (t->left==nullptr){
        return t;
    }
    return t->left;
}

template <class Type>
const Type& BinarySearchTree<Type>::findMax() const{
    return elementAt(findMax(root));
}

template <class Type>
BinaryNode<Type>* BinarySearchTree<Type>::findMax(BinaryNode<Type>* t) const{
    if (t==nullptr){
        return nullptr;
    }
    if (t->right==nullptr){
        return t;
    }
    return t->right;
}

template <class Type>
bool BinarySearchTree<Type>::isEmpty() const{
    return root==nullptr;
}

template <class Type>
void BinarySearchTree<Type>::insert(const Type & x){
    insert(x, root);
}

template <class Type>
void BinarySearchTree<Type>::insert(const Type & x, BinaryNode<Type>* &t) const{
    if (t==nullptr){
        t= new BinaryNode<Type>(x, nullptr, nullptr);
    }
    else if (x<t->element){
        insert(x, t->left);
    }
    else if (x>t->element){
        insert(x, t->right);
    }
    else
        ; // do nothing since dublication
}

template <class Type>
void BinarySearchTree<Type>::remove(const Type & x){
    remove(x, root);
}

template <class Type>
void BinarySearchTree<Type>::remove(const Type & x, BinaryNode<Type>* &t) const{
    if (t==nullptr){
        return;
    }
    if (x<t->element){
        remove(x,t->left);
    }
    else if(x>t->element){
        remove(x,t->right);
    }
    else if (t->right!=nullptr && t->left!=nullptr){ // element found, two children
        t->element=findMin(t->right)->element;
        
        remove(t->element, t->right);
    }
    else{ // zero or one children
        BinaryNode<Type>* oldnode=t;
        if (t->left!=nullptr){
            t=t->left;
        }
        else if (t->right!=nullptr){
            t=t->right;
        }
        t=nullptr;
        //t= (t->left!=nullptr) ? t->left: t->right;
        
        delete oldnode;
    }
}

template <class Type>
void BinarySearchTree<Type>::makeEmpty(){
    makeEmpty(root);
}

template <class Type>
void BinarySearchTree<Type>::makeEmpty(BinaryNode<Type>* &t) const{
    if (t!=nullptr){
        makeEmpty(t->left);
        makeEmpty(t->right);
        delete t;
    }
    t=nullptr;
}


template <class Type>
void BinarySearchTree<Type>::printTree() const{
    if (isEmpty()){
        cout<<"Empty tree"<<endl;
    }
    else{
        printTree(root);
    }
}

template <class Type>
void BinarySearchTree<Type>::printTree(BinaryNode<Type>* t) const{
    if (t!=nullptr){
        printTree(t->left);
        cout<<t->element<<" ";
        printTree(t->right);
    }
}

template <class Type>
BinarySearchTree<Type>::~BinarySearchTree(){
    makeEmpty();
}

template <class Type>
BinarySearchTree<Type>::BinarySearchTree(const BinarySearchTree<Type> & rhs): root(nullptr), ITEM_NOT_FOUND(rhs.ITEM_NOT_FOUND){
    *this=rhs;
}

template <class Type>
const BinarySearchTree<Type>& BinarySearchTree<Type>::operator=(const BinarySearchTree<Type>& rhs){
    if (this !=&rhs){
        makeEmpty();
        this->root=clone(rhs.root);
    }
    return *this;
}

template <class Type>
BinaryNode<Type>* BinarySearchTree<Type>::clone(BinaryNode<Type>* t) const{
    if (t==nullptr){
        return nullptr;
    }
    BinaryNode<Type>* tmp=new BinaryNode<Type>(t->element, clone(t->left), clone(t->right));
    return tmp;
}

#endif
