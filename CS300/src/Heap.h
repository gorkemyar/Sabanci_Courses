#ifndef Heap_h
#define Heap_h

#include <vector>
using namespace std;
int Overflow(){
    cout<<"Binary Heap is full"<<endl;
    return 0;
}
int Underflow(){
    cout<<"Binary Heap is Empty"<<endl;
    return 0;
}
template <class Comparable>
class BinaryHeap
{
  public:
    BinaryHeap( int capacity = 100 );

    bool isEmpty( ) const;
    bool isFull( ) const;
    const Comparable & findMin( ) const;

    void insert( const Comparable & x );
    void deleteMin( );
    void deleteMin( Comparable & minItem );
    void makeEmpty( );

  private:
    int currentSize; // Number of elements in heap
    vector<Comparable> array;  // The heap array

    void buildHeap(vector<Comparable> &Input );
    void percolateDown( int hole );
};

/**
 * Insert item x into the priority queue, maintaining heap order.
 * Duplicates are allowed.
 * Throw Overflow if container is full.
 */
template <class Comparable>
void BinaryHeap<Comparable>::insert( const Comparable & x )
{
    if(isFull())
        throw Overflow();

    // Percolate up
    // Note that instead of swapping we move the hole up
    int hole = ++currentSize;

    for( ; hole > 1 && x < array[ hole / 2 ]; hole /= 2 )
        array[hole] = array[hole/2];

    array[hole] = x;
}
/**
         * Remove the smallest item from the priority queue.
         * Throw Underflow if empty.
         */
template <class Comparable>
void BinaryHeap<Comparable>::deleteMin( )
{
    if(isEmpty())
        throw Underflow( );

    // move the last element to the first and shrink the array
    array[ 1 ] = array[ currentSize--];

    percolateDown( 1 );
}

/**
         * Internal method to percolate down in the heap.
         * hole is the index at which the percolate begins.
         */
template <class Comparable>
void BinaryHeap<Comparable>::percolateDown( int hole )
{
        int child;
        Comparable tmp = array[ hole ]; // tmp is the item that will
                                                           // be percolated down

        for( ; hole * 2 <= currentSize; hole = child )
        {
           child = hole * 2;
           if( child != currentSize && array[ child + 1 ] < array[ child ] )
               child++;  // child is the minimum of the children
           if( array[ child ] < tmp )
                array[ hole ] = array[ child ]; // swap hole and min child
           else
                break;
        }
        array[ hole ] = tmp;  // place tmp in its final position
}
/**
         * Establish heap order property from an arbitrary
         * arrangement of items. Runs in linear time.
         */
template <class Comparable>
void BinaryHeap<Comparable>::buildHeap(vector<Comparable> &Input)
{
    array = Input; // copy input array to private array;

    currentSize = Input.size();

    for( int i = currentSize / 2; i > 0; i--)
        percolateDown( i );
}


#endif
