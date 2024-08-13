# The following question was adopted from Lukšan, L., & Vlček, J. (1999). Sparse and Partially Separable Test Problems for Unconstrained and Equality Constrained Optimization.
# Institute of Computer Science, Academy of Sciences of the Czech Republic. Technical report No. 767 Problem 5.11
# The index in nC would be out of range for the constraints mod(k,2) == 1. Threfore, the last constraint is not implemented. The number of constraints fulfilled the question. 
function Chained_HS46_model(N = 1000; T = Float64, backend = CUDABackend(), kwargs ...)
    nC = 2 * (N - 2) ÷ 3 
    It_L1 = [3*div(i-1, 2) for i in 1:2:nC-2]
    It_L2 = [3* div(i-1, 2) for i in 2:2:nC]
    c = ExaModels.ExaCore(T; backend = backend)
    x = ExaModels.variable(c, N; start = (mod(i, 3) == 1 ? 2.0 : mod(i, 3) == 2 ? 1.5 : 0.5 for i = 1:N))
    ExaModels.constraint(
        c,
        x[l+2] + x[l+3]^4 * x[l+4]^2 - 2 for l in It_L2
    )

    ExaModels.constraint(
        c,
        x[l+1]^2 * x[l+4] + sin(x[l+4] - x[l+5]) - 1 for l in It_L1
    )

    ExaModels.objective(c, (x[(3i-1)+1] - x[(3i-1)+2])^2 + (x[(3i-1)+3] - 1)^2 + (x[(3i-1)+4] - 1)^4 + (x[(3i-1)+5] - 1)^6 for i in 1:floor(Int, (N-2)/3))
    
    
    return ExaModels.ExaModel(c)
end

