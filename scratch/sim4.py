import sys, os
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

LOG2E64 = 1.44269504088896340736
TOL = 1.0e-5
FMAX = np.float32(3.4028234663852886e38)


def psum_div(d32, mid):
    p = 0.0
    for v in d32:
        p += np.exp(-(np.float64(v) / np.float64(mid)))
    return p


def psum_exp2(d64, mid, pad):
    factor = -LOG2E64 / np.float64(mid)
    scratch = np.full((d64.size + 7) // 8 * 8, pad, dtype=np.float64)
    scratch[: d64.size] = d64
    acc = np.zeros_like(scratch)
    for s in range(0, scratch.size, 8):
        acc[s:s + 8] = np.exp2(scratch[s:s + 8] * factor)
    return acc.sum()


# --- 1. does exp2+factor reproduce the reference psum bit-exactly? ---
points = np.random.RandomState(0).normal(size=(180, 10))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 12, "euclidean", {}, False, None)
rs, rr = up.smooth_knn_dist(distances, 12.0)
target = np.float64(np.log2(12.0))

worst = 0.0
exact = True
for i in range(distances.shape[0]):
    d32 = np.maximum(distances[i][1:].astype(np.float32) - rr[i], np.float32(0.0))
    for mid in (0.5, 0.75, 1.0, 1.3, 2.0, 3.7, 8.0, 0.25, 0.1, 1e-6, 1e6):
        a = psum_div(d32, np.float32(mid))
        b = psum_exp2(d32.astype(np.float64), np.float32(mid), 1.0e45)
        if a != b:
            exact = False
            worst = max(worst, abs(a - b))
print(f"psum exp2(factor) vs exp(div): bitexact={exact} worst_ulp_diff={worst:.3e}")

# --- 2. padding lanes must contribute exactly 0 across the whole mid range ---
bad = []
for mid in (1e-20, 1e-6, 1.0, 1e6, 3.4028234663852886e38):
    s = psum_exp2(np.array([1.0, 2.0], dtype=np.float64), np.float32(mid), 1.0e45) - (
        np.exp2(-LOG2E64 / np.float64(np.float32(mid)) * 1.0)
        + np.exp2(-LOG2E64 / np.float64(np.float32(mid)) * 2.0)
    )
    if s != 0.0:
        bad.append((mid, s))
print("pad lanes nonzero at:", bad if bad else "none (exact 0 across mid range)")