#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

int setenv(const char * name, const char * value, int overwrite)
{
    FILE * f;
    f = fopen("/tmp/log_setenv.log", "a");
    fprintf(f, "PID=%i PROC=\"%s\" setenv \"%s\" \"%s\" (%i)\n", getpid(), getenv("_"), name, value, overwrite);
    fclose(f);
    
    return 0;
}
