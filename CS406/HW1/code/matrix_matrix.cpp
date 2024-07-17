// g++ dot_simd.cpp -march[need to provide the app option] -O3[or none] -fopt-info-vec 

#include <iostream>
#include <chrono>
#include <emmintrin.h>
#include <smmintrin.h>
#include <immintrin.h>
using namespace std;

void matrix_mult_simple(float** mat1, float** mat2, float** res, int N){
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            res[i][j] = 0;
            for (int k = 0; k < N; k++) {
                res[i][j] += mat1[i][k] * mat2[k][j];
            }   
        }
    }
}

void matrix_mult_simple_faster(float** mat1, float** mat2, float** res, int N){
    for (int i = 0; i < N; i++) {
        for (int k = 0; k < N; k++) {
            for (int j = 0; j < N; j++) {
                res[i][j] += mat1[i][k] * mat2[k][j];
            }   
        }
    }
}

void simd_matrix_mult_without_transpose(float** A, float** B, float** C, int N) {
    float* col = new float[N];
    for (int j = 0; j < N; j++) { 
        for(int t = 0; t < N; t++){
            col[t] = B[t][j];
        }

        for (int i = 0; i < N; i++) {
            float* row = A[i];
            float* row_end = row + N;
            float* col_c = col;
            __m256 summ = _mm256_setzero_ps(); 
            for (; row < row_end; row += 8, col_c += 8) {
                const __m256 a = _mm256_loadu_ps(row);
                const __m256 b = _mm256_loadu_ps(col_c); 
                summ = _mm256_add_ps(summ, _mm256_dp_ps(a, b, 0xFF));
            }
            const __m128 low = _mm256_castps256_ps128(summ);  
            const __m128 high = _mm256_extractf128_ps(summ, 1);    
            const __m128 result = _mm_add_ss(low, high);
            float sum = _mm_cvtss_f32(result);
            C[i][j] = sum;
        }
    }
}

void matrix_mult_with_transpose(float** A, float** B, float** C, int N){
    for (int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            float sum = 0;
            for (int k = 0; k < N; k++){
                sum += A[i][k] * B[j][k];
            }
            C[i][j] = sum;
        }
    }
}

void simd_matrix_mult_with_transpose(float** A, float** B, float** C, int N) {
    float temp[8];
    __m256 sum, a ,b;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            sum = _mm256_setzero_ps(); 
            for (int k = 0; k < N; k += 8) {
                a = _mm256_loadu_ps(&A[i][k]);
                b = _mm256_loadu_ps(&B[j][k]); 
                sum = _mm256_add_ps(sum, _mm256_mul_ps(a, b));
            }
            sum = _mm256_hadd_ps(sum, sum);
            sum = _mm256_hadd_ps(sum, sum);
            _mm256_storeu_ps(temp, sum); 
            C[i][j] = temp[0] + temp[4];
        }
    }
}

void transpose(float** a, int N) {
    for (int i = 0; i < N; i++) {
        for (int j = i + 1; j < N; j++) {
            swap(a[i][j], a[j][i]);
        }
    }
}


void reset_matrix(float** C, int N){
    for(int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            C[i][j] = 0;
        }
    }
}

void print_instances(float** C, int k, int N){
    for (int i = 0; i < k; i++){
        for(int j = 0; j < k; j++){
            cout<<C[i][j]<<" ";
        }
        cout<<endl;    
    }
    cout<<endl;
}

int main(int argc, char** argv) {
    int n = 1 << atoi(argv[1]);
    int k = atoi(argv[2]);
    
    float** mat1 = new float*[n];
    float** mat2 = new float*[n];
    float** res = new float*[n];

    for(int i = 0; i < n; i++){
        mat1[i] = new float[n];
        mat2[i] = new float[n];
        res[i] = new float[n];

        for (int j = 0; j < n; j++){
            mat1[i][j] = (float)(rand()%1000)/800.0f;
            mat2[i][j] = (float)(rand()%1000)/800.0f;
            res[i][j] = 0;
        }
    }

    //// matrix_mult_simple
    auto t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        matrix_mult_simple(mat1, mat2, res, n);
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    cout << "matrix_mult_simple with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    //// END

    print_instances(res, 10, n);
    reset_matrix(res, n);

    // matrix_mult_simple_faster
    auto t3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        matrix_mult_simple_faster(mat1, mat2, res, n);
    }
    auto t4 = std::chrono::high_resolution_clock::now();
    cout << "matrix_mult_simple_faster with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t4-t3).count() << " milliseconds\n";
    //// END

    print_instances(res, 10, n);
    reset_matrix(res, n);
    
    //// simd_matrix_mult_without_transpose
    auto t5 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        simd_matrix_mult_without_transpose(mat1, mat2, res, n);
    }
    auto t6 = std::chrono::high_resolution_clock::now();
    cout << "simd_matrix_mult_without_transpose with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t6-t5).count() << " milliseconds\n";
    //// END

    print_instances(res, 10, n);
    reset_matrix(res, n);

    //// matrix_mult_with_transpose
    float* mat2t = new float[n*n];
    auto t7 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        transpose(mat2, n);
        matrix_mult_with_transpose(mat1, mat2, res, n);
    }
    transpose(mat2, n);
    auto t8 = std::chrono::high_resolution_clock::now();
    cout << "matrix_mult_with_transpose with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t8-t7).count() << " milliseconds\n";
    //// END

    print_instances(res, 10, n);
    reset_matrix(res, n);

    //// simd_matrix_mult_with_transpose
    auto t9 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){        
        transpose(mat2, n);
        simd_matrix_mult_with_transpose(mat1, mat2, res, n);
    }
    transpose(mat2, n);
    auto t10 = std::chrono::high_resolution_clock::now();
    cout << "simd_matrix_mult_with_transpose with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t10-t9).count() << " milliseconds\n";
    //// END

    print_instances(res, 10, n);

    return 0;
}
