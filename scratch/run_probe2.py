import ctypes, os, sys, time
import numpy as np

lib = ctypes.CDLL(os.path.abspath("scratch/libprobe2.so"))
I = ctypes.c_int64
PAD = {}
for name in ("v_base", "v_exp2", "v_pad", "v_pad8"):
    f = getattr(lib, name)
    f.restype = None
    if name in ("v_pad", "v_pad8"):
        f.argtypes = [I, I, I, I, ctypes.c_float, I]
        PAD[name] = f
    else:
        f.argtypes = [I, I, I, ctypes.c_float, I]
        PAD[name] = f

rng = np.random.default_rng(0)
n, k = 250_000, 15
inc = rng.exponential(scale=0.2, size=(n, k - 1)).astype(np.float32)
distances = np.ascontiguousarray(
    np.column_stack([np.zeros(n, dtype=np.float32), np.cumsum(inc, axis=1)])
)
target = ctypes.c_float(np.log2(15.0))

names = sys.argv[1:] or ["v_base", "v_exp2", "v_pad", "v_pad8"]
res = {name: 1e9 for name in names}
for _ in range(6):
    for name in names:
        f = PAD[name]
        if name in ("v_pad", "v_pad8"):
            scratch = np.zeros(32, dtype=np.float32)
            f(distances.ctypes.data, scratch.ctypes.data, n, k, target, 64)
            t = time.perf_counter()
            f(distances.ctypes.data, scratch.ctypes.data, n, k, target, 64)
        else:
            f(distances.ctypes.data, n, k, target, 64)
            t = time.perf_counter()
            f(distances.ctypes.data, n, k, target, 64)
        res[name] = min(res[name], time.perf_counter() - t)
for name in names:
    print(f"{name}: {res[name]*1e3:.2f} ms")