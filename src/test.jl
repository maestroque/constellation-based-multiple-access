using Revise
using Plots
includet("PAM.jl")
includet("utils.jl")

a = 0.25
M = 4
N = 5
symbolMap = [13, 14, 15, 16, 9, 10, 11, 12, 5, 6, 7, 8, 1, 2, 3, 4]

pam1 = M_PAM(M, a)
pam2 = M_PAM(M, 1 - a)

qam = orthogonalComposition(pam1, pam2)

# scatter(real(qam.symbols), imag(qam.symbols))

message = rand(1 : qam.M, N)
println(message)

qamModulated = constellationMap(qam, message, symbolMap)
scatter(real(qamModulated), imag(qamModulated), xlims=[-1, 1], ylims=[-2, 2])

noisedSignal = addNoise(qamModulated, 0, 0.1)
scatter!(real(noisedSignal), imag(noisedSignal), xlims=[-1, 1], ylims=[-2, 2])