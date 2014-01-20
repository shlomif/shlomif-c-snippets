all: liblog_setenv.so

liblog_setenv.so: log_setenv.c
	gcc -shared -g -Wl,-soname,$@.1 -o $@ log_setenv.c
