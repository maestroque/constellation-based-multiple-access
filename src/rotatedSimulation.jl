using Revise
using Plots
includet("PAM.jl")
includet("utils.jl")

messageLength = 500
θ = π / 5
symbolMap = [13, 14, 15, 16, 9, 10, 11, 12, 5, 6, 7, 8, 1, 2, 3, 4]

# Channel parameters
c = 0.5
N0 = 0

qamConstellation = [-sqrt(2) / 2 + sqrt(2) / 2 * im,
                    +sqrt(2) / 2 + sqrt(2) / 2 * im,
                    -sqrt(2) / 2 - sqrt(2) / 2 * im,
                    +sqrt(2) / 2 - sqrt(2) / 2 * im]

qam = M_QAM(4, qamConstellation)
rotated = rotationComposition(qam, θ)

messageUser1 = rand(1 : Int(sqrt(rotated.M)), messageLength)
messageUser2 = rand(1 : Int(sqrt(rotated.M)), messageLength)

messageQAM = messageUser1 + (Int(sqrt(rotated.M)) .- messageUser2) * Int(sqrt(rotated.M))

qamModulated = constellationMap(rotated, messageQAM, symbolMap)

SNR = 0:1:20
N0 = avgSymbolEnergy(qam) .* 10 .^ (-SNR/10)

SEP1 = []
SEP2 = []
sepLimit = 10e-6

# Simulation for range of SNR values
for n in N0
    qamUser1 = addNoise(qamModulated, 0, n / 2)
    qamUser2 = addNoise(qamModulated, 0, c * n / 2)

    pamUser1 = real(qamUser1)
    pamUser2 = imag(qamUser2)

    demodUser1 = MLD(pamUser1, pam1)
    demodUser2 = MLD(pamUser2, pam2)

    push!(SEP1, length(findall(!iszero, demodUser1 - messageUser1)) / length(messageUser1))
    push!(SEP2, length(findall(!iszero, demodUser2 - messageUser2)) / length(messageUser2))
end

# Remove zero-value SEP entries for log-scale plotting
SEP1[SEP1 .< sepLimit ] .= sepLimit
SEP2[SEP2 .< sepLimit ] .= sepLimit

p = plot(SNR, SEP1, gridlinewidth=1, yaxis=(:log10, [sepLimit, :auto]), 
            label="User₁ SEP")
p = plot!(SNR, SEP2, gridlinewidth=1, yaxis=(:log10, [sepLimit, :auto]), 
            label="User₂ SEP", ylabel="SEP", xlabel="SNR (dB)",
            title="Multiple Access SEP vs SNR for θ=$θ")
display(p)