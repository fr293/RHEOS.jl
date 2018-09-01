#!/usr/bin/env julia

# Fractional Maxwell Model
function G_fractmaxwell(t::Array{T,1}, params::Array{T,1}) where T<:Real
    cₐ, a, cᵦ, β = params

    G = cᵦ*t.^(-β).*mittleff.(a - β, 1 - β, -cᵦ*t.^(a - β)/cₐ)
end

function J_fractmaxwell(t::Array{T,1}, params::Array{T,1}) where T<:Real
    cₐ, a, cᵦ, β = params

    J = t.^(a)/(cₐ*gamma(1 + a)) + t.^(β)/(cᵦ*gamma(1 + β))
end

function Gp_fractmaxwell(ω::Array{T,1}, params::Array{T,1}) where T<:Real
    cₐ, a, cᵦ, β = params

    denominator = (cₐ*ω.^a).^2 + (cᵦ*ω.^β).^2 + 2*(cₐ*ω.^a).*(cᵦ*ω.^β)*cos((a-β)*π/2)

    numerator = ((cᵦ*ω.^β).^2).*(cₐ*ω.^a)*cos(a*π/2) + ((cₐ*ω.^a).^2).*(cᵦ*ω.^β)*cos(β*π/2)

    numerator./denominator
end

function Gpp_fractmaxwell(ω::Array{T,1}, params::Array{T,1}) where T<:Real
    cₐ, a, cᵦ, β = params

    denominator = (cₐ*ω.^a).^2 + (cᵦ*ω.^β).^2 + 2*(cₐ*ω.^a).*(cᵦ*ω.^β)*cos((a-β)*π/2)

    numerator = ((cᵦ*ω.^β).^2).*(cₐ*ω.^a)*sin(a*π/2) + ((cₐ*ω.^a).^2).*(cᵦ*ω.^β)*sin(β*π/2)

    numerator./denominator
end

FractionalMaxwell() = RheologyModel(G_fractmaxwell, J_fractmaxwell, Gp_fractmaxwell, Gpp_fractmaxwell, [2.0, 0.2, 1.0, 0.5], ["model created with default parameters"])
FractionalMaxwell(params::Array{T, 1}) where T<:Real = RheologyModel(G_fractmaxwell, J_fractmaxwell, Gp_fractmaxwell, Gpp_fractmaxwell, params, ["model created by user with parameters $params"])

# Fractional Maxwell Model (β=0, second spring-pot specialized to spring)
function G_fractmaxwell_spring(t::Array{T,1}, params::Array{T,1}) where T<:Real
    cₐ, a, k = params

    G = k*mittleff.(a, -k*t.^a/cₐ)
end

function J_fractmaxwell_spring(t::Array{T,1}, params::Array{T,1}) where T<:Real
    cₐ, a, k = params

    J = t.^(a)/(cₐ*gamma(1 + a)) + 1/k
end

function Gp_fractmaxwell_spring(ω::Array{T,1}, params::Array{T,1}) where T<:Real
    cₐ, a, k = params

    denominator = (cₐ*ω.^a).^2 + k^2 + 2*(cₐ*ω.^a)*k*cos(a*π/2)

    numerator = k^2*(cₐ*ω.^a)*cos(a*π/2) + (cₐ*ω.^a).^2*k

    numerator./denominator
end

function Gpp_fractmaxwell_spring(ω::Array{T,1}, params::Array{T,1}) where T<:Real
    cₐ, a, k = params

    denominator = (cₐ*ω.^a).^2 + k^2 + 2*(cₐ*ω.^a)*k*cos(a*π/2)

    numerator = k^2*(cₐ*ω.^a)*sin(a*π/2)

    numerator./denominator
end

FractionalMaxwellSpring() = RheologyModel(G_fractmaxwell_spring, J_fractmaxwell_spring, Gp_fractmaxwell_spring, Gpp_fractmaxwell_spring, [2.0, 0.2, 1.0], ["model created with default parameters"])
FractionalMaxwellSpring(params::Array{T, 1}) where T<:Real = RheologyModel(G_fractmaxwell_spring, J_fractmaxwell_spring, Gp_fractmaxwell_spring, Gpp_fractmaxwell_spring, params, ["model created by user with parameters $params"])

# Fractional Maxwell Model (α=0, first spring-pot specialized to dash-pot)
function G_fractmaxwell_dashpot(t::Array{T,1}, params::Array{T,1}) where T<:Real
    η, cᵦ, β = params

    G = cᵦ*t.^(-β).*mittleff.(1 - β, 1 - β, -cᵦ*t.^(1 - β)/η)
end

function J_fractmaxwell_dashpot(t::Array{T,1}, params::Array{T,1}) where T<:Real
    η, cᵦ, β = params

    J = t/η + t.^(β)/(cᵦ*gamma(1 + β))
end

function Gp_fractmaxwell_dashpot(ω::Array{T,1}, params::Array{T,1}) where T<:Real
    η, cᵦ, β = params

    denominator = (η*ω).^2 + (cᵦ*ω.^β).^2 + 2*(η*ω).*(cᵦ*ω.^β)*cos((1-β)*π/2)

    numerator = ((η*ω).^2).*(cᵦ*ω.^β)*cos(β*π/2)

    numerator./denominator
end

function Gpp_fractmaxwell_dashpot(ω::Array{T,1}, params::Array{T,1}) where T<:Real
    η, cᵦ, β = params

    denominator = (η*ω).^2 + (cᵦ*ω.^β).^2 + 2*(η*ω).*(cᵦ*ω.^β)*cos((1-β)*π/2)

    numerator = ((cᵦ*ω.^β).^2).*(η*ω) + ((η*ω).^2).*(cᵦ*ω.^β)*sin(β*π/2)

    numerator./denominator
end

FractionalMaxwellDashpot() = RheologyModel(G_fractmaxwell_dashpot, J_fractmaxwell_dashpot, Gp_fractmaxwell_dashpot, Gpp_fractmaxwell_dashpot, [2.0, 1.0, 0.5], ["model created with default parameters"])
FractionalMaxwellDashpot(params::Array{T, 1}) where T<:Real = RheologyModel(G_fractmaxwell_dashpot, J_fractmaxwell_dashpot, Gp_fractmaxwell_dashpot, Gpp_fractmaxwell_dashpot, params, ["model created by user with parameters $params"])

# Maxwell Model (From Findley, Lai, Onaran for comparison/debug)
function G_maxwell(t::Array{T,1}, params::Array{T,1}) where T<:Real
    η, k = params

    G = k*exp.(-k*t/η)
end

function J_maxwell(t::Array{T,1}, params::Array{T,1}) where T<:Real
    η, k = params

    J = t/η + 1/k
end

function Gp_maxwell(ω::Array{T,1}, params::Array{T,1}) where T<:Real
    η, k = params

    denominator = 1 + η^2*ω.^2/k^2

    numerator = η^2*ω.^2/k

    numerator./denominator
end

function Gpp_maxwell(ω::Array{T,1}, params::Array{T,1}) where T<:Real
    η, k = params

    denominator = 1 + η^2*ω.^2/k^2

    numerator = η*ω

    numerator./denominator
end

Maxwell() = RheologyModel(G_maxwell, J_maxwell, Gp_maxwell, Gpp_maxwell, [2.0, 1.0], ["model created with default parameters"])
Maxwell(params::Array{T, 1}) where T<:Real = RheologyModel(G_maxwell, J_maxwell, Gp_maxwell, Gpp_maxwell, params, ["model created by user with parameters $params"])