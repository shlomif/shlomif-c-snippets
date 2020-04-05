/*
 * Demonstrate tree recursion
 *
 * License is the MIT/Expat license - http://opensource.org/licenses/MIT .
 * ( https://en.wikipedia.org/wiki/MIT_License ).
 */
#include <stdio.h>

typedef int myint;

static char int2letter(const myint idx)
{
    return "abcdefghijklmnopqrstuvwxyz"[idx];
}

static void recurse(
    myint *const indices, const myint max_len, const myint reached)
{
    if (reached == max_len)
    {
        for (myint i = 0; i < reached; ++i)
        {
            printf("%c", int2letter(indices[i]));
        }
        printf("\n");
        return;
    }
    for (myint i = 0; i < 10; ++i)
    {
        indices[reached] = i;
        recurse(indices, max_len, reached + 1);
    }
}

int main(void)
{
    myint stack[10];
    recurse(stack, 4, 0);

    return 0;
}
