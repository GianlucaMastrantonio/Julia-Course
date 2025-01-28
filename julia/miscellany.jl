# Set the directory for the package environment
dir = "/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/julia/"

# Load the Pkg package for managing Julia packages
using Pkg

# Activate the package environment located in the specified directory
Pkg.activate(dir)

# Flag indicating whether to start a new project setup
start_proj::Bool = false

# If starting a new project, add necessary packages
if start_proj
  Pkg.add("RCall")             # Add RCall package for interfacing with R
  Pkg.add("ToggleableAsserts") # Add ToggleableAsserts package for assertions
end

# * #SECTION: RCall
#=
# RCall allows calling R from Julia and transferring objects between them.
# Useful for tasks like graphing and data cleaning, which may be easier in R.
# You can specify which R version to use by setting the R_HOME environment variable.
=#

# Load the RCall package to interface with R
using RCall

# Load the Distributions package for statistical distributions
using Distributions

# Create a sample of 100 random numbers from a normal distribution
sample_norm = rand(Normal(0.0, 1.0), 100);

# Transfer the sample_norm object to R
@rput sample_norm

# Use R's functions to plot the density of the sample
R"""
plot(density(sample_norm))
new_sample_norm = sample_norm + 2
"""

# Retrieve the modified object from R back to Julia
@rget new_sample_norm;

# * #SECTION: ToggleableAsserts
#=
# ToggleableAsserts is used for conditional assertions in code.
# It allows assertions to be turned on/off to balance debugging and performance.
=#

# Load the ToggleableAsserts package for conditional assertions
using ToggleableAsserts

# Load the Revise package for tracking code changes
using Revise

# Load the mc_package which contains custom functions
using mc_package

# Test the assertions in mc_package
mc_package.test_assert(1, 1)
mc_package.test_assert(1, 2)
mc_package.test_toggled_assert(1, 1)
mc_package.test_toggled_assert(1, 2)

# Turn off toggleable assertions to improve performance
toggle(false)

# Test the assertions again with toggles turned off
mc_package.test_assert(1, 1)
mc_package.test_assert(1, 2)
mc_package.test_toggled_assert(1, 1)
mc_package.test_toggled_assert(1, 2)

# * #SECTION: MULTI THREADING
#=
# Multi-threading in Julia allows parallel computation.
# - @threads macro divides loop iterations among threads.
# - @spawn macro runs independent tasks on available threads.
# Threads.nthreads() shows the number of threads available.
# You can increase threads via settings or terminal command.
=#

# Display the number of threads available
Threads.nthreads()

# Variables for iteration count and storage of thread results
iter = 10
test1 = zeros(Int64, iter)
test2 = zeros(Int64, iter)

# Test multi-threading with even distribution of tasks
test_multi_threading(iter, Uniform(0.5, 2.0), test1)
# Output the thread assignments
test1

# Test multi-threading with random distribution of tasks
test_multi_threading(iter, Uniform(0.5, 2.0), test2)
# Output the thread assignments
test2

