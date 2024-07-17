#include <iostream>
#include <cuda_runtime.h>
#include <cstring>

#define WORD_SIZE 4 //this code only works for 4 letter words

///////////// THERE IS A PERFORMANCE SECTION AT THE BOTTOM ///////


//TODO 0: Write the kernel
__global__ void wordCount(const char* text, const char* words, int* count_out, int text_len, int size) {
  
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  if (idx >= size) return;

  char word[WORD_SIZE];
  for (int i = 0; i < WORD_SIZE; i++){
    word[i] = words[WORD_SIZE * idx + i];
  }
  
  int count_local = 0;

  for (int i = 0; i < text_len-WORD_SIZE + 1; i++){
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
  atomicAdd(&count_out[idx], count_local);
}

int main(int argc, char** argv) {
    const char base_text[1024] = "CUDA is a parallel computing platform and parallel application programming interface model created by Nvidia. CUDA gives developers access to the virtual instruction set and memory of the parallel computational elements in CUDA GPUs for parallel computing and parallel execution.";
    //const char base_text[4096] = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus mollis vehicula malesuada. Maecenas est leo, mollis id nunc nec, pulvinar aliquam eros. Cras hendrerit quam et neque blandit, eu rhoncus ipsum venenatis. Vestibulum pretium ipsum ac quam viverra, in rutrum orci finibus. Mauris ac est eleifend odio condimentum dignissim. In sit amet laoreet est. Ut sed eros vitae ex dignissim imperdiet. Suspendisse eget pretium purus. Ut dignissim leo eu tortor dapibus accumsan. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer ultricies mollis nulla, fermentum malesuada urna cursus a. Phasellus interdum, urna et viverra ornare, nibh neque iaculis nisl, auctor tincidunt dolor justo ut nibh. Curabitur eleifend in eros ac accumsan. Nullam consequat pellentesque erat, quis lobortis arcu iaculis vitae. Praesent a mi metus. Duis pellentesque malesuada aliquam. Duis viverra vitae nunc ut pharetra. Sed at lobortis ipsum, malesuada maximus odio. Sed consequat arcu id nisi tincidunt elementum ac eget sem. In consectetur velit nec ultrices tempor. Quisque a cursus erat. Vestibulum pharetra, mi eu sollicitudin varius, ipsum nulla tristique erat, ut ornare purus mauris ac enim. Ut ultrices mattis est, sed maximus libero pretium ac. Maecenas dignissim congue tellus ut ullamcorper. Integer eget purus vitae eros luctus euismod. Vestibulum et neque sed lacus hendrerit aliquam. Integer eget diam a nulla mattis sodales. Vestibulum varius ut arcu sed laoreet. Integer egestas ex ac ex sagittis, quis auctor lorem efficitur. Vivamus condimentum, ante at mollis tempus, dui eros aliquam libero, congue posuere odio mauris et lacus. Nulla congue in diam bibendum laoreet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi vel neque a turpis scelerisque luctus. Proin et ipsum sed nisi tincidunt dapibus nec quis nunc. Nunc eleifend orci vitae iaculis elementum. Vestibulum nisl diam, tempus in pellentesque ac, feugiat non felis. Proin vel sodales quam, vel feugiat erat. Etiam hendrerit at lacus sagittis cursus. Nunc ac lorem tortor. Aenean mollis volutpat faucibus. Cras rutrum nisi quis libero feugiat, sed laoreet mauris luctus. Proin sed sollicitudin mauris. In sit amet pretium metus. Aenean fermentum tempus est ac pellentesque. Nam posuere, enim ut ullamcorper pellentesque, mauris erat condimentum purus, vel lobortis diam justo eu massa. Vivamus egestas ultrices sapien quis molestie. Quisque id arcu nec tellus bibendum gravida. Donec vel euismod tortor, et mollis lectus. Integer a eleifend ligula, eu iaculis diam. Sed in odio quis turpis cursus lacinia. Etiam sit amet fermentum est, vitae dapibus nisl. Integer condimentum urna massa, vitae porta nulla cursus non. Suspendisse potenti. Mauris cursus, diam sed vulputate gravida, est sem tincidunt lectus, vel consequat nibh ipsum nec sem. Sed vestibulum ornare felis eu eleifend. Ut vel placerat augue. Nullam quis tincidunt massa. Fusce elementum euismod dui, et eleifend massa sodales sit amet. Pellentesque quis auctor mauris. Ut id mauris scelerisque, blandit odio non, condimentum lectus. Vivamus auctor justo eu erat rutrum lacinia. Nulla et enim magna. Morbi malesuada risus non pellentesque pellentesque. Proin posuere tellus sit amet lacus commodo, vel pulvinar nisi lobortis. Vivamus tempus suscipit mi a hendrerit.";

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
    wordCount<<< (base_len + 63) / 64, 64>>>(d_text, d_words, d_counts, text_len, base_len);
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

cs406.gorkemyar@nebula:~/HW4$ nvprof ./task2_2 100
==2623291== NVPROF is profiling process 2623291, command: ./task2_2 100
The word " par" appears 500 times in the text.
==2623291== Profiling application: ./task2_2 100
==2623291== Profiling result:
            Type  Time(%)      Time     Calls       Avg       Min       Max  Name
 GPU activities:   99.95%  10.442ms         1  10.442ms  10.442ms  10.442ms  wordCount(char const *, char const *, int*, int, int)
                    0.04%  4.3830us         3  1.4610us     415ns  3.5520us  [CUDA memcpy HtoD]
                    0.01%  1.1520us         1  1.1520us  1.1520us  1.1520us  [CUDA memcpy DtoH]
      API calls:   96.23%  319.27ms         3  106.42ms  6.0700us  319.26ms  cudaMalloc
                    3.15%  10.439ms         1  10.439ms  10.439ms  10.439ms  cudaDeviceSynchronize
                    0.44%  1.4437ms       456  3.1660us     285ns  165.86us  cuDeviceGetAttribute
                    0.08%  279.65us         1  279.65us  279.65us  279.65us  cudaLaunchKernel
                    0.06%  189.02us         3  63.006us  6.5370us  168.69us  cudaFree
                    0.03%  85.176us         4  21.294us  7.2730us  43.025us  cudaMemcpy
                    0.01%  37.806us         4  9.4510us  6.7890us  16.197us  cuDeviceGetName
                    0.01%  23.560us         4  5.8900us  1.7000us  16.130us  cuDeviceGetPCIBusId
                    0.00%  5.0970us         8     637ns     292ns  2.3980us  cuDeviceGet
                    0.00%  2.2210us         4     555ns     480ns     744ns  cuDeviceTotalMem
                    0.00%  1.4980us         3     499ns     328ns     832ns  cuDeviceGetCount
                    0.00%  1.4120us         4     353ns     320ns     405ns  cuDeviceGetUuid
                    0.00%     527ns         1     527ns     527ns     527ns  cuModuleGetLoadingMode

*/