dir = "/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/julia/"
using Pkg
Pkg.activate(dir)

start_proj::Bool = false
if start_proj

  Pkg.add("RCall")
  Pkg.add("ToggleableAsserts")

end

# * #SECTION: RCall

#=
There are thing tha, at least for me, are not easy to do in Julia. For exmaple graph, saving object or data cleaning etc

It is actuallyr eally easy to call R from julia and move object from and to R, by using the pckage RCall (there are simular packages for Phyton)

something Julia and R have compatibility problems (expecially if you update one of the two). You can select with R to use by setting the pato as
ENV["R_HOME"] = "path_to_r_version_to_use"
=#

using RCall


using Distributions
# you should move "simple" object, sich as  matrix and vector from julia to R, to facilitate the conversion

# create some object
sample_norm = rand(Normal(0.0, 1.0), 100);

# move it to R
@rput sample_norm
# now you can use R's functions inside the R""" ... """"
R"""

plot(density(sample_norm))


new_sample_norm = sample_norm+2

"""

# move it back to julia
@rget new_sample_norm;

# by using $ in the REPL, you can access R console


# * #SECTION: ToggleableAsserts

#=
Sometimes, to debugg the code, we can make some assertion that we think should be true. To do this in a very simple way, we can use the @asset macro (or if/esle). 
  The problem is that, expecially if you have many, this can slow down code. So, we can use the ToggleableAsserts package.
=#

using ToggleableAsserts;
using Revise
using mc_package



# let see the two funciton in the assert.jl file of the package
mc_package.test_assert(1,1)
mc_package.test_assert(1, 2)
mc_package.test_toggled_assert(1,1)
mc_package.test_toggled_assert(1, 2)


# no we can turn off the toggleable assert
toggle(false)
mc_package.test_assert(1, 1)
mc_package.test_assert(1, 2)
mc_package.test_toggled_assert(1, 1)
mc_package.test_toggled_assert(1, 2)


# * #SECTION: MULTI THREADING

#=
Multi threading in julia it is easy. There are two ways. 
- using the @threads macro: used on a for cicle. The number of iterration is splitte equally between the threads. THis does not take into consideration how long each iteration takes
- using the @spawn macro: can be use even outside a for cicle. Avery time a thread has finished the task it start the new one

- It seem that spawn is more efficient, but you must be careful that to start spawn or threads has a computational cost, and spawn has a larger one


Se the functions in the multi_threading.jl file
=#

# to see how many thread do you have use
Threads.nthreads()
# you can increase the number that julai used 
# -by looking at the VCcode setting, if you use vscode
# - by specifing its value at the start of julia in the terminal: JULIA_NUM_THREADS=4 julia


iter = 10
test1 = zeros(Int64,iter);
test2 = zeros(Int64,iter);

test_multi_threading(iter, Uniform(0.5,2.0), test1)
# here the thread are evenly distributed
test1

test_multi_threading(iter, Uniform(0.5, 2.0), test2)
# here are "random"
test2

