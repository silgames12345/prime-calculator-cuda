#include "kernel.cuh"
#include <iostream>
#include <chrono>

bool isPrime(int i, std::vector<int> primes) {
    bool isDivideble = false;
    for (int j = 0; primes[j] <= (i / 2); j++) {
        if (i % primes[j] == 0) {
            isDivideble = true;
        }
        
    }
    return !isDivideble;
}

void printArr(int* numbers, int size) {
    for (int i = 0; i < size; i++) {
        std::cout << numbers[i] << "\n";
    }
}

void printVector(std::vector<int> primes) {
    for (int i : primes) {
        std::cout << i << "\n";
    }
}
int main() {
    //setup
    int numbers[THREADS];

    //asking to what number the program needs to search
    int largestNum;
    std::cout << "[Log]Starting program\n[MESSAGE]to what number do i need to search: ";
    std::cin >> largestNum;

    std::vector<int> primes;
    primes.push_back(2); //add the first prime to the vector primes

    auto start = std::chrono::high_resolution_clock::now(); //start clock

    //setting numbers to 0-THREADS
    for (int i = 0; i < THREADS; i++) {
        numbers[i] = i;
    }

    //main code
    //getting the firts primes from 0-THREADS
    for (int i = 3; i < THREADS - 1; i++) {
        bool isNumberPrime = isPrime(i, primes);
        if (isNumberPrime) {
            primes.push_back(i);
        }
    }
    //doing other numbers in pairs of THREADS
    while (numbers[THREADS - 1] <= largestNum) {
        for (int i = 0; i < sizeof(numbers) / sizeof(int); i++) {
            numbers[i] = numbers[i] + THREADS;
        }
        int* cudaNumbers = numbers;
        int cudaNumbersSize = sizeof(numbers);
        primes = cudaPrimes(cudaNumbers, cudaNumbersSize, primes);
    }

    auto stop = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start);

    printVector(primes);

    std::cout << "[OUTPUT] elapsed time is: " << (float)duration.count() / 1000 << "s";

	return 0;
}