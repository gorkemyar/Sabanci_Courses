#include "BVHTree.h"

void BVHTree::printNode(std::ostream &out, BVHTreeNode *node, int level) {
	if (root == nullptr) return;
	for (int i = 0; i < level; i++) {
		out << "  ";
	}
	if (!node->isLeaf) {
		out << "+ branch || ";
		node->aabb.printAABB(out);
		out << std::endl;
		printNode(out, node->rightChild, level + 1);
		printNode(out, node->leftChild, level + 1);
	}
	else {
		out << "- ";
		if (node->parent) {
			if (node->parent->rightChild == node)
				out << "R ";
			else
				out << "L ";
		}
		out << "- leaf: " << node->name << " || ";
		node->aabb.printAABB(out);
		out << std::endl;
	}
}
std::ostream &operator<<(std::ostream &out, BVHTree &tree) {
	tree.printNode(out, tree.root, 0);
	return out;
}

BVHTree::BVHTree(){
    root=nullptr;
    
}
void BVHTree::makeEmpty(){
    makeEmpty1(root);
    makeEmpty2(root);
}
void BVHTree::makeEmpty1(BVHTreeNode* t){ //make map empty
    if (t!=nullptr){
        makeEmpty1(t->leftChild);
        makeEmpty1(t->rightChild);
        if (t->rightChild==nullptr){
            map.erase(t->name);
        }
    }
}
void BVHTree::makeEmpty2(BVHTreeNode* t){ //make tree empty
    if (t!=nullptr){
        makeEmpty2(t->leftChild);
        makeEmpty2(t->rightChild);
        delete t;
        
    }
    t=nullptr;
}
BVHTree::~BVHTree(){ // delete everything
    makeEmpty();
    root=nullptr;
}


void BVHTree::addBVHMember(AABB objectArea, std::string name){
    if (map.find(name)!=map.end()) return; // if the name already allocated
    if (root==nullptr){
        root=new BVHTreeNode(objectArea,name,true);
        map[name]=root;
    }
    else{
        BVHTreeNode* ptr=root;
        if (ptr->rightChild==nullptr){ //since each node have to have two childs checking one of them is enough
            // case when there is only one node in tree which is root
            BVHTreeNode* oldRoot=root;
            BVHTreeNode* newNode=new BVHTreeNode(objectArea, name, true);
            map[name]=newNode;
            BVHTreeNode*  newRoot=new BVHTreeNode((newNode->aabb).unions(oldRoot->aabb), "branch", false);
            oldRoot->parent=newRoot;
            newNode->parent=newRoot;
            newRoot->leftChild=newNode;
            newRoot->rightChild=oldRoot;
            root=newRoot;
        }
        else{
            AABB aatmp=ptr->aabb;
            while (ptr->rightChild!=nullptr){
                if ((aatmp.unionArea(ptr->rightChild->aabb, objectArea))-ptr->rightChild->aabb.getArea()>= (aatmp.unionArea(ptr->leftChild->aabb, objectArea))-ptr->leftChild->aabb.getArea()){ // we can do it by using operator+ aswell
                    ptr=ptr->leftChild;
                }
                else{
                    ptr=ptr->rightChild;
                }
            }
            //ptr is the sibling of the node that we are going to add
            BVHTreeNode* oldRoot=ptr;
            BVHTreeNode* newNode=new BVHTreeNode(objectArea, name, true);
            map[name]=newNode;
            
            if (ptr->parent->rightChild==ptr){
                BVHTreeNode* tmp=new BVHTreeNode((newNode->aabb).unions(oldRoot->aabb), "branch", false);
                BVHTreeNode* grandPa=ptr->parent;
                ptr->parent->rightChild=tmp;
                tmp->parent=grandPa;
                oldRoot->parent=tmp;
                newNode->parent=tmp;
                tmp->leftChild=newNode;
                tmp->rightChild=oldRoot;
                ptr=tmp;
            }
            else{
                BVHTreeNode* tmp=new BVHTreeNode((newNode->aabb).unions(oldRoot->aabb), "branch", false);
                BVHTreeNode* grandPa=ptr->parent;
                ptr->parent->leftChild=tmp; //same as oldroot actually
                tmp->parent=grandPa;
                oldRoot->parent=tmp;
                newNode->parent=tmp;
                tmp->leftChild=newNode;
                tmp->rightChild=oldRoot;
                ptr=tmp;
            }
            
            // we completed addition to BVH, now we need to arrange all of the parent nodes.

            while (ptr->parent!=nullptr){
                
                if (ptr->parent->rightChild==ptr){
                    ptr->parent->aabb=(ptr->aabb).unions(ptr->parent->leftChild->aabb);
                }
                else {
                    ptr->parent->aabb=(ptr->aabb).unions(ptr->parent->rightChild->aabb);
                }
                ptr=ptr->parent;
            }
        }
    }
}
// get sibling of a node
BVHTreeNode* sibling(BVHTreeNode* t){
    if (t->parent!=nullptr){
        if (t->parent->rightChild==t){
            return t->parent->leftChild;
        }
        else {
            return t->parent->rightChild;
        }
    }
    return nullptr;
}

void BVHTree::removeBVHMember(std::string name){
    
    if (map.find(name)==map.end()) return;
    BVHTreeNode* toRemove=map[name];
    
    if (toRemove==root){ // if there is only root
        delete root;
        root=nullptr;
        map.erase(name);
        return;
    }
    
    if (toRemove->parent->parent==nullptr){ // if grandpa does not exist
        BVHTreeNode* tm=root;
        BVHTreeNode* sib =sibling(toRemove);
        delete toRemove;
        map.erase(name);
        root=sib;
        delete tm;
        return;
    }
    BVHTreeNode* grandPa=toRemove->parent->parent;
    BVHTreeNode* sibling1=sibling(toRemove);
    if (grandPa->rightChild==toRemove->parent){
        grandPa->rightChild=sibling1;
        sibling1->parent=grandPa;
        delete toRemove->parent;
        delete toRemove;
        map.erase(name);
    }
    else{
        grandPa->leftChild=sibling1;
        sibling1->parent=grandPa;
        delete toRemove->parent;
        delete toRemove;
        map.erase(name);
    }

    //std::cout<<"kabooom"<<std::endl;
    
    while (sibling1->parent!=nullptr){
        BVHTreeNode* bro;
        if (sibling1->parent->rightChild==sibling1){
            bro=sibling1->parent->leftChild;
        }
        else {
            bro=sibling1->parent->rightChild;
        }
        sibling1->parent->aabb=bro->aabb +sibling1->aabb;
        sibling1=sibling1->parent;
    }
    
}
//moving aabb to its new location
void BVHTree::moveBVHMember(std::string name, AABB newLocation){
    AABB tmp=newLocation;
    BVHTreeNode* movingNode=map[name];
    if (movingNode->parent!=nullptr){
        BVHTreeNode* father=movingNode->parent;
        if (tmp.unionArea(father->aabb, newLocation)-father->aabb.getArea()==0){ //if parent covers the new region
            movingNode->aabb=newLocation;
        }
        else{
            removeBVHMember(name);
            addBVHMember(newLocation, name);
        }
    }
    else{
        removeBVHMember(name);
        addBVHMember(newLocation, name);
    }
}


//helper collidingObject
void BVHTree::getCollidingObjects(BVHTreeNode* t,AABB object, std::vector<std::string> & myVector){
    if ((t!=nullptr) &&(t->aabb.collide(object))){
        if (t->rightChild==nullptr){
            myVector.push_back(t->name);
        }
        getCollidingObjects(t->leftChild, object, myVector);
        getCollidingObjects(t->rightChild, object, myVector);
    }
}
//public getCollidingObject
std::vector<std::string> BVHTree::getCollidingObjects(AABB object){
    std::vector<std::string> myVector;
    getCollidingObjects(root, object, myVector);
    return myVector;
}
