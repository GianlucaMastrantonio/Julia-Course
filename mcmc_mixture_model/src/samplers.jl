
function samples_like_par(Like::NormalLike{Prior}, zeta_model::TypeMix) where {Prior<:UnivariateDistribution,TypeMix<:MixtureObj}

    
  error("Are you sure?")
    

end

function samples_like_par(Like::NormalLike{Normal{Float64}}, zeta_model::TypeMix) where {TypeMix<:MixtureObj}

  y = Like.y
  mu = Like.mu
  sigma2::Float64 = 1
  z = zeta_model.z
  n::Int64 = size(y, 1)
  K::Int64 = size(mu,1)

  par_var = zeros(Float64, K)
  par_mean = zeros(Float64, K)

  par_var[:] .= 1.0 ./ params(Like.prior_mu)[2]
  par_mean[:] .= params(Like.prior_mu)[1] ./ params(Like.prior_mu)[2]
  for i = 1:n

    k = z[i]
    
    par_var[k] += 1.0 / sigma2
    par_mean[k] += y[i] / sigma2

      
  end

  par_var = 1.0 ./ par_var
  par_mean = par_var .* par_mean

  for k in 1:K
    
    mu[k] = rand(Normal(par_mean[k], sqrt(par_var[k])))

  end

  return nothing

end




function samples_like_par(Like::PoissonLike_V2{Gamma{Float64}}, zeta_model::TypeMix) where {TypeMix<:MixtureObj}

  y = Like.y
  lambda = Like.lambda
  
  z = zeta_model.z
  n::Int64 = size(y, 1)
  K::Int64 = size(lambda, 1)

  par_a = zeros(Float64, K)
  par_b = zeros(Float64, K)
  par_a[:] .= params(Like.prior_lambda)[1]
  par_b[:] .= 1.0/params(Like.prior_lambda)[2]
  for i = 1:n

    k = z[i]

    par_a[k] += y[i]
    par_b[k] += 1.0


  end
  par_b = 1.0 ./ par_b

  for k in 1:K

    lambda[k] = rand(Gamma(par_a[k], par_b[k]))

  end

  return nothing

end



function sample_zeta(Like::PoissonLike_V2{Gamma{Float64}}, zeta_model::GenMixture)


  y = Like.y
  lambda = Like.lambda

  z = zeta_model.z
  n::Int64 = size(y, 1)
  K::Int64 = size(lambda, 1)

  log_prob::Vector{Float64} = zeros(Int64, K)

  for iobs in 1:n
    
    for k in 1:K

      log_prob[k] = log(zeta_model.prob[k]) + logpdf(Poisson(lambda[k]), y[iobs])

    end

    z[iobs] = argmax(log_prob .+ rand(Gumbel(0.0, 1.0),K))

  end
  


end



function sample_prob(Prior_prob::NoSampProb, zeta_model::GenMixture)



end

function sample_prob(Prior_prob::Dirichlet{Float64,Vector{Float64},Float64}, zeta_model::GenMixture)

  z = zeta_model.z
  prob = zeta_model.prob
  K::Int64 = size(prob,1)
  par_post::Vector{Float64} = deepcopy(Prior_prob.alpha)
  n::Int64 = size(z,1)
  for iobs in 1:n

    par_post[z[iobs]] += 1.0

  end
  
  prob .= rand(Dirichlet(par_post))


end















