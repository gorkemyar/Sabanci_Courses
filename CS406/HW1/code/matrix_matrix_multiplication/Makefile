CC = g++
CFLAGS = -I. -O3 -std=c++11 -march=native -fopt-info-vec
DEPS = 
LIB = -lbenchmark -pthread

%.o: %.cpp
	$(CC) -c -o $@ $^ $(CFLAGS) $(LIB)

all: matrix_mult_simple_faster matrix_mult_simple matrix_mult_with_transpose simd_matrix_mult_with_transpose simd_matrix_mult_without_transpose

matrix_mult_simple_faster: matrix_mult_simple_faster.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

matrix_mult_simple: matrix_mult_simple.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

matrix_mult_with_transpose: matrix_mult_with_transpose.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

simd_matrix_mult_with_transpose: simd_matrix_mult_with_transpose.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

simd_matrix_mult_without_transpose: simd_matrix_mult_without_transpose.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

clean:
	rm -f *~
	rm -f *.o
	rm -f ./simd_matrix_mult_without_transpose ./simd_matrix_mult_with_transpose ./matrix_mult_with_transpose ./matrix_mult_simple ./matrix_mult_simple_faster
