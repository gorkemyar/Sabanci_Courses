#include "../gpu/helper.cu"
#include <climits>
#include <iostream>
#include <cuda_runtime.h>
#include <cstring>
#include "omp.h"
#include <fstream>

#define SIZE 40
#define NNZ_SIZE 480

using namespace std;

__global__ void calculation_skipper_multi(double* matrix, int* cptrs, int* rowids, double* cvals, double*row_sum, double* d_result, int N, int NNZ, long start, long end, long chunk){
    long id = blockIdx.x * blockDim.x + threadIdx.x;
    long idx = threadIdx.x;
    long block_dim = blockDim.x;

    __shared__ int l_cptrs[SIZE];
    __shared__ int l_rowids[NNZ_SIZE];
    __shared__ double l_cvals[NNZ_SIZE];
    extern __shared__ double shared_x[];
    double* my_x = (double*) shared_x;
    if (threadIdx.x < N){
        l_cptrs[idx] = cptrs[idx];
        for (int i = cptrs[idx]; i < cptrs[idx + 1]; i++){
            l_rowids[i] = rowids[i];
            l_cvals[i] = cvals[i];
        }
    }
    else if (idx == N){
        l_cptrs[N] = cptrs[N];
    }
    __syncthreads();
    //double my_x[SIZE];
    for (int i = 0; i < N; i++){
        my_x[block_dim*i + idx] = row_sum[i];
    }
        

    long b = chunk*id + start;
    if (b > end) return;
    if (id == 0 && start == 0) b+=1;
    long limit = min((long)(id + 1l)*chunk + start, end);

    long gpre = 0 ^ (0 >> 1); // binary to Gray
    long g = b ^ (b >> 1l); // binary to gray
    double my_result = 0.0;
    double s;
    
    for (; b < limit;){
        long grdiff = g ^ gpre;
        int j = 0;
        while (grdiff > 0){
            if (grdiff & 1){
                s = (2 * ((g >> j) & 1l)) - 1;
                for(int ptr = l_cptrs[j]; ptr < l_cptrs[j+1]; ptr++){
                    my_x[block_dim*l_rowids[ptr] + idx] += (s * l_cvals[ptr]);
                }
            }
            grdiff = grdiff >> 1;
            j++;
        }

        double prod = b & 1 ? -1 : 1;
        for(int i = 0; i < N; i++){
            prod *= my_x[block_dim*i + idx];
        }
        
        my_result +=  prod;
        
        gpre = g;
        if (prod == 0){ // if only one of the my_x[i] = 0
            b = nextgGpu(b, my_x, matrix, N, block_dim, idx);
        }else{
            b++;
        }
        g = binaryToGrayGpu(b);
    }
    
    atomicAdd(&d_result[blockIdx.x], my_result);
}

__host__ double SkipPerMultiGpu(double* matrix, int* rptrs, int* colids, double* rvals, int* cptrs, int* rowids, double* cvals, int nonzeros, int N, int NNZ, long gpu_count)
{      
    int block_size = 2048;
    int thread_count = 128;
    double *row_sum;
    double result = 1;
    row_sum = new double[N];
    memset(row_sum, 0, N * sizeof(double));
    for(int i = 0; i < N; i++){
        double sum = 0;
        for(int intp = rptrs[i]; intp < rptrs[i+1]; intp++){
            sum += rvals[intp];
        }
        row_sum[i] = (double)matrix[(i+1)*N - 1] - (((double)sum)/2.0);
        result *= row_sum[i];
    }
     
   
    long loopVariant = 1l << (long)(N-1);
    long sections = (loopVariant + gpu_count - 1) / gpu_count;
    #pragma omp parallel for num_threads(gpu_count)
    for (int i = 0; i < gpu_count; i++){
        
        double pragma_thread_result = 0;
        long start = i * sections, end = min((i+1)*sections, loopVariant);
        cudaSetDevice(i);
        
        /// Device Pointers
        int *d_cptrs, *d_rowids;
        double *d_cvals, *d_row_sum, *d_m;
        double *d_result, *h_result = new double[block_size];
        memset(h_result, 0, block_size * sizeof(double));

        // Allocate Memory for Device
        cudaMalloc((void **)&d_rowids, nonzeros * sizeof(int));
        cudaMalloc((void **)&d_cvals, nonzeros * sizeof(double));
        cudaMalloc((void **)&d_cptrs, (N+1) * sizeof(int));
        cudaMalloc((void **)&d_m, (N*N) * sizeof(double));
        cudaMalloc((void **)&d_result, block_size * sizeof(double));
        cudaMalloc(&d_row_sum, N * sizeof(double));
        // Copy Host Memory to Device Memory
        cudaMemcpy(d_cptrs, cptrs,  (N+1)* sizeof(int), cudaMemcpyHostToDevice);
        cudaMemcpy(d_rowids, rowids,  nonzeros * sizeof(int), cudaMemcpyHostToDevice);
        cudaMemcpy(d_cvals,   cvals,  nonzeros * sizeof(double), cudaMemcpyHostToDevice);
        cudaMemcpy(d_m, matrix, N*N*sizeof(double), cudaMemcpyHostToDevice);
        cudaMemcpy(d_result, h_result, block_size * sizeof(double), cudaMemcpyHostToDevice);
        cudaMemcpy(d_row_sum, row_sum,  N * sizeof(double), cudaMemcpyHostToDevice);
        
        long chunk = (sections + (thread_count * block_size) - 1) / (thread_count * block_size);
        long shared_mem_size = thread_count * sizeof(double) * N;
        calculation_skipper_multi<<<block_size, thread_count, shared_mem_size>>>(d_m, d_cptrs,  d_rowids,  d_cvals, d_row_sum, d_result, N, NNZ, start, end, chunk);
        cudaDeviceSynchronize();
        
        cudaMemcpy(h_result, d_result, block_size*sizeof(double), cudaMemcpyDeviceToHost);
        for (int i = 0; i < block_size; i++){
            pragma_thread_result += h_result[i];
        }

        #pragma omp atomic
        result += pragma_thread_result;

        cudaFree(d_rowids);
        cudaFree(d_cptrs);
        cudaFree(d_cvals);
        cudaFree(d_result);
        cudaFree(d_row_sum);
        cudaFree(d_m);
    }

    return result * (4 * (N%2) - 2);;
}
