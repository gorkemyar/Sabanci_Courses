#include "helper.cpp"
#include <climits>
#ifndef gFunctions
#define gFunctions

long gFunction(double* mat, long i, long g, int N)
{
    long minVal = LONG_MAX;
    long pow_j = 1;
    long tmp;
    for(int j = 0; j < N; j++){
        if(mat[i*N + j] != 0){   
            tmp = g < pow_j ? pow_j : g + 2*pow_j - ((g-pow_j) % (pow_j*2)); // next(g, j)
            if (tmp < minVal){
                minVal = tmp;
            }
        }
        pow_j *= 2;
    }
    return minVal;
}

long nextg(long g, double* X, double* mat, int N, int t)
{
    long maxVal = LONG_MIN;
    long tmp;
    for(int i = 0; i < N; i++){
        if(X[i] == 0){
            tmp = gFunction(mat, i, g, N);
            if (maxVal < tmp){
                maxVal = tmp;
            }
        }

    }
    if(maxVal == LONG_MIN)
        return g+1;
    return maxVal;
}
#endif

double SkipPer(double* matrix, int* rptrs, int* colids, double* rvals, int* cptrs, int* rowids, double* cvals, int N, const int t){
    double* x = new double[N];

    for(int i = 0; i < N; i++){
        double sum = 0;
        for(int intp = rptrs[i]; intp < rptrs[i+1]; intp++){
            sum += rvals[intp];
        }
        //x[i] = (double)rvals[rptrs[i+1]-1].second - sum/2.0;
        x[i] = (double)matrix[(i+1)*N - 1] - (((double)sum)/2.0);
    }

    double result = 1;
    for(int i = 0; i < N; i++){
        result *= x[i];
    }

    long loopVariant = pow(2, N - 1);
    long loopSize = loopVariant / t;
    #pragma omp parallel num_threads(t)
    {
        double my_x[N];
        for (int i = 0; i < N; i++){
            my_x[i] = x[i];
        }
        int id = omp_get_thread_num();
        long b = id * loopSize;
        if (id == 0) b+=1;

        long gpre = binaryToGray(0), g = binaryToGray(b);
    
        long limit = id != t-1 ? ((long)(id + 1))*loopSize : loopVariant;
        double my_result = 0.0;
        double s;

        for (; b < limit;){
            long grdiff = g ^ gpre;
            int j = 0;
            while (grdiff > 0){
                if (grdiff & 1){
                    s = 2 * getBit(g, j) - 1;
                    for(int ptr = cptrs[j]; ptr < cptrs[j+1]; ptr++){
                         my_x[rowids[ptr]] += (s * cvals[ptr]);
                    }
                }
                grdiff = grdiff >> 1;
                j++;
            }

            double prod = 1;
            for(int i = 0; i < N; i++){
                prod *= my_x[i];
            }
            
            long s = b & 1 ? -1 : 1;
            my_result += s * prod;
            
            gpre = g;
            if (prod == 0){ // if only one of the my_x[i] = 0
                b = nextg(b, my_x, matrix, N, t);
            }else{
                b++;
            }
            g = binaryToGray(b);
        }

        #pragma omp atomic
        result += my_result;    
    }
    
    return result * (4 * (N%2) - 2);
}