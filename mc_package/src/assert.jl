# This file contains two functions: test_assert and test_toggled_assert.
# The first one uses the @assert macro to check if x is equal to y.
# If x is not equal to y, it will print an error message and stop the execution of the program.
# The second one uses the @toggled_assert macro to check if x is equal to y.
# If x is not equal to y, it will print an error message only if the toggle is turned on.
# The toggle is turned on by calling the toggle(true) function and off by calling the toggle(false) function.
# The toggle is on by default.

function test_assert(x::Int64, y::Int64)
  # Check if x is equal to y.
  # If it is not, print an error message and stop the execution of the program.
  @assert x == y "x is not equal to y: " * string(x) * " != " * string(y)
end


function test_toggled_assert(x::Int64, y::Int64)
  # Check if x is equal to y.
  # If it is not, print an error message only if the toggle is turned on.
  @toggled_assert x == y "x is not equal to y: " * string(x) * " != " * string(y)
end
