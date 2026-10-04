from std.math import exp2, log2

comptime SW = 8
comptime LOG2E = 1.44269504088896340736
comptime PAD_TERM = 1.0e45


@export("probe_scratch")
def probe_scratch(
    distances_address: Int,
    scratch_address: Int,
    n: Int,
    k_width: Int,
    out_address: Int,
) abi("C"):
    var distances = UnsafePointer[Float32, AnyOrigin[mut=True]](unsafe_from_address=distances_address)
    var scratch = UnsafePointer[Float64, AnyOrigin[mut=True]](unsafe_from_address=scratch_address)
    var out = UnsafePointer[Float64, AnyOrigin[mut=True]](unsafe_from_address=out_address)
    var term_count = k_width - 1
    var padded = (term_count + SW - 1) // SW * SW
    var pad = term_count
    while pad < padded:
        scratch[pad] = PAD_TERM
        pad += 1
    var row = 0
    var base = row * k_width
    var rho = distances[base + 1]
    var row_mean = Float64(distances[base])
    var offset = 0
    while offset + SW <= term_count:
        var terms = distances.unsafe_load[width=SW](base + 1 + offset)
        row_mean += Float64(terms.reduce_add())
        scratch.store(
            offset,
            SIMD[DType.float64, SW](max(terms - rho, SIMD[DType.float32, SW](0.0))),
        )
        offset += SW
    while offset < term_count:
        var term = distances[base + 1 + offset]
        row_mean += Float64(term)
        scratch[offset] = Float64(max(term - rho, Float32(0.0)))
        offset += 1
    # dump scratch and psum at mid=1
    var i = 0
    while i < padded:
        out[i] = scratch[i]
        i += 1
    var factor = -LOG2E / 1.0
    var accumulator = SIMD[DType.float64, SW](0.0)
    var slot = 0
    while slot < padded:
        accumulator += exp2(scratch.unsafe_load[width=SW](slot) * factor)
        slot += SW
    out[padded] = accumulator.reduce_add()
    out[padded + 1] = row_mean