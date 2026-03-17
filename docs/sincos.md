# How the SinCos algorithm works

The goal is to sacrifice the reliability and perfect accuracy of 
the standard library's implementation of sin and cos for raw speed. 

The algorithm uses sin(a+rem) = sin(a)cos(rem) + cos(a)sin(rem), where a 
is a value stored in a lookup table and rem is a small remainder, whose 
sin and cos values can be calculated efficiently with a Taylor polynomial. 

After initializing the return value, we get the nearest table value to x 
using `table_index = (x + 0x0200000000000000) >> 58`, which is functionally 
the same as round(x) = floor(x + .5), just on a larger scale. 

We then (unsafely) make x into a IEEE754 double from 1 to 2, and do the same 
with table_index to get the remainder, which is between -1/128 and 1/128. 

We finally compute the sin and cos of rem, and use the formula to get a 
good approximation of sin(x) and cos(x). 

As implemented now, the average error seems to be about 10^-15, while its 
execution seems to be about 2x faster. 

In the future I will make this faster by increasing the size of the lookup 
table and reducing the number of approximation terms. 