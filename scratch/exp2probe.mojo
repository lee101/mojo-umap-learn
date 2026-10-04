from std.math import exp2

comptime SW = 8


@export("probe_exp2b")
def probe_exp2b(src_address: Int, dst_address: Int) abi("C"):
    var src = UnsafePointer[Float64, AnyOrigin[mut=True]](unsafe_from_address=src_address)
    var dst = UnsafePointer[Float64, AnyOrigin[mut=True]](unsafe_from_address=dst_address)
    var factor = -1.44269504088896340736 / 1.0
    # exactly the solver's inner expression, loaded from memory
    var loaded = src.unsafe_load[width=SW](0)
    dst.store(0, loaded)
    dst.store(SW, SIMD[DType.float64, SW](factor))
    dst.store(2 * SW, loaded * SIMD[DType.float64, SW](factor))
    dst.store(3 * SW, exp2(loaded * SIMD[DType.float64, SW](factor)))
    # scalar equivalents
    dst.store(4 * SW, SIMD[DType.float64, 2](exp2(Float64(src[0]) * factor), exp2(Float64(src[1]))))