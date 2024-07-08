function modified_brown_model(N = 1000; T = Float64; backend = CUDABackend())
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = fill(-1,N))
    
    ExaModels.constraint(
        c,
        4 * (x[1] - x[2]^2) + x[2] - x[3]^2 +x[3] - x[4]^2
    )

    ExaModels.constraint(
        c,
        8 * x[2] * (x[2]^2 - x[1]) - 2 * (1-x[2]) + 4 * (x[2] - x[3]^2) + x[1]^2 + x[3] - x[4]^2 +x[4] - x[5]^2
    )

    ExaModels.constraint(
        c,
        8 * x[3] * (x[3]^2 - x[2]) - 2 * (1 - x[3]) + 4 * (x[3] - x[4]^2) + x[2]^2 - x[1] + x[4] - x[5]^2 + 
        x[1]^2 +x[5] - x[6]^2
    )

    ExaModels.constraint(
        c,
        8 * x[N-2] * (x[N-2]^2 - x[N-3]) - 2 * (1 - x[3]) + 4 * (x[3] - x[4]^2) + x[2]^2 - x[1] + x[4] - x[5]^2 + 
        x[1]^2 +x[5] - x[6]^2
    )

    ExaModels.objective(c, (x[2*i-1] + 10 * x[2*i])^2 + 5 * (x[2*i+1] - x[2*i+2])^2 + 
    (x[2*i] - 2 * x[2*i+1])^4 + 10 * (x[2*i-1] - x[2*i+2])^4 for i = 1:N/2-1)
    return ExaModels.ExaModel(c)
end

