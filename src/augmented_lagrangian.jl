function augmented_lagrangian_model(N = 1000; T = Float64; backend = CUDABackend())
    h = 1/(N+1)
    l1 = -0.002008
    l2 = -0.001900
    l3 = -0.000261

    c = ExaModels.ExaCore(T; backend = backend)
    
    x = ExaModels.variable(c, N; start = (mod(i, 2) == 1 ? -1.0 : 2.0 for i=1:N))
    
    ExaModels.constraint(
        c,
        2 * x[k+1] + h^2 * (x[k+1] + h * (k+1) + 1)^3/2 - x[k] - x[k+2] for k=1:N-2 
    )
    
    ExaModels.objective(c, exp(prod(x[5i+1-j] for j = 1:5)) + 10 *((sum(x[5i+1-j]^2 for j = 1:5) - 10 - l1)^2) +
    (x[5i-3] * x[5i-2] - 5 * x[5i-1] * x[5i] - l2)^2 + (x[5i-4]^3 + x[5i-3]^3 + 1 - l3)^2 for i =1:Int(N/5))
    
    return ExaModels.ExaModel(c)
end
