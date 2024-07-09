function generalized_brown_model(N = 1000; T = Float64, backend = CUDABackend(),  kwargs ...)
    n = Int(N)

    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = fill(-1,N))
    
    ExaModels.constraint(
        c,
        (3 - 2 * x[k+1]) * x[k+1] + 1 - x[k] - 2 * x[k+2] for k = 1:n-2
    )


    ExaModels.objective(c, (x[2i-1]^2)^(x[2i]^2 + 1) + (x[2i]^2)^(x[2i-1]^2 + 1) for i = 1:Int(N/2))
    return ExaModels.ExaModel(c)
end

