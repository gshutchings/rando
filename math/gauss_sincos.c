#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "gauss_sincos.h"

static const double SINTABLE[64] = { // precomputed values of sin
    0.0,                // SINTABLE[i] = sin(i / 64* 2 * pi) for 0 <= i < 64
    0.0980171403295606, // There are obviously repeats and I could shrink the
    0.19509032201612825,// table but that would add some complexity to sincos
    0.29028467725446233,
    0.3826834323650898,
    0.47139673682599764,
    0.5555702330196022,
    0.6343932841636455,
    0.7071067811865475,
    0.773010453362737,
    0.8314696123025452,
    0.8819212643483549,
    0.9238795325112867,
    0.9569403357322088,
    0.9807852804032304,
    0.9951847266721968,
    1.0,
    0.9951847266721969,
    0.9807852804032304,
    0.9569403357322089,
    0.9238795325112867,
    0.881921264348355,
    0.8314696123025453,
    0.7730104533627371,
    0.7071067811865476,
    0.6343932841636455,
    0.5555702330196022,
    0.47139673682599786,
    0.3826834323650899,
    0.2902846772544624,
    0.1950903220161286,
    0.09801714032956083,
    0.0,
    -0.09801714032956059,
    -0.19509032201612836,
    -0.2902846772544621,
    -0.38268343236508967,
    -0.47139673682599764,
    -0.555570233019602,
    -0.6343932841636453,
    -0.7071067811865475,
    -0.7730104533627367,
    -0.8314696123025452,
    -0.8819212643483549,
    -0.9238795325112865,
    -0.9569403357322088,
    -0.9807852804032303,
    -0.9951847266721969,
    -1.0,
    -0.9951847266721969,
    -0.9807852804032304,
    -0.9569403357322089,
    -0.9238795325112866,
    -0.881921264348355,
    -0.8314696123025455,
    -0.7730104533627369,
    -0.7071067811865477,
    -0.6343932841636459,
    -0.5555702330196022,
    -0.471396736825998,
    -0.3826834323650904,
    -0.2902846772544625,
    -0.19509032201612872,
    -0.0980171403295605,
};

#ifdef DEBUG
#define debug_printf printf
#else
#define debug_printf(...)
#endif

SinCos_Pair sincos_from64(uint64_t x) { // Takes a 64-bit unsigned integer x and returns sin and cos of (2pi * x / 2**64)
   SinCos_Pair ret;
   uint64_t table_index = (x + 0x0200000000000000) >> 58; // round to nearest table value
   double table_sin = SINTABLE[table_index];
   double table_cos = SINTABLE[(16 - table_index) & 63];
   x = ((x >> 12) | 0x3FF0000000000000ULL); // IEEE754 of 1 + x * (2 ** -64)
   // -1/128 <= rem < 1/128
   double rem =                 \
   *((double*)&(uint64_t){x}) - \
   *((double*)&(uint64_t){(((x)) + 0x0000200000000000ULL) & 0x7FFFC00000000000ULL});

   double rem_squared = rem * rem;
   double sin_rem = rem * (S1 + rem_squared * (S3 + rem_squared * (S5 + rem_squared * (S7))));
   double cos_rem = 1 + rem_squared * (C2 + rem_squared * (C4 + rem_squared * (C6)));;
   ret.s = table_sin * cos_rem + table_cos * sin_rem;
   ret.c = table_cos * cos_rem - table_sin * sin_rem;
   debug_printf("SINCOS value: %.17f", *(double*)(&x));
   debug_printf("\nSINCOS rem PART1: %.17f", *((double*)&(uint64_t){x}));
   debug_printf("\nSINCOS rem PART2: %.17f", *((double*)&(uint64_t){(((x)) + 0x0000200000000000ULL) & 0x7FFFC00000000000ULL}));
   debug_printf("\nSINCOS rem: %.17f", rem);
   debug_printf("\nSINCOS sin_rem: %.17f", sin_rem);
   debug_printf("\nSINCOS table_index: %llu", table_index);
   debug_printf("\nSINCOS table_sin: %.17f", table_sin);
   debug_printf("\nSINCOS table_cos: %.17f", table_cos);
   debug_printf("\n");
   return ret;
}

