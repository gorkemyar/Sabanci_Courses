#include "helper.cpp"

int minDegCol(int degs[],int N){
    int minDeg = INT_MAX;
    int idx = -1;
    for (int i = 0; i < N; i++){
        if (degs[i] < minDeg){
            minDeg = degs[i];
            idx = i;
        }
    }
    return idx;
}

double* skipOrd(double* mat, int N){
    int rowPerm[N];
    int colPerm[N];
    bool rowVisited[N];
    int degs[N];

    for (int i = 0; i < N; i++){
        degs[i] = 0;
        rowVisited[i] = false;
    }

    for (int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            if (mat[i*N + j] != 0){
                degs[j] += 1;
            }
        }
    }

    int i = 0;
    for (int j = 0; j < N; j++){
        int curCol = minDegCol(degs, N);

        degs[curCol] = INT_MAX;
        colPerm[j] = curCol;
        for (int l = 0; l < N; l++){
            if (mat[l*N + curCol] != 0 && rowVisited[l] == false){
                rowVisited[l] = true;
                rowPerm[i] = l;
                i++;
                for (int k = 0; k < N; k++){
                    if (mat[l* N + k] != 0 && degs[k] != INT_MAX){
                        degs[k]--;
                    }
                }
            }
        }
    }

    double* Anew = new double[N*N];
    for (int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            Anew[i*N + j] = mat[rowPerm[i]*N + colPerm[j]];
        }
    }
   
    return Anew;
}