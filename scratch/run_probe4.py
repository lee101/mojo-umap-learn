import ctypes, os, sys, time
import numpy as np

lib = ctypes.CDLL(os.path.abspath("scratch/libprobe4.so"))
I = ctypes.c_int64
names = sys.argv[1:] or ["a_f32w8", "c_f64"]
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
out = np.zeros(n, dtype=np.float32)
res = {name: 1e9 for name in names}
for _ in range(10):
    for name in names:
        f = fns[name]
        dt = np.float64 if name == "c_f64" else np.float32
        scratch = np.zeros(64, dtype=dt)
        f(distances.ctypes.data, scratch.ctypes.data, n, k, target, 64)
        t = time.perf_counter()
        f(distances.ctypes.data, scratch.ctypes.data, n, k, target, 64)
        res[name] = min(res[name], time.perf_counter() - t)
for name in names:
    print(f"{name}: {res[name]*1e3:.2f} ms")
