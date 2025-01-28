
function test_assert(x::Int64, y::Int64)

  @assert x == y "x is not equal to y: " * string(x) * " != " * string(y)
 
end

function test_toggled_assert(x::Int64, y::Int64)

  @toggled_assert x == y "x is not equal to y: " * string(x) * " != " * string(y)

end
