# The following question was adopted from Lukšan, L., & Vlček, J. (1999). Sparse and Partially Separable Test Problems for Unconstrained and Equality Constrained Optimization.
# Institute of Computer Science, Academy of Sciences of the Czech Republic. Technical report No. 767 Problem 5.5
# Extra Objective function is introduced to handle x[0] == 0 and x[n+1] == 0
function broyden_tridiagonal_model(N = 1000; T = Float64, backend = CUDABackend(),  kwargs ...)
    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = (fill(-1, N)))

    ExaModels.constraint(
        c,
        8 * x[k+2] * (x[k+2]^2 - x[k+1]) - 2 * (1 - x[k+2]) + 4 * (x[k+2] - x[k+3]^2) + x[k+1]^2 -x[k]
        + x[k+3] - x[k+4]^2 for k = 1:N-4
    )

    ExaModels.objective(c, (abs((3 - 2 * x[i]) * x[i] - x[i-1] - x[i+1] + 1))^7/3 for i = 2:N-1)

    ExaModels.objective(c, abs((3 - 2 * x[1]) * x[1] - x[2] + 1)^7/3 + abs((3 - 2 * x[N]) * x[N] - x[N-1] + 1)^7/3)
    
    return ExaModels.ExaModel(c)
end
