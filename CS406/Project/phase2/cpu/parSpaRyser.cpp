#include "helper.cpp"
#include <climits>

double parSpaRyser(double* matrix, int* rptrs, int* colids, double* rvals, int* cptrs, int* rowids, double* cvals, int N, int t){
    double* x = new double[N];
    double result = 1;

    for (int i = 0; i < N; i++){
        double sum = 0;
        for (int ptr = rptrs[i]; ptr < rptrs[i+1]; ptr++){
            sum += rvals[ptr];
        }
        x[i] = (double)matrix[(i+1)*N - 1] - (((double)sum)/2.0);
        result *= x[i];
    }
    long end = 1l << (long)(N - 1);
    long chunk = (end + t - 1) / t;
    #pragma omp parallel num_threads(t)
    {
        double my_x[N];
        for (int i = 0; i < N; i++){
            my_x[i] = x[i];
        }
        long thread_id = omp_get_thread_num();
        long my_start = thread_id * chunk;
        if (thread_id == 0) my_start++;
        long my_end = min(end, (thread_id+1)*chunk);
        
        long my_g = binaryToGray(my_start-1);
        long g_c = my_g;
        long ptr = 0;
        while (g_c > 0){
            if (g_c & 1l){
                for (int j = cptrs[ptr]; j < cptrs[ptr+1]; j++){
                    my_x[rowids[j]] += cvals[j];
                }
            }
            g_c = g_c >> 1;
            ptr++;
        }

        double my_result = 0;
        double prod = 1;
        int nzeros = 0;
        for (int i = 0; i < N; i++){
            if (my_x[i] != 0){
                prod *= my_x[i];
            }else{
                nzeros++;
            }
        }

        long b = my_start;
        long my_g_pre = my_g;
        long row_idx;
        double div;
        while (b < my_end){
            my_g = binaryToGray(b);
            long xorVAR = my_g ^ my_g_pre;
            long jking = __builtin_ctzl(xorVAR);
            double s = 2 * getBit(my_g, jking) - 1l;

            div = 1;
            for (int k = cptrs[jking]; k < cptrs[jking+1]; k++){
                row_idx = rowids[k];
                if (my_x[row_idx] == 0){
                    nzeros--;
                    my_x[row_idx] += s * cvals[k];
                    prod *= my_x[row_idx];
                }else{
                    div *= my_x[row_idx];
                    my_x[row_idx] += s * cvals[k];
                    if (my_x[row_idx] == 0){
                        nzeros++;
                    }else{
                        prod *= my_x[row_idx];
                    }
                }
            }
            prod /= div;

            if (nzeros == 0){
                double sign = b & 1 ? -1 : 1;
                my_result += sign * prod;
            }
            my_g_pre = my_g;
            b++;
        }
        #pragma omp atomic
        result += my_result;
    }

    return result * (4 * (N%2) - 2);
}