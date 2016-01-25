/*
 * Basic malloc/free test used in e.g:
 *
 * https://github.com/gperftools/gperftools/issues/758 .
 *
 * */
#include <stdlib.h>

int main()
{
    void * buffer = malloc(100);
    free (buffer);

    return 0;
}
