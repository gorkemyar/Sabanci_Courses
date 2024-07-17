#ifndef Heap_h
#define Heap_h

#include <vector>

//heap class taken from lectures

using namespace std;
int Overflow(){
    cout<<"Binary Heap is full"<<endl;
    return 0;
}
int Underflow(){
    cout<<"Binary Heap is Empty"<<endl;
    return 0;
}

struct heapStr{
    int dist;
    int idx;
    heapStr():dist(INT_MAX){};
};

class BinaryHeap
{
  public:
    BinaryHeap(int);

    bool isEmpty( ) const;
    bool isFull( ) const;
    const  heapStr & findMin( ) const;

    void insert( const heapStr & x );
    void deleteMin( );
    void deleteMin( heapStr & minItem );
    void makeEmpty( );

  private:
    int currentSize; // Number of elements in heap
    vector<heapStr> array;  // The heap array

    void buildHeap(vector<heapStr> &Input );
    void percolateDown( int hole );
};
BinaryHeap::BinaryHeap(int capacity):array(capacity){
	currentSize=0;
};

bool BinaryHeap::isEmpty() const{
    return currentSize==0;
}
bool BinaryHeap::isFull( ) const{
    return currentSize==((int)array.size());
}

void BinaryHeap::insert( const heapStr & x )
{
    if(isFull())
        throw Overflow();

    // Percolate up
    // Note that instead of swapping we move the hole up
    int hole = ++currentSize;

    for( ; hole > 1 && x.dist < array[ hole / 2 ].dist; hole /= 2 )
        array[hole] = array[hole/2];
    array[hole] = x;
}

void BinaryHeap::deleteMin( )
{
    if(isEmpty())
        throw Underflow( );

    // move the last element to the first and shrink the array
    array[ 1 ] = array[ currentSize--];
    percolateDown( 1 );
}

void BinaryHeap::percolateDown( int hole )
{
        int child;
        heapStr tmp = array[ hole ]; // tmp is the item that will
                                                           // be percolated down

        for( ; hole * 2 <= currentSize; hole = child )
        {
           child = hole * 2;
           if( child != currentSize && array[ child + 1 ].dist < array[ child ].dist )
               child++;  // child is the minimum of the children
           if( array[ child ].dist < tmp.dist )
                array[ hole ] = array[ child ]; // swap hole and min child
           else
                break;
        }
        array[ hole ] = tmp;  // place tmp in its final position
}

void BinaryHeap::buildHeap(vector<heapStr> &Input)
{
    array = Input; // copy input array to private array;

    currentSize = (int)Input.size();

    for( int i = currentSize / 2; i > 0; i--)
        percolateDown(Input[i].dist);
}
const  heapStr & BinaryHeap::findMin( ) const{
    return array[1];
}

#endif
