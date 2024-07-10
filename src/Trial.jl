module Trial

import Downloads
import ExaModels: ExaModels, NLPModels

include("rosenrock.jl") 
#include("wood.jl")
include("cragg_levy.jl")
#include("broyden_banded.jl")
include("broyden_tridiagonal.jl")
include("chained_powell.jl")
include("augmented_lagrangian.jl")
include("trigo_tridiagonal.jl")
include("modified_brown.jl")
include("generalized_brown.jl")
println("HI")
const NAMES = filter(names(Trial; all = true)) do x
    str = string(x)
    endswith(str, "model") && !startswith(str, "#")
end

for name in NAMES
    @eval export $name
end



end # module Trail
