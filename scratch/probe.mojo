from std.math import exp, exp2, log2, floor
from std.sys.info import simd_width_of
from std.time import sleep

comptime F32Ptr = UnsafePointer[Float32, AnyOrigin[mut=True]]

@export("probe_exp")
def probe_exp(distances_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
    var distances = F32Ptr(unsafe_from_address=distances_address)
    comptime W = simd_width_of[DType.float64]()
    var checksum = Float32(0.0)
    for row in range(n):
        var base = row * k_width
        var rho = distances[base + 1]
        var lo = Float32(0.0)
        var hi = Float32(3.4028234663852886e38)
        var mid = Float32(1.0)
        for iteration in range(n_iter):
            var probability_sum = Float32(0.0)
            var rank = 1
            while rank + W <= k_width:
                var delta = max(distances.unsafe_load[width=W](base + rank) - rho, Float32(0.0))
                probability_sum += exp(-(delta / mid)).reduce_add()
                rank += W
            while rank < k_width:
                var delta = distances[base + rank] - rho
                probability_sum += (exp(-(delta / mid)) if delta > 0.0 else Float32(1.0))
                rank += 1
            if abs(probability_sum - target) < 1.0e-5:
                break
            if probability_sum > target:
                hi = mid
                mid = (lo + hi) / 2.0
            else:
                lo = mid
                if hi >= Float32(3.4028234663852886e38):
                    mid *= 2.0
                else:
                    mid = (lo + hi) / 2.0
        checksum += mid
    print("checksum exp", checksum)

@export("probe_exp2")
def probe_exp2(distances_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
    var distances = F32Ptr(unsafe_from_address=distances_address)
    comptime W = simd_width_of[DType.float64]()
    var checksum = Float32(0.0)
    var scale = Float32(1.4426950408889634)
    for row in range(n):
        var base = row * k_width
        var rho = distances[base + 1]
        var lo = Float32(0.0)
        var hi = Float32(3.4028234663852886e38)
        var mid = Float32(1.0)
        for iteration in range(n_iter):
            var probability_sum = Float32(0.0)
            var rank = 1
            while rank + W <= k_width:
                var delta = max(distances.unsafe_load[width=W](base + rank) - rho, Float32(0.0))
                probability_sum += exp2(delta * (scale * (-1.0 / mid))).reduce_add()
                rank += W
            while rank < k_width:
                var delta = distances[base + rank] - rho
                probability_sum += (exp2(delta * (scale * (-1.0 / mid))) if delta > 0.0 else Float32(1.0))
                rank += 1
            if abs(probability_sum - target) < 1.0e-5:
                break
            if probability_sum > target:
                hi = mid
                mid = (lo + hi) / 2.0
            else:
                lo = mid
                if hi >= Float32(3.4028234663852886e38):
                    mid *= 2.0
                else:
                    mid = (lo + hi) / 2.0
        checksum += mid
    print("checksum exp2", checksum)

@export("probe_serial")
def probe_serial(distances_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
    var distances = F32Ptr(unsafe_from_address=distances_address)
    var checksum = Float32(0.0)
    for row in range(n):
        var base = row * k_width
        var rho = distances[base + 1]
        var lo = Float32(0.0)
        var hi = Float32(3.4028234663852886e38)
        var mid = Float32(1.0)
        for iteration in range(n_iter):
            var probability_sum = Float32(0.0)
            for rank in range(1, k_width):
                var delta = distances[base + rank] - rho
                if delta > 0.0:
                    probability_sum += exp(-(delta / mid))
            if abs(probability_sum - target) < 1.0e-5:
                break
            if probability_sum > target:
                hi = mid
                mid = (lo + hi) / 2.0
            else:
                lo = mid
                if hi >= Float32(3.4028234663852886e38):
                    mid *= 2.0
                else:
                    mid = (lo + hi) / 2.0
        checksum += mid
    print("checksum serial", checksum)

