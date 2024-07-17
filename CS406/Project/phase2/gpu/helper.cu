#ifndef HELPER_GPU
#define HELPER_GPU
#include <string>
#include <iostream>
#include <set>
#include <vector>
#include <algorithm>
#include <queue>
#include <math.h>
#include <stdio.h>
#include <random>
#include <cuda_runtime.h>
#include <cstring>

using namespace std;
typedef pair<int, double> num_pair;

__device__ long binaryToGrayGpu(long num) {
    return num ^ (num >> 1l);
}

__device__ long grayToBinaryGpu(long num) {
    long mask;
    for (mask = num >> 1l; mask != 0; mask = mask >> 1){
        num = num ^ mask;
    }
    return num;
}

__device__ long getBitGpu(long num, long position) {
    return (num >> position) & 1l;
}

__device__ long changeBitGpu(long num, long position) {
    return num ^ (1l << position);
}

__device__ long gFunctionGpu(double* mat, long i, long g, int N)
{
    long minVal = LONG_MAX;
    long pow_j = 1;
    long tmp;
    for(int j = 0; j < N; j++){
        if(mat[i*N + j] != 0){   
            tmp = g < pow_j ? pow_j : g + 2*pow_j - ((g-pow_j) % (pow_j*2)); // next(g, j)
            if (tmp < minVal){
                minVal = tmp;
            }
        }
        pow_j *= 2;
    }
    return minVal;
}

__device__ long nextgGpu(long g, double* X, double* mat, int N, long block_dim, int idx)
{
    long maxVal = LONG_MIN;
    long tmp;
    for(int i = 0; i < N; i++){
        if(X[block_dim*i + idx] == 0){
            tmp = gFunctionGpu(mat, i, g, N);
            if (maxVal < tmp){
                maxVal = tmp;
            }
        }

    }
    if(maxVal == LONG_MIN)
        return g+1;
    return maxVal;
}


#endif