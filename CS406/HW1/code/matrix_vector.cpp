// g++ dot_simd.cpp -march[need to provide the app option] -O3[or none] -fopt-info-vec 

#include <iostream>
#include <chrono>
#include <emmintrin.h>
#include <smmintrin.h>
#include <immintrin.h>
using namespace std;

void matrix_vector_float_simple(float** mat, float* b,float* res, int N){ 
    // Multiply row of matrix with column write on the index.
    for (int i = 0; i < N; i++){
        float tmp = 0;
        float* a = mat[i];
        for (int j = 0; j < N; j++){
            tmp += a[j] * b[j];
        }
        res[i] = tmp;
    }
}


void matrix_vector_float_prefetch(float** mat, float* b, float* res, int N, int d){
    for (int i = 0; i < N; i++){
        float tmp = 0;
        int j = 0;
        float* a = mat[i];
        for (; j < (N / 4); j+=4){
            __builtin_prefetch (&b[j + d], 0, 1);
            __builtin_prefetch (&a[j + d], 0, 1);
            tmp += mat[i][j]*b[j];
            tmp += mat[i][j+1]*b[j+1];
            tmp += mat[i][j+2]*b[j+2];
            tmp += mat[i][j+3]*b[j+3];
        }
        for (int k = j; k < N; k++){
            tmp += mat[i][k]*b[k];
        }
        res[i] = tmp;
    }
}

void mat_vector_simd_128(float** mat, float* b, float* res, int N){
    for (int i = 0; i < N; i++){
        float* a = mat[i];
        float* b_c = b;
        
        __m128 summ = _mm_setzero_ps();
        const float* aEnd = a + N;
        for(; a < aEnd; a += 4, b_c += 4){
            const __m128 a_data = _mm_loadu_ps(a);
            const __m128 b_data = _mm_loadu_ps(b_c);
            const __m128 mul_data = _mm_dp_ps(a_data, b_data, 0xFF );
            summ = _mm_add_ps(summ, mul_data);
        }
        float sum = _mm_cvtss_f32(summ);
        res[i] = sum;
    }
}

void mat_vector_simd_256(float** mat, float* b, float* res, int N){
    for (int i = 0; i < N; i++){
        float* a = mat[i];
        float* b_c = b;
        
        __m256 summ = _mm256_setzero_ps();
        const float* aEnd = a + N;
        for(; a < aEnd; a += 8, b_c += 8){
            const __m256 a_data = _mm256_loadu_ps(a);
            const __m256 b_data = _mm256_loadu_ps(b_c);
            const __m256 mul_data = _mm256_dp_ps(a_data, b_data, 0xFF );
            summ = _mm256_add_ps(summ, mul_data);
        }
        const __m128 low = _mm256_castps256_ps128(summ);  
        const __m128 high = _mm256_extractf128_ps(summ, 1);    
        const __m128 result = _mm_add_ss(low, high);
        float sum = _mm_cvtss_f32(result);
        res[i] = sum;
    }
}

void mat_vector_builtin_256(float** mat, float* b, float* res, int N){
    float tmp[8];
    __m256 ymm0, ymm1, ymm2, ymm3, ymm4, ymm5, ymm6, ymm7,
    ymm8, ymm9, ymm10, ymm11, ymm12, ymm13, ymm14, ymm15;
 
    const int N_reduced = N - N%64;
    const int N_reduced_32 = N - N%32;
    for (int i = 0; i < N; i++) {
        float ans = 0;
        float* a = mat[i];
        float* b_c = b;
        for (int j=0; j< N_reduced; j+=64) {
            ymm8 = __builtin_ia32_loadups256(&b_c[j]);
            ymm9 = __builtin_ia32_loadups256(&b_c[j+8]);
            ymm10 = __builtin_ia32_loadups256(&b_c[j+16]);
            ymm11 = __builtin_ia32_loadups256(&b_c[j+24]);
            ymm12 = __builtin_ia32_loadups256(&b_c[j+32]);
            ymm13 = __builtin_ia32_loadups256(&b_c[j+40]);
            ymm14 = __builtin_ia32_loadups256(&b_c[j+48]);
            ymm15 = __builtin_ia32_loadups256(&b_c[j+56]);

            ymm0 = __builtin_ia32_loadups256(&a[j]);
            ymm1 = __builtin_ia32_loadups256(&a[j+8]);
            ymm2 = __builtin_ia32_loadups256(&a[j+16]);
            ymm3 = __builtin_ia32_loadups256(&a[j+24]);
            ymm4 = __builtin_ia32_loadups256(&a[j+32]);
            ymm5 = __builtin_ia32_loadups256(&a[j+40]);
            ymm6 = __builtin_ia32_loadups256(&a[j+48]);
            ymm7 = __builtin_ia32_loadups256(&a[j+56]);

            ymm0 = __builtin_ia32_mulps256(ymm0, ymm8 );
            ymm1 = __builtin_ia32_mulps256(ymm1, ymm9 );
            ymm2 = __builtin_ia32_mulps256(ymm2, ymm10);
            ymm3 = __builtin_ia32_mulps256(ymm3, ymm11);
            ymm4 = __builtin_ia32_mulps256(ymm4, ymm12);
            ymm5 = __builtin_ia32_mulps256(ymm5, ymm13);
            ymm6 = __builtin_ia32_mulps256(ymm6, ymm14);
            ymm7 = __builtin_ia32_mulps256(ymm7, ymm15);

            ymm0 = __builtin_ia32_addps256(ymm0, ymm1);
            ymm2 = __builtin_ia32_addps256(ymm2, ymm3);
            ymm4 = __builtin_ia32_addps256(ymm4, ymm5);
            ymm6 = __builtin_ia32_addps256(ymm6, ymm7);
            ymm0 = __builtin_ia32_addps256(ymm0, ymm2);
            ymm4 = __builtin_ia32_addps256(ymm4, ymm6);
            ymm0 = __builtin_ia32_addps256(ymm0, ymm4);

            __builtin_ia32_storeups256(tmp, ymm0);
            for (int k=0; k<8; k++){
                ans += tmp[k];
            }
        }
        for (int j=N_reduced; j<N_reduced_32; j+=32) {
            ymm8 = __builtin_ia32_loadups256(&b_c[j]);
            ymm9 = __builtin_ia32_loadups256(&b_c[j+8]);
            ymm10 = __builtin_ia32_loadups256(&b_c[j+16]);
            ymm11 = __builtin_ia32_loadups256(&b_c[j+24]);
    
            ymm0 = __builtin_ia32_loadups256(&a[j]);
            ymm1 = __builtin_ia32_loadups256(&a[j+8]);
            ymm2 = __builtin_ia32_loadups256(&a[j+16]);
            ymm3 = __builtin_ia32_loadups256(&a[j+24]);
    
            ymm0 = __builtin_ia32_mulps256(ymm0, ymm8 );
            ymm1 = __builtin_ia32_mulps256(ymm1, ymm9 );
            ymm2 = __builtin_ia32_mulps256(ymm2, ymm10);
            ymm3 = __builtin_ia32_mulps256(ymm3, ymm11);
    
            ymm0 = __builtin_ia32_addps256(ymm0, ymm1);
            ymm2 = __builtin_ia32_addps256(ymm2, ymm3);
            ymm0 = __builtin_ia32_addps256(ymm0, ymm2);
    
            __builtin_ia32_storeups256(tmp, ymm0);
            for (int k=0; k<8; k++){
                ans += tmp[k];
            }
        }
        for (int j=N_reduced_32; j<N; j++) {
            ans += a[j] * b_c[j];
        }
        res[i] = ans;
    }   
}


int main(int argc, char** argv) {
    int n = 1 << atoi(argv[1]);
    int k = atoi(argv[2]);
    cout<<"n is "<<n<<" k is "<<k<<endl;
    float** mat = new float*[n];
    float* B = new float[n];

    float* res = new float[n];
    for (int i = 0; i < n; i++){
        res[i] = 0;
    }
    for(int i = 0; i < n; i++){
        B[i] = (float)(rand()%1000)/800.0f;
        mat[i] = new float[n];
        for (int j = 0; j < n; j++){
            mat[i][j] = (float)(rand()%1000)/800.0f;
        }
    }

    //// matrix_vector_float_simple
    auto t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        matrix_vector_float_simple(mat, B, res, n);
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    cout << "matrix_vector_float_simple with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res[i]<<" ";
    }
    cout<<endl<<endl;

    // for (int d = 0; d <= 64; d+= 4){
    //     //// matrix_vector_float_prefetch
    //     t1 = std::chrono::high_resolution_clock::now();
    //     for (int i = 0; i < k; i++){
    //         matrix_vector_float_prefetch(mat, B, res, n, d);
    //     }
    //     t2 = std::chrono::high_resolution_clock::now();
    //     cout << "matrix_vector_float_prefetch with "<< k<< " iterations and "<< d <<" prefetch: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    // }

    t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        matrix_vector_float_prefetch(mat, B, res, n, 4);
    }
    t2 = std::chrono::high_resolution_clock::now();
    cout << "matrix_vector_float_prefetch with "<< k<< " iterations and "<< 4 <<" prefetch: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res[i]<<" ";
    }
    cout<<endl<<endl;


    t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        mat_vector_simd_128(mat, B, res, n);
    }
    t2 = std::chrono::high_resolution_clock::now();
    cout << "mat_vector_simd_128 with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res[i]<<" ";
    }
    cout<<endl<<endl;


    t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        mat_vector_simd_256(mat, B, res, n);
    }
    t2 = std::chrono::high_resolution_clock::now();
    cout << "mat_vector_simd_256 with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res[i]<<" ";
    }
    cout<<endl<<endl;


    t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        mat_vector_builtin_256(mat, B, res, n);
    }
    t2 = std::chrono::high_resolution_clock::now();
    cout << "mat_vector_builtin_256 with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res[i]<<" ";
    }
    cout<<endl<<endl;

    return 0;
}