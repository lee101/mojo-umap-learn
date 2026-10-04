import sys, os
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

rng = np.random.default_rng(3)
points = rng.normal(size=(180, 10))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 12, "euclidean", {}, False, None)
gs, gr = mojo_umap.smooth_knn_dist(distances, 12.0)
rs, rr = up.smooth_knn_dist(distances, 12.0)
bad = np.argsort(-np.abs(gs - rs))[:3]
for i in bad:
    print("row", i, "mojo", gs[i], "up", rs[i], "diff", gs[i] - rs[i])
    d = distances[i].astype(np.float64)
    rho = float(gr[i])
    delta = np.maximum(d[1:] - rho, 0.0)
    target = np.log2(12.0)
    lo, hi, mid = 0.0, 3.4028234663852886e38, 1.0
    trace = []
    for it in range(64):
        p = float(np.exp(-delta / mid).sum())
        trace.append((it, mid, p))
        if abs(p - target) < 1e-5:
            break
        if p > target:
            hi = mid; mid = (lo + hi) / 2.0
        else:
            lo = mid
            if hi >= 3.4028234663852886e38: mid *= 2.0
            else: mid = (lo + hi) / 2.0
    for t in trace[-4:]:
        print("   ", t, "err", abs(t[2]-target))
