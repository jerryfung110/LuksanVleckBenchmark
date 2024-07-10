function broyden_banded_model(N = 1000; T = Float64, backend = CUDABackend(),  kwargs ...)
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = fill(3, N))
    
    ExaModels.constraint(
        c,
        4 * x[2k] - (x[2k-1] - x[2k+1]) * exp(x[2k-1] - x[2k] - x[2k+1]) - 3 for k = 1:div(N,2)
    )
    ranges = Array{Any}(undef, N, 2)
    for i in 1:N
        ranges[i, 1] = i
        ranges[i, 2] = collect(max(1, i-5):min(N, i+1))
    end

    ExaModels.objective(c, abs((2 + 5 * x[i]^2) * x[i] + 1 + sum(x[k] * (1 + x[k]) for k in j))^7/3 for (i , j) in ranges)
    
    return ExaModels.ExaModel(c)
end
