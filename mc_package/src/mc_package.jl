module mc_package

# the packages to load
using Distributions
using Random
using LinearAlgebra
using PDMats
using StatsBase
using ToggleableAsserts
# files that contains the functions
include(joinpath("importance sampling.jl"))
include(joinpath("gen_struct.jl"))
include(joinpath("assert.jl"))
include(joinpath("multi_threading.jl"))



export
  test_multi_spawn,
  test_multi_threading,
  test_assert,
  test_toggled_assert,
  McMethod,
  StandardMC_V1, 
  StandardMC_immutable_V2, 
  StandardMCPar_V1,
  ImportanceSampling,
  importance_sampling
#      GeneralS,
#      HMCRJ,


end # module mc_package
