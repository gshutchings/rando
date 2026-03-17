from fast cimport sincos
from rando.rando cimport state1, state2, next_gauss
from rando.rando cimport _next64, _float12
from libc.math cimport sqrt, log

cdef double _gauss():
    cdef sincos.SinCos_Pair x = sincos.sincos_from64(_next64())
    cdef double common = sqrt(-2.0 * log(_float12() - 1.0))
    next_gauss = common * x.s
    return common * x.c

def gauss():
    global next_gauss
    if next_gauss == 1e9:
        return _gauss()
    cdef double r = next_gauss
    next_gauss = 1e9
    return r