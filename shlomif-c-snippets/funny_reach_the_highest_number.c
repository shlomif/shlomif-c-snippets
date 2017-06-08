/*
 * A funny troll came by the other day to freenode's ##programming channel
 * and asked why this program, which he wrote to reach the highest possible
 * number, didn't work. It is given here for your amusement.
 *
 * Taken from his link at https://pastebin.com/jVVNrfyL .
 * */
#include <stdio.h>

static int i = 0;

int main(void)
{
	printf("%d\n", i++);
	main();
}
