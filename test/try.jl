import ExaModelsConOpt
const ExaModelsConOptMod = ExaModelsConOpt

# Verify that each model in NAMES is defined
function check_models_defined()
    all_defined = true
    for name in ExaModelsConOptMod.NAMES
        if isdefined(ExaModelsConOptMod, Symbol(name))
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
