import sys, os
sys.path.insert(0, os.path.abspath("python"))
import numpy as np
from scipy.spatial.distance import cdist
import mojo_umap
import umap.umap_ as up
random = np.random.default_rng(3)
points = random.normal(size=(180, 10))
indices, distances, _ = mojo_umap.nearest_neighbors(points, 12, "euclidean", {}, False, None)
args = (points, 12, np.random.RandomState(4), "euclidean", {}, indices, distances)
for mix in (0.0, 1.0):
    got, gs, gr = mojo_umap.fuzzy_simplicial_set(*args, set_op_mix_ratio=mix)
    exp_, rs, rr = up.fuzzy_simplicial_set(*args, set_op_mix_ratio=mix)
    d = (got.tocsr() - exp_.tocsr()).tocoo()
    print("mix", mix, "graph maxdiff", np.max(np.abs(d.data)) if d.nnz else 0.0)
    print("  sigma maxdiff", np.max(np.abs(gs - rs)), "rho maxdiff", np.max(np.abs(gr - rr)))
    # direct membership comparison using upstream sigma
    mr, mc, mv, md = up.compute_membership_strengths(indices, distances, rs, rr, return_dists=True)
    mr2, mc2, mv2, md2 = mojo_umap.compute_membership_strengths(indices, distances, rs, rr, return_dists=True)
    print("  membership value maxdiff (upstream sigma)", np.max(np.abs(mv - mv2)))
    mv3, _, _, _ = mojo_umap.compute_membership_strengths(indices, distances, gs, gr, return_dists=True)
    print("  membership value maxdiff (own sigma)", np.max(np.abs(mv - mv3)))
