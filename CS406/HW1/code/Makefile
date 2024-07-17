CC = g++
CFLAGS = -I. -O3 -std=c++11 -march=native -fopt-info-vec
DEPS = 
LIB = -lbenchmark -pthread

%.o: %.cpp
	$(CC) -c -o $@ $^ $(CFLAGS) $(LIB)

all: matrix_matrix matrix_vector

matrix_vector: matrix_vector.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

matrix_matrix: matrix_matrix.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

clean:
	rm -f *~
	rm -f *.o
	rm -f ./matrix_matrix ./matrix_vector
