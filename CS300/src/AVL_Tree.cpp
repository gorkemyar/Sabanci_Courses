#ifndef AVLtree_h
#define AVLtree_h

#include <iostream>

// does not consist the remove function
using namespace std;

template <class Type>
class AVLtree;

template <class Type>
class AVLNode{
    Type element;
    AVLNode* left;
    AVLNode* right;
    int height;
    AVLNode(Type e=Type(), AVLNode<Type>* l=nullptr, AVLNode<Type>* r=nullptr, int h=0 ): element(e), left(l), right(r), height(h){};
    
    friend class AVLtree<Type>;
};

template <class Type>
class AVLtree{
public:
    explicit AVLtree(const Type & notFound); //
    AVLtree(const AVLtree & rhs);
    ~AVLtree(); //
    
    const Type & findMin() const; //
    const Type & findMax() const; //
    const Type & find(const Type & x) const; //
    bool isEmpty() const; //
    void printTree() const; //
    
    void makeEmpty(); //
    void insert(const Type & x); //
    void remove(const Type & x); //
    
    const AVLtree& operator=(const AVLtree& rhs);
private:
    AVLNode<Type>* root; //
    const Type ITEM_NOT_FOUND; //
    
    const Type & elementAt(AVLNode<Type>* t) const; //
    void insert(const Type& x, AVLNode<Type>* &t) const; //
    void remove(const Type& x, AVLNode<Type>* &t) const; //
    AVLNode<Type>* findMin(AVLNode<Type>* t) const; //
    AVLNode<Type>* findMax(AVLNode<Type>* t) const; //
    AVLNode<Type>* find(const Type& x,AVLNode<Type>* t) const; //
    
    void makeEmpty(AVLNode<Type>* & t) const; //
    void printTree(AVLNode<Type>* t) const; //
    AVLNode<Type>* clone(AVLNode<Type>* t) const;
    
    int height(AVLNode<Type>* t) const;
    int max(int lhs, int rhs) const;
    void rotateWithLeftChild(AVLNode<Type>* & k) const;
    void rotateWithRightChild(AVLNode<Type>* & k) const;
    void doubleWithLeftChild(AVLNode<Type>* &k) const;
    void doubleWithRightChild(AVLNode<Type>* &k) const;
    
};

template <class Type>
AVLtree<Type>::AVLtree(const Type & notFound): ITEM_NOT_FOUND(notFound), root(nullptr) {};

template <class Type>
const Type & AVLtree<Type>::elementAt(AVLNode<Type>* t) const{
    return t==nullptr ? ITEM_NOT_FOUND: t->element;
}

template <class Type>
const Type& AVLtree<Type>::find(const Type & x) const{
    return elementAt(find(x, root));
}

template <class Type>
AVLNode<Type>* AVLtree<Type>::find(const Type&x, AVLNode<Type>* t) const{
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
 AVLNode<Type>* AVLtree<Type>::find(const Type&x, AVLNode<Type>* t) const{
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
const Type& AVLtree<Type>::findMin() const{
    return elementAt(findMin(root));
}

template <class Type>
AVLNode<Type>* AVLtree<Type>::findMin(AVLNode<Type>* t) const{
    if (t==nullptr){
        return nullptr;
    }
    if (t->left==nullptr){
        return t;
    }
    return t->left;
}

template <class Type>
const Type& AVLtree<Type>::findMax() const{
    return elementAt(findMax(root));
}

template <class Type>
AVLNode<Type>* AVLtree<Type>::findMax(AVLNode<Type>* t) const{
    if (t==nullptr){
        return nullptr;
    }
    if (t->right==nullptr){
        return t;
    }
    return t->right;
}

template <class Type>
bool AVLtree<Type>::isEmpty() const{
    return root==nullptr;
}

template <class Type>
void AVLtree<Type>::insert(const Type & x){
    insert(x, root);
}

template <class Type>
void AVLtree<Type>::insert(const Type & x, AVLNode<Type>* &t) const{
    if (t==nullptr){
        t= new AVLNode<Type>(x, nullptr, nullptr);
    }
    else if (x<t->element){
        // x should be inserted to left subtree;
        insert(x, t->left);
        // check if the left tree is out of balance (left subtree grew in height!!)
        if (height(t->left)-height(t->right)==2){
            if (x<t->left->element){
                rotateWithLeftChild(t);
            }
            else{
                doubleWithLeftChild(t);
            }
        }
    }
    else if (x>t->element){
        // x should be inserted to right subtree;
        insert(x, t->right);
        if (height(t->right)-height(t->left)==2){
            if (x>t->right->element){
                rotateWithRightChild(t);
            }
            else{
                doubleWithRightChild(t);
            }
        }
    }
    else
        ; // do nothing since dublication
    //updating the height of the node
    t->height=max(height(t->left),height(t->right))+1;
}

template <class Type>
void AVLtree<Type>::remove(const Type & x){
    remove(x, root);
}

template <class Type>
void AVLtree<Type>::remove(const Type & x, AVLNode<Type>* &t) const{
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
        AVLNode<Type>* oldnode=t;
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
void AVLtree<Type>::makeEmpty(){
    makeEmpty(root);
}

template <class Type>
void AVLtree<Type>::makeEmpty(AVLNode<Type>* &t) const{
    if (t!=nullptr){
        makeEmpty(t->left);
        makeEmpty(t->right);
        delete t;
    }
    t=nullptr;
}


template <class Type>
void AVLtree<Type>::printTree() const{
    if (isEmpty()){
        cout<<"Empty tree"<<endl;
    }
    else{
        printTree(root);
    }
}

template <class Type>
void AVLtree<Type>::printTree(AVLNode<Type>* t) const{
    if (t!=nullptr){
        printTree(t->left);
        cout<<t->element<<" ";
        printTree(t->right);
    }
}

template <class Type>
AVLtree<Type>::~AVLtree(){
    makeEmpty();
}

template <class Type>
AVLtree<Type>::AVLtree(const AVLtree<Type> & rhs): root(nullptr), ITEM_NOT_FOUND(rhs.ITEM_NOT_FOUND){
    *this=rhs;
}

template <class Type>
const AVLtree<Type>& AVLtree<Type>::operator=(const AVLtree<Type>& rhs){
    if (this !=&rhs){
        makeEmpty();
        this->root=clone(rhs.root);
    }
    return *this;
}

template <class Type>
AVLNode<Type>* AVLtree<Type>::clone(AVLNode<Type>* t) const{
    if (t==nullptr){
        return nullptr;
    }
    AVLNode<Type>* tmp=new AVLNode<Type>(t->element, clone(t->left), clone(t->right));
    return tmp;
}

template <class Type>
int AVLtree<Type>::height(AVLNode<Type>* t) const{
    if (t==nullptr){
        return -1;
    }
    return t->height;
}

template <class Type>
int AVLtree<Type>::max(int lhs, int rhs) const{
    if (lhs>rhs){
        return lhs;
    }
    return rhs;
}

template <class Type>
void AVLtree<Type>::rotateWithLeftChild(AVLNode<Type>* & k) const{
    AVLNode<Type>* tmp = k->left;
    k->left=k->left->right;
    tmp->right=k;
    k->height=max(height(k->left), (k->right))+1;
    tmp->height=max(height(tmp->left), height(k))+1;
    k=tmp;
}
template <class Type>
void AVLtree<Type>::rotateWithRightChild(AVLNode<Type>* & k) const{
    AVLNode<Type>* tmp = k->right;
    k->right=k->right->left;
    tmp->left=k;
    k->height=max(height(k->left), (k->right))+1;
    tmp->height=max(height(tmp->right),height(k))+1;
    k=tmp;
}
template <class Type>
void AVLtree<Type>::doubleWithLeftChild(AVLNode<Type>* &k) const{
    rotateWithRightChild(k->left);
    rotateWithLeftChild(k);
}
template <class Type>
void AVLtree<Type>::doubleWithRightChild(AVLNode<Type>* &k) const{
    rotateWithLeftChild(k->right);
    rotateWithRightChild(k);
}

#endif
