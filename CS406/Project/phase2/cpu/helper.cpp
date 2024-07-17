#ifndef HELPER_H
#define HELPER_H
#include <string>
#include <iostream>
#include <set>
#include <vector>
#include <algorithm>
#include <queue>
#include <math.h>
#include <stdio.h>
#include <random>
#include <unordered_map>

using namespace std;
typedef pair<int, double> num_pair;

long binaryToGray(long num) {
    return num ^ (num >> 1);
}

long grayToBinary(long num) {
    long mask;
    for (mask = num >> 1; mask != 0; mask = mask >> 1){
        num = num ^ mask;
    }
    return num;
}

long getBit(long num, long position) {
    return (num >> position) & 1;
}

long changeBit(long num, long position) {
    return num ^ (1 << position);
}

void CRS(double* mat, int* rptrs, int* colids, double* rvals, int N){
    int tot = 0;
    for (int i = 0; i < N+1; i++){
        rptrs[i] = tot;
        if (i == N){
            break;
        }
        for (int j = 0; j < N; j++){
            if (mat[i*N + j] != 0){
                colids[tot] = j;
                rvals[tot] = mat[i*N + j];
                tot++;
            }
        }
    }
}

void CCS(double* mat, int* cptrs, int* rowids, double* cvals, int N){
    int tot = 0;
    for (int i = 0; i < N+1; i++){
        cptrs[i] = tot;
        if (i == N){
            break;
        }
        for (int j = 0; j < N; j++){
            if (mat[j*N + i] != 0){
                rowids[tot] = j;
                cvals[tot] = mat[j*N + i];
                tot++;
            }
        }
    }
}

void fillArray(double* mat, int N){
    for (int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            mat[i*N+ j] = 0;
        }
    }
}

int fillArraySparseRandom(double* mat, int N, int p){
    int tot = 0;
    for (int i = 0; i < N; i++){
        bool isRowEmpty = true;
        for (int j = 0; j < N; j++){
            if (j == N-1 && isRowEmpty){
                mat[i*N + j] = rand() % 20 + ((double)(rand() % 1000) / 1000.0);
                tot++;
            }
            else{
                int n = rand() % 10;
                if (n < 10-p){
                    mat[i*N + j] = 0;
                } else {
                    isRowEmpty = false;
                    mat[i*N + j] = rand() % 20 + ((double)(rand() % 1000) / 1000.0);
                    tot++;
                }
            }
        }
    }
    cout<<"Matrix Density is "<<(double )tot / (double)(N*N)<<endl;
    return tot;
}

int fillArraySparseRandom01(double* mat, int N, int p, int mult){
    int tot = 0;
    bool colEmpty[N];
    for (int i = 0; i < N; i++)
        colEmpty[i] = true;
    for (int i = 0; i < N; i++){
        bool isRowEmpty = true;
        for (int j = 0; j < N; j++){
            int n = rand() % 10;
            double a = ((double)(rand() % 1000) / 1000.0);
            double b = n > 5 ? -a:a;
            if (j == N-1 && isRowEmpty){
                mat[i*N + j] = (1 + b) * mult;
                tot++;
                colEmpty[j] = false;
            }
            else if(i == N-1 && colEmpty[j]){
                mat[i*N + j] = (1 + b) * mult;
                tot++;
            }
            else{
                if (n < 10-p){
                    mat[i*N +j] = 0;
                } else {
                    colEmpty[j] = false;
                    isRowEmpty = false;
                    mat[i*N + j] = (1 + b) * mult;
                    tot++;
                }
            }
        }
    }
    cout<<"Matrix Density is "<<(double )tot / (double)(N*N)<<endl;
    return tot;
}

void printArray(double* mat, int N){
    for (int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            cout << mat[i*N + j] << " ";
        }
        cout << endl;
    }
}

void printCompressed(int* ptr, int* id, double* val, int N){
    for (int i = 0; i < N; i++){
        for (int j = ptr[i]; j < ptr[i+1]; j++){
            cout<<"("<<i<<", "<<id[j]<<") -> "<<val[j]<<endl;
        }
    }
}


double* sortOrd(double* mat, int N, int nnz){
    double* matrix_sortord = new double[N*N];
    memset(matrix_sortord, 0, sizeof(double)*N*N);
    int nnzs[N];
    int idx[N];
    for (int j = 0; j < N; j++){
        int count = 0;
        for (int i = 0; i < N; i++){
            if (mat[i*N + j] != 0){
                count++;
            }
        }
        nnzs[j] = count;
        idx[j] = j;
    }
    sort(idx, idx + N, [&nnzs](int left, int right){
        return nnzs[left] < nnzs[right];
    });

    for (int i = 0; i < N; i++){
        int k = idx[i];
        for (int j = 0; j < N; j++){
            if (mat[j*N + k] != 0){
                matrix_sortord[j*N + i] = mat[j*N + k];
            }
        }
    }
    return matrix_sortord;

}

bool rowColCheck(int* rptrs, int* colids, int N){
    bool flag = false;
    unordered_map<string, int> set;
    for (int i = 0; i < N; i++){
        int start = rptrs[i];
        int end = rptrs[i+1];
        int diff = rptrs[i+1] - rptrs[i];
        if (diff == 0) {
            flag = true;
            return flag;
        }
        if (diff == 1){
            string rowSignature;
            for (int j = start; j < end; j++) {
                rowSignature += to_string(colids[j]) + ",";
            }
            if (set.find(rowSignature) != set.end()) {
                flag = true;
                return flag;
            }
            set[rowSignature] = 0;
        }
        if (diff == 2){
            string rowSignature;
            for (int j = start; j < end; j++) {
                rowSignature += to_string(colids[j]) + ",";
            }
            if (set.find(rowSignature) != set.end()) {
                if (set[rowSignature] == 1){
                    flag = true;
                    return flag;
                }
                set[rowSignature] = 1;
            }else{
                set[rowSignature] = 0;
            }
            
        }
    }
    return flag;
}

#endif