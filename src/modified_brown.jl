function modified_brown_model(N = 1000; T = Float64; backend = CUDABackend())
    n = Int(N)

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
        8 * x[n-2] * (x[n-2]^2 - x[n-3]) - 2 * (1 - x[n-2]) + 4 * (x[n-2] - x[n-1]^2) + x[n-3]^2 - x[n-4] + x[n-1] - x[n]^2 + 
        x[n-4]^2 +x[n] - x[n-5]
    )

    ExaModels.constraint(
        c,
        8 * x[n-1] * (x[n-1]^2 - x[n-2]) - 2 * (1 - x[n-1]) + 4 * (x[n-1] - x[n]^2) + x[n-2]^2 - x[n-3] + x[n] + 
        x[n-3]^2 - x[n-4]
    )

    ExaModels.constraint(
        c,
        8 * x[n] * (x[n]^2 - x[n-1]) - 2 * (1 - x[n]) + x[n-1]^2 - x[n-2] + x[n-2]^2 - x[n-3]
    )

    ExaModels.objective(c, ((x[2i-1] - 3)^2) / 1000 - (x[2i-1] - x[2i]) + exp(20 * (x[2i-1] - x[2i])) for i = 1:Int(N/2))
    return ExaModels.ExaModel(c)
end

