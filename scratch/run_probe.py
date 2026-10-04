import ctypes, os, sys, time
import numpy as np

lib = ctypes.CDLL(os.path.abspath("scratch/libprobe.so"))
I = ctypes.c_int64
for name in ("probe_exp", "probe_exp2", "probe_serial"):
    f = getattr(lib, name)
    f.argtypes = [I, I, I, ctypes.c_float, I]
    f.restype = None

rng = np.random.default_rng(0)
n, k = 250_000, 15
inc = rng.exponential(scale=0.2, size=(n, k - 1)).astype(np.float32)
distances = np.ascontiguousarray(
    np.column_stack([np.zeros(n, dtype=np.float32), np.cumsum(inc, axis=1)])
)
target = ctypes.c_float(np.log2(15.0))

names = sys.argv[1:] or ["probe_exp", "probe_exp2", "probe_serial"]
res = {}
for name in names:
    f = getattr(lib, name)
    f(distances.ctypes.data, n, k, target, 64)
    best = 1e9
    for _ in range(3):
        t = time.perf_counter()
        f(distances.ctypes.data, n, k, target, 64)
        best = min(best, time.perf_counter() - t)
    res[name] = best
    print(f"{name}: {best*1e3:.2f} ms")