"""UMAP graph construction and Euclidean embedding backed by Mojo kernels."""

from __future__ import annotations

import os
import subprocess
import warnings

import numpy as np
import scipy.sparse
from scipy.optimize import curve_fit
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.manifold import spectral_embedding
from sklearn.utils import check_random_state
from sklearn.utils.validation import check_array, check_is_fitted

from ._lib import addr, f32, f64, i64, lib

_METRICS = {
    "euclidean": 0,
    "l2": 0,
    "manhattan": 1,
    "l1": 1,
    "cityblock": 1,
    "cosine": 2,
}
_GPU_USABLE = None
_I32 = np.iinfo(np.int32)
_F32 = np.finfo(np.float32)


def _as_i32_indices(values, name: str) -> np.ndarray:
    array = np.asarray(values)
    if not np.issubdtype(array.dtype, np.integer):
        raise TypeError(f"{name} must contain integers")
    if array.size and (array.min() < _I32.min or array.max() > _I32.max):
        raise OverflowError(f"{name} contains values outside the int32 range")
    return np.ascontiguousarray(array, dtype=np.int32)


def _as_f32(values, name: str) -> np.ndarray:
    array = np.asarray(values)
    finite = np.isfinite(array)
    if np.any(finite & (np.abs(array) > _F32.max)):
        raise OverflowError(f"{name} contains values outside the float32 range")
    return np.ascontiguousarray(array, dtype=np.float32)


def _gpu_has_headroom() -> bool:
    global _GPU_USABLE
    if _GPU_USABLE is not None:
        return _GPU_USABLE
    try:
        result = subprocess.run(
            [
                "nvidia-smi",
                "--query-gpu=memory.free",
                "--format=csv,noheader,nounits",
            ],
            check=True,
            capture_output=True,
            text=True,
            timeout=2,
        )
        free_mib = min(
            int(line.strip()) for line in result.stdout.splitlines() if line.strip()
        )
        _GPU_USABLE = free_mib >= 4000
    except (OSError, subprocess.SubprocessError, ValueError):
        _GPU_USABLE = False
    return _GPU_USABLE


def _metric_code(metric) -> int:
    try:
        return _METRICS[metric]
    except (KeyError, TypeError):
        raise NotImplementedError(
            "covered metrics are euclidean, manhattan, cosine, and precomputed"
        ) from None


def _exact_knn(X, n_neighbors: int, metric: str):
    data = f64(X)
    if data.ndim != 2:
        raise ValueError("X must be a two-dimensional array")
    n, d = data.shape
    if n == 0:
        raise ValueError("X must contain at least one sample")
    if d == 0:
        raise ValueError("X must contain at least one feature")
    k = min(int(n_neighbors), n)
    if k < 1:
        raise ValueError("n_neighbors must be positive")
    indices = np.empty((n, k), dtype=np.int64)
    distances = np.empty((n, k), dtype=np.float64)
    lib().mum_exact_knn(
        addr(data),
        n,
        d,
        k,
        _metric_code(metric),
        addr(indices),
        addr(distances),
    )
    return indices.astype(np.int32), distances.astype(np.float32)


def _query_knn(train, query, n_neighbors: int, metric: str):
    train_data = f64(train)
    query_data = f64(query)
    if train_data.ndim != 2 or query_data.ndim != 2:
        raise ValueError("train and query arrays must be two-dimensional")
    if train_data.shape[1] != query_data.shape[1]:
        raise ValueError("train and query feature counts differ")
    n, d = train_data.shape
    m = query_data.shape[0]
    if n == 0 or d == 0:
        raise ValueError("train must contain samples and features")
    k = min(int(n_neighbors), n)
    if k < 1:
        raise ValueError("n_neighbors must be positive")
    if m == 0:
        return (
            np.empty((0, k), dtype=np.int32),
            np.empty((0, k), dtype=np.float32),
        )
    indices = np.empty((m, k), dtype=np.int64)
    distances = np.empty((m, k), dtype=np.float64)
    lib().mum_query_knn(
        addr(train_data),
        addr(query_data),
        n,
        m,
        d,
        k,
        _metric_code(metric),
        addr(indices),
        addr(distances),
    )
    return indices.astype(np.int32), distances.astype(np.float32)


def nearest_neighbors(
    X,
    n_neighbors,
    metric,
    metric_kwds,
    angular,
    random_state,
    low_memory=True,
    use_pynndescent=True,
    n_jobs=-1,
    verbose=False,
):
    """Compute an exact nearest-neighbor graph with the upstream signature."""
    del metric_kwds, angular, random_state, low_memory, use_pynndescent, n_jobs
    if verbose:
        print("Finding exact nearest neighbors in Mojo")
    if metric == "precomputed":
        distances = f64(X)
        if distances.ndim != 2 or distances.shape[0] != distances.shape[1]:
            raise ValueError("precomputed distances must be a square matrix")
        k = min(int(n_neighbors), distances.shape[1])
        if k < 1:
            raise ValueError("n_neighbors must be positive")
        indices = np.argsort(distances, axis=1, kind="stable")[:, :k]
        knn_distances = np.take_along_axis(distances, indices, axis=1)
        disconnected = ~np.isfinite(knn_distances)
        indices[disconnected] = -1
        result = indices.astype(np.int32), knn_distances.copy(), None
    else:
        indices, distances = _exact_knn(X, n_neighbors, metric)
        result = indices, distances, None
    if verbose:
        print("Finished exact nearest neighbor search")
    return result


def smooth_knn_dist(
    distances,
    k,
    n_iter=64,
    local_connectivity=1.0,
    bandwidth=1.0,
):
    """Compute UMAP's continuous k-neighbor distance and local radius."""
    global _GPU_USABLE
    matrix = _as_f32(distances, "distances")
    if matrix.ndim != 2:
        raise ValueError("distances must be two-dimensional")
    n, width = matrix.shape
    if n == 0 or width == 0:
        raise ValueError("distances must have at least one row and column")
    if not np.isfinite(k) or float(k) <= 0:
        raise ValueError("k must be positive and finite")
    if int(n_iter) < 0:
        raise ValueError("n_iter must be non-negative")
    if not np.isfinite(local_connectivity) or local_connectivity < 0:
        raise ValueError("local_connectivity must be finite and non-negative")
    if not np.isfinite(bandwidth) or bandwidth <= 0:
        raise ValueError("bandwidth must be positive and finite")
    sigmas = np.empty(n, dtype=np.float32)
    rhos = np.empty(n, dtype=np.float32)
    use_gpu = (
        os.environ.get("MOJO_UMAP_DEVICE", "cpu").lower() == "gpu"
        and n >= 4096
        and matrix.nbytes + n * 8 <= 1_900_000_000
        and _gpu_has_headroom()
    )
    if use_gpu:
        used_gpu = lib().mum_smooth_knn_dist_gpu(
            addr(matrix),
            n,
            width,
            float(k),
            int(n_iter),
            float(local_connectivity),
            float(bandwidth),
            addr(sigmas),
            addr(rhos),
        )
        if used_gpu:
            return sigmas, rhos
        _GPU_USABLE = False
        raise RuntimeError(
            "the requested Mojo GPU kernel failed to initialize or execute"
        )
    lib().mum_smooth_knn_dist(
        addr(matrix),
        n,
        width,
        float(k),
        int(n_iter),
        float(local_connectivity),
        float(bandwidth),
        addr(sigmas),
        addr(rhos),
    )
    return sigmas, rhos


def compute_membership_strengths(
    knn_indices,
    knn_dists,
    sigmas,
    rhos,
    return_dists=False,
    bipartite=False,
):
    """Construct COO arrays for all directed local fuzzy-set edges."""
    return _membership_arrays(
        knn_indices,
        knn_dists,
        sigmas,
        rhos,
        return_dists=return_dists,
        bipartite=bipartite,
        include_rows=True,
    )


def _membership_arrays(
    knn_indices,
    knn_dists,
    sigmas,
    rhos,
    *,
    return_dists,
    bipartite,
    include_rows,
):
    indices = _as_i32_indices(knn_indices, "knn_indices")
    distances = _as_f32(knn_dists, "knn_dists")
    sigma_values = _as_f32(sigmas, "sigmas")
    rho_values = _as_f32(rhos, "rhos")
    if indices.shape != distances.shape or indices.ndim != 2:
        raise ValueError("knn_indices and knn_dists must have the same 2D shape")
    n, k = indices.shape
    if n == 0 or k == 0:
        raise ValueError("neighbor arrays must have at least one row and column")
    if sigma_values.shape != (n,) or rho_values.shape != (n,):
        raise ValueError("sigmas and rhos must contain one value per sample")
    valid = indices != -1
    if np.any(indices[valid] < 0):
        raise ValueError("knn_indices may only use -1 as a missing-neighbor marker")
    size = n * k
    cols = np.empty(size, dtype=np.int32)
    rows = np.empty(size, dtype=np.int32) if include_rows else None
    values = np.empty(size, dtype=np.float32)
    edge_distances = (
        np.empty(size, dtype=np.float32) if return_dists else None
    )
    lib().mum_membership_strengths(
        addr(indices),
        addr(distances),
        addr(sigma_values),
        addr(rho_values),
        n,
        k,
        int(bool(bipartite)),
        addr(rows) if rows is not None else addr(cols),
        addr(cols),
        addr(values),
        addr(edge_distances) if edge_distances is not None else addr(values),
        int(bool(return_dists)),
    )
    returned_distances = (
        edge_distances
    )
    return (
        rows,
        cols,
        values,
        returned_distances,
    )


def fuzzy_simplicial_set(
    X,
    n_neighbors,
    random_state,
    metric,
    metric_kwds={},
    knn_indices=None,
    knn_dists=None,
    angular=False,
    set_op_mix_ratio=1.0,
    local_connectivity=1.0,
    apply_set_operations=True,
    verbose=False,
    return_dists=None,
):
    """Build the weighted fuzzy UMAP graph as a SciPy COO matrix."""
    if knn_indices is None or knn_dists is None:
        knn_indices, knn_dists, _ = nearest_neighbors(
            X,
            n_neighbors,
            metric,
            metric_kwds,
            angular,
            random_state,
            verbose=verbose,
        )
    sample_count = np.asarray(X).shape[0]
    if sample_count == 0:
        raise ValueError("X must contain at least one sample")
    if np.asarray(knn_indices).shape[0] != sample_count:
        raise ValueError("neighbor arrays must contain one row per sample")
    valid_indices = np.asarray(knn_indices)
    if np.any((valid_indices != -1) & (valid_indices >= sample_count)):
        raise ValueError("knn_indices contains an out-of-range sample index")
    knn_dists = _as_f32(knn_dists, "knn_dists")
    sigmas, rhos = smooth_knn_dist(
        knn_dists,
        float(n_neighbors),
        local_connectivity=float(local_connectivity),
    )
    rows, cols, values, edge_distances = _membership_arrays(
        knn_indices,
        knn_dists,
        sigmas,
        rhos,
        return_dists=bool(return_dists),
        bipartite=False,
        include_rows=bool(return_dists) or not apply_set_operations,
    )
    if apply_set_operations:
        indptr = np.arange(
            0, values.size + 1, values.size // sample_count, dtype=np.int32
        )
        graph = scipy.sparse.csr_matrix(
            (values, cols, indptr),
            shape=(sample_count, sample_count),
            copy=bool(return_dists),
        )
        graph.sum_duplicates()
    else:
        graph = scipy.sparse.coo_matrix(
            (values, (rows, cols)), shape=(sample_count, sample_count)
        )
    graph.eliminate_zeros()
    if apply_set_operations:
        transpose = graph.transpose()
        product = graph.multiply(transpose)
        if set_op_mix_ratio == 1.0:
            graph = graph + transpose - product
        elif set_op_mix_ratio == 0.0:
            graph = product
        else:
            graph = (
                set_op_mix_ratio * (graph + transpose - product)
                + (1.0 - set_op_mix_ratio) * product
            )
        graph.eliminate_zeros()
    if return_dists is None:
        return graph, sigmas, rhos
    if return_dists:
        if rows is None:
            distance_graph = scipy.sparse.csr_matrix(
                (edge_distances, cols, indptr),
                shape=(sample_count, sample_count),
                copy=False,
            )
            distance_graph.sum_duplicates()
        else:
            distance_graph = scipy.sparse.coo_matrix(
                (edge_distances, (rows, cols)),
                shape=(sample_count, sample_count),
            )
        returned = distance_graph.maximum(distance_graph.transpose()).todok()
    else:
        returned = None
    return graph, sigmas, rhos, returned


def make_epochs_per_sample(weights, n_epochs):
    """Convert edge weights into positive-sampling intervals."""
    weight_values = f64(weights).ravel()
    if not np.isfinite(weight_values).all():
        raise ValueError("weights must be finite")
    if int(n_epochs) <= 0:
        raise ValueError("n_epochs must be positive")
    result = np.empty(weight_values.size, dtype=np.float64)
    if weight_values.size:
        lib().mum_make_epochs_per_sample(
            addr(weight_values),
            weight_values.size,
            int(n_epochs),
            addr(result),
        )
    return result


def optimize_layout_euclidean(
    head_embedding,
    tail_embedding,
    head,
    tail,
    n_epochs,
    n_vertices,
    epochs_per_sample,
    a,
    b,
    rng_state,
    gamma=1.0,
    initial_alpha=1.0,
    negative_sample_rate=5.0,
    parallel=False,
    verbose=False,
    densmap=False,
    densmap_kwds=None,
    tqdm_kwds=None,
    move_other=False,
):
    """Optimize UMAP's Euclidean cross-entropy objective in Mojo."""
    del parallel, verbose, densmap_kwds, tqdm_kwds
    if densmap:
        raise NotImplementedError("densMAP optimization is not covered")
    if isinstance(n_epochs, (list, tuple)):
        raise NotImplementedError("intermediate epoch snapshots are not covered")
    shared = head_embedding is tail_embedding or np.shares_memory(
        head_embedding, tail_embedding
    )
    head_values = f32(head_embedding)
    tail_values = head_values if shared else f32(tail_embedding)
    if head_values.ndim != 2 or tail_values.ndim != 2:
        raise ValueError("embeddings must be two-dimensional")
    if head_values.shape[1] != tail_values.shape[1]:
        raise ValueError("head and tail embedding dimensions differ")
    if not np.isfinite(head_values).all() or not np.isfinite(tail_values).all():
        raise ValueError("embeddings must be finite float32 values")
    head_indices = _as_i32_indices(head, "head").ravel()
    tail_indices = _as_i32_indices(tail, "tail").ravel()
    epochs = f64(epochs_per_sample).ravel()
    if not (
        head_indices.size == tail_indices.size == epochs.size
    ):
        raise ValueError("head, tail, and epochs_per_sample lengths differ")
    if negative_sample_rate <= 0:
        raise ValueError("negative_sample_rate must be positive")
    if int(n_epochs) <= 0:
        raise ValueError("n_epochs must be positive")
    if int(n_vertices) != tail_values.shape[0]:
        raise ValueError("n_vertices must equal the tail embedding row count")
    if np.any(head_indices < 0) or np.any(head_indices >= head_values.shape[0]):
        raise ValueError("head contains an out-of-range vertex index")
    if np.any(tail_indices < 0) or np.any(tail_indices >= tail_values.shape[0]):
        raise ValueError("tail contains an out-of-range vertex index")
    if not np.isfinite(epochs).all() or np.any(epochs <= 0):
        raise ValueError("epochs_per_sample must be positive and finite")
    state = i64(rng_state).ravel()
    if state.size != 3:
        raise ValueError("rng_state must have three int64 values")
    if head_indices.size == 0:
        return head_values
    state_per_sample = (
        np.full((head_values.shape[0], 3), state, dtype=np.int64)
        + head_values[:, 0]
        .astype(np.float64)
        .view(np.int64)
        .reshape(-1, 1)
    )
    next_sample = epochs.copy()
    next_negative = epochs / float(negative_sample_rate)
    lib().mum_optimize_layout_euclidean(
        addr(head_values),
        addr(tail_values),
        addr(head_indices),
        addr(tail_indices),
        addr(epochs),
        addr(state_per_sample),
        addr(next_sample),
        addr(next_negative),
        head_indices.size,
        head_values.shape[0],
        int(n_vertices),
        head_values.shape[1],
        int(n_epochs),
        float(a),
        float(b),
        float(gamma),
        float(initial_alpha),
        float(negative_sample_rate),
        int(bool(move_other)),
    )
    return head_values


def _noisy_scale(coords, random_state, max_coord=10.0, noise=0.0001):
    coordinates = np.asarray(coords)
    maximum = np.abs(coordinates).max()
    if maximum > 0:
        coordinates = coordinates * (max_coord / maximum)
    coordinates = coordinates.astype(np.float32)
    return coordinates + random_state.normal(
        scale=noise, size=coordinates.shape
    ).astype(np.float32)


def simplicial_set_embedding(
    data,
    graph,
    n_components,
    initial_alpha,
    a,
    b,
    gamma,
    negative_sample_rate,
    n_epochs,
    init,
    random_state,
    metric,
    metric_kwds,
    densmap,
    densmap_kwds,
    output_dens,
    output_metric="euclidean",
    output_metric_kwds={},
    euclidean_output=True,
    parallel=False,
    verbose=False,
    tqdm_kwds=None,
):
    """Initialize and optimize a fuzzy graph in Euclidean output space."""
    del output_metric, output_metric_kwds
    if densmap or output_dens:
        raise NotImplementedError("densMAP and density outputs are not covered")
    if not euclidean_output:
        raise NotImplementedError("only Euclidean output embeddings are covered")
    random_state = check_random_state(random_state)
    graph = graph.tocoo(copy=False)
    graph.sum_duplicates()
    default_epochs = 500 if graph.shape[0] <= 10_000 else 200
    if n_epochs is None:
        n_epochs = default_epochs
    if isinstance(n_epochs, (list, tuple)):
        raise NotImplementedError("intermediate epoch snapshots are not covered")
    if n_epochs > 10:
        graph.data[graph.data < graph.data.max() / float(n_epochs)] = 0.0
    else:
        graph.data[graph.data < graph.data.max() / float(default_epochs)] = 0.0
    graph.eliminate_zeros()

    if isinstance(init, str) and init == "random":
        embedding = random_state.uniform(
            -10.0, 10.0, size=(graph.shape[0], n_components)
        ).astype(np.float32)
    elif isinstance(init, str) and init == "pca":
        from sklearn.decomposition import PCA, TruncatedSVD

        estimator = (
            TruncatedSVD(n_components=n_components, random_state=random_state)
            if scipy.sparse.issparse(data)
            else PCA(n_components=n_components, random_state=random_state)
        )
        embedding = _noisy_scale(
            estimator.fit_transform(data), random_state
        )
    elif isinstance(init, str) and init in ("spectral", "tswspectral"):
        try:
            initial = spectral_embedding(
                graph,
                n_components=n_components,
                random_state=random_state,
                eigen_solver="arpack",
                drop_first=True,
            )
            embedding = _noisy_scale(initial, random_state)
        except Exception:
            embedding = random_state.uniform(
                -10.0, 10.0, size=(graph.shape[0], n_components)
            ).astype(np.float32)
    else:
        embedding = f32(init, copy=True)
        if embedding.shape != (graph.shape[0], n_components):
            raise ValueError("init array has the wrong shape")

    epochs_per_sample = make_epochs_per_sample(graph.data, n_epochs)
    rng_state = random_state.randint(
        np.iinfo(np.int32).min + 1,
        np.iinfo(np.int32).max,
        3,
    ).astype(np.int64)
    lower = embedding.min(axis=0)
    span = embedding.max(axis=0) - lower
    span[span == 0.0] = 1.0
    embedding = np.asarray(
        10.0 * (embedding - lower) / span,
        dtype=np.float32,
        order="C",
    )
    embedding = optimize_layout_euclidean(
        embedding,
        embedding,
        graph.row,
        graph.col,
        n_epochs,
        graph.shape[1],
        epochs_per_sample,
        a,
        b,
        rng_state,
        gamma=gamma,
        initial_alpha=initial_alpha,
        negative_sample_rate=negative_sample_rate,
        parallel=parallel,
        verbose=verbose,
        densmap=densmap,
        densmap_kwds=densmap_kwds,
        tqdm_kwds=tqdm_kwds,
        move_other=True,
    )
    return embedding, {}


def find_ab_params(spread, min_dist):
    """Fit the differentiable low-dimensional membership curve."""

    def curve(x, a, b):
        return 1.0 / (1.0 + a * x ** (2 * b))

    x = np.linspace(0, spread * 3, 300)
    y = np.zeros_like(x)
    y[x < min_dist] = 1.0
    y[x >= min_dist] = np.exp(
        -(x[x >= min_dist] - min_dist) / spread
    )
    params, _ = curve_fit(curve, x, y)
    return params[0], params[1]


class UMAP(TransformerMixin, BaseEstimator):
    """Covered UMAP estimator subset with an upstream-compatible constructor."""

    def __init__(
        self,
        n_neighbors=15,
        n_components=2,
        metric="euclidean",
        metric_kwds=None,
        output_metric="euclidean",
        output_metric_kwds=None,
        n_epochs=None,
        learning_rate=1.0,
        init="spectral",
        min_dist=0.1,
        spread=1.0,
        low_memory=True,
        n_jobs=-1,
        set_op_mix_ratio=1.0,
        local_connectivity=1.0,
        repulsion_strength=1.0,
        negative_sample_rate=5,
        transform_queue_size=4.0,
        a=None,
        b=None,
        random_state=None,
        angular_rp_forest=False,
        target_n_neighbors=-1,
        target_metric="categorical",
        target_metric_kwds=None,
        target_weight=0.5,
        transform_seed=42,
        transform_mode="embedding",
        force_approximation_algorithm=False,
        verbose=False,
        tqdm_kwds=None,
        unique=False,
        densmap=False,
        dens_lambda=2.0,
        dens_frac=0.3,
        dens_var_shift=0.1,
        output_dens=False,
        disconnection_distance=None,
        precomputed_knn=(None, None, None),
    ):
        self.n_neighbors = n_neighbors
        self.n_components = n_components
        self.metric = metric
        self.metric_kwds = metric_kwds
        self.output_metric = output_metric
        self.output_metric_kwds = output_metric_kwds
        self.n_epochs = n_epochs
        self.learning_rate = learning_rate
        self.init = init
        self.min_dist = min_dist
        self.spread = spread
        self.low_memory = low_memory
        self.n_jobs = n_jobs
        self.set_op_mix_ratio = set_op_mix_ratio
        self.local_connectivity = local_connectivity
        self.repulsion_strength = repulsion_strength
        self.negative_sample_rate = negative_sample_rate
        self.transform_queue_size = transform_queue_size
        self.a = a
        self.b = b
        self.random_state = random_state
        self.angular_rp_forest = angular_rp_forest
        self.target_n_neighbors = target_n_neighbors
        self.target_metric = target_metric
        self.target_metric_kwds = target_metric_kwds
        self.target_weight = target_weight
        self.transform_seed = transform_seed
        self.transform_mode = transform_mode
        self.force_approximation_algorithm = force_approximation_algorithm
        self.verbose = verbose
        self.tqdm_kwds = tqdm_kwds
        self.unique = unique
        self.densmap = densmap
        self.dens_lambda = dens_lambda
        self.dens_frac = dens_frac
        self.dens_var_shift = dens_var_shift
        self.output_dens = output_dens
        self.disconnection_distance = disconnection_distance
        self.precomputed_knn = precomputed_knn

    def _validate_supported(self):
        if self.densmap or self.output_dens:
            raise NotImplementedError("densMAP is not covered")
        if self.output_metric != "euclidean":
            raise NotImplementedError("only Euclidean output is covered")
        if self.transform_mode != "embedding":
            raise NotImplementedError("graph transform mode is not covered")
        if self.unique:
            raise NotImplementedError("unique-row fitting is not covered")
        if self.metric != "precomputed":
            _metric_code(self.metric)
        if int(self.n_components) < 1:
            raise ValueError("n_components must be positive")
        if int(self.n_neighbors) < 2:
            raise ValueError("n_neighbors must be at least 2")

    def fit(self, X, y=None, ensure_all_finite=True, **kwargs):
        del kwargs
        self._validate_supported()
        if y is not None:
            raise NotImplementedError("supervised target graphs are not covered")
        data = check_array(
            X,
            dtype=np.float64,
            accept_sparse=False,
            ensure_min_samples=2,
            ensure_all_finite=ensure_all_finite,
        )
        if scipy.sparse.issparse(data) and self.metric != "precomputed":
            raise NotImplementedError("sparse feature matrices are not covered")
        sample_count = data.shape[0]
        self._n_neighbors = min(int(self.n_neighbors), sample_count - 1)
        if self._n_neighbors != int(self.n_neighbors):
            warnings.warn(
                "n_neighbors is larger than the dataset; truncating",
                UserWarning,
                stacklevel=2,
            )
        random_state = check_random_state(self.random_state)
        supplied_indices, supplied_distances, _ = self.precomputed_knn
        if supplied_indices is None or supplied_distances is None:
            indices, distances, _ = nearest_neighbors(
                data,
                self._n_neighbors,
                self.metric,
                self.metric_kwds or {},
                self.angular_rp_forest,
                random_state,
                low_memory=self.low_memory,
                n_jobs=self.n_jobs,
                verbose=self.verbose,
            )
        else:
            indices = np.asarray(supplied_indices)
            distances = np.asarray(supplied_distances)
        graph, sigmas, rhos = fuzzy_simplicial_set(
            data,
            self._n_neighbors,
            random_state,
            self.metric,
            self.metric_kwds or {},
            indices,
            distances,
            self.angular_rp_forest,
            self.set_op_mix_ratio,
            self.local_connectivity,
            verbose=self.verbose,
        )
        a, b = (
            find_ab_params(self.spread, self.min_dist)
            if self.a is None or self.b is None
            else (float(self.a), float(self.b))
        )
        embedding, _ = simplicial_set_embedding(
            data,
            graph,
            int(self.n_components),
            float(self.learning_rate),
            a,
            b,
            float(self.repulsion_strength),
            float(self.negative_sample_rate),
            self.n_epochs,
            self.init,
            random_state,
            self.metric,
            self.metric_kwds or {},
            False,
            {},
            False,
            output_metric=self.output_metric,
            parallel=self.random_state is None,
            verbose=self.verbose,
            tqdm_kwds=self.tqdm_kwds,
        )
        self.embedding_ = embedding
        self.graph_ = graph.tocsr()
        self._sigmas = sigmas
        self._rhos = rhos
        self._knn_indices = indices
        self._knn_dists = distances
        self._raw_data = np.asarray(data)
        self._a = a
        self._b = b
        self.n_features_in_ = data.shape[1]
        return self

    def fit_transform(self, X, y=None, ensure_all_finite=True, **kwargs):
        return self.fit(
            X,
            y=y,
            ensure_all_finite=ensure_all_finite,
            **kwargs,
        ).embedding_

    def transform(self, X, ensure_all_finite=True):
        check_is_fitted(self, "embedding_")
        if self.metric == "precomputed":
            raise NotImplementedError(
                "transform with precomputed distances is not covered"
            )
        query = check_array(
            X,
            dtype=np.float64,
            ensure_all_finite=ensure_all_finite,
        )
        if query.shape[1] != self.n_features_in_:
            raise ValueError("query feature count differs from fitted data")
        if query.shape == self._raw_data.shape and np.array_equal(
            query, self._raw_data
        ):
            return self.embedding_
        indices, distances = _query_knn(
            self._raw_data,
            query,
            self._n_neighbors,
            self.metric,
        )
        sigmas, rhos = smooth_knn_dist(
            distances,
            float(self._n_neighbors),
            local_connectivity=max(0.0, self.local_connectivity - 1.0),
        )
        rows, cols, values, _ = compute_membership_strengths(
            indices,
            distances,
            sigmas,
            rhos,
            bipartite=True,
        )
        graph = scipy.sparse.coo_matrix(
            (values, (rows, cols)),
            shape=(query.shape[0], self._raw_data.shape[0]),
        ).tocsr()
        row_sums = np.asarray(graph.sum(axis=1)).ravel()
        row_sums[row_sums == 0.0] = 1.0
        normalized = scipy.sparse.diags(1.0 / row_sums) @ graph
        initial = np.asarray(
            normalized @ self.embedding_, dtype=np.float32, order="C"
        )
        epochs = (
            max(10, int(self.n_epochs) // 3)
            if self.n_epochs is not None
            else 100
        )
        graph = graph.tocoo()
        graph.data[graph.data < graph.data.max() / float(epochs)] = 0.0
        graph.eliminate_zeros()
        epoch_intervals = make_epochs_per_sample(graph.data, epochs)
        rng = check_random_state(self.transform_seed)
        state = rng.randint(
            np.iinfo(np.int32).min + 1,
            np.iinfo(np.int32).max,
            3,
        ).astype(np.int64)
        return optimize_layout_euclidean(
            initial,
            self.embedding_,
            graph.row,
            graph.col,
            epochs,
            self.embedding_.shape[0],
            epoch_intervals,
            self._a,
            self._b,
            state,
            gamma=self.repulsion_strength,
            initial_alpha=self.learning_rate / 4.0,
            negative_sample_rate=self.negative_sample_rate,
            move_other=False,
        )
