CC:=/usr/local/cuda-9.1/bin/nvcc


run: main-cuda 
	./main-cuda

prof: main-cuda main-cpu main-thrust
	/usr/local/cuda-9.1/bin/nvprof ./main-cuda
	@echo
	/usr/local/cuda-9.1/bin/nvprof ./main-thrust
	@echo
	time ./main-cuda
	@echo
	time ./main-thrust
	@echo
	time ./main-cpu

main-cuda: main.cu
	${CC} -ccbin g++-6 main.cu -o main-cuda

main-thrust: main-thrust.cu
	${CC} -ccbin g++-6 main-thrust.cu -o main-thrust

main-cpu: main-cpu.cpp
	${CC} -ccbin g++-6 main-cpu.cpp -o main-cpu
