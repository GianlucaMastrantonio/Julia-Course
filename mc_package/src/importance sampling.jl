function importance_sampling(hs::Function, fx::TypeD1, gx::TypeD2, B::Int64) where {TypeD1<:ContinuousUnivariateDistribution,TypeD2<:ContinuousUnivariateDistribution}

  samp::Vector{Float64} = rand(gx,B)
  ret::Float64 = 0.0
  for b = 1:B
    ret += hs(samp[b]) * pdf(fx, samp[b])/pdf(gx, samp[b])
  end

  return ret/B

end

function importance_sampling2(hs::Function, fx::TypeD1, gx::TypeD2, B::Int64) where {TypeD1<:ContinuousUnivariateDistribution,TypeD2<:ContinuousUnivariateDistribution}

  ret::Float64 = 0.0
  for b = 1:B
    samp =rand(gx)
    ret += hs(samp) * pdf(fx, samp) / pdf(gx, samp)
  end

  return ret / B

end

function importance_sampling3(hs::Function, fx::TypeD1, gx::TypeD2, B::Int64) where {TypeD1<:ContinuousUnivariateDistribution,TypeD2<:ContinuousUnivariateDistribution}

  samp::Vector{Float64} = rand(gx, B)
  return mean(hs.(samp) .* pdf.(fx, samp) ./ pdf.(gx, samp))


end

