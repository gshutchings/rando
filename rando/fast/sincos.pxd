cdef extern from "math/gauss_sincos.h":
    ctypedef struct SinCos_Pair:
        double s
        double c
    
    SinCos_Pair sincos_from64(unsigned long long x)