import ctypes
import os
import subprocess
import sys
import time

sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

# Build the pre-optimization solver (HEAD) under a distinct symbol.
src = subprocess.run(
    ["git", "show", "HEAD:src/umap.mojo"], capture_output=True, text=True, check=True
).stdout
src = src.replace('@export("mum_smooth_knn_dist")', '@export("probe_smooth")')
open("scratch/orig.mojo", "w").write(src)
subprocess.run(
    ["pixi", "run", "mojo", "build", "--emit", "shared-lib",
     "scratch/orig.mojo", "-o", "scratch/liborig.so"],
    check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
)

I, F, P = ctypes.c_int, ctypes.c_double, ctypes.c_void_p
old = ctypes.CDLL(os.path.abspath("scratch/liborig.so"))
old.probe_smooth.argtypes = [P, I, I, F, I, F, F, P, P, I, I]


def head_smooth(d, k, n_iter=64, local_connectivity=1.0, bandwidth=1.0):
    n, width = d.shape
    sig = np.zeros(n, dtype=np.float32)
    rho = np.zeros(n, dtype=np.float32)
    old.probe_smooth(d.ctypes.data, n, width, float(k), n_iter,
                     local_connectivity, bandwidth,
                     sig.ctypes.data, rho.ctypes.data, 0, n)
    return sig, rho


rng = np.random.default_rng(0)
points = rng.normal(size=(250_000, 20))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 15, "euclidean", {}, False, None)
distances = np.ascontiguousarray(distances, dtype=np.float32)


def timeit(fn, repeat=7):
    best = math.inf
    for _ in range(repeat):
        t = time.perf_counter()
        fn()
        best = min(best, time.perf_counter() - t)
    return best


import math

head_s, head_r = head_smooth(distances, 15.0)
now_s, now_r = mojo_umap.smooth_knn_dist(distances, 15.0)
up_s, up_r = up.smooth_knn_dist(distances, 15.0)
print("sigma bitexact vs upstream: HEAD =", np.array_equal(head_s, up_s),
      " fixed =", np.array_equal(now_s, up_s))
print("rho   bitexact vs upstream: HEAD =", np.array_equal(head_r, up_r),
      " fixed =", np.array_equal(now_r, up_r))

t_head = timeit(lambda: head_smooth(distances, 15.0))
t_now = timeit(lambda: mojo_umap.smooth_knn_dist(distances, 15.0))
t_up = timeit(lambda: up.smooth_knn_dist(distances, 15.0))
print(f"HEAD (pre-optimization) : {t_head*1e3:9.2f} ms")
print(f"fixed (this change)     : {t_now*1e3:9.2f} ms   speedup vs HEAD = {t_head/t_now:.2f}x")
print(f"upstream numba          : {t_up*1e3:9.2f} ms   ratio = {t_up/t_now:.2f}x")