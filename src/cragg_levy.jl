function cragg_levy_model(N = 1000; T = Float64; backend = CUDABackend())
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = (mod(i, 4) == 1 ? 1 : 2 for i = 1:N))
    
    ExaModels.constraint(
        c,
        8 * x[k+1] * (x[k+1]^2 - x[k]) - 2 * (1 - x[k+1]) + 4 * (x[k+1] - x[k+2]^2) for k = 1:N-2
    )
    
    ExaModels.objective(c, (exp(x[2i-1]) - x[2i])^4 + 100 * (x[2i] - x[2i+1])^6 + tan(x[2i+1] - x[2i+2])^4 +
    8 * x[2i-1]^8 + (x[2i+2] - 1)^2 for i = 1:N/2-1)
    
    return ExaModels.ExaModel(c)
end
