# Set the directory for the package environment
dir = "/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/julia/"


using Pkg
Pkg.activate(dir)

start_proj::Bool = false
if start_proj


  # the first step is to create a package, with the command generate
  Pkg.generate("mcmc_mixture_model")
  # then we have to add the package to the environment. Instead of using Pkg.add("my_package"), we can use Pkg.develop(url = ....)
  Pkg.develop(url="/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/mcmc_mixture_model")
  # this command tells julia that changes in the code are expected. If you load the package revise, than every time that you change the code, julia will automatically update the package
  Pkg.add("Revise")
  Pkg.add("Distributions")
  Pkg.add("RCall")



  # we have to create and the manifest and the project also for the package, and this can be done by activating tha package directory and Pkg.add() the packages. Let's we add some useful packages
  Pkg.activate("/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/mcmc_mixture_model")
  Pkg.add("Distributions")
  Pkg.add("Random")
  Pkg.add("LinearAlgebra")
  Pkg.add("PDMats")
  Pkg.add("StatsBase")
  Pkg.add("ToggleableAsserts")
  Pkg.activate(dir)
  # the most important file on a package is the file with the same name on the package, in the src directory. See the contento of the fle

end

using Revise
using Distributions
using mcmc_mixture_model
using Term
using RCall
using Random


## let's check the typestree of distributions
Term.typestree(Normal{Float64})
Term.typestree(Dirichlet{Float64,Vector{Float64},Float64})


## ## ## ## ## ## ## ## ## 
## let's simulate data froma mixture model
## ## ## ## ## ## ## ## ## 
Random.seed!(12)  # Set seed to 1234
n::Int64 = 1000
K::Int64 = 3
pi_vec::Vector{Float64} = rand(Uniform(1,1.2),K)
pi_vec = pi_vec / sum(pi_vec)



mu_vec::Vector{Float64} = rand(Uniform(-50.0,50.0),K)
lambda_vec::Vector{Float64} = rand(Uniform(5.0, 250.0), K)
sigma_vec::Vector{Float64} = ones(Float64,K)
z::Vector{Int64} = zeros(Int64, n)
y_normal::Vector{Float64} = Vector{Float64}(undef,n)
y_pois::Vector{Int64} = Vector{Int64}(undef, n)
for i = 1:n
  k = rand(Categorical(pi_vec))
  z[i] = k
  y_normal[i] = rand(Normal(mu_vec[k], sigma_vec[k]))
  y_pois[i] = rand(Poisson(lambda_vec[k]))
end


@rput y_normal;
@rput y_pois;
@rput z;

R"""

pdf("/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/julia/out/data.pdf")

plot(y_normal, col= z, pch=20)
plot(y_pois, col= z, pch=20)
dev.off()

"""



out = mcmc_model(
   #y_normal;
  y_pois;
  z_init=rand(Categorical(pi_vec),n),
  #prior_prob = NoSampProb()
  prior_prob=Dirichlet(ones(Float64,K)),
  mcmc_par =(iter=10000, burnin=5000, thin=2)
  
)


param_out = out.param
z_out = out.z
prob_out = out.prob

@rput param_out;
@rput z_out;
@rput z;
#@rput mu_vec;
#@rput K;

R"""

pdf("/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/julia/out/mcmc.pdf")

findmode = function(x){
                    TT = table(as.vector(x))
                    return(as.numeric(names(TT)[TT==max(TT)][1]))
            }
zmap = apply(z_out,2,findmode)
mosaicplot(table(z,zmap))
#for(k in 1:K)
#{
#  plot(mu_out[,k], type="l")
#  abline(h = mu_vec, col= 1:K +1, lwd=3)
#}

dev.off()
"""