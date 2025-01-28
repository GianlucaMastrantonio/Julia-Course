#=
to avaoid the race condition, it is good practice to have a for cicle, that has only one funciton
Otherwise, variables can be shared across threads, and f two trhead try to change the same part of the memory
the results are random
=#



# ! Threads.@threads
# just put Threads.@threads before the for cicle
function test_multi_threading(i::Int64, wait::Uniform{Float64},vec::Vector{Int64})

  Threads.@threads for j in 1:i
    test_multi_threading_uni( j, wait, vec)
  end

end

function test_multi_threading_uni(j::Int64, wait::Uniform{Float64}, vec::Vector{Int64})
  
  sleep(rand(wait))
  vec[j] = Threads.threadid()

end

# ! Threads.@spawn

#= 
spawn is a bit more complex. If you use it in a for cycle is easy. But if you use it outside a for cicle, is more complex.
The idea is tha @sync defines the part of the code that you want to run in parallel. If it is not a for cycle you can use
#sync begin
  
  Threads.@spawn operation1
  Threads.@spawn operation2
  Threads.@spawn operation3
  ...
  Threads.@spawn operationN

end

a free thread will start one operation, regardless if the previous one are all completed. For this reason they must be independent 
=#
function test_multi_spawn(i::Int64, wait::Uniform{Float64}, vec::Vector{Int64})

  @sync for j in 1:i
    Threads.@spawn test_multi_spawn_uni(j, wait, vec)
  end

  

end

function test_multi_spawn_uni(j::Float64, wait::Uniform{Float64}, vec::Vector{Int64})

  sleep(rand(wait))
  vec[j] = threadid()

end
