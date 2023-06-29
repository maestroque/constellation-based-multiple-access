using Revise, Plots
using Statistics
includet("orthogonalSimulation.jl")
includet("rotatedSimulation.jl")

A = 0.01:0.01:0.99
Θ = 0.01:0.01:π/4

similarityOrth = []
messageLength = 500
iterations = 50

for a in A
    (sep1, sep2) = orthogonalSimulation(a, messageLength, false)
    push!(similarityOrth, sum(abs.(sep1 .^ 2 - sep2 .^ 2))) 
end

println("Multiple Access (Orthogonal PAMs): Most user fairness for a = $(A[argmin(similarityOrth)])")
p = plot(A, similarityOrth, xlabel="Value of a", ylabel="User SEP similarity measure")
display(p)

similarityRot = []
for θ in Θ
    (sep1, sep2) = rotationSimulation(θ, messageLength, false)
    push!(similarityRot, sum(abs.(sep1 .^ 2 - sep2 .^ 2))) 
end

println("Multiple Access (QAM Rotation): Most user fairness for θ = $(round(rad2deg(Θ[argmin(similarityRot)]), digits=3)) degrees")
p = plot(Θ, similarityRot, xlabel="Value of θ (rad)", ylabel="User SEP similarity measure")
display(p)

orthogonalSimulation(A[argmin(similarityOrth)], messageLength);
rotationSimulation(Θ[argmin(similarityRot)], messageLength);
