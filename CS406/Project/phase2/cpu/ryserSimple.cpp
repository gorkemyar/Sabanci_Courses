#include "helper.cpp"
#include "omp.h"

double RyserSimple(double* matrix, const int N, int t){
    
    double rowSum[N];
    #pragma omp parallel for num_threads(t)
    for(int i = 0; i < N; i+=1)
    {
        double sum = 0;
        for(int j = 0; j < N; j++)
        {
            sum += matrix[i*N + j];
        }
        rowSum[i] = matrix[i*N + N-1]-(double)(sum/(double)2.0);
    }
    

    double pMultiplied = 1;
    for(int i = 0; i < N; i++)
    {
        pMultiplied *= rowSum[i];
    }

    double loopVariant = pow((long)2, (long)(N - 1));

    //can not parallelise here
    for (long g = 1; g < loopVariant; g++)
    {
        long gray_c = binaryToGray(g);
        long gray_p = binaryToGray(g-1);
       
        long xorVAR = gray_c ^ gray_p;
        long jking = log2(xorVAR);
        
        // get the jking bit of the gray_c
        double s = 2 * (double)getBit(gray_c, jking) - 1;

        double prod = g&1 ? -1 : 1; // bu daha iyi yazılabilir
        
        #pragma omp parallel for schedule(dynamic) num_threads(t) reduction(*:prod)
        for(int i = 0; i < N; i++)
        {
            rowSum[i] += (s * matrix[i*N + jking]);
            prod *= rowSum[i];
        }

        pMultiplied +=  prod;
        
    }
    double returnVal = pMultiplied * (4 * (N%2) - 2);
    return returnVal;
}
