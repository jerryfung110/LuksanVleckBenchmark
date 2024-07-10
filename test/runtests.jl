using MadNLP, NLPModelsIpopt
import Trial
const TrialMod = Trial  # Alias to avoid naming conflict
using Test

const CONFIGS = [
    #(Float32, nothing),
    (Float64, nothing),
    #(Float32, CPU()),
    #(Float64, CPU()),
    #(Float64, CUDABackend()),
]


function runtests()
    @testset "Trial test" begin
        for name in TrialMod.NAMES
            for (T, backend) in CONFIGS
                # Evaluate the model function from TrialMod
                model_func = getfield(TrialMod, Symbol(name))
                m = model_func(; T = T, backend = backend)
                result = ipopt(m)
                println(name)
                @testset "$name" begin
                    @test result.solver_specific[:internal_msg] == :Solve_Succeeded
                end
            end
        end
    end
end

runtests()

#@testset "Trial.jl" begin
#    # Write your tests here.

#end
