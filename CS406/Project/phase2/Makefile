CC = g++
NVCC = nvcc
CFLAGS = -O3 -std=c++11 
DEPS = 
LIB = -fopenmp 
LIBNV = -Xcompiler -fopenmp -arch=sm_60 -O3

%.o: %.cpp
	$(CC) -c -o $@ $^ $(CFLAGS) $(LIB)

all: main maincu skipperexe skipperexecu sparyserexe sparyserexecu

main: main.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

main2: main2.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

maincu: main.cu
	$(NVCC) -o $@ $^ $(LIBNV)

skipperexe: skipperexe.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

skipperexecu: skipperexe.cu
	$(NVCC) -o $@ $^ $(LIBNV)

sparyserexe: sparyserexe.o
	$(CC) -o $@ $^ $(CFLAGS) $(LIB)

sparyserexecu: sparyserexe.cu
	$(NVCC) -o $@ $^ $(LIBNV)

clean:
	rm -f *~
	rm -f *.o
	rm -f ./main ./main2 ./maincu ./skipperexe ./skipperexecu ./sparyserexe ./sparyserexecu
