/*
 * Copyright (c) 1996 Shlomi Fish ( https://www.shlomifish.org/ )
 * Author: Shlomi Fish ( https://www.shlomifish.org/ )
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <complex.h>
#define WITH_GRAPHICS 0
#if WITH_GRAPHICS
#include <graphics.h>
#endif
#include <stdint.h>
#include <stdio.h>

#if defined(__GNUC__)
#define GCC_UNUSED __attribute__((unused))
#else
#define GCC_UNUSED
#endif

typedef int_fast32_t my_int_type;
const my_int_type MAX_TEST = 82;
typedef long double coordtype;
typedef std::complex<coordtype> complextype;

static my_int_type mandelbrot_val(coordtype r, coordtype i)
{
    complextype z(0, 0), c(r, i);
    for (my_int_type a = 0; a < MAX_TEST; ++a)
    {
        z = z * z + c;
        if (norm(z) >= 4)
            return a;
    }
    return MAX_TEST;
}

typedef struct
{
    char filename[4000];
    my_int_type r_width;
    my_int_type i_height;
} mandelbrot_set_ret;

static inline void my_putpixel(FILE *const f, const my_int_type x GCC_UNUSED,
    const my_int_type y GCC_UNUSED, const int val)
{
    putc(val, f);
}

static void fix_extent(my_int_type *final_r, const my_int_type init_r,
    const my_int_type wanted_r_width)
{
    my_int_type r_width = *final_r - init_r + 1;
    while (r_width < wanted_r_width)
    {
        *final_r += wanted_r_width - r_width;
        r_width = *final_r - init_r + 1;
    }
}
static mandelbrot_set_ret mandelbrot_set(
    my_int_type x1, my_int_type y1, my_int_type x2, my_int_type y2)
{
    mandelbrot_set_ret ret;
    coordtype rdelta = 3.0L / (x2 - x1), idelta = 2.0L / (y2 - y1);
    my_int_type y = y1;
    const my_int_type init_r = 2 * (x1 - x2) / 3;
    my_int_type final_r = (x2 - x1) / 3;
    my_int_type final_i = (y2 - y1) / 2;
    const my_int_type wanted_r_width = x2 - x1 + 1;
    fix_extent(&final_r, init_r, wanted_r_width);
    const my_int_type init_i = ((y1 - y2) / 2);
    const my_int_type wanted_i_width = y2 - y1 + 1;
    fix_extent(&final_i, init_i, wanted_i_width);
    ret.r_width = wanted_r_width;
    ret.i_height = wanted_i_width;
    snprintf(ret.filename, 3000, "f_rw=%lu_iw=%lu.img",
        static_cast<unsigned long>(ret.r_width),
        static_cast<unsigned long>(ret.i_height));
    FILE *f = fopen(ret.filename, "wb");
    for (my_int_type i = init_i; i <= final_i; ++i)
    {
        my_int_type x = 0;
        for (my_int_type r = init_r; r <= final_r; ++r)
        {
            my_int_type a = mandelbrot_val(r * rdelta, i * idelta);
            a = a * 255 / MAX_TEST;
            my_putpixel(f, x++, y, static_cast<int>(a));
        }
        ++y;
    }
    fclose(f);
    return ret;
}

int main()
{
    // mandelbrot_set_ret ret = mandelbrot_set(0, 0, 10229, 7679);
    mandelbrot_set_ret ret = mandelbrot_set(0, 0, 1919, 1079);
    char command[5000];
    const char *const bitmap_filename = "mandel.pgm";
    snprintf(command, 4800, "gm convert -depth 8 -size %lux%lu+0 gray:%s %s",
        static_cast<unsigned long>(ret.r_width),
        static_cast<unsigned long>(ret.i_height), ret.filename,
        bitmap_filename);
    system(command);
    snprintf(command, 4800, "gwenview %s", bitmap_filename);
    system(command);
    return 0;
}
