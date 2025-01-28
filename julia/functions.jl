dir = "/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/julia/"
using Pkg
Pkg.activate(dir)
using Distributions
using Term 

# * #SECTION: Functions
#= 
a generic structure for functions is
=#
function compute_area_rectangle(x,y)
  println("function 1  ")
  return x*y
end

compute_area_rectangle(2,2.3)

#= 
as explained before, it is important for Julia to know the types. In this case, it is not possible to know the type of x and y, or even the return type. Hence, Julia, create many different version of the funciton for each possible type. We can specify the types of the arguments and the return type of the function.
=#
function compute_area_rectangle(x::Int64, y::Int64)::Int64 # the ::Int64 outside parenthesis is the return type
  println("function 2 ")
  return x * y
end

compute_area_rectangle(2,2.3)
compute_area_rectangle(2,2)

# note that if the return type is not the one specified, it will give an error. This ie very important for Julia since it knows the output type

#= 
This is another important aspect of Julia: it is possible to define a function with the same name, but with different argument type. In this case. If the aruments are not Int64, it will use the first, otherwise the second
=#

#= 
Since we know that this is a function for scalar, we may be tempeted to defined by specifiend the asbtrasct type higher in the yerarchi of number, which is Real
=#
Term.typestree(Int)
Term.typestree(Float64)
Term.typestree(Real)

function compute_area_rectangle(x::Real, y::Real)::Real 
  println("function 3 ")
  return x * y
end

compute_area_rectangle(2, 2.3)
compute_area_rectangle(2, 2)

#= 
Even if it is a litle bit better, it is not optimal because Julia will still define many funciton and have to determine which one
  A better solution os the following
=#

function compute_area_rectangle_new(x::TypeN, y::TypeN)::TypeN where {TypeN<:Real}
  println("function 4 ")
  return x * y
end

# TypeN is a word that we decide that defines the type, and then with {TypeN<:Real} we define that the type is a subtype of a Real

compute_area_rectangle_new(2, 2)
compute_area_rectangle_new(2.3, 2.3)

# This approach work everytime the arguments have the same type and give a result of the same type. If the type are different, it give an error. 
compute_area_rectangle_new(2, 2.3)
#But you should not multiply different types. A solution is
compute_area_rectangle_new(Float64(2), 2.3)

# In theory, we cannot apply the function to a vector because is not a subtype of a real
compute_area_rectangle_new([1; 2; 3], [1; 2; 3])
# but we can use the dot operator, without defining a new function
compute_area_rectangle_new.([1; 2; 3], [1; 2; 3])

# another solution is to define a new functon that operated with vectors

function compute_area_rectangle_new(x::Vector{TypeN}, y::Vector{TypeN})::Vector{TypeN} where {TypeN<:Real}
  println("function 5 ")
  return x .* y
end

compute_area_rectangle_new([1; 2; 3], [1; 2; 3])
compute_area_rectangle_new([1.0; 2.0; 3.0], [1.0; 2.0; 3.0])
compute_area_rectangle_new([1.0; 2.0; 3.0], Float64.([1; 2; 3]))


# We can also define function with the same name and different arguments
function compute_area_rectangle_new(x::Vector{TypeN}, y::Vector{TypeN}, app::Float64)::Vector{TypeN} where {TypeN<:Real}
  println("function 6 ")
  return x .* y
end
compute_area_rectangle_new([1; 2; 3], [1; 2; 3])
compute_area_rectangle_new([1; 2; 3], [1; 2; 3], 1.0)


# * #SUBSECTION: Function Arguments
#=
Argument of a funciton can be passed in two way
- by position: to the left of ;
- by name: to the right of ;
all the elements passed by name can have defalt values, and thelast parameter of the ones passed by position can have default values
=#

function test_arguments(x::Int64, y::Int64, z::Int64 = 3, w::Int64 = 4; a::Int64 = 5, b::Int64 = 6)
  
  ret = zeros(Int64,6)
  ret[1] = x
  ret[2] = y
  ret[3] = z
  ret[4] = w
  ret[5] = a
  ret[6] = b

  return ret
end

test_arguments(1,2)
test_arguments(1, 2,40)
test_arguments(1, 2, 40; a = 10)





#= 
if a fuction has a parameter that is a mutable struct, it is passed by reference, and not by value, meaning that it is not copied in the function, and we can change it in the function. 
- This is very useful when we have large object.
- The only thing to be careful is that we can change the valued but not the entire object
- It is custumary to us an ! at the end of the function name to indicate that it changes the arguments value
=#


vector_x = [1; 2; 3]
function change_one_element_f1!(i::Int64, vector_x::Vector{Int64})
  
  vector_x[i] = 10

  return nothing # speficy that there is no return
end
change_one_element_f1!(1, vector_x)
vector_x
change_one_element_f1!(2, vector_x)
vector_x

vector_x = [1; 2; 3]
function change_one_element_f2(i::Int64, vector_x::Vector{Int64}, n::Int64)

  vector_x = zeros(Int64, n)
  vector_x[i] = 10

  return nothing # speficy that there is no return
end

change_one_element_f2(1, vector_x, 3)
vector_x



# * #SUBSECTION: function as argument of functons
# a function is an object of type  Function, and it can be passed as an argument of another function 
function power_func(x::Float64, y::Float64, z::Float64)::Float64

  return x^(y+z)

end

function log_power_func(f::Function, s::Float64, w::Float64, h::Float64)::Float64

  return f(s, w,h)

end

log_power_func(power_func, 2.0, 3.0, 2.0)
power_func(2.0, 3.0, 2.0)

# if we want to change only one value of the functiion power_func, we can use a "lambda" function 
lambda_power_func = param  -> power_func(2.0, param, 3.0)
# now lambda_power_func is a function of only one parameter
lambda_power_func(1.0)


# * #SUBSECTION: @time
#=
we can easily time the computational time of a function, and how many object it creates
=#
vector_x = zeros(Int64, 1000);
@time for i in 1:100000
  change_one_element_f1!(1, vector_x)
end
vector_x = zeros(Int64, 1000)
@time for i in 1:100000
  change_one_element_f2(1, vector_x, 1000)
end
# the secondo is 100 time slower and creates a lot of objects that has to be deleted (gc)


# * #SUBSECTION: More on return

#= 
We can return more than one value in a function
=#

function test_return()

  return 1.0, 1, "test"
end

typeof(test_return())

# the return type is Tuple{Float64, Int64, String}, which is a container for multiple values. It is better to write 
function test_return()::Tuple{Float64, Int64, String}

  return 1.0, 1, "test"
end

# tu assign the values to variables we can use
a1, a2, a3 = test_return()
# or, if we are itnerested in a subset
a1, _, a3 = test_return()
