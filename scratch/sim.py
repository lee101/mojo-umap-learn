import sys, os
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

LOG2E32 = np.float32(1.4426950408889634)
EXP_FLOOR = np.float32(-1.0e30)
PAD = np.float32(1.0e30)
TOL = np.float32(1.0e-5)
F32MAX = np.float32(3.4028234663852886e38)


def bisect(delta, target, mode, n_iter=64, k=11):
    """delta: float64 array of length k (non-negative). mode selects psum arithmetic."""
    lo, hi, mid = np.float32(0.0), F32MAX, np.float32(1.0)
    d32 = delta.astype(np.float32)
    pad_to = (k + 7) // 8 * 8
    for _ in range(n_iter):
        if mode == "f32_exp":
            p = np.float32(0.0)
            for v in d32:
                p = np.float32(p + np.float32(np.exp(-np.float32(v / mid))))
        elif mode == "f32_exp2_pad":
            scratch = np.full(pad_to, PAD, dtype=np.float32)
            scratch[:k] = d32
            factor = np.float32(-LOG2E32 / mid)
            acc = np.zeros(pad_to, dtype=np.float32)
            for s in range(0, pad_to, 8):
                acc[s:s + 8] = np.exp2(np.maximum(scratch[s:s + 8] * factor, EXP_FLOOR))
            p = np.float32(np.sum(acc, dtype=np.float32))
        elif mode == "f64_exp":
            p = 0.0
            for v in delta:
                p = p + np.exp(-(v / np.float64(mid)))
        p = np.float32(p)
        if abs(np.float32(p - np.float32(target))) < TOL:
            break
        if p > np.float32(target):
            hi = mid
            mid = np.float32((lo + hi) / np.float32(2.0))
        else:
            lo = mid
            if hi >= F32MAX:
                mid = np.float32(mid * np.float32(2.0))
            else:
                mid = np.float32((lo + hi) / np.float32(2.0))
    return mid


points = np.random.RandomState(0).normal(size=(180, 10))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 12, "euclidean", {}, False, None)
rs, rr = up.smooth_knn_dist(distances, 12.0)
gs, gr = mojo_umap.smooth_knn_dist(distances, 12.0)
target = np.log2(12.0)

res = {}
for mode in ("f32_exp", "f32_exp2_pad", "f64_exp"):
    out = np.zeros(distances.shape[0], dtype=np.float32)
    for i in range(distances.shape[0]):
        d = distances[i].astype(np.float64)
        delta = np.maximum(d[1:] - rr[i], 0.0)
        out[i] = bisect(delta, target, mode)
    res[mode] = out
    print(f"{mode:16s} maxdiff vs upstream = {np.max(np.abs(out.astype(np.float64) - rs.astype(np.float64))):.6e}  exactmatch={np.array_equal(out, rs)}")
print(f"{'mojo .so':16s} maxdiff vs upstream = {np.max(np.abs(gs.astype(np.float64) - rs.astype(np.float64))):.6e}")