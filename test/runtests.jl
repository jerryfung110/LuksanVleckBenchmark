using NLPModelsIpopt
import ExaModelsConOpt
const ExaModelsConOptMod = ExaModelsConOpt  # Alias to avoid naming conflict
using Test

const CONFIGS = [
    #(Float32, nothing),
    (Float64, nothing),
    #(Float32, CPU()),
    #(Float64, CPU()),
    #(Float64, CUDABackend()),
]


function runtests()
    @testset "ExaModelsConOpt test" begin
        for name in ExaModelsConOptMod.NAMES
            for (T, backend) in CONFIGS
                # Evaluate the model function from ExaModelsConOptMod
                model_func = getfield(ExaModelsConOptMod, Symbol(name))
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

#@testset "ExaModelsConOpt.jl" begin
#    # Write your tests here.

#end
