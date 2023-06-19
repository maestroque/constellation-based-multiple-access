using Revise, Plots
includet("orthogonalSimulation.jl")
includet("rotatedSimulation.jl")

A = 0.01:0.01:0.99
Θ = 0.01:0.01:π/2

similarity = []
messageLength = 100

for a in A
    (sep1, sep2) = orthogonalSimulation(a, messageLength, false)
    push!(similarity, sum(abs.(sep1 .^ 2 - sep2 .^ 2))) 
end

println("Multiple Access (Orthogonal PAMs): Most user fairness for a = $(A[argmin(similarity)])")
p = plot(A, similarity, xlabel="Value of a", ylabel="User SEP similarity measure")
display(p)

similarity = []
for θ in Θ
    (sep1, sep2) = rotationSimulation(θ, messageLength, false)
    push!(similarity, sum(abs.(sep1 .^ 2 - sep2 .^ 2))) 
end

println("Multiple Access (QAM Rotation): Most user fairness for θ = $(rad2deg(Θ[argmin(similarity)])) degrees")
p = plot(Θ, similarity, xlabel="Value of θ (rad)", ylabel="User SEP similarity measure")
display(p)
