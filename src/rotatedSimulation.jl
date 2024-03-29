using Revise
using Plots
includet("PAM.jl")
includet("utils.jl")

messageLength = 500
θ = π / 5
function rotationSimulation(θ, messageLength, print = true)
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

        # TODO: abstract this
        demodUser1 = MLD(pamUser1, M_PAM(real(qam.symbols .* exp(im * θ))))
        demodUser2 = MLD(pamUser2, M_PAM(imag(qam.symbols .* exp(im * θ))))

        push!(SEP1, length(findall(!iszero, demodUser1 - messageUser1)) / length(messageUser1))
        push!(SEP2, length(findall(!iszero, demodUser2 - messageUser2)) / length(messageUser2))
    end

    # Remove zero-value SEP entries for log-scale plotting
    SEP1[SEP1 .< sepLimit ] .= sepLimit
    SEP2[SEP2 .< sepLimit ] .= sepLimit

    if print
        p = plot(SNR, SEP1, gridlinewidth=1, yaxis=(:log10, [sepLimit, :auto]), 
                    label="User₁ SEP")
        p = scatter!(SNR, SEP1, gridlinewidth=1, yaxis=(:log10, [sepLimit, :auto]),
                    label="")
        p = scatter!(SNR, SEP2, gridlinewidth=1, yaxis=(:log10, [sepLimit, :auto]),
                    label="")
        p = plot!(SNR, SEP2, gridlinewidth=1, yaxis=(:log10, [sepLimit, :auto]), 
                    label="User₂ SEP", ylabel="SEP", xlabel="SNR (dB)",
                    title="Multiple Access SEP vs SNR for θ=$(round(rad2deg(θ), digits=3))")
        display(p)
    end

    return SEP1, SEP2
end

rotationSimulation(0.2, 500)