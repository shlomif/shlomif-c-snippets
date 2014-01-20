/*
 * Demonstration of how we can sort an array of arrays in C, so it makes
 * sense that compare_arrays below will return a (negative,0,positive)
 * value.
 *
 * Written by Shlomi Fish ( http://www.shlomifish.org/ ).
 *
 * License is https://en.wikipedia.org/wiki/MIT_License (MIT/X11 License).
 */
#include <stdlib.h>
#include <stdio.h>

#define ARRAY_SIZE 4
#define COUNT(arr) (sizeof(arr)/sizeof(arr[0]))

int compare_arrays(int * a, int * b, int n)
{
    for (int i=0 ; i < n ; i++)
    {
        if (a[i] < b[i])
        {
            return -1;
        }
        else if (a[i] > b[i])
        {
            return 1;
        }
    }
    return 0;
}

int compare_callback(const void * a_void, const void * b_void)
{
#define DEREF(x) (*(int * *)(x))
    return compare_arrays(DEREF(a_void), DEREF(b_void), ARRAY_SIZE);
#undef DEREF
}

int main(int argc, char * argv[])
{
    int arr1[ARRAY_SIZE] = {1,2,3,4};
    int arr2[ARRAY_SIZE] = {1,2,3,3};
    int arr3[ARRAY_SIZE] = {1,2,3,5};
    int arr4[ARRAY_SIZE] = {1,2,4,3};
    int arr5[ARRAY_SIZE] = {1,2,0,3};

    int * array_of_arrays[5] = {arr1, arr2, arr3, arr4, arr5};

    const int A_OF_A_LEN = COUNT(array_of_arrays);
    qsort(array_of_arrays, A_OF_A_LEN, sizeof(array_of_arrays[0]),
        compare_callback);

    /* Print the arrays */
    for (int i = 0; i < A_OF_A_LEN; ++i)
    {
        for (int j = 0; j < ARRAY_SIZE; ++j)
        {
            printf("Array[%d].elem[%d] = %d\n", i, j, array_of_arrays[i][j]);
        }
    }

    return 0;
}
