import rando # type: ignore
import random
import statistics
import time
import math

# TG values:
# 100:     2.5076, 0.4294
# 1000:    3.2414, 0.3514
# 10000:   3.8516, 0.3042
# 100000:  4.3843, 0.2719
# 1000000: 4.8631, 0.2477

for _ in range(1000000):
    time.time()
    rando.experimental_gauss()
t0 = time.perf_counter_ns()
for _ in range(200000000):
    rando.experimental_gauss()
    rando.experimental_gauss()
    rando.experimental_gauss()
    rando.experimental_gauss()
    rando.experimental_gauss()
    rando.experimental_gauss()
    rando.experimental_gauss()
    rando.experimental_gauss()
    rando.experimental_gauss()
    rando.experimental_gauss()
t1 = time.perf_counter_ns()
for _ in range(200000000):
    rando.gauss()
    rando.gauss()
    rando.gauss()
    rando.gauss()
    rando.gauss()
    rando.gauss()
    rando.gauss()
    rando.gauss()
    rando.gauss()
    rando.gauss()
t2 = time.perf_counter_ns()
for _ in range(200000000):
    random.gauss()
    random.gauss()
    random.gauss()
    random.gauss()
    random.gauss()
    random.gauss()
    random.gauss()
    random.gauss()
    random.gauss()
    random.gauss()
t3 = time.perf_counter_ns()

print(t1-t0)
print(t2-t1)
print(t3-t2)