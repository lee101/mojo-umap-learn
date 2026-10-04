import sys, os, time, math
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
import mojo_umap
import umap.umap_ as up

rng = np.random.default_rng(0)
points = rng.normal(size=(250_000, 20))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 15, "euclidean", {}, False, None)
distances = np.ascontiguousarray(distances, dtype=np.float32)
n, width = distances.shape


def timeit(fn, repeat=5):
    best = math.inf
    for _ in range(repeat):
        t = time.perf_counter()
        fn()
        best = min(best, time.perf_counter() - t)
    return best


t = timeit(lambda: mojo_umap.smooth_knn_dist(distances, 15.0))
tu = timeit(lambda: up.smooth_knn_dist(distances, 15.0))
s, r = mojo_umap.smooth_knn_dist(distances, 15.0)
us, ur = up.smooth_knn_dist(distances, 15.0)
print(f"BUILD={os.environ.get('BUILD_TAG','?')}")
print(f"  mojo={t*1e3:.2f} ms  upstream={tu*1e3:.2f} ms  ratio={tu/t:.2f}x  rows={n}")
print(f"  sigma bitexact={np.array_equal(s, us)}  maxdiff={np.max(np.abs(s.astype(np.float64)-us.astype(np.float64))):.3e}")
print(f"  rho   bitexact={np.array_equal(r, ur)}  maxdiff={np.max(np.abs(r.astype(np.float64)-ur.astype(np.float64))):.3e}")