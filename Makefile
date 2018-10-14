CC:=/usr/local/cuda-9.1/bin/nvcc
PROF:=/usr/local/cuda-9.1/bin/nvprof


run: main-cuda.cuda 
	./main-cuda.cuda

prof: main-cuda main-cpu main-thrust
	${PROF} ./main-cuda.cuda
	@echo
	${PROF} ./main-thrust
	@echo
	time ./main-cuda.cuda
	@echo
	time ./main-thrust
	@echo
	time ./main-cpu

main-cuda: main-cuda.cu
	${CC} -ccbin g++-6 main-cuda.cu -o main-cuda

main-thrust: main-thrust.cu
	${CC} -ccbin g++-6 main-thrust.cu -o main-thrust

main-cpu: main-cpu.cpp
	${CC} -ccbin g++-6 main-cpu.cpp -o main-cpu
