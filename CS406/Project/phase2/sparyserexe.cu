#include <climits>
#include <iostream>
#include <cuda_runtime.h>
#include <cstring>
#include "omp.h"
#include <fstream>
#include <chrono>

#include "gpu/helper.cu"
//#include "gpu/skipPerGpu.cu"
#include "cpu/skipPer.cpp"
#include "cpu/skipOrd.cpp"
#include "multigpu/skipPerMultiGpu.cu"
#include "multigpu/parSpaRyserMultiGpu.cu"

int main(int argc, char* argv[]){
    double* matrix;
    int N, nonzeros;
    int t = 16;
    if (argc != 3){
        cout << "There should be exactly 3 parameters." << endl;
        return 0;
    }
    string filename = argv[1];  // Replace with your file name
    ifstream file(filename);

    if (!file.is_open()) {
        std::cerr << "Failed to open the file: " << filename << std::endl;
        return 1;
    }

    file >> N >> nonzeros;
    // cout<<"N is "<<N<<endl;
    matrix = new double[N*N];
    memset(matrix, 0, N*N*sizeof(double));
    
    for (int i = 0; i < nonzeros; i++) {
        int row_id, col_id;
        double nnz_value;
        file >> row_id >> col_id >> nnz_value;
        matrix[row_id* N+ col_id] = nnz_value;
    }
    
    file.close();

    long gpu_count = stol(argv[2]);
    
    //printArray(matrix, N);
    // cout<<"Number of nonzeros: "<<nonzeros<<endl;
    int* rptrs = new int[N+1], *cptrs = new int[N+1], *colids = new int[nonzeros], *rowids = new int[nonzeros];
    double *cvals = new double[nonzeros], *rvals = new double[nonzeros];
    CRS(matrix, rptrs, colids, rvals, N);
    CCS(matrix, cptrs, rowids, cvals, N);

    auto zerochecks = chrono::high_resolution_clock::now();
    bool isZero = rowColCheck(rptrs, colids, N);
    auto zerochecke= chrono::high_resolution_clock::now();
    double dur = (double)chrono::duration_cast<chrono::nanoseconds>(zerochecke - zerochecks).count() / 1000000000.0;
    if (isZero){
        cout<<0<<" "<<dur<<endl;
        return 0;
    }
    
    double* matrix_sortord = sortOrd(matrix, N, nonzeros);
    int* rptrs_sortord = new int[N+1], *cptrs_sortord = new int[N+1], *colids_sortord = new int[nonzeros], *rowids_sortord = new int[nonzeros];
    double *cvals_sortord = new double[nonzeros], *rvals_sortord = new double[nonzeros];
    CRS(matrix_sortord, rptrs_sortord, colids_sortord, rvals_sortord, N);
    CCS(matrix_sortord, cptrs_sortord, rowids_sortord, cvals_sortord, N);
    

    auto start4 = chrono::high_resolution_clock::now();
    double result4 = ParSpaRyserMultiGpu(matrix_sortord,  rptrs_sortord,  colids_sortord,  rvals_sortord,  cptrs_sortord,  rowids_sortord,  cvals_sortord, nonzeros, N, nonzeros, gpu_count);
    auto end4 = chrono::high_resolution_clock::now();
    // cout << "Result and time of ParSpaRyserMultiGpu with SortOrd: " << endl;
    cout << result4 << "\t" << (double)chrono::duration_cast<chrono::nanoseconds>(end4 - start4).count() / 1000000000.0 << endl;
}