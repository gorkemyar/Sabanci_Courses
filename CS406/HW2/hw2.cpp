#include <iostream>
#include "omp.h"
#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <vector>
#include <algorithm>
#include <unordered_set>
#include <unordered_map>
#include <queue>
#include "include/rcm.cpp"


using namespace std;

typedef struct sparseMatrix {
  int i;
  int j;
  double val;
} sparseMatrix;

sparseMatrix * X;
int NumCols, NumRows;
const int DensityMetric = 1000;
int NumElements;

int loadDataSparse(char * fileName, sparseMatrix ** data, int * size1, int * size2) {
  FILE *myfile;
  if((myfile = fopen(fileName, "r")) == NULL) {
    printf("Error: file cannot be found\n"); 
    exit(1);
  }
  
  int s1, s2, numel, result;
  if((result = fscanf(myfile, "%d %d %d", &s1, &s2, &numel)) <= 0) {
    printf("error while reading file %d\n", result);
    exit(1);
  }
  
  printf("The number of rows, columns, and nonzeros are %d, %d, and %d respectively\n", s1, s2, numel);
  
  *data = (sparseMatrix*)malloc(numel * sizeof(sparseMatrix));
  for (int i = 0; i < numel; i++) {
    int tempi, tempj;
    double tempval;
    if((result = fscanf(myfile, "%d %d %lf", &tempi, &tempj, &tempval)) <= 0) {
      printf("error while reading file - %d\n", result);
      exit(1);
    }

    (*data)[i].i   = tempi - 1;   // INDEXING STARTS AT 1 in the FILE but WE NEED 0 based index
    (*data)[i].j   = tempj - 1;   // INDEXING STARTS AT 1 in the FILE but WE NEED 0 based index
    (*data)[i].val = 0.01f;      
  }

  fclose(myfile);

  *size1 = s1;
  *size2 = s2;

  return numel;
}

void iterative_spmv_seq(int* crs_ptrs, int* crs_colids, double* crs_vals, double* in, int no_iterations, double* &out, double* &temp) {
  printf("sequential spmv starts\n");
  //copy the input to the output; we don't want to change the contents of the input
  for(int i = 0; i < NumRows; i++) {
    out[i] = in[i];
  }
  
  double start = omp_get_wtime();  
  //iterative SpMV - take matrix power
  for(int iter = 0; iter < no_iterations; iter++) {    
    for(int i = 0; i < NumRows; i++) {
      temp[i] = 0;
      for(int  p = crs_ptrs[i]; p < crs_ptrs[i+1]; p++) {
	      temp[i] += crs_vals[p] * out[crs_colids[p]];
      }
    }
    
    //preparing for the next iteration
    double* t = out; out = temp; temp = t;
  }
  double end = omp_get_wtime();
  printf("sequential spmv ends in %f seconds\n", end - start); 
}

/* you can modify the function description, add new additional data for processing etc */
void iterative_spmv_par_dense(int* crs_ptrs, int* crs_colids, double* crs_vals, const unordered_set<int> & dense, double* in, int no_iterations, double* &out, double* &temp) {
  //copy the input to the output; we don't want to change the contents of the input
  for(int i = 0; i < NumRows; i++) {
    out[i] = in[i];
  }
  
  double start = omp_get_wtime();
  //Parallel SpMV - take matrix power

  int t = omp_get_max_threads();
  int pad = (64/sizeof(int));
  double* tmp_thread = new double[t*pad];
  
  for(int iter = 0; iter < no_iterations; iter++) {
    #pragma omp parallel for schedule(static, 512) 
    for(int i = 0; i < NumRows; i++) {
      if (crs_ptrs[i+1] - crs_ptrs[i] < DensityMetric){
        temp[i] = 0;
        for(int  p = crs_ptrs[i]; p < crs_ptrs[i+1]; p++) {
          temp[i] += crs_vals[p] * out[crs_colids[p]];
        }
      }
    }
    
    for(const auto & i: dense) {
      for (int j = 0; j < t; j++){
          tmp_thread[j*pad] = 0;
      }  
      #pragma omp parallel for schedule(static, (crs_ptrs[i+1]-crs_ptrs[i]) / (t))
      for(int k = crs_ptrs[i]; k < crs_ptrs[i+1]; k++) {
        tmp_thread[omp_get_thread_num()*pad] += crs_vals[k] * out[crs_colids[k]];
      }
      temp[i] = 0;
      for (int j = 0; j < t; j++){
        temp[i] += tmp_thread[j*pad];
      }
    }
     double* t = out; out = temp; temp = t;
  }

  double end = omp_get_wtime();
  printf("parallel spmv ends in %f seconds with %d threads\n", end - start, omp_get_max_threads());  
}

void iterative_spmv_par_rcm(int* crs_ptrs, int* crs_colids, double* crs_vals, int* perm, int dense_count, int* dense_row, int* dense_colid, double* dense_val, int* dense_perm, double* in, int no_iterations, double* &out, double* &temp) {
  //copy the input to the output; we don't want to change the contents of the input
  for(int i = 0; i < NumRows; i++) {
    out[i] = in[i];
  }
  
  double start = omp_get_wtime();
  //Parallel SpMV - take matrix power

  int t = omp_get_max_threads();
  int pad = (64/sizeof(int));
  double* tmp_thread = new double[t*pad];

  for(int iter = 0; iter < no_iterations; iter++) {
    
    #pragma omp parallel for schedule(static, 512)
    for(int i = 0; i < NumRows; i++) {
      temp[perm[i]] = 0;
      for(int  p = crs_ptrs[i]; p < crs_ptrs[i+1]; p++) {
        temp[perm[i]] += crs_vals[p] * out[perm[crs_colids[p]]];
      }
    }
    
    for(int i = NumRows-dense_count; i < NumRows; i++) {
      //cout<<dense_perm[i]<<endl;
      for (int j = 0; j < t; j++){
          tmp_thread[j*pad] = 0;
      }  
      #pragma omp parallel for schedule(static, (dense_row[i+1]-dense_row[i]) / (t))
      for(int k = dense_row[i]; k < dense_row[i+1]; k++) {
        tmp_thread[omp_get_thread_num()*pad] += dense_val[k] * out[dense_colid[k]];
      }
      temp[dense_perm[i]] = 0;
      for (int j = 0; j < t; j++){
        temp[dense_perm[i]] += tmp_thread[j*pad];
      }
    }
     double* t = out; out = temp; temp = t;
  }

  double end = omp_get_wtime();
  printf("parallel spmv ends in %f seconds with %d threads\n", end - start, omp_get_max_threads());  
}

void iterative_spmv_par_col(int* crs_ptrs, int* crs_colids, double* crs_vals, int* crs_ptr_col, int* crs_colid_col, double* crs_val_col, const unordered_set<int> & dense, int* crs_ptrs_new, int* crs_colids_new, double* crs_values_new, double* in,  int no_iterations,  double* out,double*  temp){
  for(int i = 0; i < NumRows; i++) {
    out[i] = in[i];
  }
  
  double start = omp_get_wtime();
  //Parallel SpMV - take matrix power

  int t = omp_get_max_threads();
  int pad = (64/sizeof(int));
  double* tmp_thread = new double[t*pad];
  
  for(int iter = 0; iter < no_iterations; iter++) {
    #pragma omp parallel
    {
     #pragma omp for schedule(static, 4096) 
      for(int i = 0; i < NumRows; i++) {
        temp[i] = 0;
        for(int  p = crs_ptr_col[i]; p < crs_ptr_col[i+1]; p++) {
          temp[i] += crs_val_col[p] * out[crs_colid_col[p]];
        }   
      }

      #pragma omp for schedule(static, 512) 
      for(int i = 0; i < NumRows; i++) {
        if (crs_ptrs[i+1] - crs_ptrs[i] < DensityMetric){
          for(int  p = crs_ptrs[i]; p < crs_ptrs[i+1]; p++) {
            temp[i] += crs_vals[p] * out[crs_colids[p]];
          }
        }
      }
    } 

    
    
    for(const auto & i: dense) {
      for (int j = 0; j < t; j++){
          tmp_thread[j*pad] = 0;
      }  
      #pragma omp parallel for schedule(static, (crs_ptrs[i+1]-crs_ptrs[i]) / (t))
      for(int k = crs_ptrs[i]; k < crs_ptrs[i+1]; k++) {
        tmp_thread[omp_get_thread_num()*pad] += crs_vals[k] * out[crs_colids[k]];
      }
      for (int j = 0; j < t; j++){
        temp[i] += tmp_thread[j*pad];
      }
    }
     double* t = out; out = temp; temp = t;
  }

  double end = omp_get_wtime();
  printf("parallel spmv ends in %f seconds with %d threads\n", end - start, omp_get_max_threads());  
}

int main() {
  int no_iterations = 10;
  char fileName[80]= "/data/FullChip/FullChip.mtx";
  NumElements = loadDataSparse(fileName, &X, &NumRows, &NumCols);

  printf("Matrix is read, these should be equal to #rows, #columns, and #elements: %d %d %d\n", NumRows, NumCols, NumElements);

  int* crs_ptrs = (int*)malloc((NumRows + 1) * sizeof(int));
  int* crs_colids = (int*)malloc(NumElements * sizeof(int));
  double* crs_values = (double*)malloc(NumElements * sizeof(double));

  //fill the crs_ptrs array
  memset(crs_ptrs, 0, (NumRows + 1) * sizeof(int));
  for(int i = 0; i < NumElements; i++) {
    int rowid = X[i].i;
    if(rowid < 0 || rowid >= NumRows) {
      printf("problem in X, quitting - %d\n", rowid);
      exit(1);
    }
    crs_ptrs[rowid+1]++;
  }
  
  //now we have cumulative ordering of crs_ptrs.
  for(int i = 1; i <= NumRows; i++) {
    crs_ptrs[i] += crs_ptrs[i-1];
  }
  printf("This number should be equal to the number of nonzeros %d\n", crs_ptrs[NumRows]);

  // we set crs_colids such that for each element, it holds the related column of that element
  for(int i = 0; i < NumElements; i++) {
    int rowid = X[i].i;
    int index = crs_ptrs[rowid];

    crs_colids[index] = X[i].j;
    crs_values[index] = X[i].val;

    crs_ptrs[rowid] = crs_ptrs[rowid] + 1; 
  }
  
  for(int i = NumRows; i > 0; i--) {
    crs_ptrs[i] = crs_ptrs[i-1];
  }
  crs_ptrs[0] = 0;
  printf("This number should be equal to the number of nonzeros %d\n", crs_ptrs[NumRows]); 

  double* in = (double*) malloc(NumRows * sizeof(double));
  for(int i = 0; i < NumRows; i++) {
    in[i] = 1.0f;
  }
  double* out = (double*) malloc(NumRows * sizeof(double));
  double* temp = (double*) malloc(NumRows * sizeof(double));
  
  iterative_spmv_seq(crs_ptrs, crs_colids, crs_values, in, no_iterations, out, temp);
  
  double sum = 0;
  for(int i = 0; i < NumRows; i++) {
    sum += out[i];
  }
  printf("the sum of the output vector for sequential SpMV is %f\n", sum);


	//////////////////////////////////////////////////////////////////////////////
  // Here is the place you do your optimizations if you need to do so. 

  ////// Move dense rows to the end //////

  int count_dense = 0;
  int mult_count = 0;
  unordered_set<int> dense_rows;
  
  for (int i = 0; i < NumRows; i++){
    if (crs_ptrs[i+1] - crs_ptrs[i] > DensityMetric){
      count_dense++;
      mult_count+=crs_ptrs[i+1] - crs_ptrs[i] ;
      dense_rows.insert(i);
    }
  }
  
  int* crs_ptrs_new = new int[NumRows+1];
  int* crs_colids_new = new int[NumElements];
  double* crs_values_new = new double[NumElements];
  int* perm = new int[NumRows];

  crs_ptrs_new[0] = 0;
  int right_idx = 0;
  int left_idx = 0;
  for (int i = 0; i < NumRows; i++){
    if (dense_rows.find(i) != dense_rows.end()){
      int row_idx = NumRows - right_idx;
      perm[row_idx-1] = i;
      crs_ptrs_new[row_idx] = crs_ptrs[i + 1] - crs_ptrs[i];
      right_idx++;
    }else{
      int row_idx = left_idx + 1;
      perm[row_idx-1] = i;
      crs_ptrs_new[row_idx] = crs_ptrs[i + 1] - crs_ptrs[i];
      left_idx++;
    }
  }

  for (int i = 1; i <= NumRows; i++) {
    crs_ptrs_new[i] += crs_ptrs_new[i - 1];
  }

  right_idx = 0;
  left_idx = 0;
  for (int i = 0; i < NumRows; i++) {
    int row_idx = 0;
    if (dense_rows.find(i) != dense_rows.end()){
      row_idx = NumRows - right_idx - 1;
      right_idx++;
    }else{
      row_idx = left_idx;
      left_idx++;
    }
    
    int newStart = crs_ptrs_new[row_idx];
    if (crs_ptrs_new[row_idx+1]- crs_ptrs_new[row_idx] != crs_ptrs[i + 1] - crs_ptrs[i]){
      cout<<"Something is wrong"<<endl;
    }
    for (int j = crs_ptrs[i]; j < crs_ptrs[i + 1]; j++) {
        crs_values_new[newStart] = crs_values[j];
        crs_colids_new[newStart] = crs_colids[j];
        newStart++;
    }
  }

  //////// End for Moving Dense Rows /////////

  /////// Reorder the sparse rows using RCM //////
    
  int* copy_row = new int[NumRows+1];
  int* copy_colid = new int[NumElements-mult_count];
  double* copy_val = new double[NumElements-mult_count];
  memset(copy_colid, -1, (NumElements-mult_count) * sizeof(int));
  memset(copy_row, -1, (NumRows+1) * sizeof(int));

  copy_row[0] = 1;
  for (int i = 0; i < NumRows; i++){
    if (dense_rows.find(i) == dense_rows.end()){
      copy_row[i+1] = copy_row[i] + crs_ptrs[i+1] - crs_ptrs[i];

      int start = copy_row[i]-1;
      for (int j = crs_ptrs[i]; j < crs_ptrs[i+1]; j++){
        copy_colid[start] = crs_colids[j] + 1;
        copy_val[start] = crs_values[j];
        start++;
      }
    }else{
      copy_row[i+1] = copy_row[i]; 
    }
  }
  
  for (int i = 0; i < NumElements-mult_count; i++){
    if (copy_colid[i] == -1){
      cout<<"Error is colid "<<i<<endl;
      return -1;
    }
  }

  for (int i = 0; i <= NumRows; i++){
    if (copy_row[i] == -1){
      cout<<"Error is row"<<endl;
      return -1;
    }
  }

  int* rcm_perm = new int[NumRows];
  int* rcm_perm_inv = new int[NumRows];
  memset(rcm_perm, 0, (NumRows) * sizeof(int));
  memset(rcm_perm_inv, 0, (NumRows) * sizeof(int));
  
  cout<<"RCM perm start"<<endl;
  genrcm(NumRows, NumElements-mult_count, copy_row, copy_colid, rcm_perm);
  perm_inverse3 (NumRows, rcm_perm, rcm_perm_inv);
  cout<<"RCM perm end"<<endl;

  for (int i = 0; i < NumRows; i++){
    rcm_perm[i]--;
    rcm_perm_inv[i]--;
  }

  for (int i = 0; i < NumRows; i++){
    if (rcm_perm[rcm_perm_inv[i]] != i){
      cout<<"Problem perm"<<endl;
      return -1;
    }
  }

  int* copy_row2 = new int[NumRows+1];
  int* copy_colid2 = new int[NumElements-mult_count];
  double* copy_val2 = new double[NumElements-mult_count];

  memset(copy_row2, -1, (NumRows+1) * sizeof(int));
  memset(copy_colid2, -1, (NumElements-mult_count) * sizeof(int));
  memset(copy_val2, -7.77777, (NumElements-mult_count) * sizeof(double));

  copy_row2[0] = 0;
  for (int i = 0; i < NumRows; i++){
    copy_row2[i+1] = copy_row2[i] + copy_row[rcm_perm[i]+1] - copy_row[rcm_perm[i]];
    int start = copy_row2[i];
    for (int j = copy_row[rcm_perm[i]]; j < copy_row[rcm_perm[i]+1]; j++ ){
      copy_colid2[start] = rcm_perm_inv[copy_colid[j-1]-1];
      copy_val2[start] = copy_val[j-1];
      start++;
    }
  }

  /////// End of reordering with RCM //////

  /////// Move the Dense Columns ///////

  int* crs_ptr_col = new int[NumRows+1];
  int* crs_colid_col = new int[mult_count];
  double* crs_val_col = new double[mult_count];

  int* crs_ptr_rmn = new int[NumRows+1];
  int* crs_colid_rmn = new int[NumElements-mult_count];
  double* crs_val_rmn = new double[NumElements-mult_count];

  memset(crs_ptr_col, -1, (NumRows+1) * sizeof(int));
  memset(crs_colid_col, -1, (mult_count) * sizeof(int));
  memset(crs_ptr_rmn, -1, (NumRows+1) * sizeof(int));
  memset(crs_colid_rmn, -1, (NumElements-mult_count) * sizeof(int));

  crs_ptr_col[0] = 0;
  crs_ptr_rmn[0] = 0;
  for (int i = 0; i < NumRows; i++){
    int start_col = crs_ptr_col[i];
    int start_rmn = crs_ptr_rmn[i];
    for (int j = crs_ptrs[i]; j < crs_ptrs[i+1]; j++){
      if (dense_rows.find(crs_colids[j]) == dense_rows.end()){
        crs_colid_rmn[start_rmn] = crs_colids[j];
        crs_val_rmn[start_rmn] = crs_values[j];
        start_rmn++;
      }else{
        crs_colid_col[start_col] = crs_colids[j];
        crs_val_col[start_col] = crs_values[j];
        start_col++;
      }
    }
    crs_ptr_col[i+1] = start_col;
    crs_ptr_rmn[i+1] = start_rmn;
  }
  
  for (int i = 0; i < NumElements-mult_count; i++){
    if (crs_colid_rmn[i] == -1){
      cout<<"Error is colid "<<i<<endl;
      return -1;
    }
  }
  
  for (int i = 0; i <= NumRows; i++){
    if (crs_ptr_col[i] == -1 || crs_ptr_rmn[i] == -1){
      cout<<"Error is row"<<endl;
      return -1;
    }
  }
  

  
	//Optimizations on the data structures end. You can change the signature of iterative_spmv_par
	//if your optimizations generate extra/other helper data structures.  
  //////////////////////////////////////////////////////////////////////////////

  double* out2 = (double*) malloc(NumRows * sizeof(double));
  //int ret = system("perf stat -e cycles,instructions,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,dTLB-loads,dTLB-load-misses,dTLB-prefetch-misses,LLC-loads,LLC-load-misses,LLC-stores,LLC-prefetches -B -p $PPID sleep 0.1 &");
  for(int i = 1; i <= 16; i*=2) {
    omp_set_num_threads(i);
    iterative_spmv_par_dense(crs_ptrs, crs_colids, crs_values, dense_rows, in, no_iterations, out2, temp);
  
    int j = 0;
    for(; j <  NumRows; j++) {
      if(((double)abs(out[i] - out2[i]) / out[i]) > 1.0 / 1000000.0) {
        printf("The result is wrong - ");
        break;
      }
    }
    if(j == NumRows) {
      printf("The result is correct - ");
    }
    double sum = 0;
    for(j = 0; j < NumRows; j++) {
      sum += out2[j];
    }
    printf("the sum of the output vector for the parallel computation is %f\n", sum);
  }
  //ret = system("pkill -f 'perf stat'");
  cout<<"-------------------- RCM --------------------"<<endl;
  //ret = system("perf stat -e cycles,instructions,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,dTLB-loads,dTLB-load-misses,dTLB-prefetch-misses,LLC-loads,LLC-load-misses,LLC-stores,LLC-prefetches -B -p $PPID sleep 0.1 &");
  for(int i = 1; i <= 16; i*=2) {
    omp_set_num_threads(i);
    iterative_spmv_par_rcm(copy_row2, copy_colid2, copy_val2, rcm_perm, right_idx, crs_ptrs_new, crs_colids_new, crs_values_new, perm, in, no_iterations, out2, temp);
  
    int j = 0;
    for(; j <  NumRows; j++) {
      if(((double)abs(out[i] - out2[i]) / out[i]) > 1.0 / 1000000.0) {
        printf("The result is wrong - ");
        break;
      }
    }
    if(j == NumRows) {
      printf("The result is correct - ");
    }
    double sum = 0;
    for(j = 0; j < NumRows; j++) {
      sum += out2[j];
    }
    printf("the sum of the output vector for the parallel computation is %f\n", sum);
  }
  //ret = system("pkill -f 'perf stat'");
  cout<<"-------------------- COL --------------------"<<endl;
  //ret = system("perf stat -e cycles,instructions,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,dTLB-loads,dTLB-load-misses,dTLB-prefetch-misses,LLC-loads,LLC-load-misses,LLC-stores,LLC-prefetches -B -p $PPID sleep 0.1 &");
  for(int i = 1; i <= 16; i*=2) {
    omp_set_num_threads(i);
    iterative_spmv_par_col(crs_ptr_rmn, crs_colid_rmn, crs_val_rmn, crs_ptr_col, crs_colid_col, crs_val_col, dense_rows, crs_ptrs_new, crs_colids_new, crs_values_new, in, no_iterations, out2, temp);
  
    int j = 0;
    for(; j <  NumRows; j++) {
      if(((double)abs(out[i] - out2[i]) / out[i]) > 1.0 / 1000000.0) {
        printf("The result is wrong - ");
        break;
      }
    }
    if(j == NumRows) {
      printf("The result is correct - ");
    }
    double sum = 0;
    for(j = 0; j < NumRows; j++) {
      sum += out2[j];
    }
    printf("the sum of the output vector for the parallel computation is %f\n", sum);
  }
}
