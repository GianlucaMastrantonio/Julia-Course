#=
This file contains three functions for importance sampling.

The first function, `importance_sampling`, takes as arguments a function `hs`, two continuous univariate distributions `fx` and `gx`, and an integer `B`. It returns an approximation of the integral of `hs` with respect to `fx` using importance sampling with `gx` as the proposal distribution.

The second function, `importance_sampling2`, takes the same arguments as the first function, but it returns an approximation of the integral of `hs` with respect to `fx` using importance sampling with `gx` as the proposal distribution, but it does not store the samples in a vector.

The third function, `importance_sampling3`, takes the same arguments as the first function, but it returns an approximation of the integral of `hs` with respect to `fx` using importance sampling with `gx` as the proposal distribution, but it uses the broadcasting operator `.` to vectorize the operations.

The functions are written in a verbose style to make it easier to understand what is going on.
=#

function importance_sampling(hs::Function, fx::TypeD1, gx::TypeD2, B::Int64) where {TypeD1<:ContinuousUnivariateDistribution,TypeD2<:ContinuousUnivariateDistribution}

  # Create a vector to store the samples
  samp::Vector{Float64} = rand(gx,B)

  # Initialize the return variable to zero
  ret::Float64 = 0.0

  # Loop over the samples
  for b = 1:B
    # Evaluate the function `hs` at the current sample
    hs_val = hs(samp[b])

    # Evaluate the probability density function of `fx` at the current sample
    pdf_fx = pdf(fx, samp[b])

    # Evaluate the probability density function of `gx` at the current sample
    pdf_gx = pdf(gx, samp[b])

    # Update the return variable
    ret += hs_val * pdf_fx / pdf_gx
  end

  # Return the average of the values of the function `hs` evaluated at the samples
  return ret/B

end

function importance_sampling2(hs::Function, fx::TypeD1, gx::TypeD2, B::Int64) where {TypeD1<:ContinuousUnivariateDistribution,TypeD2<:ContinuousUnivariateDistribution}

  # Initialize the return variable to zero
  ret::Float64 = 0.0

  # Loop over the samples
  for b = 1:B
    # Generate a new sample from the proposal distribution `gx`
    samp = rand(gx)

    # Evaluate the function `hs` at the current sample
    hs_val = hs(samp)

    # Evaluate the probability density function of `fx` at the current sample
    pdf_fx = pdf(fx, samp)

    # Evaluate the probability density function of `gx` at the current sample
    pdf_gx = pdf(gx, samp)

    # Update the return variable
    ret += hs_val * pdf_fx / pdf_gx
  end

  # Return the average of the values of the function `hs` evaluated at the samples
  return ret / B

end

function importance_sampling3(hs::Function, fx::TypeD1, gx::TypeD2, B::Int64) where {TypeD1<:ContinuousUnivariateDistribution,TypeD2<:ContinuousUnivariateDistribution}

  # Generate a vector of samples from the proposal distribution `gx`
  samp::Vector{Float64} = rand(gx, B)

  # Evaluate the function `hs` at the samples
  hs_val = hs.(samp)

  # Evaluate the probability density function of `fx` at the samples
  pdf_fx = pdf.(fx, samp)

  # Evaluate the probability density function of `gx` at the samples
  pdf_gx = pdf.(gx, samp)

  # Return the average of the values of the function `hs` evaluated at the samples
  return mean(hs_val .* pdf_fx ./ pdf_gx)

end

