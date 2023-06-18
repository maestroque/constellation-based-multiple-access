using Revise

mutable struct M_PAM
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

function printConstellationMap(pam::M_PAM, )
    
end