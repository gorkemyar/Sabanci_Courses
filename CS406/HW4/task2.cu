#include <iostream>
#include <cuda_runtime.h>
#include <cstring>

#define WORD_SIZE 4 //this code only works for 4 letter words

///////////// THERE IS A COMMENT SECTION AT THE BOTTOM ///////

//TODO 0: Write the kernel
__global__ void wordCount(const char* text, const char* words, int* count_out, int text_len) {
  __shared__ char word[WORD_SIZE];
  word[threadIdx.x] = words[blockDim.x * blockIdx.x + threadIdx.x];
  __syncthreads();
  
  int gap = text_len / blockDim.x;
  int start = threadIdx.x * gap;
  int count_local = 0;

  for (int i = start; i < start + gap; i++){
    bool flag = true;
    for (int j = 0; j < WORD_SIZE; j++){
      if (text[i+j] !=  word[j]){
        flag = false;
        break;
      }
    }
    if (flag){
      count_local++;
    }
  }
  atomicAdd(&count_out[blockIdx.x], count_local);
}

int main(int argc, char** argv) {
    const char base_text[1024] = "CUDA is a parallel computing platform and parallel application programming interface model created by Nvidia. CUDA gives developers access to the virtual instruction set and memory of the parallel computational elements in CUDA GPUs for parallel computing and parallel execution.";

    const unsigned int multiplier = atoi(argv[1]); //the base_text is copied this number of times to increase the input size

    //copies the base text to create larger instances -----
    const int base_len = strlen(base_text);
    const int text_len = base_len * multiplier;
    char* h_text = new char[text_len];
    for(int i = 0; i < multiplier; i++) {
      memcpy(h_text + (i * base_len), base_text, base_len);
    }

    // Find all possible word sequences
    char h_words[base_len * WORD_SIZE];
    for (int i = 0; i < base_len; i++){
        for (int j = 0; j < WORD_SIZE; j++){
             h_words[i* WORD_SIZE + j] = base_text[(i+j) % base_len];
        }
    }
    //data is ready in h_text -----------------------------
    int h_counts[base_len];
    memset(&h_counts, 0, base_len * sizeof(int));

    // Device variables 
    char *d_text, *d_words;
    int *d_counts;

    //TODO 1: Allocate memory on the device
    cudaMalloc((void **)&d_text, text_len * sizeof(char));
    cudaMalloc((void **)&d_words, base_len * WORD_SIZE * sizeof(char));
    cudaMalloc((void **)&d_counts, base_len * sizeof(int));
    
    //TODO 2: Copy data from host to device
    cudaMemcpy(d_text, h_text, text_len * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_words, h_words, base_len * WORD_SIZE * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_counts, &h_counts, base_len * sizeof(int), cudaMemcpyHostToDevice);

    //TODO 3: Launch the kernel
    wordCount<<< base_len, WORD_SIZE>>>(d_text, d_words, d_counts, text_len);
    cudaDeviceSynchronize();

    //TODO 4: Copy result back to host
    cudaMemcpy(&h_counts, d_counts,  base_len * sizeof(int), cudaMemcpyDeviceToHost);

    //Display the result
    char res_word[WORD_SIZE+1];
    res_word[WORD_SIZE] = '\0';
    int res_count = 0;
    for (int i = 0; i < base_len; i++){        
        if (res_count < h_counts[i]){
            res_count = h_counts[i];
            for (int j = 0; j < WORD_SIZE; j++){
                res_word[j] = h_words[i*WORD_SIZE + j];
            }
        }
    }


    std::cout << "The word \"" << res_word << "\" appears " << res_count << " times in the text." << std::endl;

    //TODO 5: Clear the memory on the device
    cudaFree(d_text);
    cudaFree(d_words);
    cudaFree(d_counts);

    return 0;
}
/*
cs406.gorkemyar@nebula:~/HW4$ nvprof ./task2 100
==2623810== NVPROF is profiling process 2623810, command: ./task2 100
The word " par" appears 500 times in the text.
==2623810== Profiling application: ./task2 100
==2623810== Profiling result:
            Type  Time(%)      Time     Calls       Avg       Min       Max  Name
 GPU activities:   99.51%  1.1350ms         1  1.1350ms  1.1350ms  1.1350ms  wordCount(char const *, char const *, int*, int)
                    0.39%  4.4170us         3  1.4720us     416ns  3.5840us  [CUDA memcpy HtoD]
                    0.10%  1.1520us         1  1.1520us  1.1520us  1.1520us  [CUDA memcpy DtoH]
      API calls:   98.81%  266.50ms         3  88.833ms  6.1120us  266.49ms  cudaMalloc
                    0.54%  1.4461ms       456  3.1710us     279ns  167.29us  cuDeviceGetAttribute
                    0.42%  1.1310ms         1  1.1310ms  1.1310ms  1.1310ms  cudaDeviceSynchronize
                    0.11%  290.38us         1  290.38us  290.38us  290.38us  cudaLaunchKernel
                    0.07%  188.36us         3  62.785us  6.4500us  168.20us  cudaFree
                    0.03%  77.629us         4  19.407us  7.0630us  38.076us  cudaMemcpy
                    0.01%  35.565us         4  8.8910us  6.3740us  15.323us  cuDeviceGetName
                    0.01%  21.121us         4  5.2800us  1.7250us  14.678us  cuDeviceGetPCIBusId
                    0.00%  4.9520us         8     619ns     283ns  2.0950us  cuDeviceGet
                    0.00%  2.1580us         4     539ns     451ns     747ns  cuDeviceTotalMem
                    0.00%  1.6000us         3     533ns     300ns     980ns  cuDeviceGetCount
                    0.00%  1.4480us         4     362ns     300ns     451ns  cuDeviceGetUuid
                    0.00%     692ns         1     692ns     692ns     692ns  cuModuleGetLoadingMode


This version of task 2 is better since multiple threads can search for the same word in the text. Even though the total thread count
for this version 4 times greater than the other one, this version approximately performed 10 times better.
*/