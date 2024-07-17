//
// integer_increment_loop.c
// Copyright (C) 2024 Wulf < https://www.shlomifish.org/ >
//
// Distributed under the terms of the MIT license.
//

int main(void)
{
    volatile unsigned long a;
    for (a = 0; a < 10000000000UL; ++a)
        ;
}
