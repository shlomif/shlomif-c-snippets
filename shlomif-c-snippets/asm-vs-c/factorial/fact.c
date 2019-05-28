/*
 * Calculate a large factorial and print it.
 *
 * License is the MIT/X11 license - http://opensource.org/licenses/MIT .
 * ( https://en.wikipedia.org/wiki/MIT_License ).
 */
#include <stdio.h>
#include <stdlib.h>

typedef unsigned myint;
myint num;
myint len;
myint * result;
myint i, r;

int main(int argc, char * argv[])
{

    num = atoi(argv[1]);
    result = malloc(sizeof(result[0]) * (num+1));

    len = 1;
    result[0] = 1;

    for ( i = 2 ; i <= num ; i++)
    {
        r = 0;
        for ( myint digit_idx = 0 ; digit_idx < len ; digit_idx++ )
        {
            r += result[digit_idx] * i;
            result[digit_idx] = r % 10000;
            r /= 10000;
        }
        while(r)
        {
            result[len++] = r % 10000;
            r /= 10000;
        }
    }

    /* Now let's print the result.
     * */

    printf("%d", result[len-1]);

    for (int digit_idx = len-2 ; digit_idx >= 0 ; digit_idx--)
    {
        printf("%04d", result[digit_idx]);
    }
    puts("");

    free(result);

    return 0;
}

