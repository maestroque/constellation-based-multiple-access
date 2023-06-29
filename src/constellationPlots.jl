using Revise, Plots
using Statistics
includet("orthogonalSimulation.jl")
includet("rotatedSimulation.jl")

qamConstellation = [-sqrt(2) / 2 + sqrt(2) / 2 * im,
+sqrt(2) / 2 + sqrt(2) / 2 * im,
-sqrt(2) / 2 - sqrt(2) / 2 * im,
+sqrt(2) / 2 - sqrt(2) / 2 * im]

theta = 0.2

qam = M_QAM(4, qamConstellation)
turned = qam.symbols * exp(im * theta)
rotated = rotationComposition(qam, theta)

p = scatter(real(qam.symbols), imag(qam.symbols), mc=:red, markershape=:xcross,
                markersize=8, label="4-QAM")
p = scatter!(real(turned), imag(turned), mc=:darkblue, markershape=:xcross,
                markersize=8 , label="Rotated 4-QAM")
p = scatter!(real(turned), zeros(length(real(turned))), mc=:purple , label="")
p = scatter!(zeros(length(imag(turned))), imag(turned), mc=:purple , label="Projected PAMs",
            legend =:outertopright)

p = scatter!(real(rotated.symbols), imag(rotated.symbols), mc=:pink , label="Composed QAM"
            , xlabel="ℜ{s}", ylabel="ℑ{s}", title="Rotation Composed Constellation")      