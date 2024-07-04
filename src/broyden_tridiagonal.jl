function broyden_tridiagonal_model(N = 1000; T = Float64; backend = CUDABackend())
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = (fill(-1, N)))
    
    ExaModels.constraint(
        c,
        8 * x[k+2] * (x[k+2]^2 - x[k+1]) - 2 * (1 - x[k+2]) + 4 * (x[k+2] - x[k+3]^2) + x[k+1]^2 -x[k]
        + x[k+3] - x[k+4]^2 for k = 1:N-4
    )
    
    ExaModels.objective(c, (abs((3 - 2 * x[i]) * x[i] - x[i-1] - x[i+1] + 1)^7/3 for i = 1:N/2-1) + 
    abs((3 - 2 * x[1]) * x[1] - x[2] + 1)^7/3 + abs((3 - 2 * x[N]) * x[N] - x[N-1] + 1)^7/3)
    
    return ExaModels.ExaModel(c)
end
