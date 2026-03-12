from setuptools import setup
from Cython.Build import cythonize


setup(
    name="rando",
    ext_modules=cythonize(
        "rando.pyx",
        compiler_directives={'language_level': "3"}
    )
)