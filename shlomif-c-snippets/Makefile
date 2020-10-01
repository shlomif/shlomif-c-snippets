#
# Makefile
# Shlomi Fish, 2020-10-01 12:51
#

all:

mandel.exe: mandelbrot_set_render.cpp
	# g++ -O3 -march=native -fwhole-program -flto -Wall -Wextra -o $@ $<
	clang++ -O3 -march=native -flto -Weverything -o $@ $<

clean:
	rm -f mandel.exe

reformat:
	clang-format -i mandelbrot_set_render.cpp

rebuild: clean reformat mandel.exe

run: rebuild
	./mandel.exe

# vim:ft=make
#
