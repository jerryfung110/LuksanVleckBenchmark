function broyden_banded_model(N = 1000; T = Float64, backend=CUDABackend(), kwargs ...)
    n = Int(N)
    
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, 2*N; start = fill(3, 2*N))
    ExaModels.constraint(
        c,
        4 * x[2k] - (x[2k-1] - x[2k+1]) * exp(x[2k-1] - x[2k] - x[2k+1]) - 3 for k = 1:div(N,2)
    )
    
    ExaModels.constraint(
        c,
        x[1+n] - x[1] * (1 + x[1]) - x[2] * (1 + x[2])
    )

    ExaModels.constraint(
        c,
        x[2+n] - x[2] * (1 + x[2]) - x[3] * (1 + x[3]) - x[1] * (1 + x[1])
    )

    ExaModels.constraint(
        c,
        x[3+n] - x[2] * (1 + x[2]) - x[3] * (1 + x[3]) - x[1] * (1 + x[1]) - x[4] * (1 + x[4]) 
    )
    
    ExaModels.constraint(
        c,
        x[4+n] - x[2] * (1 + x[2]) - x[3] * (1 + x[3]) - x[1] * (1 + x[1]) - x[4] * (1 + x[4]) - x[5] * (1 + x[5]) 
    )

    ExaModels.constraint(
        c,
        x[5+n] - x[2] * (1 + x[2]) - x[3] * (1 + x[3]) - x[1] * (1 + x[1]) - x[4] * (1 + x[4]) - x[5] * (1 + x[5]) - x[6] * (1 + x[6]) 
    )

    ExaModels.constraint(
        c,
        x[i+n] - x[i-5] * (1 + x[i-5]) - x[i-4] * (1 + x[i-4]) - x[i-3] * (1 + x[i-3]) - x[i-2] * (1 + x[i-2]) - x[i-1] * (1 + x[i-1]) - 
        x[i] * (1 + x[i]) - x[i+1] * (1 + x[i+1]) for i in 6:N-1
    )

    ExaModels.constraint(
        c,
        x[2*n] - x[n-5] * (1 + x[n-5]) - x[n-4] * (1 + x[n-4]) - x[n-3] * (1 + x[n-3]) - x[n-2] * (1 + x[n-2]) - x[n-1] * (1 + x[n-1]) - 
        x[n] * (1 + x[n])
    )

    ExaModels.objective(c, abs((2 + 5 * x[i]^2) * x[i] + 1 + x[i+n])^7/3 for i in N)
    
    return ExaModels.ExaModel(c)
end
