#=
When using multi-threading, it is important to keep in mind that multiple threads can access the same variables.
This can lead to race conditions, where two threads try to change the same part of the memory at the same time.
The results of this are random and can be difficult to debug.

The easiest way to avoid this is to use a for loop with only one function call.
This ensures that each thread has its own local variables and does not share any variables with other threads.

To do this, we can use the Threads.@threads macro. This macro automatically splits the loop into as many parts as there are threads available
and assigns each part to a different thread. The function call is then executed in parallel on each thread.

For example, in the following code, the function test_multi_threading will be called in parallel on each thread.
The argument i is the number of times to call the function, the argument wait is a uniform distribution from which we draw the sleep time,
and the argument vec is a vector where we store the thread id.

The function test_multi_threading_uni is the function that is called in parallel. It simply sleeps for a random amount of time and then stores the thread id in the vector.
=#

function test_multi_threading(i::Int64, wait::Uniform{Float64}, vec::Vector{Int64})

  # Split the loop into as many parts as there are threads available and assign each part to a different thread.
  Threads.@threads for j in 1:i
    # Call the function in parallel on each thread
    test_multi_threading_uni( j, wait, vec)
  end

end

function test_multi_threading_uni(j::Int64, wait::Uniform{Float64}, vec::Vector{Int64})
  
  # Sleep for a random amount of time
  sleep(rand(wait))
  # Store the thread id in the vector
  vec[j] = Threads.threadid()
  println(Threads.threadid())

end

#=
If you want to run operations in parallel that are not in a for loop, you can use the Threads.@spawn macro.
The idea is that @sync defines the part of the code that you want to run in parallel.
If it is not a for loop you can use

@sync begin
  
  Threads.@spawn operation1
  Threads.@spawn operation2
  Threads.@spawn operation3
  ...
  Threads.@spawn operationN

end

a free thread will start one operation, regardless if the previous one are all completed. For this reason they must be independent 
=#
function test_multi_spawn(i::Int64, wait::Uniform{Float64}, vec::Vector{Int64})

  # Define the part of the code that you want to run in parallel
  @sync for j in 1:i
    # Call the function in parallel on each thread
    Threads.@spawn test_multi_spawn_uni(j, wait, vec)
  end

  

end

function test_multi_spawn_uni(j::Int64, wait::Uniform{Float64}, vec::Vector{Int64})

  # Sleep for a random amount of time
  sleep(rand(wait))
  # Store the thread id in the vector
  vec[j] = Threads.threadid()
  println(Threads.threadid())
end

