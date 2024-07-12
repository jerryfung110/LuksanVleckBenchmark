

function wood_model(N = 10; T = Float64, kwargs...)
    c = ExaModels.ExaCore(T)
    x = ExaModels.variable(c, N; start = (mod(i, 2) == 1 ? -2 : 0 for i = 1:N))
    
    # Define the constraints
    con = ExaModels.constraint(
        c,
        (2 + 5 * x[(k)+5]^2) * x[(k)+5] + 1 for k in 1:N-7
    )
    
    ExaModels.constraint!(
        c,
        con,
        i => x[i] * (1 + x[i]) + x[i+1] * (1 + x[i+1]) for i in 1:N-7
    )

    ExaModels.objective(c, (100 * (x[2*i-1]^2 - x[2*i])^2 + (x[2*i-1] - 1)^2 +
    90 * (x[2*i+1]^2 - x[2*i+2])^2 + (x[2*i+1] - 1)^2 +
    10 * (x[2*i] + x[2*i+2] - 2)^2 + (x[2*i] - x[2*i+2])^2 / 10) for i = 1:Int(N/2))
    
    return ExaModels.ExaModel(c)
end