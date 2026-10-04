import ctypes, os, sys, time
import numpy as np

lib = ctypes.CDLL(os.path.abspath("scratch/libprobe3.so"))
I = ctypes.c_int64
names = sys.argv[1:] or ["w_pad4", "w_pad8", "w_pad8_fill", "w_pad16"]
fns = {}
for name in names:
    f = getattr(lib, name)
    f.restype = None
    f.argtypes = [I, I, I, I, ctypes.c_float, I]
    fns[name] = f

rng = np.random.default_rng(0)
n, k = 250_000, 15
inc = rng.exponential(scale=0.2, size=(n, k - 1)).astype(np.float32)
distances = np.ascontiguousarray(
    np.column_stack([np.zeros(n, dtype=np.float32), np.cumsum(inc, axis=1)])
)
target = ctypes.c_float(np.log2(15.0))
scratch = np.zeros(64, dtype=np.float32)
res = {name: 1e9 for name in names}
for _ in range(12):
    for name in names:
        f = fns[name]
        f(distances.ctypes.data, scratch.ctypes.data, n, k, target, 64)
        t = time.perf_counter()
        f(distances.ctypes.data, scratch.ctypes.data, n, k, target, 64)
        res[name] = min(res[name], time.perf_counter() - t)
for name in names:
    print(f"{name}: {res[name]*1e3:.2f} ms")
