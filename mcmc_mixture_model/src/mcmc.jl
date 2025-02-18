

function mcmc_model(
  dataset::Vector{TypeData};
  K::Int64 = 3,
  z_init::Vector{Int64},
  
  prior_mu::TypeDistrMu = Normal(0,10000),
  prior_lambda::TypeDistrLambda=Gamma(1.0, 1.0),
  prior_prob::TypeDistrProb = NoSampProb(),
  mcmc_par::@NamedTuple{iter::Int64, burnin::Int64, thin::Int64}=(iter=1000, burnin=500, thin=2)


) where {TypeData<:Real,TypeDistrLambda<:ContinuousUnivariateDistribution,TypeDistrMu<:ContinuousUnivariateDistribution,TypeDistrProb<:ContinuousMultivariateDistribution}


  ### mcmc param
  mu_mcmc = rand(Uniform(1, 50), K)
  lambda_mcmc = rand(Uniform(1,50),K)
  z_mcmc = z_init
  pi_mcmc = ones(Int64, K) ./ K

  
  ###
  
  if typeof(dataset) == Vector{Float64}

    like_obj = NormalLike(dataset, mu_mcmc, Normal(), prior_mu)

  elseif typeof(dataset) == Vector{Int64}

    like_obj = PoissonLike_V2(dataset, lambda_mcmc, Poisson(), prior_lambda)

  else

    error("Like")

  end


  ## mixture model

  zeta_model = GenMixture(z_mcmc, pi_mcmc)

  sample_to_save::Int64 = floor((mcmc_par.iter - mcmc_par.burnin) / mcmc_par.thin);
  

  ## ut
  param_out = zeros(Float64, sample_to_save, K)
  zeta_out = zeros(Int64, sample_to_save, length(z_mcmc))
  prob_out = zeros(Float64, sample_to_save, K)

  thin_burnin::Int64 = mcmc_par.burnin



  for iMCMC in 1:sample_to_save

    for _ in 1:thin_burnin

      samples_like_par(like_obj, zeta_model)

      sample_zeta(like_obj, zeta_model)

      sample_prob(prior_prob, zeta_model)

    end
    thin_burnin = mcmc_par.thin

    
    extract_param!(iMCMC, param_out, like_obj)
    zeta_out[iMCMC, :] = zeta_model.z[:]
    prob_out[iMCMC,:] = zeta_model.prob

  end


  return (param=param_out, z=zeta_out, prob=prob_out)


end