#include <iostream>
#include <vector>
using namespace std;

/**
* Standard swap
*/
template <class Comparable>
inline void swap( Comparable & obj1, Comparable & obj2 )
{
   Comparable tmp = obj1;
   obj1 = obj2;
   obj2 = tmp;
}


template <class Comparable>
void insertionSort (vector <Comparable> & a){
    int j;
    
    for (int p=1;p<a.size();p++){ // loop over the passes
        Comparable tmp = a[p];
        for (j = p; j > 0 &&  tmp < a[j-1]; j--) // loop over the elements
            a[j] = a[j-1];
        a[j]=tmp;
    }
}


template <class Comparable>
void shellsort (vector <Comparable> & a){
    int j;
    // Loop over increments
    for (int gap = a.size()/2;  gap > 0; gap/=2)
        // Loop over elements
        for (int i = gap; i < a.size(); i++)
        {
            Comparable tmp = a[i];
            // Loop over elements that are gap apart
            for (j = i; j >= gap &&  tmp < a[j - gap]; j -= gap)
                a[j] = a[j -gap];
            a[j] = tmp;
        }
}


template <class Comparable>  // for deleteMax
// a is the array, i is the position to percolate down from
// n is the logical size of the array
void percDown( vector<Comparable> &a, int i, int n )
{
        int child;
        Comparable tmp;

        for(tmp=a[i] ; 2*i < n; i = child )
        {
           child = 2*i;
           if( child != n-1 && a[ child  ] < a[ child+1 ] )
                child++;
           if( a[child ] > tmp )
               a[i] = a[ child ];
           else
               break;
       }
       a[ i ] = tmp;
}
template <class Comparable>
void heapsort(vector<Comparable> & a)
{
    // buildHeap
    for(int i = a.size()/2; i >= 0; i--)
        percDown(a, i, a.size());

    // sort
    for(int j = a.size() -1; j > 0; j--)
    {
         swap(a[0], a[j]);  // swap max to the last pos.
              percDown(a, 0, j); // re-form the heap
    }
}


/**
* Internal method that merges two sorted halves of a subarray.
* a is an array of Comparable items.
* tmpArray is an array to place the merged result.
* leftPos is the left-most index of the subarray.
* rightPos is the index of the start of the second half.
* rightEnd is the right-most index of the subarray.
*/
template <class Comparable>
void merge( vector<Comparable> & a, vector<Comparable> & tmpArray,
      int leftPos, int rightPos, int rightEnd )
{
   int leftEnd = rightPos - 1;
   int tmpPos = leftPos;
   int numElements = rightEnd - leftPos + 1;

   
    // Main loop
   while( leftPos <= leftEnd && rightPos <= rightEnd )
       if( a[ leftPos ] <= a[ rightPos ] )
           tmpArray[ tmpPos++ ] = a[ leftPos++ ];
       else
           tmpArray[ tmpPos++ ] = a[ rightPos++ ];

   while( leftPos <= leftEnd )    // Copy rest of first half
       tmpArray[ tmpPos++ ] = a[ leftPos++ ];

   while( rightPos <= rightEnd )  // Copy rest of right half
       tmpArray[ tmpPos++ ] = a[ rightPos++ ];

   // Copy tmpArray back
   for( int i = 0; i < numElements; i++, rightEnd-- )
       a[ rightEnd ] = tmpArray[ rightEnd ];
}
/**
* Internal method that makes recursive calls.
* a is an array of Comparable items.
* tmpArray is an array to place the merged result.
* left is the left-most index of the subarray.
* right is the right-most index of the subarray.
*/
template <class Comparable>
void mergeSort( vector<Comparable> & a,
          vector<Comparable> & tmpArray, int left, int right )
{
   if( left < right )
   {
       int center = ( left + right ) / 2;
       mergeSort( a, tmpArray, left, center );
       mergeSort( a, tmpArray, center + 1, right );
       merge( a, tmpArray, left, center + 1, right );
   }
}

/**
* Mergesort algorithm (driver).
*/
template <class Comparable>
void mergeSort( vector<Comparable> & a )
{
   vector<Comparable> tmpArray( a.size( ) );
   mergeSort( a, tmpArray, 0, a.size( ) - 1 );
}

/**
  * Return median of left, center, and right.
  * Order these and hide the pivot.
  */
 template <class Comparable>
 const Comparable & median3( vector<Comparable> & a, int left, int right )
 {
     int center = ( left + right ) / 2;
     if( a[ center ] < a[ left ] )
         swap( a[ left ], a[ center ] );
     if( a[ right ] < a[ left ] )
         swap( a[ left ], a[ right ] );
     if( a[ right ] < a[ center ] )
         swap( a[ center ], a[ right ] );

     // Place pivot at position right - 1
     swap( a[ center ], a[ right - 1 ] );
     return a[ right - 1 ];
 }

/**
 * Quicksort algorithm (driver).
*/

/**
        * Internal insertion sort routine for subarrays
        * that is used by quicksort.
        * a is an array of Comparable items.
        * left is the left-most index of the subarray.
        * right is the right-most index of the subarray.
        */
template <class Comparable>
void insertionSort( vector<Comparable> & a, int left, int right )
{
   for( int p = left + 1; p <= right; p++ )
   {
       Comparable tmp = a[ p ];
       int j;

       for( j = p; j > left && tmp < a[ j - 1 ]; j-- )
           a[ j ] = a[ j - 1 ];
       a[ j ] = tmp;
   }
}


template <class Comparable>
void quicksort( vector<Comparable> & a )
{
   quicksort( a, 0, a.size( ) - 1 );
}

/**
         * Internal quicksort method that makes recursive calls.
         * Uses median-of-three partitioning and a cutoff of 10.
         * a is an array of Comparable items.
         * left is the left-most index of the subarray.
         * right is the right-most index of the subarray.
         */
template <class Comparable>
void quicksort( vector<Comparable> & a, int left, int right )
{
    if( left + 10 <= right ) // more than 10 elements
    {
       Comparable pivot = median3( a, left, right );
        // Begin partitioning
       int i = left, j = right - 1;
       for( ; ; )
       {
           while( a[ ++i ] < pivot ) { }
           while( pivot < a[ --j ] ) { }
           if( i < j )
              swap( a[ i ], a[ j ] );
           else
              break;
       }
        swap( a[ i ], a[ right - 1 ] );  // Restore pivot
        quicksort( a, left, i - 1 );     // Sort small elements
        quicksort( a, i + 1, right );    // Sort large elements
    }
    else  // Do an insertion sort on the subarray
        insertionSort( a, left, right );
}



int main() {
    
    
    return 0;
}
