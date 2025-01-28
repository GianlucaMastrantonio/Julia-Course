#=
In this file, we define the structures for the Monte Carlo methods

We start by defining an abstract type (similar to the Real of a number)
=#
abstract type ExampleType end
# this type is a subtype of the McMethods
abstract type McMethod <: ExampleType end
# and we will not define two concrete type which are the StandarMC and the ImportanceSampling

#=

The structures are

- mutable: if we can change (substitute) the values of its object
- immutable: if we cannot. Be careful that we cannot change the values of the object, but if the object is a matrix or a vector, we can change its value

if not specifies, the structure is immutable

# ! Be careful that once a structure is loaded, it cannot be changed, not even by revise. Mys trategy is to give it a name and use find/replace to give a new name to it and all the place where I use it  
=#

#=
The mutable structure StandardMC_V1. It contains the function (hx) to be estimated, the number of samples (B), and the vector of samples.
The constructor checks if the size of the samples is equal to B.

We also define an external constructor to create a StandardMC_V1 without having to specify the samples
=#
mutable struct StandardMC_V1 <: McMethod

  hx::Function
  B::Int64 # hoe many samples do i want
  samples::Vector{Float64} # a vector that will contain the samples
  
  # the constructor: this is not strickly necessary, but it is better to have it.
  # you can use it to check the argument values
  # this below is an option,
  #function StandardMC(B::Int64)
  #  new(B, zeros(Float64, B))
  #end
  # but it is better to pass all the arguments
  function StandardMC_V1(hx::Function, B::Int64, samples::Vector{Float64})
    
    @assert size(samples,1) == B "size of samples is not equal to B"# assert give an error if the condition is not true. For debugging is better to use  @toggled_assert of the package ToggleableAsserts, that can be turned on and off

    new(hx, B, samples)
  end

end

# External constructor for mutable StandardMC_V1
function StandardMC_V1(hx::Function, B::Int64)::StandardMC_V1
  return StandardMC_V1(hx, B, zeros(Float64, B))
end

#=
The immutable structure StandardMC_immutable_V2. It contains the function (hx) to be estimated, the number of samples (B), and the vector of samples.
The constructor checks if the size of the samples is equal to B.
=#
struct StandardMC_immutable_V2 <: McMethod
  hx::Function
  B::Int64 # number of samples
  samples::Vector{Float64} # vector to hold samples

  # Constructor for StandardMC_immutable_V2
  function StandardMC_immutable_V2(hx::Function, B::Int64, samples::Vector{Float64})
    @assert size(samples, 1) == B "Size of samples does not match B."
    new(hx, B, samples)
  end
end

#=
We can enhance the standard structures' flexibility by using parametric types.
This allows for handling sample types beyond Float64, accommodating distributions with discrete samples.
=#
struct StandardMCPar_V1{TypeV<:Real} <: McMethod


  hx::Function
  B::Int64 
  samples::Vector{TypeV}

  function StandardMCPar_V1(hx::Function,B::Int64, samples::Vector{TypeV}) where {TypeV<:Real}

    @assert size(samples,1) == B "Size of samples is not equal to B"# assert give an error if the condition is not true. For debugging is better to use  @toggled_assert of the package ToggleableAsserts, that can be turned on and off

    new{TypeV}(hx, B, samples) 
  end

end


#=
Before creating the structure for the importance sampling, we can make the standard structure more flexible. We are assuming the the samples are Float64, but if the distribution is discrete this is not true. 
# For this we can use the parametric type
=#
struct ImportanceSampling{TypeV<:Real, TypeDistr<:Distribution} <: McMethod
  
  hx::Function
  g::TypeDistr
  B::Int64
  samples::Vector{TypeV}
  
  function ImportanceSampling(hx::Function, g::TypeDistr, B::Int64, samples::Vector{TypeV}) where {TypeV<:Real, TypeDistr<:Distribution}

    new{TypeV, TypeDistr}(hx, g, B, samples)
  end
end

#=
The function sample_mc, that takes a distribution and an ImportanceSampling object and returns the mean of the function hx evaluated at the samples, weighted by the importance sampling weights.
=#
function sample_mc(f::TypeDistr, samp::ImportanceSampling) where {TypeDistr<:Distribution}

  samples = samp.samples
  hx::Function = samp.hx
  g = samp.g 
  for b in 1:samp.B
    samples[b] = rand(g)
  end
  
  return mean(hx.(samples) .* pdf(f, samples) ./ pdf(g, samples))

end


#=
The function sample_mc, that takes a distribution and a StandardMC_V1 object and returns the mean of the function hx evaluated at the samples.
=#
function sample_mc(f::TypeDistr, samp::StandardMC_V1) where {TypeDistr<:Distribution}

  samples = samp.samples
  hx::Function = samp.hx
  for b in 1:samp.B
    samples[b] = rand(f)
  end

  return mean(hx.(samples))

end

