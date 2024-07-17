CC = g++
CFLAGS = -I. -O3 -std=c++11 -march=native -fopt-info-vec
DEPS = 
LIB = -lbenchmark -pthread

%.o: %.cpp
	$(CC) -c -o $@ $^ $(CFLAGS) $(LIB)

all: basic prefetch simd128 simd256 builtin256

basic: basic.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

prefetch: prefetch.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

simd128: simd128.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

simd256: simd256.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

builtin256: builtin256.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

clean:
	rm -f *~
	rm -f *.o
	rm -f ./basic ./prefetch ./simd128 ./simd256 ./builtin256
