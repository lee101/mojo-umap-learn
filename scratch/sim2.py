import sys, os
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

LOG2E32 = np.float32(1.4426950408889634)
LOG2E64 = 1.44269504088896340736
PAD = np.float32(1.0e30)
EXP_FLOOR = np.float32(-1.0e30)
TOL = 1.0e-5
NPY_FLOATMAX = 3.4028234663852886e38


def bisect(delta32, target, mid64, psum64, pad_mode, n_iter=64):
    """delta32: float32 non-negative deltas (numba keeps d in float32).
    mid64/psum64 select float64 bisection state / accumulator."""
    k = delta32.size
    pad_to = (k + 7) // 8 * 8
    lo = 0.0 if mid64 else np.float32(0.0)
    hi = NPY_FLOATMAX if mid64 else np.float32(NPY_FLOATMAX)
    mid = 1.0 if mid64 else np.float32(1.0)
    for _ in range(n_iter):
        if psum64:
            p = 0.0
            for v in delta32:
                p += np.exp(-(np.float64(v) / mid))
        else:
            scratch = np.full(pad_to, PAD, dtype=np.float32)
            scratch[:k] = delta32
            factor = np.float32(-LOG2E32 / np.float32(mid))
            acc = np.zeros(pad_to, dtype=np.float32)
            for s in range(0, pad_to, 8):
                acc[s:s + 8] = np.exp2(np.maximum(scratch[s:s + 8] * factor, EXP_FLOOR))
            p = np.float32(np.sum(acc, dtype=np.float32))
        if abs(p - target) < TOL:
            break
        if p > target:
            hi = mid
            mid = (lo + hi) / 2.0
        else:
            lo = mid
            if hi >= NPY_FLOATMAX:
                mid *= 2
            else:
                mid = (lo + hi) / 2.0
    return np.float32(mid)


points = np.random.RandomState(0).normal(size=(180, 10))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 12, "euclidean", {}, False, None)
rs, rr = up.smooth_knn_dist(distances, 12.0)
target = np.float64(np.log2(12.0))

for name, mid64, psum64 in (("f64 mid + f64 psum (upstream model)", True, True),
                            ("f32 mid + f64 psum", False, True)):
    out = np.zeros(distances.shape[0], dtype=np.float32)
    for i in range(distances.shape[0]):
        d = distances[i].astype(np.float32)
        delta = np.maximum(d[1:] - rr[i], np.float32(0.0))
        out[i] = bisect(delta, target, mid64, psum64, None)
    diff = np.max(np.abs(out.astype(np.float64) - rs.astype(np.float64)))
    print(f"{name:38s} maxdiff={diff:.6e} bitexact={np.array_equal(out, rs)}")

nsig, nrho = mojo_umap.smooth_knn_dist(distances, 12.0)
print(f"{'current .so':38s} maxdiff={np.max(np.abs(nsig.astype(np.float64) - rs.astype(np.float64))):.6e}")