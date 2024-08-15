using MadNLP, MadNLPGPU, CUDA
import LuksanScalableBenchmark
const LuksanScalableBenchmarkMod = LuksanScalableBenchmark  # Alias to avoid naming conflict
using Test

const CONFIGS = [
    #(Float32, nothing),
    (Float64, nothing),
    #(Float32, CPU()),
    #(Float64, CPU()),
    (Float64, CUDABackend()),
]


function runtests()
    @testset "LuksanScalableBenchmark test" begin
        for name in LuksanScalableBenchmarkMod.NAMES
            for (T, backend) in CONFIGS
                # Evaluate the model function from LuksanScalableBenchmarkMod
                model_func = getfield(LuksanScalableBenchmarkMod, Symbol(name))
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

#@testset "LuksanScalableBenchmark.jl" begin
#    # Write your tests here.

#end
