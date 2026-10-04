from std.math import exp, exp2

comptime SW = 8


@export("probe_range")
def probe_range(src_address: Int, e2_address: Int, e_address: Int) abi("C"):
    var src = UnsafePointer[Float64, AnyOrigin[mut=True]](unsafe_from_address=src_address)
    var e2 = UnsafePointer[Float64, AnyOrigin[mut=True]](unsafe_from_address=e2_address)
    var e = UnsafePointer[Float64, AnyOrigin[mut=True]](unsafe_from_address=e_address)
    var slot = 0
    while slot < 64:
        e2.store(slot, exp2(src.unsafe_load[width=SW](slot)))
        e.store(slot, exp(src.unsafe_load[width=SW](slot)))
        slot += SW