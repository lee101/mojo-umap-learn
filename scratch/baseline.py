import ctypes
import os
import subprocess
import sys

sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

src = subprocess.run(["git", "show", "HEAD:src/umap.mojo"], capture_output=True, text=True, check=True).stdout
# keep only the CPU solver, rename so it exports a distinct symbol
src = src.replace('@export("mum_smooth_knn_dist")', '@export("probe_smooth")')
open("scratch/orig.mojo", "w").write(src)
subprocess.run(["mojo", "build", "--emit", "shared-lib", "scratch/orig.mojo", "-o", "scratch/liborig.so"], check=True, cwd=os.getcwd())

lib = ctypes.CDLL(os.path.abspath("scratch/liborig.so"))
I, F = ctypes.c_int, ctypes.c_double
lib.probe_smooth.argtypes = [ctypes.c_void_p, I, I, F, I, F, F, ctypes.c_void_p, ctypes.c_void_p, I, I]


def orig_smooth(distances, k, n_iter=64, local_connectivity=1.0, bandwidth=1.0):
    n, width = distances.shape
    sig = np.zeros(n, dtype=np.float32)
    rho = np.zeros(n, dtype=np.float32)
    lib.probe_smooth(distances.ctypes.data, n, width, float(k), n_iter, local_connectivity, bandwidth,
                     sig.ctypes.data, rho.ctypes.data, 0, n)
    return sig, rho


points = np.random.RandomState(0).normal(size=(180, 10))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 12, "euclidean", {}, False, None)
rs, rr = up.smooth_knn_dist(distances, 12.0)
osig, orho = orig_smooth(distances, 12.0)
nsig, nrho = mojo_umap.smooth_knn_dist(distances, 12.0)
print("HEAD mojo sigma maxdiff vs upstream:", np.max(np.abs(osig.astype(np.float64) - rs.astype(np.float64))), "bitexact:", np.array_equal(osig, rs))
print("HEAD mojo rho   maxdiff vs upstream:", np.max(np.abs(orho.astype(np.float64) - rr.astype(np.float64))))
print("new  mojo sigma maxdiff vs upstream:", np.max(np.abs(nsig.astype(np.float64) - rs.astype(np.float64))), "bitexact:", np.array_equal(nsig, rs))
print("sigma ~ magnitude:", rs[:5])