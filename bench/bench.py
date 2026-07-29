"""Measured kernel and end-to-end comparisons against umap-learn."""

from __future__ import annotations

import math
import os
import platform
import sys
import time

import numpy as np

sys.path.insert(
    0,
    os.path.join(
        os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
        "python",
    ),
)

import mojo_umap
import mojo_umap.layouts as mojo_layouts
import umap
import umap.layouts as upstream_layouts
import umap.umap_ as upstream_umap_


def timeit(function, repeat=3):
    best = math.inf
    for _ in range(repeat):
        start = time.perf_counter()
        function()
        best = min(best, time.perf_counter() - start)
    return best


def machine_name():
    try:
        with open("/proc/cpuinfo", encoding="utf-8") as handle:
            for line in handle:
                if line.startswith("model name"):
                    return line.split(":", 1)[1].strip()
    except OSError:
        pass
    return platform.processor() or platform.machine()


def report(name, mojo_seconds, upstream_seconds, note=""):
    ratio = upstream_seconds / mojo_seconds
    result = "faster" if ratio >= 1.0 else "slower"
    suffix = f"; {note}" if note else ""
    print(
        f"| {name} | {mojo_seconds * 1e3:.2f} | "
        f"{upstream_seconds * 1e3:.2f} | {ratio:.2f}x | "
        f"{result}{suffix} |"
    )


def main():
    random = np.random.default_rng(0)
    sample_count = 250_000
    neighbor_count = 15
    increments = random.exponential(
        scale=0.2, size=(sample_count, neighbor_count - 1)
    ).astype(np.float32)
    distances = np.column_stack(
        [
            np.zeros(sample_count, dtype=np.float32),
            np.cumsum(increments, axis=1),
        ]
    )
    indices = np.empty((sample_count, neighbor_count), dtype=np.int32)
    indices[:, 0] = np.arange(sample_count, dtype=np.int32)
    indices[:, 1:] = random.integers(
        0,
        sample_count,
        size=(sample_count, neighbor_count - 1),
        dtype=np.int32,
    )

    upstream_umap_.smooth_knn_dist(distances[:16], 15.0)
    mojo_umap.smooth_knn_dist(distances[:16], 15.0)
    sigmas, rhos = upstream_umap_.smooth_knn_dist(distances, 15.0)
    upstream_umap_.compute_membership_strengths(
        indices[:16],
        distances[:16],
        sigmas[:16],
        rhos[:16],
    )
    mojo_umap.compute_membership_strengths(
        indices[:16],
        distances[:16],
        sigmas[:16],
        rhos[:16],
    )

    smooth_mojo = timeit(
        lambda: mojo_umap.smooth_knn_dist(distances, 15.0)
    )
    smooth_gpu = None
    previous_device = os.environ.get("MOJO_UMAP_DEVICE")
    os.environ["MOJO_UMAP_DEVICE"] = "gpu"
    if mojo_umap.umap_._gpu_has_headroom():
        mojo_umap.smooth_knn_dist(distances, 15.0)
        smooth_gpu = timeit(
            lambda: mojo_umap.smooth_knn_dist(distances, 15.0)
        )
    if previous_device is None:
        os.environ.pop("MOJO_UMAP_DEVICE", None)
    else:
        os.environ["MOJO_UMAP_DEVICE"] = previous_device
    smooth_upstream = timeit(
        lambda: upstream_umap_.smooth_knn_dist(distances, 15.0)
    )
    membership_mojo = timeit(
        lambda: mojo_umap.compute_membership_strengths(
            indices, distances, sigmas, rhos
        )
    )
    membership_upstream = timeit(
        lambda: upstream_umap_.compute_membership_strengths(
            indices, distances, sigmas, rhos
        )
    )

    graph_n = 60_000
    graph_indices = indices[:graph_n].copy()
    graph_indices[:, 1:] %= graph_n
    graph_args = (
        np.empty((graph_n, 1), dtype=np.float32),
        neighbor_count,
        np.random.RandomState(1),
        "euclidean",
        {},
        graph_indices,
        distances[:graph_n],
    )
    mojo_umap.fuzzy_simplicial_set(*graph_args)
    upstream_umap_.fuzzy_simplicial_set(*graph_args)
    graph_mojo = timeit(
        lambda: mojo_umap.fuzzy_simplicial_set(*graph_args)
    )
    graph_upstream = timeit(
        lambda: upstream_umap_.fuzzy_simplicial_set(*graph_args)
    )

    vertices = 6_000
    edges = 80_000
    embedding = random.uniform(0, 10, size=(vertices, 2)).astype(np.float32)
    head = random.integers(0, vertices, size=edges, dtype=np.int32)
    tail = random.integers(0, vertices, size=edges, dtype=np.int32)
    weights = random.uniform(0.05, 1.0, size=edges)
    epochs_per_sample = upstream_umap_.make_epochs_per_sample(weights, 50)
    state = np.array([-1_234_567, 987_654, -333], dtype=np.int64)

    def mojo_optimize():
        values = embedding.copy()
        return mojo_layouts.optimize_layout_euclidean(
            values,
            values,
            head,
            tail,
            50,
            vertices,
            epochs_per_sample,
            1.57694346,
            0.89506088,
            state.copy(),
            move_other=True,
        )

    def upstream_optimize():
        values = embedding.copy()
        return upstream_layouts.optimize_layout_euclidean(
            values,
            values,
            head,
            tail,
            50,
            vertices,
            epochs_per_sample,
            1.57694346,
            0.89506088,
            state.copy(),
            move_other=True,
        )

    mojo_optimize()
    upstream_optimize()
    optimize_mojo = timeit(mojo_optimize)
    optimize_upstream = timeit(upstream_optimize)

    neighbor_data = random.normal(size=(3_000, 20))
    mojo_umap.nearest_neighbors(
        neighbor_data, 15, "euclidean", {}, False, np.random.RandomState(2)
    )
    upstream_umap_.nearest_neighbors(
        neighbor_data,
        15,
        "euclidean",
        {},
        False,
        np.random.RandomState(2),
    )
    exact_indices = mojo_umap.nearest_neighbors(
        neighbor_data, 15, "euclidean", {}, False, None
    )[0]
    approximate_indices = upstream_umap_.nearest_neighbors(
        neighbor_data,
        15,
        "euclidean",
        {},
        False,
        np.random.RandomState(2),
    )[0]
    recall = np.mean(
        [
            len(set(left) & set(right)) / 15.0
            for left, right in zip(exact_indices, approximate_indices)
        ]
    )
    neighbors_mojo = timeit(
        lambda: mojo_umap.nearest_neighbors(
            neighbor_data, 15, "euclidean", {}, False, None
        )
    )
    neighbors_upstream = timeit(
        lambda: upstream_umap_.nearest_neighbors(
            neighbor_data,
            15,
            "euclidean",
            {},
            False,
            np.random.RandomState(2),
        )
    )

    print(f"Machine: {machine_name()}; {os.cpu_count()} logical CPUs")
    print(f"Python: {platform.python_version()}; umap-learn: {umap.__version__}")
    print()
    print("| case | Mojo (ms) | umap-learn (ms) | ratio | result |")
    print("| --- | ---: | ---: | ---: | --- |")
    report("smooth_knn_dist (250k x 15)", smooth_mojo, smooth_upstream)
    if smooth_gpu is not None:
        report(
            "smooth_knn_dist GPU (250k x 15)",
            smooth_gpu,
            smooth_upstream,
            "opt-in via MOJO_UMAP_DEVICE=gpu",
        )
    report(
        "compute_membership_strengths (3.75M edges)",
        membership_mojo,
        membership_upstream,
    )
    report(
        "fuzzy_simplicial_set (60k x 15 supplied k-NN)",
        graph_mojo,
        graph_upstream,
    )
    report(
        "optimize_layout_euclidean (6k, 80k edges, 50 epochs)",
        optimize_mojo,
        optimize_upstream,
    )
    report(
        "nearest_neighbors (3k x 20, k=15)",
        neighbors_mojo,
        neighbors_upstream,
        f"exact vs approximate, recall {recall:.3f}",
    )


if __name__ == "__main__":
    main()
