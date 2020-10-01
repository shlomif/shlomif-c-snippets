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
#include <stdio.h>

const int MAX_TEST = 82;
typedef long double coordtype;
typedef std::complex<coordtype> complextype;

static int mandelbrot_val(coordtype r, coordtype i)
{
    complextype z(0, 0), c(r, i);
    for (int a = 1; a <= MAX_TEST; a++)
    {
        z = z * z + c;
        if (norm(z) >= 4)
            return a;
    }
    return 0;
}
typedef struct
{
    char filename[4000];
    int r_width;
    int i_height;
} mandelbrot_set_ret;

static mandelbrot_set_ret mandelbrot_set(int x1, int y1, int x2, int y2)
{
    mandelbrot_set_ret ret;
    if (((x2 - x1) % 3 != 0) || ((y2 - y1) % 2 == 1) || (x2 - x1 < 10) ||
        (y2 - y1 < 10))
    {
        perror("foo");
        return ret;
    }
    coordtype rdelta = 3.0L / (x2 - x1), idelta = 2.0L / (y2 - y1);
#if WITH_GRAPHICS
    unsigned y = y1;
#endif
    const int init_r = 2 * (x1 - x2) / 3;
    const int final_r = (x2 - x1) / 3;
    const int final_i = (y2 - y1) / 2;
    const int r_width = final_r - init_r + 1;
    const int init_i = ((y1 - y2) / 2);
    const int i_width = final_i - init_i + 1;
    ret.r_width = r_width;
    ret.i_height = i_width;
    snprintf(ret.filename, 3000, "f_rw=%d_iw=%d.img", r_width, i_width);
    FILE *f = fopen(ret.filename, "wb");
    for (int i = init_i; i <= final_i; i++)
    {
        for (int r = init_r; r <= final_r; r++)
        {
            int a = mandelbrot_val(r * rdelta, i * idelta);
#if 0
            if (a)
            {
                a = (a >> 2) + 32;
            }
#else
            a = a * 255 / MAX_TEST;
#endif

#if WITH_GRAPHICS
            putpixel(x++, y, a);
#endif
            putc(a, f);
#ifdef DEBUG
            printf("pos = %ld\n", ftell(f));
#endif
        }
#if WITH_GRAPHICS
        y++;
#endif
    }
    fclose(f);
    return ret;
}

#if WITH_GRAPHICS
int return0() { return 0; }
#endif

int32_t main()
{
#if WITH_GRAPHICS
    int gi = installuserdriver("Svga256", return0), gm = 0; // SVGA1024x768x256;
    initgraph(&gi, &gm, "c:\\tc\\bgi");
#else
#endif
    mandelbrot_set_ret ret = mandelbrot_set(0, 0, 10230, 7680);
    char command[5000];
    const char *const bitmap_filename = "mandel.pgm";
    snprintf(command, 4800, "gm convert -depth 8 -size %dx%d+0 gray:%s %s",
        ret.r_width, ret.i_height, ret.filename, bitmap_filename);
    system(command);
    snprintf(command, 4800, "gwenview %s", bitmap_filename);
    system(command);
    return 0;
}
