CC:=/usr/local/cuda-9.1/bin/nvcc
PROF:=/usr/local/cuda-9.1/bin/nvprof

run: main-cuda 
	./main-cuda

prof: main-cuda main-cpu main-thrust
	${PROF} ./main-cuda
	@echo
	${PROF} ./main-thrust
	@echo
	time -v ./main-cuda
	@echo
	time -v ./main-thrust
	@echo
	time -v ./main-cpu

main-cuda: main-cuda.cu
	${CC} -ccbin g++-6 main-cuda.cu -o main-cuda

main-thrust: main-thrust.cu
	${CC} -ccbin g++-6 main-thrust.cu -o main-thrust

main-cpu: main-cpu.cpp
	${CC} -ccbin g++-6 main-cpu.cpp -o main-cpu
