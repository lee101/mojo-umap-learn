import sys, os
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

LOG2E64 = 1.44269504088896340736
PAD64 = 1.0e45
TOL = 1.0e-5
NPY_FLOATMAX = 3.4028234663852886e38


def bisect(delta32, target, use_factor, pad_mode, k_width):
    """delta32: float32 non-negative deltas, length k_width-1."""
    k = k_width - 1
    lo, hi, mid = np.float32(0.0), np.float32(NPY_FLOATMAX), np.float32(1.0)
    if pad_mode == "big":
        scratch = np.full((k + 7) // 8 * 8, PAD64, dtype=np.float64)
        scratch[:k] = delta32
        pmask = None
    else:
        scratch = np.zeros((k + 7) // 8 * 8, dtype=np.float64)
        scratch[:k] = delta32
        pmask = (np.arange((k + 7) // 8 * 8) < k).astype(np.float64)
    for _ in range(64):
        if use_factor:
            factor = -LOG2E64 / np.float64(mid)
            acc = np.zeros_like(scratch)
            for s in range(0, scratch.size, 8):
                acc[s:s + 8] = np.exp2(scratch[s:s + 8] * factor)
            if pmask is not None:
                acc *= pmask
            p = acc.sum()
        else:
            p = 0.0
            for v in delta32:
                p += np.exp(-(np.float64(v) / np.float64(mid)))
        if abs(p - target) < TOL:
            break
        if p > target:
            hi = mid
            mid = np.float32((lo + hi) / np.float32(2.0))
        else:
            lo = mid
            if hi >= np.float32(NPY_FLOATMAX):
                mid = np.float32(mid * np.float32(2.0))
            else:
                mid = np.float32((lo + hi) / np.float32(2.0))
    return np.float32(mid)


points = np.random.RandomState(0).normal(size=(180, 10))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 12, "euclidean", {}, False, None)
rs, rr = up.smooth_knn_dist(distances, 12.0)
target = np.float64(np.log2(12.0))

for use_factor in (False, True):
    for pad_mode in ("big", "mask"):
        for kw in (12, 5, 15, 16, 17, 31, 2):
            out = np.zeros(distances.shape[0], dtype=np.float32)
            for i in range(distances.shape[0]):
                d = distances[i][:kw].astype(np.float32)
                delta = np.maximum(d[1:] - rr[i], np.float32(0.0))
                out[i] = bisect(delta, target, use_factor, pad_mode, kw)
            ok = np.array_equal(out, rs)
            diff = np.max(np.abs(out.astype(np.float64) - rs.astype(np.float64)))
            print(f"factor={use_factor!s:5s} pad={pad_mode:4s} k={kw:3d} bitexact={ok!s:5s} maxdiff={diff:.3e}")