"""ctypes loading for the compiled Mojo kernels."""

from __future__ import annotations

import ctypes
import os
import subprocess
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[2]
LIB = Path(os.environ.get("MOJO_UMAP_LIB", ROOT / "dist/libmojo-umap-learn.so"))
I = ctypes.c_int64
F = ctypes.c_double

_SIGNATURES = {
    "mum_exact_knn": ([I, I, I, I, I, I, I], None),
    "mum_query_knn": ([I, I, I, I, I, I, I, I, I], None),
    "mum_smooth_knn_dist": ([I, I, I, F, I, F, F, I, I], None),
    "mum_smooth_knn_dist_gpu": ([I, I, I, F, I, F, F, I, I], I),
    "mum_membership_strengths": ([I] * 12, None),
    "mum_make_epochs_per_sample": ([I, I, I, I], None),
    "mum_optimize_layout_euclidean": (
        [I] * 13 + [F, F, F, F, F, I],
        None,
    ),
}

_library: ctypes.CDLL | None = None


def build(force: bool = False) -> Path:
    source = ROOT / "src/umap.mojo"
    if (
        not force
        and LIB.exists()
        and LIB.stat().st_mtime >= source.stat().st_mtime
    ):
        return LIB
    if os.environ.get("MOJO_UMAP_LIB"):
        raise RuntimeError(f"MOJO_UMAP_LIB does not exist or is stale: {LIB}")
    subprocess.run(
        ["bash", str(ROOT / "build/build.sh")],
        cwd=ROOT,
        check=True,
        timeout=1800,
    )
    return LIB


def lib() -> ctypes.CDLL:
    global _library
    if _library is None:
        _library = ctypes.CDLL(str(build()))
        for name, (argtypes, restype) in _SIGNATURES.items():
            function = getattr(_library, name)
            function.argtypes = argtypes
            function.restype = restype
    return _library


def f64(values, *, copy: bool = False) -> np.ndarray:
    if copy:
        return np.array(values, dtype=np.float64, order="C", copy=True)
    return np.ascontiguousarray(values, dtype=np.float64)


def f32(values, *, copy: bool = False) -> np.ndarray:
    if copy:
        return np.array(values, dtype=np.float32, order="C", copy=True)
    return np.ascontiguousarray(values, dtype=np.float32)


def i64(values) -> np.ndarray:
    return np.ascontiguousarray(values, dtype=np.int64)


def addr(values: np.ndarray) -> int:
    return values.ctypes.data
