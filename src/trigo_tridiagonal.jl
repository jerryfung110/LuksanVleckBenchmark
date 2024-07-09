function trigo_tridiagonal_model(N = 1000; T = Float64; backend = CUDABackend())
    n = N
    
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = (fill(1, N)))
    
    ExaModels.constraint(
        c,
        4 * (x[1] - x[2]^2) + x[2] - x[3]^2
    )

    ExaModels.constraint(
        c,
        8 * x[2] * (x[2]^2 - x[1]) - 2 * (1 - x[2]) + 4 * (x[2] - x[3]^2) + x[3] - x[4]^2
    )

    ExaModels.constraint(
        c,
        8 * x[n-1] * (x[n-1]^2 - x[n-2]) - 2 * (1 - x[n-1]) + 4 * (x[n-1] - x[n]^2) + x[n-2] - x[n-3]^2 
    )

    ExaModels.constraint(
        c,
        8 * x[n] * (x[n]^2 - x[n-1]) - 2 * (1 - x[n]) + x[n-1]^2 - x[n-2] 
    )

    ExaModels.objective(c, i * ((1 - cos(x[i]) + sin(x[i-1]) - sin(x[i+1]))) for i=2:N-1)
    return ExaModels.ExaModel(c)
end

