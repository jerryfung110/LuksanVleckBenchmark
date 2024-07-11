function Chained_HS48_model(N = 1000; T = Float64, backend=CUDABackend(), kwargs ...)
    nC = (2 * (N-2) ÷ 3)
    It_L1 = [3*div(i-1, 2) for i in 1:2:nC-1]
    It_L2 = [3*div(i-1, 2) for i in 2:2:nC]

    c = ExaModels.ExaCore(T; backend = backend)
    x = ExaModels.variable(c, N; start = (mod(i, 3) == 1 ? 3 : mod(i, 3) == 2 ? 5 : -3 for i = 1:N))
    ExaModels.constraint(
        c,
        x[l+1] + x[l+2]^2 + x[l+3] + x[l+4] + x[l+5] - 5 for l in It_L1
    )

    ExaModels.constraint(
        c,
        x[l+3]^2 - 2* (x[l+4] + x[l+5]) - 3 for l in It_L2
    )



    ExaModels.objective(c, (x[3(i-1)+1] - 1)^2 + (x[3(i-1)+2] - x[3(i-1)+3])^2 + (x[3(i-1)+4] - x[3(i-1)+5])^2 for i in 1:floor(Int, (N-2)/3))
    
    
    return ExaModels.ExaModel(c)
end

