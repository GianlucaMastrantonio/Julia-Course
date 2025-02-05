#=
This file contains three functions for importance sampling.

The first function, `importance_sampling`, takes as arguments a function `hs`, two continuous univariate distributions `fx` and `gx`, and an integer `B`. It returns an approximation of the integral of `hs` with respect to `fx` using importance sampling with `gx` as the proposal distribution.

The second function, `importance_sampling2`, takes the same arguments as the first function, but it returns an approximation of the integral of `hs` with respect to `fx` using importance sampling with `gx` as the proposal distribution, but it does not store the samples in a vector.

The third function, `importance_sampling3`, takes the same arguments as the first function, but it returns an approximation of the integral of `hs` with respect to `fx` using importance sampling with `gx` as the proposal distribution, but it uses the broadcasting operator `.` to vectorize the operations.

The functions are written in a verbose style to make it easier to understand what is going on.
=#

function importance_sampling(hs::Function, fx::TypeD1, gx::TypeD2, B::Int64) where {TypeD1<:ContinuousUnivariateDistribution,TypeD2<:ContinuousUnivariateDistribution}

  # Create a vector to store the samples
  samp::Vector{Float64} = rand(gx, B)

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
  return ret / B

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

"""
    importance_sampling(hs, fx, gx, B; [threaded=false])

Perform importance sampling estimation of ∫hs(x)fx(x)dx using proposal distribution g(x).

# Arguments
- `hs`: Function to integrate, must map Real → Real
- `fx`: Target distribution (must be a ContinuousUnivariateDistribution)
- `gx`: Proposal distribution (must be a ContinuousUnivariateDistribution)
- `B`: Number of samples (must be ≥ 1)
- `threaded`: Use multithreading (default: false)

# Returns
- Tuple (estimate, variance, relative_eff)

# Examples
```julia
using Distributions
f = Normal(0, 1)
g = Normal(0, 2)
h(x) = x^2
estimate, var, re = importance_sampling(h, f, g, 10_000)
```

Implementation uses vectorized operations with SIMD optimizations.
"""
function importance_sampling(
    hs::Function,
    fx::D1,
    gx::D2,
    B::Int;
    threaded::Bool=false
) where {D1<:ContinuousUnivariateDistribution,
         D2<:ContinuousUnivariateDistribution}
    
    B > 0 || throw(ArgumentError("Number of samples B must be ≥ 1, got $B"))
    
    # Preallocate arrays
    samp = rand(gx, B)
    weights = Vector{Float64}(undef, B)
    hs_vals = Vector{Float64}(undef, B)
    
    # Compute in parallel if requested
    if threaded
        Threads.@threads for i in 1:B
            x = @inbounds samp[i]
            fx_pdf = @inbounds pdf(fx, x)
            gx_pdf = @inbounds pdf(gx, x)
            @inbounds hs_vals[i] = hs(x)
            @inbounds weights[i] = fx_pdf / gx_pdf
        end
    else
        @inbounds @simd for i in 1:B
            x = samp[i]
            fx_pdf = pdf(fx, x)
            gx_pdf = pdf(gx, x)
            hs_vals[i] = hs(x)
            weights[i] = fx_pdf / gx_pdf
        end
    end
    
    # Calculate importance weights
    w_sum = sum(weights)
    w_sq_sum = sum(abs2, weights)
    
    # Normalize weights
    inv_B = 1 / B
    est = dot(hs_vals, weights) * inv_B
    
    # Calculate variance
    var = (sum(hs_vals.^2 .* weights.^2) * inv_B - est^2) / B
    
    # Calculate relative efficiency
    rel_eff = (w_sum^2) / (B * w_sq_sum)
    
    # Check numerical stability
    isnan(est) && @warn "Importance sampling estimate is NaN - check proposal distribution support"
    rel_eff < 1e-3 && @warn "Low relative efficiency ($(round(rel_eff, sigdigits=2))) - consider different proposal distribution"
    
    return est, var, rel_eff
end

@deprecate importance_sampling3 importance_sampling
