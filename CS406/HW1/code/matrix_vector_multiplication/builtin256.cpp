#include <iostream>
#include <chrono>
#include <emmintrin.h>
#include <smmintrin.h>
#include <immintrin.h>
using namespace std;

void mat_vector_builtin_256_float(float** mat, float* b, float* res, int N){
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


void mat_vector_builtin_256_double(double** mat, double* b, double* res, int N){
    double tmp[8];
    __m256d ymm0, ymm1, ymm2, ymm3, ymm4, ymm5, ymm6, ymm7,
    ymm8, ymm9, ymm10, ymm11, ymm12, ymm13, ymm14, ymm15;
 
    const int N_reduced = N - N%32;
    const int N_reduced_16 = N - N%16;
    for (int i = 0; i < N; i++) {
        double ans = 0;
        double* a = mat[i];
        double* b_c = b;
        for (int j=0; j< N_reduced; j+=32) {
            ymm8 = __builtin_ia32_loadupd256(&b_c[j]);
            ymm9 = __builtin_ia32_loadupd256(&b_c[j+4]);
            ymm10 = __builtin_ia32_loadupd256(&b_c[j+8]);
            ymm11 = __builtin_ia32_loadupd256(&b_c[j+12]);
            ymm12 = __builtin_ia32_loadupd256(&b_c[j+16]);
            ymm13 = __builtin_ia32_loadupd256(&b_c[j+20]);
            ymm14 = __builtin_ia32_loadupd256(&b_c[j+24]);
            ymm15 = __builtin_ia32_loadupd256(&b_c[j+28]);

            ymm0 = __builtin_ia32_loadupd256(&a[j]);
            ymm1 = __builtin_ia32_loadupd256(&a[j+4]);
            ymm2 = __builtin_ia32_loadupd256(&a[j+8]);
            ymm3 = __builtin_ia32_loadupd256(&a[j+12]);
            ymm4 = __builtin_ia32_loadupd256(&a[j+16]);
            ymm5 = __builtin_ia32_loadupd256(&a[j+20]);
            ymm6 = __builtin_ia32_loadupd256(&a[j+24]);
            ymm7 = __builtin_ia32_loadupd256(&a[j+28]);

            ymm0 = __builtin_ia32_mulpd256(ymm0, ymm8 );
            ymm1 = __builtin_ia32_mulpd256(ymm1, ymm9 );
            ymm2 = __builtin_ia32_mulpd256(ymm2, ymm10);
            ymm3 = __builtin_ia32_mulpd256(ymm3, ymm11);
            ymm4 = __builtin_ia32_mulpd256(ymm4, ymm12);
            ymm5 = __builtin_ia32_mulpd256(ymm5, ymm13);
            ymm6 = __builtin_ia32_mulpd256(ymm6, ymm14);
            ymm7 = __builtin_ia32_mulpd256(ymm7, ymm15);

            ymm0 = __builtin_ia32_addpd256(ymm0, ymm1);
            ymm2 = __builtin_ia32_addpd256(ymm2, ymm3);
            ymm4 = __builtin_ia32_addpd256(ymm4, ymm5);
            ymm6 = __builtin_ia32_addpd256(ymm6, ymm7);
            ymm0 = __builtin_ia32_addpd256(ymm0, ymm2);
            ymm4 = __builtin_ia32_addpd256(ymm4, ymm6);
            ymm0 = __builtin_ia32_addpd256(ymm0, ymm4);

            __builtin_ia32_storeupd256(tmp, ymm0);
            for (int k=0; k<4; k++){
                ans += tmp[k];
            }
        }
        for (int j=N_reduced; j<N_reduced_16; j+=16) {
            ymm8 = __builtin_ia32_loadupd256(&b_c[j]);
            ymm9 = __builtin_ia32_loadupd256(&b_c[j+4]);
            ymm10 = __builtin_ia32_loadupd256(&b_c[j+8]);
            ymm11 = __builtin_ia32_loadupd256(&b_c[j+12]);
    
            ymm0 = __builtin_ia32_loadupd256(&a[j]);
            ymm1 = __builtin_ia32_loadupd256(&a[j+4]);
            ymm2 = __builtin_ia32_loadupd256(&a[j+8]);
            ymm3 = __builtin_ia32_loadupd256(&a[j+12]);
    
            ymm0 = __builtin_ia32_mulpd256(ymm0, ymm8 );
            ymm1 = __builtin_ia32_mulpd256(ymm1, ymm9 );
            ymm2 = __builtin_ia32_mulpd256(ymm2, ymm10);
            ymm3 = __builtin_ia32_mulpd256(ymm3, ymm11);
    
            ymm0 = __builtin_ia32_addpd256(ymm0, ymm1);
            ymm2 = __builtin_ia32_addpd256(ymm2, ymm3);
            ymm0 = __builtin_ia32_addpd256(ymm0, ymm2);
    
            __builtin_ia32_storeupd256(tmp, ymm0);
            for (int k=0; k<8; k++){
                ans += tmp[k];
            }
        }
        for (int j=N_reduced_16; j<N; j++) {
            ans += a[j] * b_c[j];
        }
        res[i] = ans;
    }   
}

int main(int argc, char** argv) {
    int n = 1 << atoi(argv[1]);
    int k = atoi(argv[2]);
    
    float** mat_float = new float*[n];
    float* B_float = new float[n];
    float* res_float = new float[n];
    double** mat_double = new double*[n];
    double* B_double = new double[n];
    double* res_double = new double[n];


    for (int i = 0; i < n; i++){
        res_float[i] = 0;
        res_double[i] = 0;
    }
    for(int i = 0; i < n; i++){
        B_float[i] = (float)(rand()%1000)/800.0f;
        B_double[i] = (double)B_float[i];
        mat_float[i] = new float[n];
        mat_double[i] = new double[n];
        for (int j = 0; j < n; j++){
            mat_float[i][j] = (float)(rand()%1000)/800.0f;
            mat_double[i][j] = (double)mat_float[i][j];
        }
    }

    auto t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        mat_vector_builtin_256_float(mat_float, B_float, res_float, n);
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    cout << "mat_vector_builtin_256_float with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res_float[i]<<" ";
    }
    cout<<endl<<endl;

    auto t3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        mat_vector_builtin_256_double(mat_double, B_double, res_double, n);
    }
    auto t4 = std::chrono::high_resolution_clock::now();
    cout << "mat_vector_builtin_256_double with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t4-t3).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res_double[i]<<" ";
    }
    cout<<endl<<endl;

    return 0;
}