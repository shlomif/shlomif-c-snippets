MDIGITS_PROGS  = mdigits-g mdigits-o mdigits-uno mdigits-oo

all: $(MDIGITS_PROGS)

mdigits-g: multi-digits.cpp
	g++ -g -o $@ $<

mdigits-uno: multi-digits.cpp
	g++ -o $@ $<

mdigits-o: multi-digits.cpp
	g++ -O3 -o $@ $<

mdigits-oo: multi-digits.cpp
	g++ -O2 -flto -fwhole-program -fomit-frame-pointer -march=native -o $@ $<

# mdigits-pentium: multi-digits.cpp
# 	g++ -O9 -mpentium -o $@ $<

clean:
	rm -f $(MDIGITS_PROGS)
