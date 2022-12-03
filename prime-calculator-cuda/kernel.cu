
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "kernel.cuh"

#include <iostream>


__global__ void findPrimes(int* primesArr, int* numbers, int* primesAnwser, int* primesSize) {
	int j = threadIdx.x;
	bool isDivideble = false;
	for (int i = 0; i < primesSize[0]; i++) {
		if (numbers[j] % primesArr[i] == 0) {
			isDivideble = true;
		}
	}
	if (!isDivideble) {
		primesAnwser[j] = numbers[j];
	}
}

std::vector<int> cudaPrimes(int* numbers, int numbersSize, std::vector<int> primes) {
	//converting vector to array
	int* primesArr = new int[primes.size()];
	std::copy(primes.begin(), primes.end(), primesArr);

	int primesArrSize = primes.size();
	int* primesArrSizePointer = &primesArrSize;

	int primesAnwser[THREADS] = {0};

	int* cudaNumbers = 0;
	int* cudaPrimes = 0;
	int* cudaPrimesAnwser = 0;

	int* cudaPrimesSize = 0;

	cudaMalloc(&cudaNumbers, numbersSize);
	cudaMalloc(&cudaPrimes, primesArrSize * sizeof(int));
	cudaMalloc(&cudaPrimesAnwser, sizeof(primesAnwser));
	cudaMalloc(&cudaPrimesSize, sizeof(primesArrSize));

	cudaMemcpy(cudaNumbers, numbers, numbersSize, cudaMemcpyHostToDevice);
	cudaMemcpy(cudaPrimes, primesArr, primesArrSize*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(cudaPrimesAnwser, primesAnwser, sizeof(primesAnwser), cudaMemcpyHostToDevice);
	cudaMemcpy(cudaPrimesSize, primesArrSizePointer, sizeof(primesArrSize), cudaMemcpyHostToDevice);

	findPrimes << <1, THREADS >> > (cudaPrimes, cudaNumbers, cudaPrimesAnwser, cudaPrimesSize);

	cudaMemcpy(primesAnwser, cudaPrimesAnwser, sizeof(primesAnwser), cudaMemcpyDeviceToHost);

	for (int i = 0; i < THREADS; i++) {
		if (primesAnwser[i] != 0) {
			primes.push_back(primesAnwser[i]);
		}
	}

	delete[] primesArr;

	return primes;
}

