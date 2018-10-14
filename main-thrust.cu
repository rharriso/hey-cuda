#include <thrust/device_vector.h>
#include <thrust/random.h>
#include <thrust/functional.h>
#include <thrust/iterator/counting_iterator.h>
#include <iostream>

struct initRandomPrg
{
  float minValue, maxValue;

  __host__ __device__
  initRandomPrg(float _mnV=0.f, float _mxV=1.f) : minValue(_mnV), maxValue(_mxV) {};

  __host__ __device__
  float operator()(const unsigned int n) const
  {
    thrust::default_random_engine rng;
    thrust::uniform_real_distribution<float> dist(minValue, maxValue);
    rng.discard(n);

    return dist(rng);
  }
};


int main() {
  int N = 8000 * 8000; // 800px x 800px image
  int iterations = 10;

  auto x = thrust::device_vector<float>(N);
  auto y = thrust::device_vector<float>(N);
  auto output = thrust::device_vector<float>(N);

  // initilize array  
  auto index_sequence_begin = thrust::counting_iterator<unsigned int>(0);
  
  thrust::transform(
      index_sequence_begin,
      index_sequence_begin + N,
      x.begin(),
      initRandomPrg()
  );
  
  thrust::transform(
      index_sequence_begin,
      index_sequence_begin + N,
      y.begin(),
      initRandomPrg()
  );


  // add them up
  for (int i = 0; i < iterations; i++) {
    thrust::transform(
        x.begin(), x.end(),
        y.begin(),
        output.begin(),
        thrust::plus<float>()
    );
  }

  return 0;
}
