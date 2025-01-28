# * #SECTION: Introduction
# * #DESCRIPTION: Julia in a Nutshell
#=
* Released in 2012
* Geared towards numerical (math) and scientific computing
* Open-source (contributors welcome)
* A solid, flexible, and powerful language, easy to learn and use but also fast
* Supports rapid prototyping and interactive exploration of numerical algorithms and datasets
* High-level language (garbage collecting, variable-length structures)
* Comprehensive support for linear algebra, statistics, and plotting
* Most operators and functions work on entire matrices
* Internally uses highly optimized numerical libraries (BLAS, LAPACK, FFTW)
* Supports interactive use via a read-evaluate-print loop (REPL)
* Interpreted or just-in-time compiled, with notebook support
* Comprehensive toolboxes/modules/packages for easy access to standard algorithms from various fields:
  * Statistics
  * Machine learning
  * Image processing
  * Signal processing
  * Neural networks
  * Wavelets
  * Communication systems
* Very easy I/O for many data and multimedia file formats
=#

# * #DESCRIPTION: Drawbacks 
#=


* Start-up delay when loading/calling large packages, as they need to be JIT compiled first (“time to first plot”).
* Not aimed at compilation of stand-alone binaries.
* Not designed for hard real-time applications:
* The package ecosystem and documentation are sometimes less mature or complete compared to Python, R, or MATLAB.
* The diversity of the package ecosystem can be confusing initially (e.g., several competing major plotting libraries).

=#

# * #DESCRIPTION: Installing and Running Julia
#=

* Julia can be downloaded from <https://julialang.org/>, and then it can be executed in the terminal (by typing ``julia''), but it is much easier to work with VSCode.
* To use Julia in Vscode, install the Julia extension and then open the Julia file in the editor (there is a guide <https://code.visualstudio.com/docs/languages/julia>).
* Julia scripts have extension ``.jl''

=#

# * #SECTION: Setting Up the Environment
# * #DESCRIPTION: First operations
#=
The first operations in Julia are probably the most confusing.

* As in many other languages, Julia needs packages. The first package to load is the package manager Pkg.
* We can set different environments (loaded packages with their version) on different folders. To do that, we need to activate the folder with `Pkg.activate("FolderName")`.
* Things to do only one time:
  * Only if you do not have a Manifest and Project file in your activated folder, you need to create them with `Pkg.instantiate()`.
  * Packages can be added to the environment with `Pkg.add("Distributions")`.
* Once you activate the environment, the package must be loaded with `using PackageName`.

By sharing the Manifest and Project file, it is possible to have the same environment on different folders or computers and be sure that the version of the package loaded is always the same.
=#
# * #DESCRIPTION: Julia Code

# Set the directory for the package environment
dir = "/Users/gianlucamastrantonio/Dropbox (Politecnico di Torino Staff)/lavori/Julia Course/julia/"

# load the Pkg package
using Pkg

# Activate the package environment
Pkg.activate(dir)

# Flag indicating if it's the first time setting up the environment
first_time::Bool = false
if first_time
  # Instantiate the package environment if it's the first time
  Pkg.instantiate()

  # Add necessary packages if they are not already installed
  Pkg.add("Distributions")
  Pkg.add("AbstractTrees")
  Pkg.add("Term")
  #Pkg.add("JuliaFormatter")
end

# Load the package used in this script
using Term # to see types

# * #SECTION: Basic Operations and Objects
# * #SUBSECTION: Types
#=
every object in Julia has a type. For example
=#

x = 1 + 2
y = 1.0 + 2.0
z = 1 + 2
typeof(x)
typeof(y)
typeof(z)

#=
Types are organized in a hierarchy, for example we can see the Int and Float
=#
Term.typestree(Int)
Term.typestree(Float64)
#=
# !For performance reasons 
- it is important that Julia always knows the type of each variable
- The type of an object must be as specialized as possible (the right column of the tree)

the type of an object can be checked with the typeof() function
=#

#=
We have two possibilities
- We can check the type of an object with the :: on the right-hand side of an operation. This will give an error if the type is not correct
- We can impose a type to an object with the:: on the left-hand side of an operation (preferable option)

P.S. in the global scope (the script), it is not possible to assign a new type to an existing object of a different type, but it is possible in other scopes
=#

# option 1 - Note that we can change the type of x 
typeof(x)
x = z::Float64
x = z::Float32
x = z::Int64
x = 1.4
typeof(x)

# option 2 - Note that we cannot change the type of the object anymore
h::Float64 = z
h = 1
typeof(h)
h = 1 + 2
typeof(h)

w::Int64 = 1
w = 1.2

#=
Be careful: if h is  a float, and you do
=#
h = 1 + 2
#=
# julia need to infer the type of the operation and do a cast. This should be avoided. A better solution is
=#
h = Float64(1 + 2)

#=
Important objects are the literal zero and literal 1
=#
typeof(zero(x))
typeof(zero(z))

typeof(one(x))
typeof(one(z))


# * #SUBSECTION: Vectors, Matrices, and Array
#=
There are different ways to define a vectors
=#
x_vec = [1; 2; 3];
x_vec = zeros(Int64, 3)
x_vec = ones(Int64, 3) * 1
x_vec = Vector{Int64}(undef, 3)

#=
Vectors, Matrices and Array are parametric type. Meaning that their type has an argument. Which is indicated as the type of the object that it contains, shown in the brackets.
=#
typeof(x_vec)

#=
Here is even more important to give the define the object of the object, in the more precise way is possible 
=#
z_vec::Vector{Float64} = Vector{Float64}(undef, 3)

#=
Similar constructor are available for matrices and arrays. 
=#

x_mat = [1 2 3; 4 5 6]
x_mat = zeros(Int64, 2, 3)
x_mat = ones(Int64, 2, 3) * 1
x_mat = Matrix{Int64}(undef, 2, 3)

z_mat::Matrix{Float64} = Matrix{Float64}(undef, 2, 3)

x_array = zeros(Int64, 2, 3, 5)
x_array = ones(Int64, 2, 3, 5) * 1
x_array = Array{Int64,3}(undef, 2, 3, 5)

#=
Note that, for example,  Vector{Int64} is equal to Array{Int64,1} and Matrix{Int64} is equal to Array{Int64,2}
=#

#=
Elements can be access wht square brackets
=#
x_array[1, 2, 3]
x_array[:, 2, :]

#=
We can access matrix and array as vector (be careful of the order of the indexes)
=#
test_array = ones(Int64, 2, 2, 2)
h = 1
for i in 1:2
  for j in 1:2
    for k in 1:2
      test_array[k, j, i] = h
      h += 1
    end
  end
end

test_array[1] 

test_array[2]
test_array[3]
test_array[4]
test_array[5]
test_array[6]
test_array[7]
test_array[8]

#=
Operation such + - / * are defined for vectors, matrices and arrays, and they are matricial operations
=#

mat1 = [1 2 3; 4 5 6]
mat2 = [1 2 3; 4 5 6] * 10

mat1 * mat2 # Le dimensioni non cambaciano
mat1 * transpose(mat2)

#=
notice that the traspose of a matrix has a different type. This is because it is a lazy traspose, meaning that id does not create a new matrix, but keeps the old one with an extra argument specicienf that is the traspose
=#
typeof(transpose(mat2))

# ! #SUBSECTION: IMPORTANT CONSIDERATIONS
#= #
One of the most intriguing aspects of Julia, but potentially risky, is that Arrays, Matrices, and Vectors are mutable structs (which we will discuss in another script). These objects behave like pointers in C++.
=#
#= 
To better understand the implications, let's introduce the
== operator: which checks if two objects have the same values
=== operator: which checks if two objects are actually the same
=#

x_test = [1; 2; 3]
z_test = [1; 2; 3]

x_test == z_test # they have the same value
x_test === z_test # they are different object

# now let's see what happens when we copy an object

z_test = x_test
x_test == z_test # they have the same value
x_test === z_test # they are the same object

# let's first see their elements and then we change the elements of x_text
x_test
z_test

x_test[1] = 10
x_test
z_test

# by changing x we change also z
# this is also true for the transpose of a matrix
mat1 
mat1t = transpose(mat2)

mat1 === mat1t # they are not the same because they are of a different type, but they share the matrix

mat1[1,1] = 1000
mat1t

#=
this is not true for scalars, because they are not structures
=#
a = 1
c = a
c
c = 100
a

#=
if I want to copy a matrix and create a new object I can use 
=#
x_copy = deepcopy(x_test)
x_copy === x_test
x_copy[1] = 120
x_test

#=
if the left-hand side object already exists, I can use
=#

x_copy .= x_test
x_copy === x_test
# or
x_copy[:] = x_test
x_copy === x_test

# ! #SUBSECTION: THE DOT OPERATOR
#=
The dot operator is used to apply a function to each element of an array. 
  - It can be used to assign a new value to each element of an array
  - to perform a dot operation between matrices/vectors
  - to apply a function to each element of an array (we will see it in another script)
=#

x_copy .= x_test

mat1 = [1 2 3; 4 5 6]
mat2 = [2 2 2; 3 3 3]
mat1 .* mat2
mat1 .^ mat2

mat1 ^ 3
mat1 .^ 3