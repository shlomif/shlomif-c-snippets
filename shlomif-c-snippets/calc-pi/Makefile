MDIGITS_PROGS = mdigits-g mdigits-o mdigits-uno mdigits-oo
CXX = g++
CXXFLAGS = -Wall -Wextra

all: $(MDIGITS_PROGS)

mdigits-g: multi-digits.cpp
	$(CXX) $(CXXFLAGS) -g -o $@ $<

mdigits-uno: multi-digits.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

mdigits-o: multi-digits.cpp
	$(CXX) $(CXXFLAGS) -O3 -o $@ $<

mdigits-oo: multi-digits.cpp
	$(CXX) $(CXXFLAGS) -O2 -flto -fwhole-program -fomit-frame-pointer -march=native -o $@ $<

clean:
	rm -f $(MDIGITS_PROGS)
