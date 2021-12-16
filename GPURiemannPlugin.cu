#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <emmintrin.h>
#include <sys/time.h>
#include "GPURiemannPlugin.h"


void GPURiemannPlugin::input(std::string file) {
   std::ifstream infile(file.c_str(), std::ios::in);
   infile >> N;
}

void GPURiemannPlugin::run() {
	  //size of the arrays in bytes
  size_t size = N * sizeof(double);

  //allocate array on host and device
  a_h = (double *)malloc(size);
  cudaMalloc((void **) &a_d, size);

  //do calculation on device
  int block_size = 1024;
  int n_blocks = N/block_size + (N % block_size == 0 ? 0:1);
  integratorKernel <<< n_blocks, block_size >>> (a_d, N);

  //copy results from device to host
  cudaMemcpy(a_h, a_d, sizeof(double)*N, cudaMemcpyDeviceToHost);

  //add results
  sum = 0;
  for (int i = 0; i < N; i++) sum += a_h[i];
  sum *= 1 / (double)N;;

}


void GPURiemannPlugin::output(std::string file) {
  //clean up
	printf("%.54lf\n", sum);
  free(a_h);
  cudaFree(a_d);
}


PluginProxy<GPURiemannPlugin> GPURiemannPluginProxy = PluginProxy<GPURiemannPlugin>("GPURiemann", PluginManager::getInstance());

