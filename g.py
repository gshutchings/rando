import rando
import matplotlib.pyplot as plt
import time
import random

n = 1000000

samples = [rando.gauss() for _ in range(n)]
# Plot histogram
plt.figure(figsize=(8, 5))
plt.hist(samples, bins=2000, density=True, alpha=0.7, color='steelblue')

plt.title("Histogram")
plt.xlabel("Value")
plt.ylabel("Density")

plt.show()