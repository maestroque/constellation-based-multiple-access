using Revise
using Plots

abstract type Constellation end

mutable struct M_PAM <: Constellation
    M::Integer
    Es::Float32
    Eg::Float32
    symbols::Vector{Float32}
end

function M_PAM(M, Es)
    Eg = 3 * Es / (M ^ 2 - 1)
    symbols = zeros(M)
    for (i, s) in enumerate(symbols)
        symbols[i] = (2 * i - M - 1) * sqrt(Eg)
    end
    M_PAM(M, Es, Eg, symbols)
end

mutable struct M_QAM <: Constellation
    M::Integer
    symbols::Vector{ComplexF32}
end

function printConstellationMap(c::Constellation)
    p = scatter(real(c.symbols), imag(c.symbols))
    display(p)
end

function orthogonalComposition(mPAM1::M_PAM, mPAM2::M_PAM)
    M = mPAM1.M * mPAM2.M
    symbols = zeros(ComplexF32, mPAM1.M * mPAM2.M)
    for (i, s1) in enumerate(mPAM1.symbols)
        for (j, s2) in enumerate(mPAM2.symbols)
           symbols[i + (j - 1) * (mPAM1.M)] = s1 + im * s2 
        end
    end
    qam = M_QAM(M, symbols)
    return qam
end

function rotationComposition(c::Constellation, θ::Real)
    rotatedSymbols = c.symbols .* exp(im * θ)
    rotatedQAM = M_QAM(c.M, rotatedSymbols)
    return rotatedQAM
end

function constellationMap(c::Constellation, message::Vector{Int}, symbolMap::Vector{Int})
    modulated = zeros(ComplexF32, length(message))
    for (i, m) in enumerate(message)
        modulated[i] = c.symbols[symbolMap[m]]
    end

    return modulated
end

function avgSymbolEnergy(c::Constellation)
    return 1 / length(c.symbols) * (sum(abs2.(c.symbols)))
end

function avgSymbolEnergy(c::Vector{<:Complex})
    return 1 / length(c) * (sum(abs2.(c)))
end