using Revise
using Plots
includet("PAM.jl")

a = 0.25
M = 4
N = 5

pam1 = M_PAM(M, a)
pam2 = M_PAM(M, 1 - a)

qam = orthogonalComposition(pam1, pam2)

# scatter(real(qam.symbols), imag(qam.symbols))

message = rand(1 : qam.M - 1, N)
println(message)

qamModulated = constellationMap(qam, message)
scatter(real(qamModulated), imag(qamModulated))