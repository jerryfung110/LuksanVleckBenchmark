using MadNLP, NLPModelsIpopt
using Trial
using Test

const CONFIGS = [
    (Float32, nothing),
    (Float64, nothing),
    (Float32, CPU()),
    (Float64, CPU()),
    #(Float64, CUDABackend()),
]


function runtests()
    @testset "Trial test" begin
        for name in Trial.NAMES
            for (T, backend) in CONFIGS
                m = eval(name)(; T = T, backend = backend)
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
