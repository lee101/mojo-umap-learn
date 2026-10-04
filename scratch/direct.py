import sys, os
sys.path.insert(0, os.path.abspath("python"))
import ctypes
import numpy as np
import mojo_umap
from mojo_umap import _lib

lib = _lib.lib()
d = np.array([[0.0, 2.0, 2.1, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0, 3.05, 3.1, 3.15]], dtype=np.float32)
n, width = d.shape
scratch = np.zeros(16, dtype=np.float64)
sig = np.zeros(n, dtype=np.float32)
rho = np.zeros(n, dtype=np.float32)
lib.mum_smooth_knn_dist(
    d.ctypes.data, scratch.ctypes.data, n, width, 12.0, 64, 1.0, 1.0,
    sig.ctypes.data, rho.ctypes.data, 0, n,
)
print("rho   :", rho)
print("sigma :", sig, " (1e-3*row_mean/12 =", 1e-3 * d[0].mean() / 12, ")")
print("scratch:", scratch)
print("expected deltas rho=%.4f:" % rho[0], np.maximum(d[0][1:] - rho[0], 0))

# Now the same via the public wrapper
sig2, rho2 = mojo_umap.smooth_knn_dist(d, 12.0)
print("wrapper sigma:", sig2, "rho:", rho2)