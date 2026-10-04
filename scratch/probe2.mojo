from std.math import exp, exp2, log2, floor
from std.sys.info import simd_width_of

comptime F32Ptr = UnsafePointer[Float32, AnyOrigin[mut=True]]
comptime LOG2E = Float32(1.4426950408889634)
comptime BIG = Float32(1.0e30)


@export("v_base")
def v_base(distances_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
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
    print("v_base", checksum)


@export("v_exp2")
def v_exp2(distances_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
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
            var acc = SIMD[DType.float32, W](0.0)
            while rank + W <= k_width:
                var delta = max(distances.unsafe_load[width=W](base + rank) - rho, Float32(0.0))
                acc += exp2(delta * (-LOG2E / mid))
                rank += W
            probability_sum = acc.reduce_add()
            while rank < k_width:
                var delta = distances[base + rank] - rho
                probability_sum += (exp2(delta * (-LOG2E / mid)) if delta > 0.0 else Float32(1.0))
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
    print("v_exp2", checksum)


@export("v_pad")
def v_pad(distances_address: Int, scratch_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
    var distances = F32Ptr(unsafe_from_address=distances_address)
    var scratch = F32Ptr(unsafe_from_address=scratch_address)
    comptime W = simd_width_of[DType.float64]()
    var padded = (k_width + W - 1) // W * W
    var r = k_width
    while r < padded:
        scratch[r] = BIG
        r += 1
    var checksum = Float32(0.0)
    for row in range(n):
        var base = row * k_width
        var rho = distances[base + 1]
        var rank = 0
        while rank < k_width:
            scratch[rank] = max(distances[base + rank] - rho, Float32(0.0))
            rank += 1
        var lo = Float32(0.0)
        var hi = Float32(3.4028234663852886e38)
        var mid = Float32(1.0)
        for iteration in range(n_iter):
            var factor = -LOG2E / mid
            var acc = SIMD[DType.float32, W](0.0)
            var offset = 0
            while offset < padded:
                acc += exp2(scratch.unsafe_load[width=W](offset) * factor)
                offset += W
            var probability_sum = acc.reduce_add()
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
    print("v_pad", checksum)


@export("v_pad8")
def v_pad8(distances_address: Int, scratch_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
    var distances = F32Ptr(unsafe_from_address=distances_address)
    var scratch = F32Ptr(unsafe_from_address=scratch_address)
    comptime W = 8
    var padded = (k_width + W - 1) // W * W
    var r = k_width
    while r < padded:
        scratch[r] = BIG
        r += 1
    var checksum = Float32(0.0)
    for row in range(n):
        var base = row * k_width
        var rho = distances[base + 1]
        var rank = 0
        while rank < k_width:
            scratch[rank] = max(distances[base + rank] - rho, Float32(0.0))
            rank += 1
        var lo = Float32(0.0)
        var hi = Float32(3.4028234663852886e38)
        var mid = Float32(1.0)
        for iteration in range(n_iter):
            var factor = -LOG2E / mid
            var acc = SIMD[DType.float32, W](0.0)
            var offset = 0
            while offset < padded:
                acc += exp2(scratch.unsafe_load[width=W](offset) * factor)
                offset += W
            var probability_sum = acc.reduce_add()
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
    print("v_pad8", checksum)