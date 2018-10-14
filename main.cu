#include <iostream>
#include <math.h>
#include <cstdlib>

// add two arrays
template<typename T>
__global__ void add(T *output, T *inputA, T *inputB) {
  int idx = (blockIdx.x * blockDim.x) + threadIdx.x;
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
  std::cout << "HEYO" << '\n';

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
  
  // initialize random arrays
  for (int i = 0; i < N; i++) {
    x[i] = ((float) std::rand()) / (float) RAND_MAX;
    y[i] = ((float) std::rand()) / (float) RAND_MAX;
  }

  for (int blerp = 0; blerp < iterations; blerp++) {
    add<<<numBlocks, blockSize>>>(output, x, y);
    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();
  }

  // Free memory
  cudaFree(x);
  cudaFree(y);
  

  return 0;
}

