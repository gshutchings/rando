import rando
import random
import statistics
import time

# TG values:
# 100:     2.5076, 0.4294
# 1000:    3.2414, 0.3514
# 10000:   3.8516, 0.3042
# 100000:  4.3843, 0.2719
# 1000000: 4.8631, 0.2477

for _ in range(10000000):
    1 + 2 + 3 + 4 + 5
t0 = time.perf_counter_ns()
for _ in range(50):
    rando.randobit(2147483647)
t1 = time.perf_counter_ns()
for _ in range(50):
    random.getrandbits(2147483647)
t2 = time.perf_counter_ns()

print(t1-t0)
print(t2-t1)