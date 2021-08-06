/*
 * The canonical Hello World program kept here to avoid code duplication
 *
 * License is the MIT/Expat license - http://opensource.org/licenses/MIT .
 * ( https://en.wikipedia.org/wiki/MIT_License ).
 */
#include <stdio.h>
#include <stdbool.h>
#include <math.h>

typedef long long myint;

static bool is_prime(const myint n)
{
    const myint max_i = (myint)(sqrtl(n) + 1);

    for (myint i = 2; i <= max_i; ++i)
    {
        if (0 == (n % i))
        {
            return false;
        }
    }
    return true;
}

int main(void)
{
    myint curr = 0, next = 1, temp;

    while (curr >= 0)
    {
        printf("%lld (%s)\n", curr, (is_prime(curr) ? "prime" : "not prime"));
        fflush(stdout);
        temp = next + curr;
        curr = next;
        next = temp;
    }

    return 0;
}
