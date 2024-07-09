function Chained_HS46_model(N = 1000; T = Float64, backend = CUDABackend(),  kwargs ...)
    nC = 2 * (N - 2) ÷ 3
    
    c = ExaModels.ExaCore(T; backend = backend)
    x = ExaModels.variable(c, N; start = (mod(i, 3) == 1 ? 2 : mod(i, 3) == 2 ? 1.5 : 0.5 for i = 1:N))

    ExaModels.constraint(
        c,
        for k = 1:nC
            if mod(k, 2) == 0
                l = 3 * div(k - 1, 2)
                x[l+2] + x[l+3]^4 * x[l+4]^2 - 2
            end
        end
    )
    println(2)
    ExaModels.constraint(
        c,
        for k = 1:nC
            if mod(k, 2) == 1
                l = 3 * div(k - 1, 2)
                x[l+1]^2 * x[l+4] + sin(x[l+4] - x[l+5]) - 1
            end
        end
    )

    println(5)
    ExaModels.constraint(
        c,
        j - 3 * i -1 for i = 1:Int((N-2)/3)
    )    

    println(6)


    ExaModels.objective(c, 
        for i=Int((N-2)/3)
            j = 3 * i -1
            (x[j+1] - x[j+2])^2 + (x[j+3] - 1)^2 + (x[j+4] - 1)^4 + (x[j+5] - 1)^6
        end
    )
    
    
    return ExaModels.ExaModel(c)
end


