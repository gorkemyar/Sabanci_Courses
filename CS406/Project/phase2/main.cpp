#include <chrono>
#include <iostream>
#include <cstring>
#include <cmath>
#include <omp.h>
#include <time.h>
#include <fstream>

#include "cpu/ryserSimple.cpp"
#include "cpu/spaRyser.cpp"
#include "cpu/skipPer.cpp"
#include "cpu/skipOrd.cpp"
#include "cpu/lundow.cpp"
#include "cpu/skipPerOptimized.cpp"
#include "cpu/parSpaRyser.cpp"


using namespace std;

int main(int argc, char* argv[]){
    double* matrix;
    int N, nonzeros;
    int t = 16;
    if (argc != 3){
        cout << "There should be exactly 3 parameters." << endl;
        return 0;
    }
    string filename = argv[1]; 
    ifstream file(filename);

    if (!file.is_open()) {
        std::cerr << "Failed to open the file: " << filename << std::endl;
        return 1;
    }

    file >> N >> nonzeros;
    matrix = new double[N*N];
    memset(matrix, 0, N*N*sizeof(double));
    
    for (int i = 0; i < nonzeros; i++) {
        int row_id, col_id;
        double nnz_value;
        file >> row_id >> col_id >> nnz_value;
        matrix[row_id* N+ col_id] = nnz_value;
    }
    
    file.close();

    t = stoi(argv[2]);
    
    //printArray(matrix, N);
    // cout<<"N is "<<N<<endl;
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
    
    auto start5 = chrono::high_resolution_clock::now();
    double result5 = parSpaRyser(matrix_sortord, rptrs_sortord, colids_sortord, rvals_sortord, cptrs_sortord, rowids_sortord, cvals_sortord, N, t);
    auto end5 = chrono::high_resolution_clock::now();
    cout << "Result and time of ParSpaRyser with SortOrder: " << endl;
    cout << result5 << "\t" << (double)chrono::duration_cast<chrono::nanoseconds>(end5 - start5).count() / 1000000000.0 << endl;

    double *matrix_new = skipOrd(matrix, N);
    CRS(matrix_new, rptrs, colids, rvals, N);
    CCS(matrix_new, cptrs, rowids, cvals, N);

    auto start6 = chrono::high_resolution_clock::now();
    double result6 = SkipPerOptimized(matrix_new, rptrs, colids, rvals, cptrs, rowids, cvals, N, t);
    auto end6 = chrono::high_resolution_clock::now();
    cout << "Result and time of SkipPer with SkipOrd: " << endl;
    cout << result6 << "\t" << (double)chrono::duration_cast<chrono::nanoseconds>(end6 - start6).count() / 1000000000.0 << endl;


    return 0;
}