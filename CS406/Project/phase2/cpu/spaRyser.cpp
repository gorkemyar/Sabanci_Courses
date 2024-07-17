#include "helper.cpp"

double spaRyser(double* matrix, int* rptrs, int* colids, double* rvals, int* cptrs, int* rowids, double* cvals, int N, int t){
    int nzeros = 0;
    double* x = new double[N+1];
    double result = 1;

    #pragma omp parallel for schedule(dynamic) num_threads(t) reduction(+:nzeros)
    for (int i = 0; i < N; i++){
        double sum = 0;
        for (int ptr = rptrs[i]; ptr < rptrs[i+1]; ptr++){
            sum += rvals[ptr];
        }
       
        //x[i] = (double)rvals[rptrs[i+1]-1] - (((double)sum)/2.0);
        x[i] = (double)matrix[(i+1)*N - 1] - (((double)sum)/2.0);
        if (x[i] == 0){
            nzeros++;
        }
    }

    if (nzeros == 0){
        for (int i = 0; i < N; i++){
            result *= x[i];
        }
    }else{
        result = 0;
    }

    long loopVariant = pow(2, N - 1);
    for (long g = 1; g < loopVariant; g++){
        long gray_c = binaryToGray(g);
        long gray_p = binaryToGray(g-1);
       
        long xorVAR = gray_c ^ gray_p;
        long jking = log2(xorVAR);
        // get the jking bit of the gray_c
        double s = 2 * getBit(gray_c, jking) - 1;

        for (int k = cptrs[jking]; k < cptrs[jking+1]; k++){
            int r = rowids[k];
            if (x[r] == 0){
                nzeros--;
            }

            x[r] += s * cvals[k];

            if (x[r] == 0){
                nzeros++;
            }
        }

        if (nzeros == 0){
            double prod = g&1 ? -1 : 1; // g % 2 = 1 -> -1 else 1
            for (int i = 0; i < N; i++){
                prod *= x[i];
            }
            
            result += prod;
        }
    }
    return result * (4 * (N%2) - 2);
}
