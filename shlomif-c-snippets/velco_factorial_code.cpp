/*
 * This C++ program by velco (= his IRC nickname) implements a factorial
 * function in C++ templates. It demonstrates how one line of code can take
 * O(i) to compile where i is a constant in the code.
 *
 * License is unknown.
 *
 * */
template< unsigned n > struct factorial
{
    static const unsigned value = n * factorial<n-1>::value;
};

template<> struct factorial<0>
{
    static const unsigned value = 1;
};

int main(int argc, char * argv[])
{
    factorial<100> hello;
}
