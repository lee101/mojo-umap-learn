from std.math import exp, exp2, log2
from std.sys.info import simd_width_of

comptime F32Ptr = UnsafePointer[Float32, AnyOrigin[mut=True]]
comptime LOG2E = Float32(1.4426950408889634)
comptime BIG = Float32(1.0e30)


@export("w_pad8")
def w_pad8(distances_address: Int, scratch_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
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
    print("w_pad8", checksum)


@export("w_pad8_fill")
def w_pad8_fill(distances_address: Int, scratch_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
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
        while rank + W <= k_width:
            scratch.store(rank, max(distances.unsafe_load[width=W](base + rank) - rho, SIMD[DType.float32, W](0.0)))
            rank += W
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
    print("w_pad8_fill", checksum)


@export("w_pad16")
def w_pad16(distances_address: Int, scratch_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
    var distances = F32Ptr(unsafe_from_address=distances_address)
    var scratch = F32Ptr(unsafe_from_address=scratch_address)
    comptime W = 16
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
    print("w_pad16", checksum)


@export("w_pad4")
def w_pad4(distances_address: Int, scratch_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
    var distances = F32Ptr(unsafe_from_address=distances_address)
    var scratch = F32Ptr(unsafe_from_address=scratch_address)
    comptime W = 4
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
    print("w_pad4", checksum)