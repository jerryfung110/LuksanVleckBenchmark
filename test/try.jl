import LuksanVleckBenchmark
const LuksanVleckBenchmarkMod = LuksanVleckBenchmark

# Verify that each model in NAMES is defined
function check_models_defined()
    all_defined = true
    for name in LuksanVleckBenchmarkMod.NAMES
        if isdefined(LuksanVleckBenchmarkMod, Symbol(name))
            println("$name is defined")
        else
            println("$name is NOT defined")
            all_defined = false
        end
    end
    return all_defined
end

if check_models_defined()
    println("All models are defined")
else
    println("Some models are NOT defined")
end
