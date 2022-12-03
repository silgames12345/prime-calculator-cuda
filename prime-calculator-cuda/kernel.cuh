#ifndef KERNEL_H
#define KERNEL_H

#include <vector>

#define THREADS 1000
#define LARGEST_NUM 664579

std::vector<int> cudaPrimes(int* numbers, int numbersSize, std::vector<int> primes);

#endif