// g++ dot_simd.cpp -march[need to provide the app option] -O3[or none] -fopt-info-vec 

#include <iostream>
#include <chrono>
#include <emmintrin.h>
#include <smmintrin.h>
#include <immintrin.h>
using namespace std;

void simd_matrix_mult_with_transpose_float(float** A, float** B, float** C, int N) {
    float temp[8];
    __m256 sum, a ,b;
    int i, j, k;
    float* adx, *bdx;
    for (i = 0; i < N; i++) {
        adx = A[i];
        for (j = 0; j < N; j++) {
            bdx = B[j];
            sum = _mm256_setzero_ps(); 
            for (k = 0; k < N; k += 8) {
                a = _mm256_loadu_ps(adx + k);
                b = _mm256_loadu_ps(bdx + k); 
                sum = _mm256_add_ps(sum, _mm256_mul_ps(a, b));
            }
            sum = _mm256_hadd_ps(sum, sum);
            sum = _mm256_hadd_ps(sum, sum);
            _mm256_storeu_ps(temp, sum); 
            C[i][j] = temp[0] + temp[4];
        }
    }
}

void simd_matrix_mult_with_transpose_double(double** A, double** B, double** C, int N) {
    __m256d sum, a, b;
    double temp[4];
    int i, j, k;
    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            sum = _mm256_setzero_pd(); 
            for (k = 0; k < N; k += 4) {
                a = _mm256_loadu_pd(&A[i][k]);
                b = _mm256_loadu_pd(&B[j][k]); 
                sum = _mm256_add_pd(sum, _mm256_mul_pd(a, b));
            }
            sum = _mm256_hadd_pd(sum, sum);
            _mm256_storeu_pd(temp, sum); 
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

template <typename T>
void transpose(T** a, int N) {
    for (int i = 0; i < N; i++) {
        for (int j = i + 1; j < N; j++) {
            swap(a[i][j], a[j][i]);
        }
    }
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

    // simd_matrix_mult_with_transpose_float
    // auto t1 = std::chrono::high_resolution_clock::now();
    // for (int i = 0; i < k; i++){
    //     transpose<float>(mat2_float, n);
    //     simd_matrix_mult_with_transpose_float(mat1_float, mat2_float, res_float, n);
    // }
    // auto t2 = std::chrono::high_resolution_clock::now();
    // cout << "simd_matrix_mult_with_transpose_float with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    // //// END

    // print_instances<float>(res_float, 10, n);

    //simd_matrix_mult_with_transpose_double
    
    auto t3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        transpose<double>(mat2_double, n);
        simd_matrix_mult_with_transpose_double(mat1_double, mat2_double, res_double, n);
    }
    auto t4 = std::chrono::high_resolution_clock::now();
    cout << "simd_matrix_mult_with_transpose_double with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t4-t3).count() << " milliseconds\n";
    //// END

    print_instances<double>(res_double, 10, n);
    
    return 0;
}
