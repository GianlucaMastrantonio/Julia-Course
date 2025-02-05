module mc_package

# Load necessary packages
using Distributions       # For statistical distributions
using Random              # For random number generation
using LinearAlgebra       # For linear algebra operations
using PDMats              # For positive definite matrices
using StatsBase           # For statistical functions
using ToggleableAsserts   # For toggleable assertions during debugging

# Include files that contain additional functions and definitions
include(joinpath("importance sampling.jl"))  # Contains importance sampling functions
include(joinpath("gen_struct.jl"))           # Contains definitions for structures and types
include(joinpath("assert.jl"))               # Contains assertion functions for testing
include(joinpath("multi_threading.jl"))      # Contains functions for multi-threading

# Exported Monte Carlo symbols
export
  test_multi_spawn,         # Function for testing multi-threading using @spawn
  test_multi_threading,     # Function for testing multi-threading using @threads
  test_assert,              # Function to test assertions
  test_toggled_assert,      # Function to test toggleable assertions
  McMethod,                 # Abstract type for Monte Carlo methods
  StandardMC_V1,            # Mutable structure for standard Monte Carlo method
  StandardMC_immutable_V2,  # Immutable structure for standard Monte Carlo method
  StandardMCPar_V1,         # Parametric version of standard Monte Carlo structure
  ImportanceSampling,       # Structure for importance sampling
  importance_sampling       # Optimized importance sampling function returning (estimate, variance, efficiency)
#  GeneralS,               # Commented out, possibly for future use
#  HMCRJ,                  # Commented out, possibly for future use

end # module mc_package
