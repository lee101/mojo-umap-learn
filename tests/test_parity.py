"""Numerical and behavioral parity against umap-learn 0.5.x."""

import inspect
import os
import subprocess
import warnings

import numpy as np
import pytest
import scipy.sparse
from scipy.spatial.distance import cdist, pdist
from sklearn.datasets import make_blobs
from sklearn.manifold import trustworthiness

import mojo_umap
import mojo_umap.layouts as mojo_layouts
import mojo_umap.umap_ as mojo_umap_
import umap
import umap.layouts as upstream_layouts
import umap.umap_ as upstream_umap_


@pytest.fixture(scope="module")
def points():
    return np.random.default_rng(7).normal(size=(180, 9))


@pytest.mark.parametrize(
    ("metric", "scipy_metric"),
    [
        ("euclidean", "euclidean"),
        ("manhattan", "cityblock"),
        ("cosine", "cosine"),
    ],
)
def test_exact_nearest_neighbors_match_scipy(points, metric, scipy_metric):
    indices, distances, forest = mojo_umap.nearest_neighbors(
        points, 12, metric, {}, False, np.random.RandomState(0)
    )
    reference_distances = cdist(points, points, metric=scipy_metric)
    reference_indices = np.argsort(
        reference_distances, axis=1, kind="stable"
    )[:, :12]
    expected = np.take_along_axis(
        reference_distances, reference_indices, axis=1
    )
    assert forest is None
    assert np.array_equal(indices, reference_indices)
    assert np.allclose(distances, expected, atol=2e-6)


def test_precomputed_nearest_neighbors_match_upstream(points):
    matrix = cdist(points[:40], points[:40])
    got = mojo_umap.nearest_neighbors(
        matrix, 8, "precomputed", {}, False, None
    )
    expected = upstream_umap_.nearest_neighbors(
        matrix, 8, "precomputed", {}, False, None
    )
    assert np.array_equal(got[0], expected[0])
    assert np.array_equal(got[1], expected[1])
    assert got[2] is expected[2] is None


@pytest.mark.parametrize("local_connectivity", [0.0, 1.0, 1.5, 3.0])
def test_smooth_knn_dist_matches_upstream(points, local_connectivity):
    distances = np.sort(cdist(points, points), axis=1)[:, :15].astype(
        np.float32
    )
    got_sigma, got_rho = mojo_umap.smooth_knn_dist(
        distances,
        15.0,
        local_connectivity=local_connectivity,
    )
    ref_sigma, ref_rho = upstream_umap_.smooth_knn_dist(
        distances,
        15.0,
        local_connectivity=local_connectivity,
    )
    assert np.allclose(got_sigma, ref_sigma, rtol=2e-5, atol=2e-6)
    assert np.allclose(got_rho, ref_rho, rtol=1e-6, atol=1e-7)


@pytest.mark.parametrize("sample_count", [9, 128])
def test_smooth_knn_dist_simd_tail_and_parallel_threshold(sample_count):
    random = np.random.default_rng(sample_count)
    increments = random.exponential(
        scale=0.3, size=(sample_count, 12)
    ).astype(np.float32)
    distances = np.column_stack(
        [
            np.zeros(sample_count, dtype=np.float32),
            np.cumsum(increments, axis=1),
        ]
    )
    got = mojo_umap.smooth_knn_dist(distances, 13.0)
    expected = upstream_umap_.smooth_knn_dist(distances, 13.0)
    assert np.allclose(got[0], expected[0], rtol=2e-5, atol=2e-6)
    assert np.allclose(got[1], expected[1], rtol=1e-6, atol=1e-7)


def test_smooth_knn_dist_gpu_matches_cpu():
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
        if min(map(int, result.stdout.split())) < 4000:
            pytest.skip("GPU has less than 4000 MiB free")
    except (OSError, subprocess.SubprocessError, ValueError):
        pytest.skip("no NVIDIA GPU available")
    random = np.random.default_rng(41)
    increments = random.exponential(
        scale=0.25, size=(4096, 12)
    ).astype(np.float32)
    distances = np.column_stack(
        [np.zeros(4096, dtype=np.float32), np.cumsum(increments, axis=1)]
    )
    expected = mojo_umap.smooth_knn_dist(distances, 13.0)
    previous = os.environ.get("MOJO_UMAP_DEVICE")
    os.environ["MOJO_UMAP_DEVICE"] = "gpu"
    mojo_umap_._GPU_USABLE = None
    try:
        got = mojo_umap.smooth_knn_dist(distances, 13.0)
    finally:
        if previous is None:
            os.environ.pop("MOJO_UMAP_DEVICE", None)
        else:
            os.environ["MOJO_UMAP_DEVICE"] = previous
    assert mojo_umap_._GPU_USABLE is True
    assert np.allclose(got[0], expected[0], rtol=2e-5, atol=2e-6)
    assert np.allclose(got[1], expected[1], rtol=1e-6, atol=1e-7)


@pytest.mark.parametrize("bipartite", [False, True])
def test_membership_strengths_match_upstream(points, bipartite):
    indices, distances, _ = mojo_umap.nearest_neighbors(
        points, 10, "euclidean", {}, False, None
    )
    sigmas, rhos = upstream_umap_.smooth_knn_dist(distances, 10.0)
    got = mojo_umap.compute_membership_strengths(
        indices,
        distances,
        sigmas,
        rhos,
        return_dists=True,
        bipartite=bipartite,
    )
    expected = upstream_umap_.compute_membership_strengths(
        indices,
        distances,
        sigmas,
        rhos,
        return_dists=True,
        bipartite=bipartite,
    )
    assert np.array_equal(got[0], expected[0])
    assert np.array_equal(got[1], expected[1])
    assert np.allclose(got[2], expected[2], rtol=2e-6, atol=1e-7)
    assert np.array_equal(got[3], expected[3])


@pytest.mark.parametrize("mix_ratio", [0.0, 0.35, 1.0])
def test_fuzzy_simplicial_set_matches_upstream(points, mix_ratio):
    indices, distances, _ = mojo_umap.nearest_neighbors(
        points, 12, "euclidean", {}, False, None
    )
    args = (
        points,
        12,
        np.random.RandomState(4),
        "euclidean",
        {},
        indices,
        distances,
    )
    got, got_sigma, got_rho = mojo_umap.fuzzy_simplicial_set(
        *args, set_op_mix_ratio=mix_ratio
    )
    expected, ref_sigma, ref_rho = upstream_umap_.fuzzy_simplicial_set(
        *args, set_op_mix_ratio=mix_ratio
    )
    difference = (got.tocsr() - expected.tocsr()).tocoo()
    assert (
        difference.nnz == 0
        or np.max(np.abs(difference.data)) < 3e-6
    )
    assert np.allclose(got_sigma, ref_sigma, rtol=2e-5, atol=2e-6)
    assert np.allclose(got_rho, ref_rho)


def test_fuzzy_set_return_distances_matches_upstream(points):
    indices, distances, _ = mojo_umap.nearest_neighbors(
        points[:50], 8, "euclidean", {}, False, None
    )
    got = mojo_umap.fuzzy_simplicial_set(
        points[:50],
        8,
        None,
        "euclidean",
        knn_indices=indices,
        knn_dists=distances,
        return_dists=True,
    )
    expected = upstream_umap_.fuzzy_simplicial_set(
        points[:50],
        8,
        None,
        "euclidean",
        knn_indices=indices,
        knn_dists=distances,
        return_dists=True,
    )
    assert np.allclose(got[3].toarray(), expected[3].toarray())


def test_make_epochs_per_sample_matches_upstream():
    weights = np.array([1.0, 0.7, 0.25, 0.01, 0.0])
    got = mojo_umap.make_epochs_per_sample(weights, 200)
    expected = upstream_umap_.make_epochs_per_sample(weights, 200)
    assert np.array_equal(got, expected)


@pytest.mark.parametrize(
    ("spread", "min_dist"),
    [(1.0, 0.1), (1.5, 0.0), (2.0, 0.5)],
)
def test_find_ab_params_matches_upstream(spread, min_dist):
    got = mojo_umap.find_ab_params(spread, min_dist)
    expected = upstream_umap_.find_ab_params(spread, min_dist)
    assert got == pytest.approx(expected, rel=1e-10)


def test_optimizer_matches_upstream_numerically():
    random = np.random.RandomState(3)
    initial = random.uniform(0, 10, size=(16, 3)).astype(np.float32)
    head = np.repeat(np.arange(16, dtype=np.int32), 3)
    tail = np.column_stack(
        [
            (np.arange(16) + 1) % 16,
            (np.arange(16) + 3) % 16,
            (np.arange(16) + 7) % 16,
        ]
    ).ravel().astype(np.int32)
    weights = np.tile(np.array([1.0, 0.6, 0.2]), 16)
    epochs = upstream_umap_.make_epochs_per_sample(weights, 15)
    state = np.array([-1_234_567, 987_654, -333], dtype=np.int64)
    expected = upstream_layouts.optimize_layout_euclidean(
        initial.copy(),
        initial.copy(),
        head,
        tail,
        15,
        16,
        epochs,
        1.57694346,
        0.89506088,
        state.copy(),
        move_other=True,
    )
    got = mojo_layouts.optimize_layout_euclidean(
        initial.copy(),
        initial.copy(),
        head,
        tail,
        15,
        16,
        epochs,
        1.57694346,
        0.89506088,
        state.copy(),
        move_other=True,
    )
    assert np.allclose(got, expected, atol=2e-4, rtol=2e-5)


def test_optimizer_transform_mode_matches_upstream():
    random = np.random.RandomState(5)
    head_embedding = random.normal(size=(7, 2)).astype(np.float32)
    tail_embedding = random.normal(size=(12, 2)).astype(np.float32)
    head = np.repeat(np.arange(7, dtype=np.int32), 2)
    tail = random.randint(0, 12, size=head.size).astype(np.int32)
    epochs = upstream_umap_.make_epochs_per_sample(
        np.linspace(0.2, 1.0, head.size), 20
    )
    state = np.array([12345, -67890, 24680], dtype=np.int64)
    expected = upstream_layouts.optimize_layout_euclidean(
        head_embedding.copy(),
        tail_embedding.copy(),
        head,
        tail,
        20,
        12,
        epochs,
        1.5,
        0.9,
        state.copy(),
        move_other=False,
    )
    got = mojo_layouts.optimize_layout_euclidean(
        head_embedding.copy(),
        tail_embedding.copy(),
        head,
        tail,
        20,
        12,
        epochs,
        1.5,
        0.9,
        state.copy(),
        move_other=False,
    )
    assert np.allclose(got, expected, atol=2e-4, rtol=2e-5)


def test_public_function_signatures_match_upstream():
    names = [
        "nearest_neighbors",
        "smooth_knn_dist",
        "compute_membership_strengths",
        "fuzzy_simplicial_set",
        "make_epochs_per_sample",
    ]
    for name in names:
        assert inspect.signature(getattr(mojo_umap_, name)) == inspect.signature(
            getattr(upstream_umap_, name)
        )
    assert inspect.signature(mojo_umap.UMAP) == inspect.signature(umap.UMAP)
    assert inspect.signature(mojo_umap.UMAP.fit) == inspect.signature(
        umap.UMAP.fit
    )
    assert inspect.signature(
        mojo_umap.UMAP.fit_transform
    ) == inspect.signature(umap.UMAP.fit_transform)
    assert inspect.signature(mojo_umap.UMAP.transform) == inspect.signature(
        umap.UMAP.transform
    )


def test_estimator_graph_and_embedding_quality_match_upstream():
    X, _ = make_blobs(
        n_samples=180,
        centers=5,
        n_features=8,
        cluster_std=1.4,
        random_state=12,
    )
    params = dict(
        n_neighbors=12,
        n_epochs=45,
        init="random",
        random_state=42,
    )
    indices, distances, _ = mojo_umap.nearest_neighbors(
        X, 12, "euclidean", {}, False, None
    )
    with warnings.catch_warnings():
        warnings.simplefilter("ignore", UserWarning)
        reference = umap.UMAP(
            **params,
            precomputed_knn=(indices, distances, None),
            force_approximation_algorithm=True,
        ).fit(X)
    model = mojo_umap.UMAP(**params).fit(X)
    graph_delta = (model.graph_ - reference.graph_).tocoo()
    assert (
        graph_delta.nnz == 0
        or np.max(np.abs(graph_delta.data)) < 4e-6
    )
    ref_score = trustworthiness(X, reference.embedding_, n_neighbors=7)
    got_score = trustworthiness(X, model.embedding_, n_neighbors=7)
    assert got_score >= ref_score - 0.03
    assert np.corrcoef(
        pdist(reference.embedding_), pdist(model.embedding_)
    )[0, 1] > 0.55


def test_estimator_is_reproducible_and_sklearn_shaped(points):
    params = dict(
        n_neighbors=10,
        n_components=3,
        n_epochs=25,
        init="random",
        random_state=8,
    )
    first = mojo_umap.UMAP(**params).fit_transform(points)
    second = mojo_umap.UMAP(**params).fit_transform(points)
    assert first.shape == (points.shape[0], 3)
    assert first.dtype == np.float32
    assert np.array_equal(first, second)
    estimator = mojo_umap.UMAP(**params)
    assert estimator.get_params()["n_neighbors"] == 10
    assert estimator.set_params(n_neighbors=11).n_neighbors == 11


def test_transform_is_finite_and_preserves_nearby_queries():
    X, labels = make_blobs(
        n_samples=150,
        centers=4,
        n_features=6,
        random_state=22,
    )
    model = mojo_umap.UMAP(
        n_neighbors=10,
        n_epochs=35,
        init="random",
        random_state=2,
    ).fit(X)
    queries = X[:8] + 1e-4
    transformed = model.transform(queries)
    assert transformed.shape == (8, 2)
    assert np.isfinite(transformed).all()
    nearest = cdist(transformed, model.embedding_).argmin(axis=1)
    assert np.mean(labels[nearest] == labels[:8]) >= 0.875


def test_default_spectral_usage_runs(points):
    embedding = mojo_umap.UMAP(
        n_neighbors=8,
        n_epochs=15,
        random_state=3,
    ).fit_transform(points[:60])
    assert embedding.shape == (60, 2)
    assert np.isfinite(embedding).all()


@pytest.mark.parametrize("init", ["pca", "explicit"])
def test_documented_initialization_modes_run(points, init):
    initial = (
        np.random.RandomState(9).normal(size=(60, 2)).astype(np.float32)
        if init == "explicit"
        else init
    )
    embedding = mojo_umap.UMAP(
        n_neighbors=8,
        n_epochs=15,
        init=initial,
        random_state=3,
    ).fit_transform(points[:60])
    assert embedding.shape == (60, 2)
    assert embedding.dtype == np.float32
    assert np.isfinite(embedding).all()


def test_unsupported_scope_fails_plainly(points):
    with pytest.raises(NotImplementedError, match="densMAP"):
        mojo_umap.UMAP(densmap=True).fit(points)
    with pytest.raises(NotImplementedError, match="metrics"):
        mojo_umap.UMAP(metric="hamming").fit(points)
    with pytest.raises(NotImplementedError, match="supervised"):
        mojo_umap.UMAP().fit(points, np.zeros(points.shape[0]))


def test_ffi_rejects_unsafe_shapes_ranges_and_narrowing(points):
    with pytest.raises(ValueError, match="row and column"):
        mojo_umap.smooth_knn_dist(np.empty((0, 3)), 3)
    with pytest.raises(OverflowError, match="int32"):
        mojo_umap.compute_membership_strengths(
            np.array([[0, 2**40]]),
            np.array([[0.0, 1.0]]),
            np.ones(1),
            np.zeros(1),
        )
    with pytest.raises(ValueError, match="out-of-range sample"):
        mojo_umap.fuzzy_simplicial_set(
            points[:2],
            2,
            None,
            "euclidean",
            knn_indices=np.array([[0, 2], [1, 0]]),
            knn_dists=np.array([[0.0, 1.0], [0.0, 1.0]]),
        )
    with pytest.raises(OverflowError, match="float32"):
        mojo_umap.smooth_knn_dist(np.array([[0.0, 1e100]]), 2)


def test_optimizer_rejects_out_of_bounds_indices():
    embedding = np.zeros((2, 2), dtype=np.float32)
    with pytest.raises(ValueError, match="head contains"):
        mojo_layouts.optimize_layout_euclidean(
            embedding,
            embedding,
            np.array([2]),
            np.array([0]),
            2,
            2,
            np.array([1.0]),
            1.5,
            0.9,
            np.array([1, 2, 3], dtype=np.int64),
        )
