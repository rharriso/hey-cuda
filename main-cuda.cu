#include <iostream>
#include <math.h>
#include <cstdlib>
#include <curand_kernel.h>
#include <thrust/random.h>

// add two arrays
template<typename T>
__global__ void add(T *output, T *inputA, T *inputB) {
  int idx = (blockIdx.x * blockDim.x) + threadIdx.x;
  output[idx] = inputA[idx] + inputB[idx];
}

template<typename T>
__global__ void initRandom(T *arr, float minValue, float maxValue) {
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  thrust::default_random_engine rng;
  thrust::uniform_real_distribution<float> dist(minValue, maxValue);
  rng.discard(idx);
  arr[idx] = dist(rng);
}

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess)
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

int main () {
  int N = 8000 * 8000; // 800px x 800px image
  int iterations = 10;
  int size = N*sizeof(float);
  int blockSize = 256;
  int numBlocks = (N + blockSize - 1) / blockSize;
  
  float *x, *y, *output;

  // Allocate Unified Memory – accessible from CPU or GPU
  cudaMallocManaged(&x, size);
  cudaMallocManaged(&y, size);
  cudaMallocManaged(&output, size);
   
  // initialize arrays 
  initRandom<<<numBlocks, blockSize>>>(x, 0., 1.);
  initRandom<<<numBlocks, blockSize>>>(y, 0., 1.);
  cudaDeviceSynchronize();
  
  for (int blerp = 0; blerp < iterations; blerp++) {
    add<<<numBlocks, blockSize>>>(output, x, y);
    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();
  }
  
  // Free memory
  cudaFree(x);
  cudaFree(y);
  cudaFree(output);
  

  return 0;
}

