There are 2 directories and 2 files. matrix_matrix_multiplication folder contains all the matrix_matrix multiplication algorithms with different data types. matrix_vector_multiplication folder contains all the matrix_vector multiplication algorithms with different data types. Both have makefiles and script to run all algorithms and calculate GFLOPS.

You can use makefile to create executables by typing make filename.
example:
    make matrix_mult_simple
all:
    make all // to compile all files
clean:
    make clean // to delete the executables

After compilation is concluded. You can either use script to run all files or you can run a specific file by the following command:
    ./matrix_mult_simple size count

// size is the dimension of the matrix for instance if you type 8 ==> 2^8 = 256. The dimension of the matrices will be 256 by 256.
// count shows how many times do you want to do this operation.
// both size and count are positive integers

matrix_matrix and matrix_vector contains all the implementations. If you want to compare them in single run you can follow the instructions above.

Final Note: If you want to see perf results like in the results folder use the following command:
    perf stat -e cycles,instructions,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,dTLB-loads,dTLB-load-misses,dTLB-prefetch-misses,LLC-loads,LLC-load-misses,LLC-stores,LLC-prefetches ./matrix_mult_simple size count