import ctypes
import os
import sys
import time

sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

I, F, P = ctypes.c_int, ctypes.c_double, ctypes.c_void_p
old = ctypes.CDLL(os.path.abspath("scratch/liborig.so"))
old.probe_smooth.argtypes = [P, I, I, F, I, F, F, P, P, I, I]

rng = np.random.default_rng(0)
points = rng.normal(size=(20_000, 20))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 15, "euclidean", {}, False, None)
distances = np.ascontiguousarray(distances, dtype=np.float32)
n, width = distances.shape

sig = np.zeros(n, dtype=np.float32)
rho = np.zeros(n, dtype=np.float32)
old.probe_smooth(distances.ctypes.data, n, width, 15.0, 64, 1.0, 1.0,
                 sig.ctypes.data, rho.ctypes.data, 0, n)
us, ur = up.smooth_knn_dist(distances, 15.0)
ns, nr = mojo_umap.smooth_knn_dist(distances, 15.0)
print("HEAD sigma maxdiff vs upstream:", np.max(np.abs(sig.astype(np.float64) - us.astype(np.float64))))
print("HEAD rho   maxdiff vs upstream:", np.max(np.abs(rho.astype(np.float64) - ur.astype(np.float64))))
print("new  sigma bitexact:", np.array_equal(ns, us), " maxdiff:", np.max(np.abs(ns.astype(np.float64) - us.astype(np.float64))))
print("HEAD sigma sample:", sig[:5], " upstream:", us[:5])


def head_smooth(d, k):
    nn, ww = d.shape
    s = np.zeros(nn, dtype=np.float32)
    r = np.zeros(nn, dtype=np.float32)
    old.probe_smooth(d.ctypes.data, nn, ww, float(k), 64, 1.0, 1.0, s.ctypes.data, r.ctypes.data, 0, nn)
    return s, r


for name, fn in (("HEAD", lambda: head_smooth(distances, 15.0)),
                 ("new ", lambda: mojo_umap.smooth_knn_dist(distances, 15.0)),
                 ("ups ", lambda: up.smooth_knn_dist(distances, 15.0))):
    fn()
    t = time.perf_counter()
    fn()
    print(f"{name}: {(time.perf_counter()-t)*1e3:9.2f} ms  ({n} rows)")