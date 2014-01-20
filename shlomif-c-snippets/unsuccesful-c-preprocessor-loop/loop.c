printf("Hello world!\n");
#if NUM_TIMES > 0
#define TEMP_NUM_TIMES (NUM_TIMES-1)
#define NUM_TIMES TEMP_NUM_TIMES
printf("%i\n", NUM_TIMES);
#include "loop.c"
#endif

