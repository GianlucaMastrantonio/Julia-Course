module mcmc_mixture_model

  using Distributions
  using Random
  using LinearAlgebra
  using PDMats
  using StatsBase
  using ToggleableAsserts

  include(joinpath("struct.jl"))
include(joinpath("samplers.jl"))
  include(joinpath("mcmc.jl"))



export mcmc_model, NoSampProb

end # module mcmc_mixture_model
