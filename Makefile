CC:=/usr/local/cuda-9.1/bin/nvcc


run: hey-cuda
	./hey-cuda

prof: hey-cuda main-slow
	/usr/local/cuda-9.1/bin/nvprof ./hey-cuda
	/usr/local/cuda-9.1/bin/nvprof ./main-slow

hey-cuda: main.cu
	${CC} -ccbin g++-6 main.cu -o hey-cuda

main-slow: main-slow.cpp
	${CC} -ccbin g++-6 main-slow.cpp -o main-slow
