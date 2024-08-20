using MadNLP, MadNLPGPU, CUDA
import LuksanVleckBenchmark
const LuksanVleckBenchmarkMod = LuksanVleckBenchmark  # Alias to avoid naming conflict
using Test

const CONFIGS = [
    #(Float32, nothing),
    (Float64, nothing),
    #(Float32, CPU()),
    #(Float64, CPU()),
    (Float64, CUDABackend()),
]


function runtests()
    @testset "LuksanVleckBenchmark test" begin
        for name in LuksanVleckBenchmarkMod.NAMES
            for (T, backend) in CONFIGS
                # Evaluate the model function from LuksanVleckBenchmarkMod
                model_func = getfield(LuksanVleckBenchmarkMod, Symbol(name))
                m = model_func(; T = T, backend = backend)
                println(name)
                result = madnlp(m)
                @testset "$name" begin
                    @test result.status == MadNLP.SOLVE_SUCCEEDED
                end
            end
        end
    end
end

runtests()

#@testset "LuksanVleckBenchmark.jl" begin
#    # Write your tests here.

#end
