# The following question was adopted from Lukšan, L., & Vlček, J. (1999). Sparse and Partially Separable Test Problems for Unconstrained and Equality Constrained Optimization.
# Institute of Computer Science, Academy of Sciences of the Czech Republic. Technical report No. 767 Problem 5.3
function chained_powell_model(N = 1000; T = Float64, backend = CUDABackend(),  kwargs ...)
    n = N

    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = (mod(i, 4) == 1 ? 3 : mod(i, 4) == 2 ? -1 : mod(i, 4) == 3 ? 0 : 1 for i = 1:N))
    
    ExaModels.constraint(
        c,
        3 * x[1]^3 + 2x[2] - 5 + sin(x[1] - x[2]) * sin(x[1] + x[2])
    )

    ExaModels.constraint(
        c,
        4 * x[n] - x[n-1] * exp(x[n-1] - x[n]) - 3 
    )

    ExaModels.objective(c, (x[2*i-1] + 10 * x[2*i])^2 + 5 * (x[2*i+1] - x[2*i+2])^2 + 
    (x[2*i] - 2 * x[2*i+1])^4 + 10 * (x[2*i-1] - x[2*i+2])^4 for i = 1:Int(N/2-1))
    return ExaModels.ExaModel(c)
end

