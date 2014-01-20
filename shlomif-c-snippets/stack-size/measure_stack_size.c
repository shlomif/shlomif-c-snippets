/* A program to help estimate the amount of available stack for your C
 * program.
 *
 * Written by Shlomi Fish and made available under the MIT/X11 licence
 * (see https://en.wikipedia.org/wiki/MIT_License ).
 *
 * */
#include <stdio.h>

void myfunc(int c)
{
	c++;
	if (c % 1024*16 == 0)
	{
		printf("c=%d\n",c);
		fflush(stdout);
	}
	myfunc(c);
}

int main()
{
	myfunc(0);

	return 0;
}

