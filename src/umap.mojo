"""Compute kernels for exact UMAP graph construction and Euclidean embedding."""

from std.algorithm import sync_parallelize
from std.gpu import global_idx
from std.gpu.host import DeviceContext
from std.math import exp, floor, log2, pow, sqrt
from std.sys.info import simd_width_of

comptime Ptr = UnsafePointer[Float64, AnyOrigin[mut=True]]
comptime F32Ptr = UnsafePointer[Float32, AnyOrigin[mut=True]]
comptime IPtr = UnsafePointer[Int64, AnyOrigin[mut=True]]
comptime I32Ptr = UnsafePointer[Int32, AnyOrigin[mut=True]]
comptime INF = 1.7976931348623157e308


def fp(address: Int) -> Ptr:
    return Ptr(unsafe_from_address=address)


def f32p(address: Int) -> F32Ptr:
    return F32Ptr(unsafe_from_address=address)


def ip(address: Int) -> IPtr:
    return IPtr(unsafe_from_address=address)


def i32p(address: Int) -> I32Ptr:
    return I32Ptr(unsafe_from_address=address)


def smooth_knn_gpu_kernel(
    distances: F32Ptr,
    n: Int,
    k_width: Int,
    target: Float32,
    n_iter: Int,
    local_connectivity: Float32,
    mean_distances: Float32,
    sigmas: F32Ptr,
    rhos: F32Ptr,
):
    var row = global_idx.x
    if row >= n:
        return
    var base = row * k_width
    var first_nonzero = k_width
    for rank in range(k_width):
        if distances[base + rank] > 0.0:
            first_nonzero = rank
            break
    var nonzero_count = k_width - first_nonzero
    var rho = Float32(0.0)
    if Float32(nonzero_count) >= local_connectivity:
        var index = Int(floor(Float64(local_connectivity)))
        var interpolation = local_connectivity - Float32(index)
        if index > 0:
            rho = distances[base + first_nonzero + index - 1]
            if interpolation > 1.0e-5 and index < nonzero_count:
                rho += interpolation * (
                    distances[base + first_nonzero + index]
                    - distances[base + first_nonzero + index - 1]
                )
        elif nonzero_count > 0:
            rho = interpolation * distances[base + first_nonzero]
    elif nonzero_count > 0:
        rho = distances[base + k_width - 1]
    rhos[row] = rho

    var lo = Float32(0.0)
    var hi = Float32(3.4028234663852886e38)
    var mid = Float32(1.0)
    for iteration in range(n_iter):
        var probability_sum = Float32(0.0)
        for rank in range(1, k_width):
            var delta = distances[base + rank] - rho
            probability_sum += (
                exp(-(delta / mid)) if delta > 0.0 else Float32(1.0)
            )
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

    var minimum_scale = Float32(0.0)
    if rho > 0.0:
        var row_mean = Float32(0.0)
        for rank in range(k_width):
            row_mean += distances[base + rank]
        minimum_scale = 1.0e-3 * row_mean / Float32(k_width)
    else:
        minimum_scale = 1.0e-3 * mean_distances
    sigmas[row] = max(mid, minimum_scale)


@always_inline
def metric_distance(a: Ptr, b: Ptr, d: Int, metric: Int) -> Float64:
    if metric == 1:
        var total = 0.0
        for col in range(d):
            total += abs(a[col] - b[col])
        return total

    if metric == 2:
        var product = 0.0
        var norm_a = 0.0
        var norm_b = 0.0
        for col in range(d):
            product += a[col] * b[col]
            norm_a += a[col] * a[col]
            norm_b += b[col] * b[col]
        if norm_a == 0.0 and norm_b == 0.0:
            return 0.0
        if norm_a == 0.0 or norm_b == 0.0:
            return 1.0
        return 1.0 - product / sqrt(norm_a * norm_b)

    var squared = 0.0
    for col in range(d):
        var delta = a[col] - b[col]
        squared += delta * delta
    return sqrt(squared)


@always_inline
def insert_neighbor(
    indices: IPtr,
    distances: Ptr,
    base: Int,
    k: Int,
    distance: Float64,
    neighbor: Int,
):
    if distance >= distances[base + k - 1]:
        return
    var position = k - 1
    while position > 0 and distance < distances[base + position - 1]:
        distances[base + position] = distances[base + position - 1]
        indices[base + position] = indices[base + position - 1]
        position -= 1
    distances[base + position] = distance
    indices[base + position] = Int64(neighbor)


@export("mum_exact_knn")
def mum_exact_knn(
    x_address: Int,
    n: Int,
    d: Int,
    k: Int,
    metric: Int,
    indices_address: Int,
    distances_address: Int,
) abi("C"):
    var x = fp(x_address)
    var indices = ip(indices_address)
    var distances = fp(distances_address)

    @parameter
    def compute_row(row: Int):
        var base = row * k
        for rank in range(k):
            indices[base + rank] = -1
            distances[base + rank] = INF
        for other in range(n):
            var distance = metric_distance(x + row * d, x + other * d, d, metric)
            insert_neighbor(indices, distances, base, k, distance, other)

    if n >= 128:
        sync_parallelize[compute_row](n)
    else:
        for row in range(n):
            compute_row(row)


@export("mum_query_knn")
def mum_query_knn(
    train_address: Int,
    query_address: Int,
    n: Int,
    m: Int,
    d: Int,
    k: Int,
    metric: Int,
    indices_address: Int,
    distances_address: Int,
) abi("C"):
    var train = fp(train_address)
    var query = fp(query_address)
    var indices = ip(indices_address)
    var distances = fp(distances_address)

    @parameter
    def compute_row(row: Int):
        var base = row * k
        for rank in range(k):
            indices[base + rank] = -1
            distances[base + rank] = INF
        for other in range(n):
            var distance = metric_distance(
                query + row * d, train + other * d, d, metric
            )
            insert_neighbor(indices, distances, base, k, distance, other)

    if m >= 128:
        sync_parallelize[compute_row](m)
    else:
        for row in range(m):
            compute_row(row)


@export("mum_smooth_knn_dist")
def mum_smooth_knn_dist(
    distances_address: Int,
    n: Int,
    k_width: Int,
    k_target: Float64,
    n_iter: Int,
    local_connectivity: Float64,
    bandwidth: Float64,
    sigmas_address: Int,
    rhos_address: Int,
) abi("C"):
    var distances = f32p(distances_address)
    var sigmas = f32p(sigmas_address)
    var rhos = f32p(rhos_address)
    comptime W = simd_width_of[DType.float64]()
    var mean_distances = Float32(0.0)
    var element_count = n * k_width
    var needs_mean_distances = local_connectivity <= 0.0
    if not needs_mean_distances:
        for row in range(n):
            if distances[row * k_width + k_width - 1] <= 0.0:
                needs_mean_distances = True
                break
    if needs_mean_distances:
        var offset = 0
        while offset + W <= element_count:
            mean_distances += (
                distances.load[width=W](offset).reduce_add()
            )
            offset += W
        while offset < element_count:
            mean_distances += distances[offset]
            offset += 1
        mean_distances /= Float32(element_count)
    var target = Float32(log2(k_target) * bandwidth)

    @parameter
    def compute_row(row: Int):
        var base = row * k_width
        var first_nonzero = k_width
        for rank in range(k_width):
            if distances[base + rank] > 0.0:
                first_nonzero = rank
                break
        var nonzero_count = k_width - first_nonzero
        var rho = Float32(0.0)
        if Float64(nonzero_count) >= local_connectivity:
            var index = Int(floor(local_connectivity))
            var interpolation = Float32(
                local_connectivity - Float64(index)
            )
            if index > 0:
                rho = distances[base + first_nonzero + index - 1]
                if interpolation > 1.0e-5 and index < nonzero_count:
                    rho += interpolation * (
                        distances[base + first_nonzero + index]
                        - distances[base + first_nonzero + index - 1]
                    )
            elif nonzero_count > 0:
                rho = interpolation * distances[base + first_nonzero]
        elif nonzero_count > 0:
            rho = distances[base + k_width - 1]
        rhos[row] = rho

        var lo = Float32(0.0)
        var hi = Float32(3.4028234663852886e38)
        var mid = Float32(1.0)
        for iteration in range(n_iter):
            var probability_sum = Float32(0.0)
            var rank = 1
            while rank + W <= k_width:
                var delta = max(
                    distances.load[width=W](base + rank) - rho,
                    Float32(0.0),
                )
                probability_sum += exp(-(delta / mid)).reduce_add()
                rank += W
            while rank < k_width:
                var delta = distances[base + rank] - rho
                probability_sum += (
                    exp(-(delta / mid)) if delta > 0.0 else Float32(1.0)
                )
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

        var minimum_scale = Float32(0.0)
        if rho > 0.0:
            var row_mean = Float32(0.0)
            var rank = 0
            while rank + W <= k_width:
                row_mean += (
                    distances.load[width=W](base + rank).reduce_add()
                )
                rank += W
            while rank < k_width:
                row_mean += distances[base + rank]
                rank += 1
            minimum_scale = 1.0e-3 * row_mean / Float32(k_width)
        else:
            minimum_scale = 1.0e-3 * mean_distances
        sigmas[row] = max(mid, minimum_scale)

    if n >= 128:
        var tasks = min(n, 256)

        @parameter
        def compute_chunk(task: Int):
            var start = task * n // tasks
            var stop = (task + 1) * n // tasks
            for row in range(start, stop):
                compute_row(row)

        sync_parallelize[compute_chunk](tasks)
    else:
        for row in range(n):
            compute_row(row)


@export("mum_smooth_knn_dist_gpu")
def mum_smooth_knn_dist_gpu(
    distances_address: Int,
    n: Int,
    k_width: Int,
    k_target: Float64,
    n_iter: Int,
    local_connectivity: Float64,
    bandwidth: Float64,
    sigmas_address: Int,
    rhos_address: Int,
) abi("C") -> Int:
    var element_count = n * k_width
    if (
        n <= 0
        or k_width <= 0
        or element_count * 4 + n * 8 > 1_900_000_000
    ):
        return 0
    try:
        var distances = f32p(distances_address)
        var sigmas = f32p(sigmas_address)
        var rhos = f32p(rhos_address)
        var mean_distances = Float32(0.0)
        comptime W = simd_width_of[DType.float64]()
        var offset = 0
        while offset + W <= element_count:
            mean_distances += (
                distances.load[width=W](offset).reduce_add()
            )
            offset += W
        while offset < element_count:
            mean_distances += distances[offset]
            offset += 1
        mean_distances /= Float32(element_count)

        with DeviceContext() as ctx:
            var device_distances = (
                ctx.enqueue_create_buffer[DType.float32](element_count)
            )
            var device_sigmas = ctx.enqueue_create_buffer[DType.float32](n)
            var device_rhos = ctx.enqueue_create_buffer[DType.float32](n)
            ctx.enqueue_copy(device_distances, distances)
            ctx.enqueue_function[smooth_knn_gpu_kernel](
                device_distances,
                n,
                k_width,
                Float32(log2(k_target) * bandwidth),
                n_iter,
                Float32(local_connectivity),
                mean_distances,
                device_sigmas,
                device_rhos,
                grid_dim=(n + 255) // 256,
                block_dim=256,
            )
            ctx.enqueue_copy(sigmas, device_sigmas)
            ctx.enqueue_copy(rhos, device_rhos)
            ctx.synchronize()
        return 1
    except:
        return 0


@export("mum_membership_strengths")
def mum_membership_strengths(
    indices_address: Int,
    distances_address: Int,
    sigmas_address: Int,
    rhos_address: Int,
    n: Int,
    k: Int,
    bipartite: Int,
    rows_address: Int,
    cols_address: Int,
    values_address: Int,
    edge_distances_address: Int,
    write_distances: Int,
) abi("C"):
    var indices = i32p(indices_address)
    var distances = f32p(distances_address)
    var sigmas = f32p(sigmas_address)
    var rhos = f32p(rhos_address)
    var rows = i32p(rows_address)
    var cols = i32p(cols_address)
    var values = f32p(values_address)
    var edge_distances = f32p(edge_distances_address)

    @parameter
    def compute_row(row: Int):
        for rank in range(k):
            var offset = row * k + rank
            var neighbor = indices[offset]
            if neighbor == -1:
                rows[offset] = 0
                cols[offset] = 0
                values[offset] = 0.0
                if write_distances != 0:
                    edge_distances[offset] = 0.0
                continue
            var value = Float32(0.0)
            if bipartite == 0 and neighbor == Int32(row):
                value = Float32(0.0)
            elif distances[offset] - rhos[row] <= 0.0 or sigmas[row] == 0.0:
                value = Float32(1.0)
            else:
                value = Float32(
                    exp(
                        -Float64(
                            (distances[offset] - rhos[row]) / sigmas[row]
                        )
                    )
                )
            rows[offset] = Int32(row)
            cols[offset] = neighbor
            values[offset] = value
            if write_distances != 0:
                edge_distances[offset] = distances[offset]

    if n >= 128:
        var tasks = min(n, 256)

        @parameter
        def compute_chunk(task: Int):
            var start = task * n // tasks
            var stop = (task + 1) * n // tasks
            for row in range(start, stop):
                compute_row(row)

        sync_parallelize[compute_chunk](tasks)
    else:
        for row in range(n):
            compute_row(row)


@export("mum_make_epochs_per_sample")
def mum_make_epochs_per_sample(
    weights_address: Int,
    edge_count: Int,
    n_epochs: Int,
    result_address: Int,
) abi("C"):
    var weights = fp(weights_address)
    var result = fp(result_address)
    var maximum = 0.0
    for edge in range(edge_count):
        maximum = max(maximum, weights[edge])
    for edge in range(edge_count):
        result[edge] = -1.0
        if weights[edge] > 0.0 and maximum > 0.0:
            result[edge] = maximum / weights[edge]


@always_inline
def tau_rand_int(states: IPtr, base: Int) -> Int:
    var s0 = states[base]
    var s1 = states[base + 1]
    var s2 = states[base + 2]
    s0 = (((s0 & 4294967294) << 12) & 4294967295) ^ (
        (((s0 << 13) & 4294967295) ^ s0) >> 19
    )
    s1 = (((s1 & 4294967288) << 4) & 4294967295) ^ (
        (((s1 << 2) & 4294967295) ^ s1) >> 25
    )
    s2 = (((s2 & 4294967280) << 17) & 4294967295) ^ (
        (((s2 << 3) & 4294967295) ^ s2) >> 11
    )
    states[base] = s0
    states[base + 1] = s1
    states[base + 2] = s2
    return Int(Int32(s0 ^ s1 ^ s2))


@always_inline
def clip(value: Float64) -> Float64:
    return min(4.0, max(-4.0, value))


@always_inline
def squared_distance(
    embedding: F32Ptr, left: Int, right: Int, dim: Int
) -> Float32:
    var total = Float32(0.0)
    for component in range(dim):
        var delta = (
            embedding[left * dim + component]
            - embedding[right * dim + component]
        )
        total += delta * delta
    return total


@export("mum_optimize_layout_euclidean")
def mum_optimize_layout_euclidean(
    head_embedding_address: Int,
    tail_embedding_address: Int,
    head_address: Int,
    tail_address: Int,
    epochs_per_sample_address: Int,
    rng_states_address: Int,
    epoch_of_next_sample_address: Int,
    epoch_of_next_negative_sample_address: Int,
    edge_count: Int,
    head_vertices: Int,
    tail_vertices: Int,
    dim: Int,
    n_epochs: Int,
    a: Float64,
    b: Float64,
    gamma: Float64,
    initial_alpha: Float64,
    negative_sample_rate: Float64,
    move_other: Int,
) abi("C"):
    var head_embedding = f32p(head_embedding_address)
    var tail_embedding = f32p(tail_embedding_address)
    var head = i32p(head_address)
    var tail = i32p(tail_address)
    var epochs_per_sample = fp(epochs_per_sample_address)
    var rng_states = ip(rng_states_address)
    var epoch_of_next_sample = fp(epoch_of_next_sample_address)
    var epoch_of_next_negative_sample = fp(
        epoch_of_next_negative_sample_address
    )
    var alpha = initial_alpha

    for epoch in range(n_epochs):
        for edge in range(edge_count):
            if epoch_of_next_sample[edge] > Float64(epoch):
                continue
            var j = Int(head[edge])
            var k = Int(tail[edge])
            var head_base = j * dim
            var tail_base = k * dim
            var dist_squared = Float64(0.0)
            if dim == 2:
                var delta0 = (
                    head_embedding[head_base] - tail_embedding[tail_base]
                )
                var delta1 = (
                    head_embedding[head_base + 1]
                    - tail_embedding[tail_base + 1]
                )
                dist_squared = Float64(
                    delta0 * delta0 + delta1 * delta1
                )
            elif head_embedding_address == tail_embedding_address:
                dist_squared = Float64(
                    squared_distance(head_embedding, j, k, dim)
                )
            else:
                dist_squared = Float64(
                    squared_distance_separate(
                        head_embedding, tail_embedding, j, k, dim
                    )
                )
            var grad_coeff = 0.0
            if dist_squared > 0.0:
                var powered_distance = pow(dist_squared, b)
                grad_coeff = (
                    -2.0 * a * b * powered_distance
                    / (dist_squared * (a * powered_distance + 1.0))
                )
            if dim == 2:
                var grad0 = clip(
                    grad_coeff
                    * Float64(
                        head_embedding[head_base]
                        - tail_embedding[tail_base]
                    )
                )
                var grad1 = clip(
                    grad_coeff
                    * Float64(
                        head_embedding[head_base + 1]
                        - tail_embedding[tail_base + 1]
                    )
                )
                head_embedding[head_base] += Float32(grad0 * alpha)
                head_embedding[head_base + 1] += Float32(grad1 * alpha)
                if move_other != 0:
                    tail_embedding[tail_base] -= Float32(grad0 * alpha)
                    tail_embedding[tail_base + 1] -= Float32(grad1 * alpha)
            else:
                for component in range(dim):
                    var head_offset = head_base + component
                    var tail_offset = tail_base + component
                    var grad = clip(
                        grad_coeff
                        * Float64(
                            head_embedding[head_offset]
                            - tail_embedding[tail_offset]
                        )
                    )
                    head_embedding[head_offset] += Float32(grad * alpha)
                    if move_other != 0:
                        tail_embedding[tail_offset] -= Float32(grad * alpha)

            epoch_of_next_sample[edge] += epochs_per_sample[edge]
            var negative_interval = (
                epochs_per_sample[edge] / negative_sample_rate
            )
            var negative_count = Int(
                (Float64(epoch) - epoch_of_next_negative_sample[edge])
                / negative_interval
            )
            for sample in range(negative_count):
                var random_value = tau_rand_int(rng_states, j * 3)
                var negative = random_value % tail_vertices
                if negative < 0:
                    negative += tail_vertices
                var negative_base = negative * dim
                var negative_distance = Float64(0.0)
                if dim == 2:
                    var delta0 = (
                        head_embedding[head_base]
                        - tail_embedding[negative_base]
                    )
                    var delta1 = (
                        head_embedding[head_base + 1]
                        - tail_embedding[negative_base + 1]
                    )
                    negative_distance = Float64(
                        delta0 * delta0 + delta1 * delta1
                    )
                elif head_embedding_address == tail_embedding_address:
                    negative_distance = Float64(
                        squared_distance(
                            head_embedding, j, negative, dim
                        )
                    )
                else:
                    negative_distance = Float64(
                        squared_distance_separate(
                            head_embedding,
                            tail_embedding,
                            j,
                            negative,
                            dim,
                        )
                    )
                var negative_coeff = 0.0
                if negative_distance > 0.0:
                    negative_coeff = (
                        2.0 * gamma * b
                        / (
                            (0.001 + negative_distance)
                            * (a * pow(negative_distance, b) + 1.0)
                        )
                    )
                elif j == negative:
                    continue
                if dim == 2:
                    var grad0 = 0.0
                    var grad1 = 0.0
                    if negative_coeff > 0.0:
                        grad0 = clip(
                            negative_coeff
                            * Float64(
                                head_embedding[head_base]
                                - tail_embedding[negative_base]
                            )
                        )
                        grad1 = clip(
                            negative_coeff
                            * Float64(
                                head_embedding[head_base + 1]
                                - tail_embedding[negative_base + 1]
                            )
                        )
                    head_embedding[head_base] += Float32(grad0 * alpha)
                    head_embedding[head_base + 1] += Float32(grad1 * alpha)
                else:
                    for component in range(dim):
                        var head_offset = head_base + component
                        var tail_offset = negative_base + component
                        var grad = 0.0
                        if negative_coeff > 0.0:
                            grad = clip(
                                negative_coeff
                                * Float64(
                                    head_embedding[head_offset]
                                    - tail_embedding[tail_offset]
                                )
                            )
                        head_embedding[head_offset] += Float32(grad * alpha)
            epoch_of_next_negative_sample[edge] += (
                Float64(negative_count) * negative_interval
            )
        alpha = initial_alpha * (
            1.0 - Float64(epoch) / Float64(n_epochs)
        )


@always_inline
def squared_distance_separate(
    head_embedding: F32Ptr,
    tail_embedding: F32Ptr,
    left: Int,
    right: Int,
    dim: Int,
) -> Float32:
    var total = Float32(0.0)
    for component in range(dim):
        var delta = (
            head_embedding[left * dim + component]
            - tail_embedding[right * dim + component]
        )
        total += delta * delta
    return total
