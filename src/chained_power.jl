function chained_power_model(N = 1000; T = Float64; backend = CUDABackend())
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = (mod(i, 4) == 1 ? 3 : mod(i, 4) == 2 ? -1 : mod(i, 4) == 3 ? 0 : 1 for i = 1:N))
    
    ExaModels.constraint(
        c,
        3 * x[1]^3 + 2x[2] - 5 + sin(x[1] - x[2]) * sin(x[1] + x[2])
    )

    ExaModels.constraint(
        c,
        4 * x[n] - x[n-1] * exp(x[n-1] - x[n]) - 3 for n = 2:N
    )

    ExaModels.objective(c, (x[2*i-1] + 10 * x[2*i])^2 + 5 * (x[2*i+1] - x[2*i+2])^2 + 
    (x[2*i] - 2 * x[2*i+1])^4 + 10 * (x[2*i-1] - x[2*i+2])^4 for i = 1:N/2-1)
    return ExaModels.ExaModel(c)
end

