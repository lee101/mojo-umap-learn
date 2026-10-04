import sys, os
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
from scipy.spatial.distance import cdist
import mojo_umap
import umap.umap_ as up

def exact_sigma(distances, k, local_connectivity=1.0, bandwidth=1.0, n_iter=64):
    d = np.asarray(distances, dtype=np.float64)
    n, width = d.shape
    target = np.log2(k) * bandwidth
    sig = np.ones(n)
    rhos = np.zeros(n)
    for i in range(n):
        nz = d[i][d[i] > 0]
        if nz.size == 0:
            sig[i] = 0.0
            continue
        lc = int(np.floor(local_connectivity))
        if nz.size >= local_connectivity:
            interp = local_connectivity - lc
            if lc > 0:
                rho = nz[lc - 1]
                if interp > 1e-5 and lc < nz.size:
                    rho += interp * (nz[lc] - nz[lc - 1])
            else:
                rho = interp * nz[0]
        else:
            rho = nz[-1]
        rhos[i] = rho
        lo, hi, mid = 0.0, 3.4028234663852886e38, 1.0
        delta = np.maximum(d[i][1:] - rho, 0.0)
        for _ in range(n_iter):
            psum = float(np.exp(-delta / mid).sum())
            if abs(psum - target) < 1e-5:
                break
            if psum > target:
                hi = mid
                mid = (lo + hi) / 2.0
            else:
                lo = mid
                if hi >= 3.4028234663852886e38:
                    mid *= 2.0
                else:
                    mid = (lo + hi) / 2.0
        ms = 1e-3 * d[i].mean() if rho > 0 else 1e-3 * d.mean()
        sig[i] = max(mid, ms)
    return sig, rhos

random = np.random.default_rng(3)
points = random.normal(size=(180, 10))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 12, "euclidean", {}, False, None)
gs, gr = mojo_umap.smooth_knn_dist(distances, 12.0)
rs, rr = up.smooth_knn_dist(distances, 12.0)
es, er = exact_sigma(distances, 12.0)
print("upstream vs exact :", np.max(np.abs(rs - es)))
print("mojo     vs exact :", np.max(np.abs(gs - es)))
print("mojo     vs upstream:", np.max(np.abs(gs - rs)))
print("rho exact match mojo:", np.array_equal(gr, er))
