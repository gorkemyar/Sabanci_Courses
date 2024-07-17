#include <iostream>
#include <chrono>
#include <emmintrin.h>
#include <smmintrin.h>
#include <immintrin.h>
using namespace std;

void simd_matrix_mult_without_transpose_float(float** A, float** B, float** C, int N) {
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

void simd_matrix_mult_without_transpose_double(double** A, double** B, double** C, int N) {
    double* col = new double[N];
    for (int j = 0; j < N; j++) { 
        for(int t = 0; t < N; t++){
            col[t] = B[t][j];
        }

        for (int i = 0; i < N; i++) {
            double* row = A[i];
            double* row_end = row + N;
            double* col_c = col;
            __m256d summ = _mm256_setzero_pd(); 
            for (; row < row_end; row += 4, col_c += 4) {
                const __m256d a = _mm256_loadu_pd(row);
                const __m256d b = _mm256_loadu_pd(col_c); 
                summ = _mm256_add_pd(summ, _mm256_mul_pd(a, b));
            }
            summ = _mm256_hadd_pd(summ, summ);
            double temp[4];
            _mm256_storeu_pd(temp, summ); 
            C[i][j] = temp[0] + temp[2];
        }
    }
}

template <typename T>
void print_instances(T** C, int k, int N){
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
    
    float** mat1_float = new float*[n];
    float** mat2_float = new float*[n];
    float** res_float = new float*[n];

    double** mat1_double = new double*[n];
    double** mat2_double = new double*[n];
    double** res_double = new double*[n];

    for(int i = 0; i < n; i++){
        mat1_double[i] = new double[n];
        mat2_double[i] = new double[n];
        mat1_float[i] = new float[n];
        mat2_float[i] = new float[n];
        res_float[i] = new float[n];
        res_double[i] = new double[n];

        for (int j = 0; j < n; j++){
            mat1_float[i][j] = (float)(rand()%1000)/800.0f;
            mat2_float[i][j] = (float)(rand()%1000)/800.0f;
            res_float[i][j] = 0;

            mat1_double[i][j] = (double)mat1_float[i][j];
            mat2_double[i][j] = (double)mat2_float[i][j];
            res_double[i][j] = 0;
        }
    }

    //// simd_matrix_mult_without_transpose_float
    auto t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        simd_matrix_mult_without_transpose_float(mat1_float, mat2_float, res_float, n);
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    cout << "simd_matrix_mult_without_transpose_float with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    //// END

    print_instances<float>(res_float, 10, n);

     //// simd_matrix_mult_without_transpose_double
    auto t3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        simd_matrix_mult_without_transpose_double(mat1_double, mat2_double, res_double, n);
    }
    auto t4 = std::chrono::high_resolution_clock::now();
    cout << "simd_matrix_mult_without_transpose_double with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t4-t3).count() << " milliseconds\n";
    //// END

    print_instances<double>(res_double, 10, n);

    return 0;
}
