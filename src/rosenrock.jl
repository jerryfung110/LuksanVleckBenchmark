# The following question was adopted from Lukšan, L., & Vlček, J. (1999). Sparse and Partially Separable Test Problems for Unconstrained and Equality Constrained Optimization.
# Institute of Computer Science, Academy of Sciences of the Czech Republic. Technical report No. 767 Problem 5.1
function rosenrock_model(N = 1000; T = Float64, backend = CUDABackend(), kwargs ...)
    c = ExaModels.ExaCore(T; backend = backend)
    x = ExaModels.variable(c, N; start = (mod(i, 2) == 1 ? -1.2 : 1.0 for i = 1:N))
    ExaModels.constraint(
        c,
        3 * x[k+1]^3 + 2 * x[k+2] - 5 + sin(x[k+1] - x[k+2]) * sin(x[k+1] + x[k+2]) + 4x[k+1] -
        x[k] * exp(x[k] - x[k+1]) - 3 for k = 1:N-2
    )
    ExaModels.objective(c, 100 * (x[i]^2 - x[i+1])^2 + (x[i] - 1)^2 for i = 1:N-1)
    return ExaModels.ExaModel(c)
end


