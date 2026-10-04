import sys, os
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

rng = np.random.default_rng(3)
points = rng.normal(size=(180, 10))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 12, "euclidean", {}, False, None)
d64 = distances.astype(np.float64)
n, k = d64.shape
target = np.float32(np.log2(12.0))
LOG2E32 = np.float32(1.4426950408889634)

def bisect(delta64, mode):
    lo, hi, mid = np.float32(0.0), np.float32(3.4028234663852886e38), np.float32(1.0)
    for _ in range(64):
        if mode == "f64":
            p = np.float32(np.exp(-delta64 / np.float64(mid)).sum())
        elif mode == "f32seq":
            p = np.float32(np.exp(-(delta64 / np.float64(mid)).astype(np.float32).astype(np.float32)).sum(dtype=np.float32))
        elif mode == "simd8_f32":
            f = np.float32(LOG2E32 * (-np.float32(1.0) / mid))
            t = np.exp2((delta64.astype(np.float32) * f)).astype(np.float32)
            pad = np.zeros(16 - len(t), dtype=np.float32)
            t = np.concatenate([t, pad])
            acc = (t[0:8] + t[8:16]).astype(np.float32)
            p = np.float32(acc[0] + acc[1] + (acc[2] + acc[3]) + ((acc[4] + acc[5]) + (acc[6] + acc[7])))
        elif mode == "simd8_f64red":
            f = np.float32(LOG2E32 * (-np.float32(1.0) / mid))
            t = np.exp2((delta64.astype(np.float32) * f)).astype(np.float32)
            pad = np.zeros(16 - len(t), dtype=np.float32)
            t = np.concatenate([t, pad])
            acc = (t[0:8] + t[8:16]).astype(np.float32)
            p = np.float32(acc.astype(np.float64).sum())
        elif mode == "simd8_f64exp":
            f = np.float64(LOG2E32) * (-np.float64(1.0) / np.float64(mid))
            t = np.exp2(delta64 * f)
            pad = np.zeros(16 - len(t))
            t = np.concatenate([t, pad])
            acc = t[0:8] + t[8:16]
            p = np.float32(acc.sum())
        elif mode == "simd8_f64term_f32exp":
            f = np.float64(LOG2E32) * (-np.float64(1.0) / np.float64(mid))
            t = np.exp2(delta64 * f).astype(np.float32)
            pad = np.zeros(16 - len(t), dtype=np.float32)
            t = np.concatenate([t, pad])
            acc = (t[0:8].astype(np.float64) + t[8:16].astype(np.float64))
            p = np.float32(acc.sum())
        if abs(p - target) < np.float32(1e-5):
            break
        if p > target:
            hi = mid; mid = np.float32((lo + hi) / np.float32(2.0))
        else:
            lo = mid
            mid = np.float32(mid * np.float32(2.0)) if hi >= np.float32(3.4028234663852886e38) else np.float32((lo + hi) / np.float32(2.0))
    return mid

def run(mode):
    out = np.zeros(n, dtype=np.float32)
    for i in range(n):
        rho = np.float32(d64[i][1])
        delta = np.maximum(d64[i][1:] - np.float64(rho), 0.0)
        out[i] = bisect(delta, mode)
    return out

ref = up.smooth_knn_dist(distances, 12.0)[0]
for mode in ["f64", "f32seq", "simd8_f32", "simd8_f64red", "simd8_f64exp", "simd8_f64term_f32exp"]:
    got = run(mode)
    print(f"{mode:22s} maxdiff vs upstream: {np.max(np.abs(got.astype(np.float64) - ref.astype(np.float64))):.4e}  nflip={int((got != ref).sum())}")
