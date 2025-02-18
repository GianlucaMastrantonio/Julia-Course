abstract type LikelihoodObj end

## see https://github.com/JuliaStats/Distributions.jl/blob/e470421079f2eb4f725657842fbbab40bd981fc8/docs/src/types.md?plain=1#L88
struct NormalLike{TypeDistrMu<:ContinuousUnivariateDistribution} <: LikelihoodObj
  
  y::Vector{Float64}
  mu::Vector{Float64}
  
  distr::Normal{Float64}
  prior_mu::TypeDistrMu

  function NormalLike(y::Vector{Float64}, mu::Vector{Float64}, distr::Normal{Float64}, prior_mu::TypeDistrMu) where {TypeDistrMu<:ContinuousUnivariateDistribution}


    new{TypeDistrMu}(y::Vector{Float64}, mu::Vector{Float64}, distr::Normal{Float64}, prior_mu::TypeDistrMu)

  end

end

struct PoissonLike_V2{TypeDistrLambda<:ContinuousUnivariateDistribution} <: LikelihoodObj
  
  y::Vector{Int64}
  lambda::Vector{Float64}
  
  
  distr::Poisson{Float64}
  prior_lambda::TypeDistrLambda
  

  function PoissonLike_V2(y::Vector{Int64}, lambda::Vector{Float64}, distr::Poisson{Float64}, prior_lambda::TypeDistrLambda) where {TypeDistrLambda<:ContinuousUnivariateDistribution}


    new{TypeDistrLambda}(y::Vector{Int64}, lambda::Vector{Float64}, distr::Poisson{Float64}, prior_lambda::TypeDistrLambda)

  end
end

function extract_param!(iter::Int64, out::Matrix{Float64}, Like::PoissonLike_V2{TypeDistr}) where {TypeDistr<:ContinuousUnivariateDistribution}

  out[iter,:] = Like.lambda

end

function extract_param!(iter::Int64, out::Matrix{Float64}, Like::NormalLike{TypeDistr}) where {TypeDistr<:ContinuousUnivariateDistribution}

  out[iter, :] = Like.mu

end

abstract type MixtureObj end


struct GenMixture <: MixtureObj

  z::Vector{Int64}
  prob::Vector{Float64}

  function GenMixture(z::Vector{Int64}, prob::Vector{Float64})

    new(z::Vector{Int64}, prob::Vector{Float64})

  end

end




struct NoSampProb <: ContinuousMultivariateDistribution


  
  function NoSampProb()

    new()
  end

end