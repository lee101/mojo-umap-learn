from std.math import exp2

comptime SW = 8


@export("probe_widen")
def probe_widen(src_address: Int, dst_address: Int) abi("C"):
    var src = UnsafePointer[Float32, AnyOrigin[mut=True]](unsafe_from_address=src_address)
    var dst = UnsafePointer[Float64, AnyOrigin[mut=True]](unsafe_from_address=dst_address)
    var terms = src.unsafe_load[width=SW](0)
    var a = SIMD[DType.float64, SW](terms)
    var b = terms.cast[DType.float64]()
    dst.store(0, a)
    dst.store(SW, b)
    var factor = -1.44269504088896340736 / 2.0
    dst.store(2 * SW, exp2(SIMD[DType.float64, SW](0.5) * SIMD[DType.float64, SW](factor)))