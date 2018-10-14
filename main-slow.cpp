#include <iostream>
#include <math.h>
#include <cstdlib>
#include <vector>

int main () {
  int N = 8000 * 8000; // 800px x 800px image
  int iterations = 10;
  int size = N*sizeof(float);
  float *x, *y, *output;
  
  x = (float *) malloc(size);
  y = (float *) malloc(size);
  output = (float *) malloc(size);
    
  for (int i = 0; i < N; i++) {
    x[i] = ((float) std::rand()) / (float) RAND_MAX;
    y[i] = ((float) std::rand()) / (float) RAND_MAX;
  }

  // initialize random arrays
  for (int blerp = 0; blerp < iterations; blerp++) {
    for (int i = 0; i < N; i++) {
      output[i] = x[i] + y[i];
    }
  }

  free(x);
  free(y);
  free(output);

  return 0;
}

