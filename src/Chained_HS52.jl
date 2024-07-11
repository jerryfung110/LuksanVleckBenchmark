function Chained_HS51_model(N = 1000; T = Float64, backend=CUDABackend(), kwargs ...)
    nC = (3 * (N-1) ÷ 4)
    It_L1 = [4*div(i-1, 3) for i in 1:3:nC-3]
    It_L2 = [4*div(i-1, 3) for i in 2:3:nC-3]
    It_L3 = [4*div(i-1, 3) for i in 3:3:nC-3]
    c = ExaModels.ExaCore(T; backend = backend)
    x = ExaModels.variable(c, N; start = fill(2, N))
    ExaModels.constraint(
        c,
        x[l+1]^2 + 3 * x[l+2] for l in It_L1
    )

    ExaModels.constraint(
        c,
        x[l+3]^2 + 2 * x[l+4] - 2 * x[l+5] for l in It_L2
    )

    ExaModels.constraint(
        c,
        x[l+2]^2 - x[l+5]  for l in It_L3
    )

    ExaModels.objective(c, (4 * x[4(i-1)+1] - x[4(i-1)+2])^2 + (x[4(i-1)+2] + x[4(i-1)+3] - 2)^4 + (x[4(i-1)+4] - 1)^2 + (x[4(i-1)+5] - 1)^2 for i in 1:floor(Int, (N-1)/4))
    
    
    return ExaModels.ExaModel(c)
end

