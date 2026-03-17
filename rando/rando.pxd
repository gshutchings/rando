from libc.stdint cimport uint64_t
cdef public uint64_t state1
cdef public uint64_t state2
cdef public double next_gauss

cdef uint64_t _next64()

cdef double _float12()