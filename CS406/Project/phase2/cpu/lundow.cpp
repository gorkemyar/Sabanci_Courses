#include "helper.cpp"
#include <omp.h>
#include <chrono>

// management of this is complete nonsense && we could manage it better
// at least 5 for some reason

typedef struct row_nonzeros{
    int row;
    int numNonZeros;
} row_nonzeros;

bool compareRows(row_nonzeros a, row_nonzeros b){
    return a.numNonZeros > b.numNonZeros; // burada 1 tık daha optimizasyon var
}

vector<row_nonzeros> calculateArrayAndRowPriority(double** arr, vector<set<int>> & neighbors, int N){
    
    vector<row_nonzeros> rows; // row _ # nonzeros //priority queue
    rows.resize(N);   

    for (int i = 0; i < N; i++){ /// N^2
        rows[i].row = i;
        rows[i].numNonZeros = 0;
        for (int j = 0; j < N; j++){
            if(arr[i][j] != 0){
                rows[i].numNonZeros++;
                neighbors[i].insert(j);
            }
        }
    }
    sort(rows.begin(), rows.end(), compareRows); // this sorts in descending order

    return rows;

}

void  greedyPartition(double** arr, vector<set<int>> &partition, int N){
    vector<set<int>> S = {};
    S.resize(N);

    // number of these sets can be reduced
    set<int> Nl = {}; 
    set<int> Nk = {};
    set<int> intersection = {};
    set<int> temp = {};

    int k = 0;
    
    // calculate B, and delta_i's
    //1, 2
    vector<set<int>> neighbors = {}; 
    neighbors.resize(N);
    vector<row_nonzeros> rows = calculateArrayAndRowPriority(arr, neighbors, N);

    //3
    set<int> V = {}; // vertex I presume
    for (int i = 0; i < N; i++){
        V.insert(i);
    }
    set<int> VCopy = V;
    
    int d = -1;
    int l = 0;

    while(V.size()!= 0){   // 4                                                 N^2

        k = rows.back().row; // 5
        rows.pop_back();

        // if (k not in V)
        if(V.find(k) == V.end())  continue;

        d++; // 7
        S[d] = neighbors[k]; // 8

        //remove k from V
        V.erase(k);

        for (set<int>::iterator iter = VCopy.begin(); iter != VCopy.end(); iter++){
            l = *iter;
            Nk = neighbors[k]; // 10
            Nl = neighbors[l];
            set_intersection(Nk.begin(), Nk.end(), Nl.begin(), Nl.end(), inserter(intersection, intersection.begin())); // 10
            if(intersection.size() != 0)               // 10
                V.erase(l); // 11
        
            intersection.clear();
        }
        VCopy = V;
    }
    
    set<int> unionS = {};
    for (int i = 0; i < S.size(); i++){   // this is for 14
        temp = S[i];
        set_union(unionS.begin(), unionS.end(), temp.begin(), temp.end(), inserter(unionS, unionS.begin()));
    }

    temp = {};
    for (int i = 0; i < N; i++) // this is for 14 
        temp.insert(i);
    
    //remove union of S's from T
    set<int> T = {};
    set_difference(temp.begin(), temp.end(), unionS.begin(), unionS.end(), inserter(T, T.begin()));
    

    for(int i = 0; i < S.size() && !S[i].empty(); i++){
        partition.push_back(S[i]);  // 15
    }

    partition.push_back(T); // 15 part 2
}

void calculateSubsets(set<int> & mySet, vector<set<int>> & subsets){
    vector<int> myVector(mySet.begin(), mySet.end());
    int n = mySet.size();
    int max = 1 << n;
    set<int> temp = {};

    for (int i = 0; i < max; i++){
        for (int j = 0; j < n; j++){
            if(i & (1 << j)){
                temp.insert(myVector[j]);
            }
        }
        subsets.push_back(temp);

        temp.clear();
    }
    subsets.erase(subsets.begin());
}

double computation(double** arr, set<int>& J, int N){
    double result = 1;
    int loc = 0;
    for (int i = 0; i < N; i++){
        loc = 0;
        for (int j = 0; j < N; j++){
            if(J.find(j) != J.end()){
                loc += arr[i][j];
            }
        }
        result *= loc;
    }
    return result;
}

int* findState(int* maxValues, int number, int n) {
    int* result = new int[n];

    for (int i = n - 1; i >= 0; --i) {
        result[i] = number % maxValues[i];
        number /= maxValues[i];
    }

    if (number > 0) {
        cout << "Warning: The number is too large to be fully represented." << std::endl;
    }

    return result;
}

set<int> unionSets(const vector<vector<set<int>>> & subsets, int* currentState, int n){
    set<int> res = {};
    set<int> tmp;
    for (int i = 0; i < n; i++){
        tmp = subsets[i][currentState[i]];
        set_union(res.begin(), res.end(), tmp.begin(), tmp.end(), inserter(res, res.begin()));
    }
    return res;
}

double lundow(double** arr, int N, int t){
    vector<set<int>> D;
    greedyPartition(arr, D, N);

    set<int> temp = {};

    vector<vector<set<int>>> subsets(D.size());
    
    #pragma omp parallel for schedule(dynamic) num_threads(t)
    for (int i = 0; i < D.size(); i++){
        vector<set<int>> t;
        calculateSubsets(D[i], t);
        subsets[i] = t;
    }

    // add empty set to last element of subsets
    subsets.back().push_back(temp);

    int upperLimit = 0;
    int lowerLimit = 0;

    upperLimit = 1;

    int size = 1;
    int dsize = (int)D.size();
    int* sizeOfSubsets = new int[dsize];
    for (int i = 0; i < dsize; i++){
        sizeOfSubsets[i] = subsets[i].size();
        size *= subsets[i].size();
    }

    double result = 0;

    #pragma omp parallel for schedule(dynamic) num_threads(t) reduction(+:result)
    for (int i = 0; i < size; i++){
        int* state = findState(sizeOfSubsets, i, dsize);
        set<int> readyForCalculate = unionSets(subsets, state, dsize);
        double tmp = computation(arr, readyForCalculate, N);     
        if (readyForCalculate.size() % 2 == 0) result += tmp;
        else                                   result -= tmp;
        delete state;
    }

    if (N % 2 == 1) result = -result;

    return result;
}