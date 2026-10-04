import sys, os
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

points = np.random.RandomState(0).normal(size=(180, 10))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 12, "euclidean", {}, False, None)
rs, rr = up.smooth_knn_dist(distances, 12.0)
gs, gr = mojo_umap.smooth_knn_dist(distances, 12.0)

bad = np.where(np.abs(gs.astype(np.float64) - rs.astype(np.float64)) > 1e-3)[0]
print("rows off by >1e-3:", len(bad), "of", len(rs))
i = int(bad[0]) if len(bad) else 0
print("row", i, "mojo", gs[i], "upstream", rs[i], "rho", gr[i], rr[i])
d = distances[i].astype(np.float32)
delta = np.maximum(d[1:] - gr[i], np.float32(0.0))
print("deltas:", delta)
target = np.log2(12.0)
lo, hi, mid = 0.0, 3.4028234663852886e38, 1.0
for it in range(64):
    p = 0.0
    for v in delta:
        p += np.exp(-(np.float64(v) / mid))
    if abs(p - target) < 1e-5:
        print(f"  it={it} mid={mid!r} psum={p!r} BREAK")
        break
    if p > target:
        hi = mid
        mid = (lo + hi) / 2.0
    else:
        lo = mid
        mid = (lo + hi) / 2.0
else:
    print("  no break, mid =", mid)

# what does the padding contribute for this row's converged mid?
LOG2E = 1.44269504088896340736
for m in (1.0, gs[i], 1e-20, 3.4028234663852886e38):
    f = -LOG2E / float(m)
    print(f"  mid={m:g} factor={f:g} pad*factor={1e45*f:g} exp2={np.exp2(1e45*f) if 1e45*f > -1075 else 0.0}")