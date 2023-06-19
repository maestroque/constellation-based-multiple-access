using Random, Distributions
using Revise
includet("PAM.jl")

function addNoise(signal::Vector{<:Complex}, μ, σ)
    d = Normal(μ, σ / 2)
    n1 = zeros(length(signal))
    n2 = zeros(length(signal))
    rand!(d, n1)
    rand!(d, n2)

    noisy = signal + (n1 + n2 * im)
    return noisy
end

function addNoise(signal::Vector{<:Real}, μ, σ)
    d = Normal(μ, σ)
    n = zeros(length(signal))
    rand!(d, n)

    noisy = signal + n * im
    return noisy
end

function MLD(signal::Vector, c::Constellation)
    estimation = []
    for s in signal
        distances = abs.(s .- c.symbols)
        push!(estimation, argmin(distances))
    end

    return estimation
end