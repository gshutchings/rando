from fast cimport sincos
from rando.rando cimport state1, state2, next_gauss
from rando.rando cimport _next64, _float12
from rando.rando import getrandbits
from libc.math cimport sqrt, log
from libc.stdint cimport uint64_t

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

def shortshuffle(list x):
    cdef object _sentinel = object()
    cdef Py_ssize_t l = len(x)
    if l > 16:
        return
    cdef uint64_t bits = _next64()
    r = [_sentinel] * 16
    cdef int i, b
    for i in range(l):
        r[i] = x[i] # r is now x.extend([_sentinel] * (padding))
    for i in range(l):
        b = bits & 15
        bits >>= 2
        r[i], r[b] = r[b], r[i]
    b = 0
    for i in range(16):
        if r[i] is _sentinel:
            continue
        x[b] = r[i]
        b += 1
