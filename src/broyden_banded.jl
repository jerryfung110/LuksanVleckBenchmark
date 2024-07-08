function broyden_banded_model(N = 1000; T = Float64; backend = CUDABackend())
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = fill(3, N))
    
    ExaModels.constraint(
        c,
        4 * x[2k] - (x[2k-1] - x[2k+1]) * exp(x[2k-1] - x[2k] - x[2k+1] - 3 for k = 1:div(N,2))
    )
    
    ExaModels.objective(c, abs((2 + 5 * x[i]^2) * x[i] + 1 + sum(x[j] * (1 + x[j]) for j = max(1, i-5):min(n, i+1)))^7/3 for i = 1:N-1)
    
    return ExaModels.ExaModel(c)
end
