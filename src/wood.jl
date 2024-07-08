function wood_model(N = 1000; T = Float64; backend = CUDABackend())
    c = ExaModels.ExaCore(T; backend = backend)
    x = ExaModels.variable(c, N; start = (mod(i, 2) == 1 ? -2 : 0 for i = 1:N))
    ExaModels.constraint(
        c,
        (2 + 5 * x[k+5]^2) * x[k+5] + 1 + sum(x[i] * (1 + x[i]) for i in k-5:k+1) for k = 1:N-7
    )
    ExaModels.objective(c, 100 * (x[2*i-1]^2 - x[2*i])^2 + (x[2*i-1] - 1)^2 +
    90 * (x[2*i+1]^2 - x[2*i+2])^2 + (x[2*i+1] - 1)^2 +
    10 * (x[2*i] + x[2*i+2] - 2)^2 + (x[2*i] - x[2*i+2])^2 / 10 for i =1:N/2)
    return ExaModels.ExaModel(c)
end
