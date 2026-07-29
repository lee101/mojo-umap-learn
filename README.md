# mojo-umap-learn

UMAP graph construction and Euclidean embedding implemented in
[Mojo](https://www.modular.com/mojo), with a Python API shaped like
[`umap-learn`](https://github.com/lmcinnes/umap).

This port targets the compute-heavy core rather than wrapping upstream:
exact nearest-neighbor search, smooth k-neighbor distance calibration,
fuzzy membership construction, graph set operations, edge scheduling, and
stochastic layout optimization. `umap-learn` is present in the development
environment for parity tests and benchmarks, but it is not a runtime
dependency of `mojo_umap`.

The covered API uses the upstream names and signatures, so the migration for
the supported subset is an import change:

```python
import mojo_umap as umap

model = umap.UMAP(
    n_neighbors=15,
    n_components=2,
    min_dist=0.1,
    random_state=42,
)
embedding = model.fit_transform(X)
new_embedding = model.transform(X_new)
```

The distribution uses the `mojo_umap` namespace rather than shadowing
`umap`, which lets both implementations coexist for testing.

## Covered subset

| area | coverage |
| --- | --- |
| Neighbor search | Exact dense `euclidean`/`l2`, `manhattan`/`l1`/`cityblock`, `cosine`, and dense `precomputed`; training and query search |
| Graph construction | `nearest_neighbors`, `smooth_knn_dist`, `compute_membership_strengths`, `fuzzy_simplicial_set`, fuzzy union/intersection mixing |
| Embedding | `make_epochs_per_sample`, `optimize_layout_euclidean`, `simplicial_set_embedding`, `find_ab_params` |
| Estimator | Upstream-compatible `UMAP` constructor, `fit`, `fit_transform`, `transform`, sklearn parameter handling |
| Initialization | `random`, `pca`, `spectral`, explicit arrays |

The exact k-NN kernel is quadratic in sample count. It is useful for small and
medium dense datasets, where exact recall matters, and as a graph builder for
validation. For larger datasets, compute approximate neighbors externally and
pass them through `precomputed_knn` or call `fuzzy_simplicial_set` with
`knn_indices` and `knn_dists`.

Not covered are NN-descent, sparse feature matrices, arbitrary/custom input
metrics, supervised target graphs, densMAP, non-Euclidean output metrics,
inverse transform, unique-row fitting, and intermediate epoch snapshots.
Unsupported modes raise `NotImplementedError` instead of silently changing
the algorithm.

## Install and run

```bash
pixi install
pixi run build
pixi run test
pixi run bench
```

`pixi run build` produces
`dist/libmojo-umap-learn.so`. The Python loader also rebuilds it when the Mojo
source is newer. A prebuilt library can be selected with `MOJO_UMAP_LIB`.

A complete runnable example:

```python
from sklearn.datasets import make_blobs
import mojo_umap

X, labels = make_blobs(
    n_samples=500,
    centers=6,
    n_features=12,
    random_state=7,
)

embedding = mojo_umap.UMAP(
    n_neighbors=12,
    min_dist=0.15,
    n_epochs=100,
    random_state=7,
).fit_transform(X)

print(embedding.shape, embedding.dtype)
# (500, 2) float32
```

## Correctness

The test suite compares against `umap-learn` 0.5.12 on the same inputs:

- exact neighbors against SciPy distances for every covered metric;
- smooth distances, local radii, membership coefficients, fuzzy graph
  matrices, returned graph distances, epoch schedules, and fitted curve
  parameters against upstream numerically;
- deterministic optimizer updates against upstream at float32 tolerance;
- estimator graphs against upstream with identical supplied neighbors;
- embedding trustworthiness and pairwise structure on clustered data;
- reproducibility, transform behavior, default spectral initialization, and
  sklearn-shaped parameter handling.

Embeddings after many stochastic epochs are not compared coordinate by
coordinate. Floating-point perturbations compound chaotically, and a valid
UMAP embedding is also free to rotate or reflect. The tests compare the exact
graph coefficients and optimizer updates directly, then compare the final
embedding's neighborhood and pairwise structure.

## Benchmarks

Measured with `pixi run bench` on this machine: Intel Xeon E5-2697 v4, 72
logical CPUs, Python 3.13.14, and `umap-learn` 0.5.12. Times are the best of
three warm runs. Ratio is upstream time divided by Mojo time. CPU remains the
default.

| case | Mojo (ms) | umap-learn (ms) | ratio | result |
| --- | ---: | ---: | ---: | --- |
| `smooth_knn_dist` (250k x 15) | 46.67 | 46.07 | 0.99x | slower |
| `smooth_knn_dist GPU` (250k x 15) | 14.44 | 46.07 | 3.19x | faster; opt-in |
| `compute_membership_strengths` (3.75M edges) | 72.50 | 53.25 | 0.73x | slower |
| `fuzzy_simplicial_set` (60k x 15 supplied k-NN) | 174.36 | 208.91 | 1.20x | faster |
| `optimize_layout_euclidean` (6k, 80k edges, 50 epochs) | 1109.71 | 1022.92 | 0.92x | slower |
| `nearest_neighbors` (3k x 20, k=15) | 32.49 | 230.92 | 7.11x | faster |

The nearest-neighbor row compares Mojo's exact scan with upstream
PyNNDescent, whose measured recall against the exact result was 0.989. Exact
Mojo search was 7.11x faster at this dataset size, but its quadratic scaling
means PyNNDescent is the appropriate choice at large sample counts.

Exact neighbor search and supplied-neighbor fuzzy graph construction were
faster in this run. The other CPU cases were slower; the GPU smooth-distance
kernel was faster when enabled.

Smooth distance calibration has enough repeated exponential work per input
byte to benefit from the GPU. Set `MOJO_UMAP_DEVICE=gpu` to enable its optional
GPU kernel.
Inputs below 4,096 rows stay on the CPU. If no NVIDIA GPU is available, less
than 4,000 MiB is free, or the combined allocation would exceed 1.9 GB, the
call uses the CPU path. A GPU initialization or execution failure raises
`RuntimeError` instead of being hidden by a CPU retry.

## How it works

All kernels live in one Mojo compilation unit. Python makes one `ctypes` call
per operation, passing array addresses and extents through the C ABI. Exported
functions use `@export("name")` with `abi("C")`; buffers cross as integer
addresses and are reconstructed as typed pointers inside Mojo.

Graph arrays retain upstream-native layouts: C-contiguous float32 distances
and weights with int32 neighbor/COO indices. Optimizer edge indices also stay
int32 across the FFI boundary instead of being copied to int64. Exact feature
search uses C-contiguous float64 input, and embeddings stay row-major float32.
Python owns CPU output and scratch buffers. Optional GPU buffers are scoped to
one call and released promptly.

Nearest-neighbor rows, smooth distance calibration, and membership
construction are parallelized across bounded row chunks, with small inputs
remaining serial. Smooth calibration uses SIMD exponential/reduction blocks
with a scalar tail. The fuzzy graph path builds CSR rows directly and avoids
allocating unused distance/row arrays. The common two-dimensional layout
optimizer is unrolled, but deliberately serial: it updates shared embedding
coordinates in edge order, matching upstream's reproducible seeded path and
Tausworthe random number generator.

## License

MIT
