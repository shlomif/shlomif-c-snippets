#
# Makefile
# Shlomi Fish, 2020-10-01 12:51
#

all:

mandel.exe: mandelbrot_set_render.cpp
	g++ `pkg-config apr-1 --cflags --libs` -O3 -march=native -fwhole-program -flto -Wall -Wextra -o $@ $<
	# clang++ `pkg-config apr-1 --cflags --libs` -O3 -march=native -flto -Weverything -o $@ $<

clean:
	rm -f mandel.exe

fibonacci_primes.exe: fibonacci_primes.c Makefile
	# gcc -O3 -march=native -flto -Wall -Wextra -o $@ $< -lm
	gcc -g -Wall -Wextra -o $@ $< -lm
	gcc -O3 -o $@ $< -lm
	# clang -O3 -march=native -flto -Weverything -o $@ $< -lm

reformat:
	clang-format -i mandelbrot_set_render.cpp

rebuild: clean reformat mandel.exe

run: rebuild
	./mandel.exe --width 1920 --height 1080

# vim:ft=make
#
