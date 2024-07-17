#include <iostream>
#include <chrono>
using namespace std;


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

void matrix_vector_double_prefetch(double** mat, double* b, double* res, int N, int d){
    for (int i = 0; i < N; i++){
        double tmp = 0;
        int j = 0;
        double* a = mat[i];
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
        matrix_vector_float_prefetch(mat_float, B_float, res_float, n, 4);
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    cout << "matrix_vector_float_prefetch with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t2-t1).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res_float[i]<<" ";
    }
    cout<<endl<<endl;

    auto t3 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < k; i++){
        matrix_vector_double_prefetch(mat_double, B_double, res_double, n, 4);
    }
    auto t4 = std::chrono::high_resolution_clock::now();
    cout << "matrix_vector_double_prefetch with "<< k<< " iterations: " << chrono::duration_cast<chrono::milliseconds>(t4-t3).count() << " milliseconds\n";
    for (int i = 0; i < 10; i++){
        cout<<res_double[i]<<" ";
    }
    cout<<endl<<endl;

    return 0;
}