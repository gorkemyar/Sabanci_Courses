#include <iostream>
#include <chrono>

using namespace std;
template<typename T>
void matrix_vector_basic(T** mat, T* b,T* res, int N){ 
    for (int i = 0; i < N; i++){
        T tmp = 0;
        T* a = mat[i];
        for (int j = 0; j < N; j++){
            tmp += a[j] * b[j];
        }
        res[i] = tmp;
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

    // auto t1 = std::chrono::high_resolution_clock::now();
    // for (int i = 0; i < k; i++){
    //     matrix_vector_basic<float>(mat_float, B_float, res_float, n);
    // }
    // auto t2 = std::chrono::high_resolution_clock::now();
    // cout << "matrix_vector_float_simple with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    // for (int i = 0; i < 10; i++){
    //     cout<<res_float[i]<<" ";
    // }
    // cout<<endl<<endl;

    auto t3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        matrix_vector_basic<double>(mat_double, B_double, res_double, n);
    }
    auto t4 = std::chrono::high_resolution_clock::now();
    cout << "matrix_vector_double_simple with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t4-t3).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res_double[i]<<" ";
    }
    cout<<endl<<endl;

    return 0;
}