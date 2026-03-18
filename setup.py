from setuptools import setup, Extension
from Cython.Build import cythonize

extensions = [
    Extension(
        name="rando.rando",
        sources=[
            "rando/rando.pyx",
        ],
        include_dirs=[
            "math",
            "rando"
        ],
        extra_compile_args=["-O3"]
    ),
    Extension(
        name="rando.fast.rando",
        sources=[
            "rando/fast/rando.pyx",
            "math/gauss_sincos.c"
        ],
        include_dirs=[
            ".",
            "math"
        ],
        extra_compile_args=["-O3", "-mcpu=apple-m2"]
    )
]

setup(
    name="rando",
    version="0.1.1",
    packages=["rando", "rando.fast"],
    ext_modules=cythonize(
        extensions,
        compiler_directives={'language_level': "3"},
        include_path=["rando"]
    )
)