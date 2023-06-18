using Random, Distributions
using Revise

function addNoise(signal::Vector, μ, σ)
    d = Normal(μ, σ)
    n1 = zeros(length(signal))
    n2 = zeros(length(signal))
    rand!(d, n1)
    rand!(d, n2)

    noisy = signal + (n1 + n2 * im)
    return noisy
end