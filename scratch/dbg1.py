import sys, os
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
from scipy.spatial.distance import cdist
import mojo_umap
import umap.umap_ as up
random = np.random.default_rng(7)
points = random.normal(size=(60, 8))
distances = np.sort(cdist(points, points), axis=1)[:, :15].astype(np.float32)
gs, gr = mojo_umap.smooth_knn_dist(distances, 15.0, local_connectivity=1.0)
rs, rr = up.smooth_knn_dist(distances, 15.0, local_connectivity=1.0)
print("rho equal", np.array_equal(gr, rr))
bad = np.where(~np.isclose(gs, rs, rtol=2e-5, atol=2e-6))[0]
print("bad rows", bad[:10], len(bad))
for i in bad[:3]:
    print("got", gs[i], "ref", rs[i], "rho", gr[i], rr[i])
    print("row", distances[i])
