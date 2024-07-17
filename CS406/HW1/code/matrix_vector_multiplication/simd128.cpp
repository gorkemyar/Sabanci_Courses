#include <iostream>
#include <chrono>
#include <emmintrin.h>
#include <smmintrin.h>
#include <immintrin.h>
using namespace std;

void mat_vector_simd_128_float(float** mat, float* b, float* res, int N){
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

void mat_vector_simd_128_double(double** mat, double* b, double* res, int N){
    for (int i = 0; i < N; i++){
        double* a = mat[i];
        double* b_c = b;
        
        __m128d summ = _mm_setzero_pd();
        const double* aEnd = a + N;
        for(; a < aEnd; a += 2, b_c += 2){
            const __m128d a_data = _mm_loadu_pd(a);
            const __m128d b_data = _mm_loadu_pd(b_c);
            const __m128d mul_data = _mm_dp_pd(a_data, b_data, 0xFF );
            summ = _mm_add_pd(summ, mul_data);
        }
        double sum = _mm_cvtsd_f64(summ);
        res[i] = sum;
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
        mat_vector_simd_128_double(mat_double, B_double, res_double, n);
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    cout << "mat_vector_simd_128_double with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res_double[i]<<" ";
    }
    cout<<endl<<endl;
    
    auto t3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        mat_vector_simd_128_float(mat_float, B_float, res_float, n);
    }
    auto t4 = std::chrono::high_resolution_clock::now();
    cout << "mat_vector_simd_128_float with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t4-t3).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res_float[i]<<" ";
    }
    cout<<endl<<endl;

    

    return 0;
}