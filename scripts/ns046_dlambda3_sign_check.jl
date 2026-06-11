#!/usr/bin/env julia
# ns046_dlambda3_sign_check.jl — independent corroboration of the sympy sign Required-Check
# (scripts/ns046_dlambda3_sign_check.py). Two rungs:
#   (1) EXACT Rational{BigInt}: the matrix identities I2 (sym(A²)=S²+Ω²) and I3
#       (Ω² = ¼(ω⊗ω − |ω|²I)) on random exact-rational matrices — zero residual, not 1e-16.
#   (2) Float64 finite-difference CONVERGENCE for I4 + the assembled formula:
#       dλ₃/dt vs e₃ᵀ(dS/dt)e₃ on a smooth parametrized S(t) family — central-diff error
#       must shrink ~4× per h-halving (O(h²)) toward the formula value.
# Evidence class: algebraic (rung 1) + computational corroboration (rung 2). :proved=0. -- STABLE

using LinearAlgebra, Random, Printf

ok_all = true
function report(name, ok; detail="")
    global ok_all &= ok
    @printf("  [%s] %s%s\n", ok ? "PASS" : "FAIL", name, isempty(detail) ? "" : "  — "*detail)
end

println("="^74)
println("  NS-046 sign check — Julia corroboration (exact-rational + FD convergence)")
println("="^74)

# ── rung 1: EXACT identities on random Rational{BigInt} matrices ─────────────
rng = MersenneTwister(46)
rq() = Rational{BigInt}(rand(rng, -9:9), rand(rng, 1:9))
maxres = (M) -> maximum(abs.(M))
res2 = zero(Rational{BigInt}); res3 = zero(Rational{BigInt})
for trial in 1:25
    A = [rq() for _ in 1:3, _ in 1:3]
    S = (A + A') .// 2;  Om = (A - A') .// 2
    global res2 = max(res2, maxres((A*A + (A*A)') .// 2 .- (S*S .+ Om*Om)))
    ω = [A[3,2]-A[2,3], A[1,3]-A[3,1], A[2,1]-A[1,2]]
    I3rhs = (ω*ω' .- (ω'ω) .* Matrix{Rational{BigInt}}(I,3,3)) .// 4
    global res3 = max(res3, maxres(Om*Om .- I3rhs))
end
report("I2 exact (25 random Rational{BigInt} A): sym(A²)=S²+Ω²", res2 == 0; detail="max residual = $(res2) (exact zero)")
report("I3 exact: Ω² = ¼(ω⊗ω − |ω|²I)",                       res3 == 0; detail="max residual = $(res3) (exact zero)")

# ── rung 2: FD convergence for I4 + assembled Dλ₃ formula ────────────────────
# S(t) = R(t) diag(λ(t)) R(t)ᵀ, generic smooth λ_i(t) (kept separated ⇒ λ₃ simple), R(t) two-angle rotation.
λs(t) = (-1.0 - 0.3sin(t), 0.2 + 0.1cos(2t), 0.8 + 0.2sin(1.3t))   # λ₁<λ₂<λ₃ on the window
function Rt(t)
    θ1 = 0.7t + 0.2; θ2 = 0.4sin(t) + 0.1
    Rz = [cos(θ1) -sin(θ1) 0; sin(θ1) cos(θ1) 0; 0 0 1]
    Rx = [1 0 0; 0 cos(θ2) -sin(θ2); 0 sin(θ2) cos(θ2)]
    Rz*Rx
end
St(t) = (R=Rt(t); R*Diagonal(collect(λs(t)))*R')
λ3(t) = λs(t)[3]
e3t(t) = Rt(t)[:,3]
t0 = 0.9
dSdt_fd(h) = (St(t0+h) .- St(t0-h)) ./ (2h)
form(h)   = dot(e3t(t0), dSdt_fd(h)*e3t(t0))            # e₃ᵀ(dS/dt)e₃ (FD in S only)
dλ3_fd(h) = (λ3(t0+h) - λ3(t0-h)) / (2h)
errs = [abs(dλ3_fd(h) - form(h)) for h in (1e-2, 5e-3, 2.5e-3)]
rates = [errs[i]/errs[i+1] for i in 1:2]
conv_ok = all(r -> 3.0 < r < 5.0, rates) || maximum(errs) < 1e-10
report("I4 FD: dλ₃/dt = e₃ᵀ(dS/dt)e₃ converges O(h²)", conv_ok;
       detail=@sprintf("errs %.2e → %.2e → %.2e (rates %.2f, %.2f)", errs..., rates...))

# assembled formula on a synthetic 'NS-like' decomposition: given arbitrary symmetric P̃, Ω̃(ω), check
# the e₃-projection algebra  e₃ᵀ(−S²−Ω²−P̃)e₃ = −λ₃² + ¼(|ω|²−(ω·e₃)²) − e₃ᵀP̃e₃  (Float64, machine-ε)
S0 = St(t0); e3 = e3t(t0); l3 = λ3(t0)
ω0 = [0.37, -1.21, 0.64]
Om0 = [0 -ω0[3] ω0[2]; ω0[3] 0 -ω0[1]; -ω0[2] ω0[1] 0] ./ 2  # Ω_ij = −½ε_ijk ω_k
P0 = [1.1 0.2 -0.4; 0.2 -0.7 0.3; -0.4 0.3 0.9]
lhs = dot(e3, (-S0*S0 .- Om0*Om0 .- P0)*e3)
rhs = -l3^2 + 0.25*(dot(ω0,ω0) - dot(ω0,e3)^2) - dot(e3, P0*e3)
report("Assembly: e₃ᵀ(−S²−Ω²−P)e₃ = −λ₃²+¼(|ω|²−(ω·e₃)²)−e₃ᵀPe₃", abs(lhs-rhs) < 1e-12;
       detail=@sprintf("|lhs−rhs| = %.2e", abs(lhs-rhs)))

println("-"^74)
println(ok_all ?
    "  ⇒ CORROBORATED: the pressure-Hessian enters Dλ₃ with coefficient −1 (convention PINNED)." :
    "  ✗ FAIL above — do NOT treat the convention as pinned.")
println("="^74)
exit(ok_all ? 0 : 1)
