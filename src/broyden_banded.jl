# The following question was adopted from Lukšan, L., & Vlček, J. (1999). Sparse and Partially Separable Test Problems for Unconstrained and Equality Constrained Optimization.
# Institute of Computer Science, Academy of Sciences of the Czech Republic. Technical report No. 767 Problem 5.6
# y variable does not exist in the original problem, however, in order to represent the summation sign in the objective funciton, y and extra constraints introduced 
function broyden_banded_model(N = 1000; T = Float64, backend=CUDABackend(), kwargs ...)
    n = Int(N)
    
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = fill(3, N))
    y = ExaModels.variable(c, N; start = fill(0, N))
    ExaModels.constraint(
        c,
        4 * x[2k] - (x[2k-1] - x[2k+1]) * exp(x[2k-1] - x[2k] - x[2k+1]) - 3 for k = 1:div(N,2)
    )
    
    ExaModels.constraint(
        c,
        y[1] - x[1] * (1 + x[1]) - x[2] * (1 + x[2])
    )

    ExaModels.constraint(
        c,
        y[2] - x[2] * (1 + x[2]) - x[3] * (1 + x[3]) - x[1] * (1 + x[1])
    )

    ExaModels.constraint(
        c,
        y[3] - x[2] * (1 + x[2]) - x[3] * (1 + x[3]) - x[1] * (1 + x[1]) - x[4] * (1 + x[4]) 
    )
    
    ExaModels.constraint(
        c,
        y[4] - x[2] * (1 + x[2]) - x[3] * (1 + x[3]) - x[1] * (1 + x[1]) - x[4] * (1 + x[4]) - x[5] * (1 + x[5]) 
    )

    ExaModels.constraint(
        c,
        y[5] - x[2] * (1 + x[2]) - x[3] * (1 + x[3]) - x[1] * (1 + x[1]) - x[4] * (1 + x[4]) - x[5] * (1 + x[5]) - x[6] * (1 + x[6]) 
    )

    ExaModels.constraint(
        c,
        y[i] - x[i-5] * (1 + x[i-5]) - x[i-4] * (1 + x[i-4]) - x[i-3] * (1 + x[i-3]) - x[i-2] * (1 + x[i-2]) - x[i-1] * (1 + x[i-1]) - 
        x[i] * (1 + x[i]) - x[i+1] * (1 + x[i+1]) for i in 6:N-1
    )

    ExaModels.constraint(
        c,
        y[n] - x[n-5] * (1 + x[n-5]) - x[n-4] * (1 + x[n-4]) - x[n-3] * (1 + x[n-3]) - x[n-2] * (1 + x[n-2]) - x[n-1] * (1 + x[n-1]) - 
        x[n] * (1 + x[n])
    )

    ExaModels.objective(c, abs((2 + 5 * x[i]^2) * x[i] + 1 + y[i])^7/3 for i in N)
    
    return ExaModels.ExaModel(c)
end
