"""
    inpaint(A)

Inpaints `missing` values if `A` contains some.

Inspired by MATLAB's `inpaint_nans`'s (by John d'Errico: [link](https://www.mathworks.com/matlabcentral/fileexchange/4551-inpaint_nans)).

# Example
```jldoctest
julia> A = convert(Array{Union{Float64, Missing},2}, (1:5)*(1:5)') ; A[1:2, 1:2] .= missing ; A
5×5 Array{Union{Missing, Float64},2}:
  missing    missing   3.0   4.0   5.0
  missing    missing   6.0   8.0  10.0
 3.0        6.0        9.0  12.0  15.0
 4.0        8.0       12.0  16.0  20.0
 5.0       10.0       15.0  20.0  25.0

julia> inpaint(A)
5×5 Array{Union{Missing, Float64},2}:
 1.0   2.0   3.0   4.0   5.0
 2.0   4.0   6.0   8.0  10.0
 3.0   6.0   9.0  12.0  15.0
 4.0   8.0  12.0  16.0  20.0
 5.0  10.0  15.0  20.0  25.0
```
"""
inpaint(A::VecOrMat{Union{Missing, T}}; method=1, cycledims=Int64[]) where {T<:AbstractFloat} = inpaint(ismissing, A, method=method, cycledims=cycledims)

"""
    inpaint(A)

Inpaints `NaN` values if the elements of `A` are all float (i.e., `eltype(A) <: AbstractFloat`).

# Example

```jldoctest
julia> A = float((1:5)*(1:5)') ; A[1:2, 1:2] .= NaN ; A
5×5 Array{Float64,2}:
 NaN    NaN     3.0   4.0   5.0
 NaN    NaN     6.0   8.0  10.0
   3.0    6.0   9.0  12.0  15.0
   4.0    8.0  12.0  16.0  20.0
   5.0   10.0  15.0  20.0  25.0

julia> inpaint(A)
5×5 Array{Float64,2}:
 1.0   2.0   3.0   4.0   5.0
 2.0   4.0   6.0   8.0  10.0
 3.0   6.0   9.0  12.0  15.0
 4.0   8.0  12.0  16.0  20.0
 5.0  10.0  15.0  20.0  25.0
```
"""
inpaint(A::VecOrMat{T}; method=1, cycledims=Int64[]) where {T<:AbstractFloat} = inpaint(isnan, A, method=method, cycledims=cycledims)

"""
    inpaint(A, missing)

Inpaints `missing` values.
Should be the same as `inpaint(A)`.
"""
inpaint(A::VecOrMat, ::Missing; method=1, cycledims=Int64[]) = inpaint(ismissing, A, method=method, cycledims=cycledims)

"""
    inpaint(A, value_to_fill)

Inpaints `value_to_fill` values (can be `NaN`).
Useful in the case data was generated by filling missing values with an
arbitrary chosen one.

# Examples

```jldoctest
julia> A = float((1:5)*(1:5)') ; A[1:2, 1:2] .= 999 ; A
5×5 Array{Float64,2}:
 999.0  999.0   3.0   4.0   5.0
 999.0  999.0   6.0   8.0  10.0
   3.0    6.0   9.0  12.0  15.0
   4.0    8.0  12.0  16.0  20.0
   5.0   10.0  15.0  20.0  25.0

julia> inpaint(A, 999)
5×5 Array{Float64,2}:
 1.0   2.0   3.0   4.0   5.0
 2.0   4.0   6.0   8.0  10.0
 3.0   6.0   9.0  12.0  15.0
 4.0   8.0  12.0  16.0  20.0
 5.0  10.0  15.0  20.0  25.0
```

```jldoctest
julia> A = float((1:5)*(1:5)') ; A[1:2, 1:2] .= NaN ; A
5×5 Array{Float64,2}:
 NaN    NaN     3.0   4.0   5.0
 NaN    NaN     6.0   8.0  10.0
   3.0    6.0   9.0  12.0  15.0
   4.0    8.0  12.0  16.0  20.0
   5.0   10.0  15.0  20.0  25.0

julia> inpaint(A, NaN)
5×5 Array{Float64,2}:
 1.0   2.0   3.0   4.0   5.0
 2.0   4.0   6.0   8.0  10.0
 3.0   6.0   9.0  12.0  15.0
 4.0   8.0  12.0  16.0  20.0
 5.0  10.0  15.0  20.0  25.0
```
"""
function inpaint(A::VecOrMat{T}, value_to_fill; method=1, cycledims=Int64[]) where T<:AbstractFloat
    return if isnan(value_to_fill) 
        inpaint(isnan, A, method=method, cycledims=cycledims)
    else
        inpaint(x -> x == value_to_fill, A, method=method, cycledims=cycledims)
    end
end

"""
    inpaint(f, A)

Inpaints values of `A` for which `f(A) == true`.

# Examples

```jldoctest
julia> A = float((1:5)*(1:5)') ; A[1:2, 1:2] .= 999 ; A
5×5 Array{Float64,2}:
 999.0  999.0   3.0   4.0   5.0
 999.0  999.0   6.0   8.0  10.0
   3.0    6.0   9.0  12.0  15.0
   4.0    8.0  12.0  16.0  20.0
   5.0   10.0  15.0  20.0  25.0

julia> inpaint(x -> x == 999, A)
5×5 Array{Float64,2}:
 1.0   2.0   3.0   4.0   5.0
 2.0   4.0   6.0   8.0  10.0
 3.0   6.0   9.0  12.0  15.0
 4.0   8.0  12.0  16.0  20.0
 5.0  10.0  15.0  20.0  25.0
```

```jldoctest
julia> A = float((1:5)*(1:5)') ; A[1:2, [1, end]] .= NaN ; A
5×5 Array{Float64,2}:
 NaN     2.0   3.0   4.0  NaN
 NaN     4.0   6.0   8.0  NaN
   3.0   6.0   9.0  12.0   15.0
   4.0   8.0  12.0  16.0   20.0
   5.0  10.0  15.0  20.0   25.0

julia> inpaint(isnan, A)
5×5 Array{Float64,2}:
 1.0   2.0   3.0   4.0   5.0
 2.0   4.0   6.0   8.0  10.0
 3.0   6.0   9.0  12.0  15.0
 4.0   8.0  12.0  16.0  20.0
 5.0  10.0  15.0  20.0  25.0
```

    inpaint(f, A; method=1, cycledims=[])

With optional arguments, you can chose the inpainting method and if dimensions are cyclic.

```jldoctest
julia> A = float((1:5)*(1:5)') ; A[1:2, [1, end]] .= NaN ; A
5×5 Array{Float64,2}:
 NaN     2.0   3.0   4.0  NaN
 NaN     4.0   6.0   8.0  NaN
   3.0   6.0   9.0  12.0   15.0
   4.0   8.0  12.0  16.0   20.0
   5.0  10.0  15.0  20.0   25.0

julia> inpaint(A, cycledims=[2])
5×5 Array{Float64,2}:
 2.13971   2.0   3.0   4.0   3.86029
 3.50735   4.0   6.0   8.0   8.49265
 3.0       6.0   9.0  12.0  15.0
 4.0       8.0  12.0  16.0  20.0
 5.0      10.0  15.0  20.0  25.0
```
"""
function inpaint(f, A; method=1, cycledims=Int64[])
    return @match method begin
        0 => inpaint_method0(A)
        1 => inpaint_method1(f, A, cycledims=cycledims) # Default
        _ => error("Method $method not available yet. Suggest it on Github!")
    end
end


"""
    inpaint_method0(f, A::Vector)

Inpaints values in `A` that `f` gives `true` on by solving a simple diffusion PDE.
The partial differential equation (PDE) is defined by the standard Laplacian, `Δ = ∇^2`.
Inspired by MATLAB's `inpaint_nans`'s method `0` for vectors (by John d'Errico).
See https://www.mathworks.com/matlabcentral/fileexchange/4551-inpaint_nans.
"""
function inpaint_method0(f, A::Vector)
    i_unknown = findall(@. f(A))
    i_known = findall(@. !f(A))

    # The Laplacian is applied to the non-NaN neighbors
    iwork = unique(sort([i_unknown..., (i_unknown .- 1)..., (i_unknown .+ 1)...]))
    iwork = iwork[findall(1 .< iwork .< length(A))]
    nw = length(iwork)
    u = collect(1:nw)

    # Build the Laplacian (not the fastest way but easier-to-read code)
    Δ =  sparse(u, iwork     , -2.0, nw, length(A))
    Δ += sparse(u, iwork .- 1, +1.0, nw, length(A))
    Δ += sparse(u, iwork .+ 1, +1.0, nw, length(A))

    # knowns to right hand side
    rhs = -Δ[:, i_known] * A[i_known]

    # and solve...
    B = copy(A)
    B[i_unknown] .= Δ[:, i_unknown] \ rhs
    return B
end

"""
    list_neighbors(A, idx, neighbors)

Lists all the neighbors of the indices in `idx` in Array `A`.
Neighbors already in `idx` are accepted.
The argument `neighnors` contains a list of the neighbors about the
origin coordinate `(0, 0, ...)`.
In other words, it is a `Vector` of `CartesianIndex` such that
the direct neighbors of index `i` are given by `i + n for n in neighbors`.
Inspired by MATLAB's `inpaint_nans`'s `identify_neighbors` (by John d'Errico).
See https://www.mathworks.com/matlabcentral/fileexchange/4551-inpaint_nans.
"""
function list_neighbors(R, idx, neighbors)
    out = [i + n for i in idx for n in neighbors if i + n ∈ R]
    out = sort(unique([out; idx]))
end

"""
    inpaint_method1(f, A::Array, cycledims=Int64[])

Inpaints values in `A` that `f` gives `true` on by solving a simple diffusion PDE.
Default method for `inpaint`.
The partial differential equation (PDE) is defined by the standard Laplacian, `Δ = ∇^2`.
Inspired by MATLAB's `inpaint_nans`'s method `0` for matrices (by John d'Errico).
See https://www.mathworks.com/matlabcentral/fileexchange/4551-inpaint_nans.
The discrete stencil used for `Δ` looks like
```
      ┌───┐
      │ 1 │
      └─┬─┘
        │
┌───┐ ┌─┴─┐ ┌───┐
│ 1 ├─┤-4 ├─┤ 1 │
└───┘ └─┬─┘ └───┘
        │
      ┌─┴─┐
      │ 1 │
      └───┘
```
By default, the stencil is not applied at the borders. Instead, its 1D component,
```
┌───┐ ┌───┐ ┌───┐
│ 1 ├─┤-2 ├─┤ 1 │
└───┘ └───┘ └───┘
```
is applied where it fits at the borders.
However, the user can supply a list of dimensions that should be considered cyclic.
In this case, the sentil will be used also at the borders and "jump" to the other side.
This is particularly useful for, e.g., world maps with longitudes spanning the entire globe.
"""
function inpaint_method1(f, A::Array; cycledims=Int64[])
    I_unknown = findall(@. f(A))
    I_known = findall(@. !f(A))

    # horizontal and vertical neighbors only
    N1 = CartesianIndices(size(A))[2,1] - CartesianIndices(size(A))[1,1]
    N2 = CartesianIndices(size(A))[1,2] - CartesianIndices(size(A))[1,1]
    N1′ = CartesianIndices(size(A))[end,1] - CartesianIndices(size(A))[1,1]
    N2′ = CartesianIndices(size(A))[1,end] - CartesianIndices(size(A))[1,1]
    neighbors = [N1, -N1, N2, -N2]
    for d in cycledims # Add neighbors in cyclic case
        neighbors = push!(neighbors, (N1′, N2′)[d])
        neighbors = push!(neighbors, -((N1′, N2′)[d]))
    end

    # list of strict neighbors
    R = CartesianIndices(size(A))
    Iwork = list_neighbors(R, I_unknown, neighbors)
    iwork = LinearIndices(size(A))[Iwork]
    # Preallocate the Laplacian (not the fastest way but easier-to-read code)

    nA = length(A)
    Δ = sparse([], [], Vector{Float64}(), nA, nA)

    for iN in 1:2
        N = (N1, N2)[iN]
        # R′ is the ranges of indices without one of the borders
        R′ = CartesianIndices(size(A) .- 2 .* N.I)
        R′ = [r + N for r in R′]

        u = vec(LinearIndices(size(A))[R′])
        n = LinearIndices(size(A))[first(R) + N] - LinearIndices(size(A))[first(R)]

        # Build the Laplacian (not the fastest way but easier-to-read code)
        Δ += sparse(u, u     , -2.0, nA, nA)
        Δ += sparse(u, u .- n, +1.0, nA, nA)
        Δ += sparse(u, u .+ n, +1.0, nA, nA)
    end

    for d in cycledims # Add Laplacian along border if cyclic along dimension `d`
        N = (N1, N2)[d]    # Usual neighbor
        N′ = (N1′, N2′)[d] # Neighbor across the border
        n = LinearIndices(size(A))[first(R) + N] - LinearIndices(size(A))[first(R)]
        n′ = LinearIndices(size(A))[first(R) + N′] - LinearIndices(size(A))[first(R)]
        R′₊ = [r for r in R if r + N ∉ R] # One border
        R′₋ = [r for r in R if r - N ∉ R] # The other border
        u₊ = LinearIndices(size(A))[R′₊]
        u₋ = LinearIndices(size(A))[R′₋]
        Δ += sparse(u₊, u₊      , -2.0, nA, nA)
        Δ += sparse(u₊, u₊ .- n , +1.0, nA, nA)
        Δ += sparse(u₊, u₊ .- n′, +1.0, nA, nA)
        Δ += sparse(u₋, u₋      , -2.0, nA, nA)
        Δ += sparse(u₋, u₋ .+ n , +1.0, nA, nA)
        Δ += sparse(u₋, u₋ .+ n′, +1.0, nA, nA)
    end

    # Use Linear indices to access the sparse Laplacian
    i_unknown = LinearIndices(size(A))[I_unknown]
    i_known = LinearIndices(size(A))[I_known]

    # knowns to right hand side
    rhs = -Δ[iwork, i_known] * A[i_known]

    # and solve...
    B = copy(A)
    B[i_unknown] .= Δ[iwork, i_unknown] \ rhs
    return B
end

export inpaint

