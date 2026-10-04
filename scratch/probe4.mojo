from std.math import exp2, log2
from std.sys.info import simd_width_of

comptime F32Ptr = UnsafePointer[Float32, AnyOrigin[mut=True]]
comptime F64Ptr = UnsafePointer[Float64, AnyOrigin[mut=True]]
comptime PAD = Float32(1.0e30)
comptime PAD64 = Float64(1.0e30)
comptime FLOOR = Float64(-1.0e30)


@export("a_f32w8")
def a_f32w8(distances_address: Int, scratch_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
    var distances = F32Ptr(unsafe_from_address=distances_address)
    var scratch = F32Ptr(unsafe_from_address=scratch_address)
    comptime W = 8
    var padded = (k_width - 1 + W - 1) // W * W
    var pad = k_width - 1
    while pad < padded:
        scratch[pad] = PAD
        pad += 1
    var checksum = Float32(0.0)
    for row in range(n):
        var base = row * k_width
        var rho = distances[base + 1]
        var rank = 0
        while rank < k_width - 1:
            scratch[rank] = max(distances[base + 1 + rank] - rho, Float32(0.0))
            rank += 1
        var lo = Float32(0.0)
        var hi = Float32(3.4028234663852886e38)
        var mid = Float32(1.0)
        for iteration in range(n_iter):
            var factor = Float32(-1.4426950408889634) / mid
            var accumulator = SIMD[DType.float32, W](0.0)
            var slot = 0
            while slot < padded:
                accumulator += exp2(max(scratch.unsafe_load[width=W](slot) * factor, Float32(-1.0e30)))
                slot += W
            var probability_sum = accumulator.reduce_add()
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
    print("a_f32w8", checksum)


@export("c_f64")
def c_f64(distances_address: Int, scratch_address: Int, n: Int, k_width: Int, target: Float32, n_iter: Int) abi("C"):
    var distances = F32Ptr(unsafe_from_address=distances_address)
    var scratch = F64Ptr(unsafe_from_address=scratch_address)
    comptime W = simd_width_of[DType.float64]()
    var padded = (k_width - 1 + W - 1) // W * W
    var pad = k_width - 1
    while pad < padded:
        scratch[pad] = PAD64
        pad += 1
    var checksum = Float32(0.0)
    for row in range(n):
        var base = row * k_width
        var rho = distances[base + 1]
        var rank = 0
        while rank < k_width - 1:
            scratch[rank] = max(Float64(distances[base + 1 + rank] - rho), 0.0)
            rank += 1
        var lo = Float32(0.0)
        var hi = Float32(3.4028234663852886e38)
        var mid = Float32(1.0)
        for iteration in range(n_iter):
            var factor = Float64(-1.4426950408889634073599) / Float64(mid)
            var accumulator = SIMD[DType.float64, W](0.0)
            var slot = 0
            while slot < padded:
                accumulator += exp2(max(scratch.unsafe_load[width=W](slot) * factor, FLOOR))
                slot += W
            var probability_sum = Float32(accumulator.reduce_add())
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
    print("c_f64", checksum)