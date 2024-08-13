# The following question was adopted from Lukšan, L., & Vlček, J. (1999). Sparse and Partially Separable Test Problems for Unconstrained and Equality Constrained Optimization.
# Institute of Computer Science, Academy of Sciences of the Czech Republic. Technical report No. 767 Problem 5.10
function generalized_brown_model(N = 1000; T = Float64, backend = CUDABackend(),  kwargs ...)
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = fill(-1,N))
    
    ExaModels.constraint(
        c,
        (3 - 2 * x[k+1]) * x[k+1] + 1 - x[k] - 2 * x[k+2] for k = 1:N-2
    )


    ExaModels.objective(c, (x[2i-1]^2)^(x[2i]^2 + 1) + (x[2i]^2)^(x[2i-1]^2 + 1) for i = 1:Int(N/2))
    return ExaModels.ExaModel(c)
end

