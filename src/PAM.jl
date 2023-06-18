using Revise
using Plots

abstract type Constellation end

mutable struct M_PAM <: Constellation
    M::Integer
    Es::Float32
    Eg::Float32
    symbols::Array{Float32}

    function M_PAM(M, Es)
        Eg = 3 * Es / (M ^ 2 - 1)
        symbols = zeros(M)
        for (i, s) in enumerate(symbols)
            symbols[i] = (2 * i - M - 1) * sqrt(Eg)
        end
        new(M, Es, Eg, symbols)
    end
end

mutable struct M_QAM <: Constellation
    M::Integer
    symbols::Matrix{ComplexF32}

    function M_QAM(M, symbols)
        new(M, symbols)
    end
end

function printConstellationMap(pam::M_PAM, )
    
end

function orthogonalComposition(mPAM1::M_PAM, mPAM2::M_PAM)
    M = mPAM1.M * mPAM2.M
    symbols = zeros(ComplexF32, mPAM1.M, mPAM2.M)
    for (i, s1) in enumerate(mPAM1.symbols)
        for (j, s2) in enumerate(mPAM2.symbols)
           symbols[i, j] = s1 + im * s2 
        end
    end
    qam = M_QAM(M, symbols)
    return qam
end

function constellationMap(c::Constellation, message)
    modulated = zeros(ComplexF32, length(message))
    for (i, m) in enumerate(message)
        modulated[i] = c.symbols[m + 1]
    end

    return modulated
end