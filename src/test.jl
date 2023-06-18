using Revise
includet("PAM.jl")

a = 0.25
M = 4

pam1 = M_PAM(M, a)
pam2 = M_PAM(M, 1 - a)

println(pam1.symbols)
println(pam2.symbols)
