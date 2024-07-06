module Trial

import Downloads
import ExaModels: ExaModels, NLPModels

include("rosenrock.jl")
include("wood.jl")
include("cragg_levy.jl")
include("broyden_banded.jl")
include("broyden_tridiagonal.jl")
include("chained_power.jl")

const NAMES = filter(names(optimizer; all = true)) do x
    str = string(x)
    endswith(str, "model") && !startswith(str, "#")
end

for name in NAMES
    @eval export $name
end



end # module Trail
