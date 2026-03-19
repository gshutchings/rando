from libc.stdint cimport uint64_t, uint8_t
from libc.math cimport log, sqrt, sin, cos
from time import perf_counter_ns # For seeding
from cpython.ref cimport PyObject
from libc.string cimport memcpy
from cpython.mem cimport PyMem_Malloc, PyMem_Free

cdef extern from "Python.h": # Deprecated in 3.13 for PyLong_AsNativeBytes
    object _PyLong_FromByteArray(
        const unsigned char* buf,
        size_t n,
        int little_endian,
        int is_signed
    )

### TODO:
# Vectorize all random number generation
# Clean up code (general I know)
# Get rid of def rand64() (I have no idea why it's still here)
# Add all the other random functions that the random module has


#*#**#*#*#*#*#*#*#*#*#*#*#* Important functions #*#**#*#*#*#*#*#*#*#*#*#*#*

def randoLAME():
    cdef:
        double r = _float1()
    return r
# ^^
# Still not sure which one is faster...
# vv
def rando(): # 12
    cdef: 
        double r = _float12() - 1.0
    return r

def getrandbits(uint64_t n_bits):  
    cdef Py_ssize_t n_bytes = (n_bits + 7) >> 3
    cdef Py_ssize_t n_words = n_bytes >> 3
    cdef Py_ssize_t rem_bytes = n_bytes & 7
    cdef uint64_t b
    cdef Py_ssize_t i
    cdef object result
    cdef uint8_t* buf

    buf = <uint8_t*> PyMem_Malloc(n_bytes)
    if buf == NULL:
        raise MemoryError()

    for i in range(n_words):
        b = _next64()
        memcpy(buf + (i << 3), &b, 8)
    
    if rem_bytes:
        b = _next64() >> ((~(n_bits - 1)) & 63)
        memcpy(buf + (n_words << 3), &b, rem_bytes)
    
    result = _PyLong_FromByteArray(buf, n_bytes, 1, 0)
    PyMem_Free(buf)
    return result

def gauss():
    global next_gauss
    if next_gauss == 1e9:
        return _gauss()
    ret = next_gauss
    next_gauss = 1e9
    return ret

def seed(uint64_t s):
    global state1, state2
    state1 = s
    state2 = s
    for _ in range(20):
        _next64()

def below(n):
    if n < 1:
        return 0
    n -= 1
    cdef int size = n.bit_length()
    cdef object x
    while True:
        x = getrandbits(size)
        if x <= n:
            return x

def randrange(a, b): # includes both -- random.rangrange()
    return a + below(b - a + 1)

def shuffle(list x):
    l = len(x)
    for i in range(len(x)):
        i2 = randrange(i, l - 1)
        x[i], x[i2] = x[i2], x[i]

#*#**#*#*#*#*#*#*#*#*#*#*#* Helper Functions #*#**#*#*#*#*#*#*#*#*#*#*#*

# TODO: put all this into a C file

cdef uint64_t rotl(uint64_t x, int a):
    return (x << a) | (x >> (64 - a))

cdef uint64_t _next64():
    # xoroshiro128++, until I create my own
    global state1, state2
    cdef uint64_t x = state1
    cdef uint64_t y = state2
    cdef uint64_t res = rotl(x + y, 17) + x
    y ^= x
    state1 = rotl(x, 49) ^ y ^ (y << 21)
    state2 = rotl(y, 28)
    return res

cdef double _float12():
    cdef uint64_t bits = ((_next64() >> 12) | 0x3FF0000000000000ULL)
    return (<double*>&bits)[0]

cdef double _float1():
    cdef uint64_t bits = _next64()
    return <double> bits * 5.42101086242752217003726400434970855712890625e-20 # 2^-64

def rand64():
    return _next64()

cdef double _gauss(): # box-muller transform
    cdef double u1 = _float12() * 6.28318530717958647
    cdef double u2 = _float12() - 1.0
    u2 = sqrt(-2.0 * log(u2)) # unnecessarily reuse variables
    next_gauss = u2 * sin(u1) # store second number
    return u2 * cos(u1)

cdef test_gauss(uint64_t n):
    cdef double _max = -1e9
    cdef uint64_t _ = n
    cdef double x
    while _ > 0:
        _ -= 1
        x = _gauss()
        if x > _max:
            _max = x
    return _max

def tg(uint64_t n):
    return test_gauss(n)

#*#**#*#*#*#*#*#*#*#*#*#*#* Global Variables #*#**#*#*#*#*#*#*#*#*#*#*#*

cdef double next_gauss = 1e9
cdef uint64_t state1 = 1
cdef uint64_t state2 = 1
seed(perf_counter_ns())

del perf_counter_ns # so you can't import them