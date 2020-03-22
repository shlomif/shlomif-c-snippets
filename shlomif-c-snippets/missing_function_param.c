/*
 * test.c
 * Copyright (C) 2020 Shlomi Fish <shlomif@cpan.org>
 *
 * Distributed under terms of the MIT license.
 */

#include <stdio.h>

int fun(int x, int y)
{
    printf("%d,%d\n", x, y);
    return 0;
}

int main(int argc, char const *argv[])
{
    fun(3);
    return 0;
}
