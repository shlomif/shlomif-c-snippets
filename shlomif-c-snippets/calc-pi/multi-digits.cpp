#include <malloc.h>
#include <string.h>
#include <stdio.h>

const int base = 10000;
typedef signed short multi_digit_t;

class MultiDigit
{
public:
    multi_digit_t * digits;
    int length;
public:
    MultiDigit();
    MultiDigit(MultiDigit &);
    MultiDigit(unsigned long long);
    ~MultiDigit()  { free(digits); }
    int from_number(unsigned long long number);
    void print(FILE *);
    void copy(MultiDigit & a);
    int from_string(char * s);
    int from_hexstring(char * s);
};

MultiDigit::MultiDigit()
{
    digits = (multi_digit_t*)malloc(sizeof(multi_digit_t)*1);
    digits[0] = 0;
    length = 1;
}

MultiDigit::MultiDigit(unsigned long long value)
{
    digits  = NULL;
    from_number(value);
}

MultiDigit::MultiDigit(MultiDigit & a)
{
    digits = NULL;
    copy(a);
}

void MultiDigit::copy(MultiDigit & a)
{
    length = a.length;
    digits = (multi_digit_t*)realloc(digits, a.length*sizeof(multi_digit_t));
    memcpy(digits, a.digits, a.length*sizeof(multi_digit_t));
}

int MultiDigit::from_number(unsigned long long number)
{
    int a;
    unsigned long long n = number;
    a=0;

    while (n > 0)
    {
        a++;
        n = n / base;
    }
    digits = (multi_digit_t*)realloc(digits, sizeof(multi_digit_t)*a);

    a=0;
    while (number > 0)
    {
        digits[a] = (multi_digit_t)(number % base);
        a++;
        number = number / base;
    }
    length = a;
    return 1;
}

void MultiDigit::print(FILE * f = stdout)
{
    int a;
    for(a=0;a<length;a++)
    {
        fprintf(f, (a==0)?"%i,":"%04i,", digits[length-a-1]);
    }
    printf("%s", "\n");
}

int multiply_multi_digit(MultiDigit & one, MultiDigit & two, MultiDigit * result);
int add_multi_digit(MultiDigit & one, MultiDigit & two, MultiDigit * result);

int MultiDigit::from_string(char * s)
{
    if (!strncmp(s,"0x",2))
    {
        // return from_hexstring(s+2);
    }
    else
    {
        MultiDigit d, accum2(0), ten(10);

        from_number(0);

        while (((*s) >= '0') && ((*s) <= '9'))
        {
            d.from_number(*s-'0');
            multiply_multi_digit(*(this), ten, &accum2);
            add_multi_digit(accum2, d, this);
        }
    }
}

int add_multi_digit(MultiDigit & one, MultiDigit & two, MultiDigit * result)
{
    int min_len, max_len, a, sum, which;
    if (one.length > two.length)
    {
        max_len = one.length;
        min_len = two.length;
        which = 0;
    }
    else
    {
        min_len = one.length;
        max_len = two.length;
        which = 1;
    }

    result->length = max_len+1;
    result->digits = (multi_digit_t*)realloc(result->digits, result->length*sizeof(multi_digit_t));
    for(a=0;a<max_len+1;a++)
    {
        result->digits[a] = 0;
    }
    for(a=0;a<min_len;a++)
    {
        sum = one.digits[a] + two.digits[a] + result->digits[a];
        result->digits[a] = sum % base;
        result->digits[a+1] = sum / base;
    }
    for(;a<max_len;a++)
    {
        if (which == 0)
        {
            sum = one.digits[a] + result->digits[a];
        }
        else
        {
            sum = two.digits[a] + result->digits[a];
        }
        result->digits[a] = sum % base;
        result->digits[a+1] = sum / base;
    }

    while (result->digits[result->length-1] == 0)
    {
        result->length--;
        if (result->length == 1)
            break;
    }
    result->digits = (multi_digit_t*)realloc(result->digits, result->length*sizeof(multi_digit_t));


    return 1;
}

int subtract_multi_digit(MultiDigit & one, MultiDigit & two, MultiDigit * result)
{
    int min_len, max_len, a, diff;
    if (one.length > two.length)
    {
        max_len = one.length;
        min_len = two.length;
    }
    else
    {
        min_len = one.length;
        max_len = two.length;
    }

    result->length = max_len;
    result->digits = (multi_digit_t*)realloc(result->digits, result->length*sizeof(multi_digit_t));
    for(a=0;a<max_len;a++)
    {
        result->digits[a] = 0;
    }
    for(a=0;a<max_len;a++)
    {
        diff = result->digits[a];
        if (one.length > a)
        {
            diff += one.digits[a];
        }
        if (two.length > a)
        {
            diff -= two.digits[a];
        }
        if (diff >= 0)
        {
            result->digits[a] = diff;
        }
        else
        {
            result->digits[a] = diff+base;
            result->digits[a+1] = -1;
        }
    }

    while (result->digits[result->length-1] == 0)
    {
        result->length--;
        if (result->length == 1)
            break;
    }
    result->digits = (multi_digit_t*)realloc(result->digits, result->length*sizeof(multi_digit_t));


    return 1;
}


int multiply_multi_digit(MultiDigit & one, MultiDigit & two, MultiDigit * result)
{
    int a,b,c, product;

    result->length = one.length+two.length;
    result->digits = (multi_digit_t*)realloc(result->digits, result->length*sizeof(multi_digit_t));
    for(a=0;a<result->length;a++)
    {
        result->digits[a]=0;
    }
    for(a=0;a<one.length;a++)
    {
        for(b=0;b<two.length;b++)
        {
            product = one.digits[a] * two.digits[b];
            result->digits[a+b] += product % base;
            for(c=a+b;result->digits[c]>=base;c++)
            {
                result->digits[c+1] += result->digits[c] / base;
                result->digits[c] %= base;
            }
            if ((product / base) > 0)
            {
                result->digits[a+b+1] += (product / base);
                for(c=a+b+1;result->digits[c]>=base;c++)
                {
                    result->digits[c+1] += (result->digits[c] / base);
                    result->digits[c] %= base;
                }
            }
        }
    }

    while (result->digits[result->length-1] == 0)
    {
        result->length--;
        if (result->length == 1)
            break;
    }
    result->digits = (multi_digit_t*)realloc(result->digits, result->length*sizeof(multi_digit_t));

    return 1;
}

#define max(a,b) ((a) > (b) ? (a) : (b))

int divide_multi_digit(MultiDigit & divide_, MultiDigit & div_by, MultiDigit * result)
{
    MultiDigit divide[2];
    int a, d_digit, db_digit, offset, multiply_by;
    int which=0;
    MultiDigit product;

    divide[which].copy(divide_);      // clone it because we are going to change it

    result->length = max(divide[which].length-div_by.length+1, 1);
    result->digits = (multi_digit_t*)realloc(result->digits, result->length*sizeof(multi_digit_t));
    for(a=0;a < result->length; a++)
    {
        result->digits[a] = 0;
    }

    d_digit = divide[which].length-1;
    db_digit = -1;
    for(a=div_by.length-1;a>=0;a--)
    {
        if (div_by.digits[a] > 0)
        {
            db_digit = a;
            break;
        }
    }
    if (db_digit == -1) // div_by equals to 0
    {
        return 0;
    }

    while (1)
    {
        // Check if the division can be ended
        for(a=d_digit, d_digit = -1;a>=0;a--)
        {
            if (divide[which].digits[a] > 0)
            {
                d_digit = a;
                break;
            }
        }

        if (db_digit > d_digit)
        {
            while (result->digits[result->length-1] == 0)
            {
                result->length--;
                if (result->length == 1)
                    break;
            }
            result->digits = (multi_digit_t*)realloc(result->digits, result->length*sizeof(multi_digit_t));


            return 1;
        }


        if (db_digit == d_digit)
        {
            for(a=d_digit;a>=0;a--)
            {
                if (div_by.digits[a] > divide[which].digits[a])
                {
                    while (result->digits[result->length-1] == 0)
                    {
                        result->length--;
                        if (result->length == 1)
                            break;
                    }
                    result->digits = (multi_digit_t*)realloc(result->digits, result->length*sizeof(multi_digit_t));

                    return 1;
                }
                else if (div_by.digits[a] < divide[which].digits[a])
                {
                    break;
                }
            }
        }


        for (a=0; a<=db_digit; a++)
        {
            if (divide[which].digits[d_digit-a] != div_by.digits[db_digit-a])
            {
                break;
            }
        }

        if (a == db_digit+1)
        {
            multiply_by = 1;
            offset = d_digit - db_digit;
        }
        else if (divide[which].digits[d_digit-a] > div_by.digits[db_digit-a])
        {
            offset = d_digit - db_digit;
            if (a>0)
            {
                multiply_by = 1;
            }
            else
            {
                int b = ((divide[which].digits[d_digit]*base + ((d_digit>0)?divide[which].digits[d_digit-1]:0)) /
                             (div_by.digits[db_digit]*base + ((db_digit>0)?div_by.digits[db_digit-1]:0)));
                multiply_by = (b>1)?(b-1):b;
            }
        }
        else
        {
            offset = d_digit - db_digit - 1;
            if (a>1)
            {
                multiply_by = base-1;
            }
            else
            {
                int b = (multi_digit_t) ((((long long)divide[which].digits[d_digit])*base*base + ((d_digit>0)?divide[which].digits[d_digit-1]:0)*base +  ((d_digit>1)?divide[which].digits[d_digit-1]:0)) /
                             (div_by.digits[db_digit]*base + ((db_digit>0)?div_by.digits[db_digit-1]:0)));
                multiply_by = (b>1)?(b-1):b;
            }
        }
        {
            MultiDigit m(multiply_by);
            multiply_multi_digit(div_by, m, &product);

            product.length += offset;
            product.digits = (multi_digit_t*)realloc(product.digits, sizeof(multi_digit_t)*product.length);
            memmove(product.digits+offset,product.digits,sizeof(multi_digit_t)*(product.length-offset));
            for(a=0;a<offset;a++)
            {
                product.digits[a] = 0;
            }
        }
        subtract_multi_digit(divide[which], product, &divide[1-which]);
        which = 1-which;
        result->digits[offset] += multiply_by;
        for(a=offset;result->digits[a]>=base;a++)
        {
            result->digits[a+1] += result->digits[a] / base;
            result->digits[a] %= base;
        }
    }
}

#if 0

int main()
{
    MultiDigit a(1390), b(49);
    MultiDigit c;

    divide_multi_digit(a,b,&c);
    c.print();

    return 0;
}

#endif

int main()
{
    MultiDigit numer(2), numer2, denom[2], item[2], pi, m, m2;
    item[0].from_number(2);
    denom[0].from_number(1);
    int which=0;
    int a;

    //for(a=1;a<=33250;a++)
    for(a=1;a<=3350;a++)
    {
        if (a % 100 == 0)
        {
            printf("%i\n", a);
        }
        m.from_number(2*a+1);
        multiply_multi_digit(denom[which], m, &denom[1-which]);
        m2.from_number(a);
        multiply_multi_digit(item[which], m2, &item[1-which]);
        multiply_multi_digit(numer, m, &numer2);
        add_multi_digit(item[1-which], numer2, &numer);
        which = 1-which;
    }

    int offset = 250;

    numer.length += offset;
    numer.digits = (multi_digit_t*)realloc(numer.digits, sizeof(multi_digit_t)*numer.length);
    memmove(numer.digits+offset,numer.digits,sizeof(multi_digit_t)*(numer.length-offset));
    for(a=0;a<offset;a++)
    {
        numer.digits[a] = 0;
    }

    divide_multi_digit(numer, denom[which], &pi);

    FILE * f = fopen("dump.txt", "w");

    printf("pi is ");
    pi.print();
    fprintf(f,"pi is ");
    pi.print(f);
    fclose(f);

    return 0;
}
