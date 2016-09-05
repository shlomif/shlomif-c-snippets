/*
 * Print the name of the executable (passed as argv[0]).
 *
 * License is the MIT/X11 license - http://opensource.org/licenses/MIT .
 * ( https://en.wikipedia.org/wiki/MIT_License ).
 */
#include <stdio.h>

int main(int argc, char * argv[])
{
    printf ("Usage: %s \n", argv[0]);

    return 0;
}
