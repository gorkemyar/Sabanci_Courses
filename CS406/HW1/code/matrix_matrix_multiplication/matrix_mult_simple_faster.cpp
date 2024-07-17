// g++ dot_simd.cpp -march[need to provide the app option] -O3[or none] -fopt-info-vec 

#include <iostream>
#include <chrono>
#include <emmintrin.h>
#include <smmintrin.h>
#include <immintrin.h>
using namespace std;

template <typename T>
void matrix_mult_simple_faster(T** mat1, T** mat2, T** res, int N){
    for (int i = 0; i < N; i++) {
        for (int k = 0; k < N; k++) {
            for (int j = 0; j < N; j++) {
                res[i][j] += mat1[i][k] * mat2[k][j];
            }   
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

    //// matrix_mult_simple_faster_float
    // auto t1 = std::chrono::high_resolution_clock::now();
    // for (int i = 0; i < k; i++){
    //     matrix_mult_simple_faster<float>(mat1_float, mat2_float, res_float, n);
    // }
    // auto t2 = std::chrono::high_resolution_clock::now();
    // cout << "matrix_mult_simple_faster_float with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    // //// END

    // print_instances<float>(res_float, 10, n);

     //// matrix_mult_simple_faster_double
    auto t3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        matrix_mult_simple_faster<double>(mat1_double, mat2_double, res_double, n);
    }
    auto t4 = std::chrono::high_resolution_clock::now();
    cout << "matrix_mult_simple_faster_double with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t4-t3).count() << " milliseconds\n";
    //// END

    print_instances<double>(res_double, 10, n);
    

    // matrix_matrix_simple_double
    return 0;
}
