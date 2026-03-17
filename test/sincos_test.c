#include "math/gauss_sincos.c"
#include <math.h>
#include <stdio.h>

void print_bin(double t) {
    uint64_t x = * ((uint64_t*) &(t));
    for (int i = 0; i < 64; i++) {
        if (i == 12 || i == 1) {
            printf(" ");
        }
        if (((x << i) & (1ULL << 63)) == 0) {
            printf("0");
        } else {
            printf("1");
        }
    }
    printf("\n");
}

void print_bint(uint64_t t) {
    for (int i = 0; i < 64; i++) {
        if (i == 12 || i == 0) {
            printf(" ");
        }
        if (((t << i) & (1ULL << 63)) == 0) {
            printf("0");
        } else {
            printf("1");
        }
    }
    printf("\n");
}

int main() { 
    uint64_t x = 0xFE00000000000000;
    //           0x0200000000000000ULL;
    printf("%.17f\n", cos((double) (x) * (pow(2.0, -64.0)) * 2 * M_PI) - sincos_from64(x).c);
    return 0; /*
    uint64_t b = 0x1FA0000000000000;
    int z = __builtin_clzll(b);
    printf("%d\n", z);
    print_bint(b);
    double x = ((double) b) * pow(2.0, -64.0);
    print_bin(x + 1.0);
    print_bin(x);
    printf("%.17f\n", x);
    return 0;*/
}