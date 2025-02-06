dir = "/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/julia/"
using Pkg
Pkg.activate(dir)

# * #SECTION: Packages 
#=
  Julia has a very simple way to create packages. Using a package for your functions has a number of advantages:
  - the scope of a package makes more sense of the scope of a script
  - functions outside of a package tend to run slower
  - revise is very useful.
=#

#=
we are going to create a package to do some MC simulation
=#
start_proj::Bool = false
if start_proj
  

  # the first step is to create a package, with the command generate
  Pkg.generate("mc_package")
  # then we have to add the package to the environment. Instead of using Pkg.add("my_package"), we can use Pkg.develop(url = ....)
  Pkg.develop(url="/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/mc_package")
  # this command tells julia that changes in the code are expected. If you load the package revise, than every time that you change the code, julia will automatically update the package
  Pkg.add("Revise")
  Pkg.add("Distributions")



  # we have to create and the manifest and the project also for the package, and this can be done by activating tha package directory and Pkg.add() the packages. Let's we add some useful packages
  Pkg.activate("/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/mc_package")
  Pkg.add("Distributions")
  Pkg.add("Random")
  Pkg.add("LinearAlgebra")
  Pkg.add("PDMats")
  Pkg.add("StatsBase")
  Pkg.add("ToggleableAsserts")
  Pkg.activate(dir)
  # the most important file on a package is the file with the same name on the package, in the src directory. See the contento of the fle
  
end

#=
take the package aside for a moment and let introduce the package Distributions
=#
using Revise
using mc_package 
#=
using mc_package  may give you error, if you change the packages that your package depends on. Julia tells you the solution to this issue.
In general, Julia tells you the problem, where it is (if it is a function of a package, she tells you the row), and sometimes how to solve it
=#
using Distributions
using Term
# * SUBSECTION: Distributions

#=
In Julia, distributions are Types, as Float and Int. For example we can create an object of type N(10,2)
=#
dist1 = Normal(10,2)
typeof(dist1)

# all julia packages are on github, and you can see there the code and the functions: https://github.com/JuliaStats/Distributions.jl

# since it is a type, the function that has dist1 has a type give output based on the object
# some examples
rand(dist1)
rand(dist1,2,3)
mean(dist1) # true expected value
var(dist1) # true variance
logpdf(dist1,1)
logcdf(dist1, 1)
quantile(dist1,0.5)

# we can extract the parameters of the distribution
params(dist1)
# or
dump(dist1)
# note that parameters are actually greek letters. In Julia you can use unicode characters, for example
Σ = 2
ζ = Σ*3
ζ

# as for the traspose of a matrix (even though ' and traspose create two different objects)
zmat = rand(Gamma(1,1),3,2);
zmat
zmat'
transpose(zmat)

# we can access the parameters as (depends on the distribution)
typeof(params(dist1))
params(dist1)[1]
dist1.μ

# * SUBSECTION: importance sampling
#=
We want to compute an MC approximation of the integral
int h(x)f(x) d(x)
by using importance sampling
int h(x)f(x)/g(x)g(x) d(x) approx sum_{b=1}^B (h(x_b)f(x_b)/g(x_b))/B

- our function need
- B
- f(x)
- g(x)

look at the function defined in the package
=#


function func_h(x::Float64)

  return x^2

end


importance_sampling(func_h, Gamma(1.0, 1.0), TDist(3.0), 1000)

# we can check if the support of the g contains the one of  f, with the function issubset
support(Gamma(1.0, 1.0))
# maybe it is better to put this control inside the function

# as a test, let's check the differente function and which one is faster. Even though there is not much difference
@time for isim in 1:10000
  importance_sampling(func_h, Gamma(1.0, 1.0), TDist(3.0), 1000)
end

@time for isim in 1:10000
  mc_package.importance_sampling2(func_h, Gamma(1.0, 1.0), TDist(3.0), 1000)
end

@time for isim in 1:10000
  mc_package.importance_sampling3(func_h, Gamma(1.0, 1.0), TDist(3.0), 1000)
end

# * #SECTION: Structures and Types
# * #SUBSECTION: Monte Carlo
#=
Suppose that we want to define a function that approximate and integral with MC, but we want that, based on the type of the parameters, the function will use the standard MC or the one with importance sampling. We can do it with the structure. See the file gen_struct.jl
=#


# we can create the first object
mc_standard = StandardMC_V1(func_h, 100, zeros(Float64, 100));
typeof(mc_standard)

# I can change the value of the object
mc_standard.B = 20
mc_standard.B

vec_norm = rand(Normal(0.0, 1.0), 100)
mc_standard.samples = vec_norm

mc_standard.samples


# let's see what happens with the immutable one

mc_standard_imm = StandardMC_immutable_V2(func_h,100, zeros(Float64, 100));
mc_standard_imm.B = 20
vec_norm = rand(Normal(0.0, 1.0), 100)
mc_standard_imm.samples = vec_norm
# we cannot change the element, but since a vector is mutable, we can change their value
mc_standard_imm.samples[1:3] .=  [1.0, 2.0, 3.0]
mc_standard_imm.samples


# you should be careful when the object is created, because since arguments are passed by reference, the vector inside the object and the one used to create the object are the same
# it is dangerous but also helpful when object must have things in common
# for example each object may represent a level of a hierarchical model with shared random variables

test_vec = rand(Normal(0.0,1.0),5)
mc_standard_imm = StandardMC_immutable_V2(func_h,5, test_vec);

test_vec === mc_standard_imm.samples

test_vec[1] = 100000.0
mc_standard_imm.samples[1]
# this can be very useful. If you don't like it, just use a deepcopy in the constructur, or define a constructor without the matrix
StandardMC_V1(func_h,100);

# we can also use the parametric version of the structure
mc_standard_par = StandardMCPar_V1(func_h, 5, test_vec);
typeof(mc_standard_par)


# * #SUBSECTION: Importance sampling and MC function

# let's define an importance sampling object
test_vec = zeros(Float64,5)
imp_samp = ImportanceSampling(func_h, Gamma(1.0, 1.0), 5, test_vec);
dump(imp_samp)
typeof(imp_samp)


# now that we have the two functions we can use the mc function
n_samples::Int64 = 1000
test_vec = zeros(Float64, n_samples)
function func_h(x::Float64)

  return x

end
mc1 = ImportanceSampling(func_h, Normal(0.0, 1.0), n_samples, deepcopy(test_vec));
mc2 = StandardMC_V1(func_h,n_samples, deepcopy(test_vec));


mc_package.sample_mc(TDist(100.0), mc1)
mc_package.sample_mc(TDist(100.0), mc2)

