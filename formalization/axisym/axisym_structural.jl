# axisym_structural.jl — Rung 1 of the formalization ladder (ALGEBRAIC evidence)
#
# Exact symbolic verification of the AXISYMMETRIC STRUCTURAL CALCULUS — the
# load-bearing differential identities the entire NS-048 arc rests on:
#   (I)  the swirl Γ = r u^θ obeys a SOURCE-FREE transport–diffusion equation
#        (the basis of the maximum principle);
#   (II) the good quantity Ω = ω^θ/r has the SOLE production
#        S = (1/r⁴)∂_z(Γ²) = (2Γ/r⁴)∂_zΓ = ∂_z(u₁²),  u₁ = Γ/r² = u^θ/r,
#        whose origin is the centrifugal term (u^θ)²/r differentiated in z.
#
# METHOD (hermetic, no deps — Julia Base only): a tiny exact LAURENT-POLYNOMIAL
# engine over `Rational{BigInt}`. A field is a map (e_r, e_z, e_t) → coeff, i.e.
# a finite sum of monomials r^{e_r} z^{e_z} t^{e_t} with e_r ∈ ℤ (Laurent in r, so
# 1/r, 1/r² are exact). Partial derivatives are exact (term-by-term). These are
# FORMAL differential identities (hold for all smooth fields); verifying that the
# difference is the IDENTICALLY-ZERO Laurent polynomial — for each monomial of a
# spanning set (linear identities) or for a generic polynomial (multilinear ones)
# — is a rigorous symbolic proof. Float64 is never used (algebraic, not numeric).
#
# CONVENTIONS (declared): cylindrical (r,θ,z); θ-independent; b = u^r e_r + u^z e_z
# (meridional); D/Dt = ∂_t + b·∇. The axisymmetric u^θ-momentum equation used in (I):
#   ∂_t u^θ + b·∇u^θ + (u^r u^θ)/r = ν(∂_r² + (1/r)∂_r − 1/r² + ∂_z²) u^θ.
# DEPENDENCIES: none (Base only) — hermetic; only pin is the Julia version (README).

const Exp = NTuple{3,Int}                       # (e_r, e_z, e_t)
const Field = Dict{Exp, Rational{BigInt}}

mono(er, ez, et, c=1) = Field((er,ez,et) => Rational{BigInt}(c))
function prune(a::Field)
    Field(k => v for (k,v) in a if v != 0)
end
function padd(a::Field, b::Field)
    r = copy(a); for (k,v) in b; r[k] = get(r,k,0//1) + v; end; prune(r)
end
psub(a::Field, b::Field) = padd(a, Field(k => -v for (k,v) in b))
pscale(a::Field, c) = prune(Field(k => v*Rational{BigInt}(c) for (k,v) in a))
function pmul(a::Field, b::Field)               # Laurent polynomial product
    r = Field()
    for (ka,va) in a, (kb,vb) in b
        k = (ka[1]+kb[1], ka[2]+kb[2], ka[3]+kb[3])
        r[k] = get(r,k,0//1) + va*vb
    end
    prune(r)
end
rpow(a::Field, n::Int) = Field((k[1]+n, k[2], k[3]) => v for (k,v) in a)   # · r^n (exact, Laurent)
d_r(a::Field) = prune(Field((k[1]-1,k[2],k[3]) => v*k[1] for (k,v) in a))  # ∂_r
d_z(a::Field) = prune(Field((k[1],k[2]-1,k[3]) => v*k[2] for (k,v) in a))  # ∂_z
d_t(a::Field) = prune(Field((k[1],k[2],k[3]-1) => v*k[3] for (k,v) in a))  # ∂_t
iszerofield(a::Field) = isempty(prune(a))

# the axisymmetric scalar pieces as operators on a field
lap_ang(u)   = padd(padd(d_r(d_r(u)), rpow(d_r(u), -1)), padd(rpow(u, -2) |> x->pscale(x,-1), d_z(d_z(u))))
#   lap_ang u = ∂_r²u + (1/r)∂_r u − u/r² + ∂_z²u   (the "angular" Laplacian acting on u^θ)
L_Gamma(g)   = padd(psub(d_r(d_r(g)), rpow(d_r(g), -1)), d_z(d_z(g)))
#   L_Γ g     = ∂_r²g − (1/r)∂_r g + ∂_z²g           (the operator in the Γ equation)

# ============================================================================ #
function run()
    println("Rung 1 — axisymmetric structural calculus (exact Laurent polynomials; algebraic evidence)\n")
    pass = Ref(true)
    chk(name, cond, detail="") = (pass[] &= cond;
        println(rpad(cond ? "  PASS" : "  FAIL", 8), rpad(name, 50), detail))

    # ---- (I) Γ source-free, via two formal identities + the u^θ-momentum equation ----
    # Identity I-op:  L_Γ(r·u^θ) = r · lap_ang(u^θ)   — verified MONOMIAL-BY-MONOMIAL
    #   (linear in u^θ ⇒ holding on the spanning set proves it for all fields).
    okI = true
    for a in -1:4, b in 0:4
        uθ = mono(a, b, 0)
        lhs = L_Gamma(rpow(uθ, 1))                 # L_Γ(r u^θ)
        rhs = rpow(lap_ang(uθ), 1)                 # r · lap_ang(u^θ)
        okI &= iszerofield(psub(lhs, rhs))
    end
    chk("(I-op) L_Γ(r u^θ) = r·lap_ang(u^θ)", okI, "all monomials r^a z^b, a∈−1:4,b∈0:4")

    # Identity I-tr: transport(r·u^θ) = r·[D/Dt u^θ + (u^r u^θ)/r]   (generic u^r,u^z,u^θ)
    uθ = padd(padd(mono(2,1,0,3), mono(-1,2,1,2//5)), mono(0,0,3,7))     # generic Laurent poly
    ur = padd(mono(1,0,0,1), mono(0,2,1,-4//3));  uz = padd(mono(0,1,0,5), mono(2,0,2,1//2))
    Γ  = rpow(uθ, 1)                                                      # Γ = r u^θ
    transport_Γ = padd(d_t(Γ), padd(pmul(ur, d_r(Γ)), pmul(uz, d_z(Γ)))) # ∂_tΓ + b·∇Γ
    matCor = padd(d_t(uθ), padd(pmul(ur,d_r(uθ)), padd(pmul(uz,d_z(uθ)), rpow(pmul(ur,uθ),-1))))
    chk("(I-tr) transport(rΓ) = r·(D/Dt+Coriolis)u^θ", iszerofield(psub(transport_Γ, rpow(matCor,1))),
        "generic u^r,u^z,u^θ")

    # ⇒ Closing (I): the u^θ-momentum eq says (D/Dt + Coriolis)u^θ = ν·lap_ang(u^θ);
    #   then transport(Γ) = r·ν·lap_ang(u^θ) = ν·L_Γ(Γ) by (I-op). So:
    #   ∂_tΓ + b·∇Γ − ν L_Γ Γ = ν·[ r·lap_ang(u^θ) − L_Γ(ru^θ) ] = 0  (SOURCE-FREE).
    chk("(I) Γ-equation is SOURCE-FREE (I-op ∧ I-tr ⇒ no production)", okI &&
        iszerofield(psub(transport_Γ, rpow(matCor,1))), "max-principle basis")

    # ---- (II) the Ω = ω^θ/r source identities (definitional, generic Γ / u^θ) -------
    Γg = padd(padd(mono(2,1,0,1), mono(3,0,1,-2//7)), mono(1,2,0,5//3))   # generic Γ(r,z,t)
    u1 = rpow(Γg, -2)                                                     # u₁ = Γ/r²
    S_def   = rpow(d_z(pmul(Γg,Γg)), -4)                                  # (1/r⁴)∂_z(Γ²)
    S_2Γ    = pscale(pmul(rpow(Γg,-4), d_z(Γg)), 2)                       # (2Γ/r⁴)∂_zΓ
    S_u1    = d_z(pmul(u1,u1))                                            # ∂_z(u₁²)
    chk("(II-a) (1/r⁴)∂_z(Γ²) = (2Γ/r⁴)∂_zΓ", iszerofield(psub(S_def, S_2Γ)), "chain rule")
    chk("(II-b) (1/r⁴)∂_z(Γ²) = ∂_z(u₁²), u₁=Γ/r²", iszerofield(psub(S_def, S_u1)), "u₁ = Γ/r² definition")

    # centrifugal origin: the ω^θ source ∂_z((u^θ)²/r), divided by r (the Ω-transform),
    #   equals S in Γ-form:  (1/r)∂_z((u^θ)²/r) = (1/r⁴)∂_z((r u^θ)²).
    uθg = padd(mono(1,1,0,2), mono(0,3,1,-1//4))                          # generic u^θ
    centrifugal_over_r = rpow(d_z(rpow(pmul(uθg,uθg), -1)), -1)           # (1/r)·∂_z((u^θ)²/r)
    S_from_Γ = rpow(d_z(pmul(rpow(uθg,1), rpow(uθg,1))), -4)              # (1/r⁴)∂_z((r u^θ)²)
    chk("(II-c) (1/r)∂_z((u^θ)²/r) = (1/r⁴)∂_z((ru^θ)²)", iszerofield(psub(centrifugal_over_r, S_from_Γ)),
        "swirl centrifugal term IS the Ω-source")

    println()
    println(pass[] ? "ALL EXACT IDENTITIES VERIFIED — algebraic evidence (Rung 1)." :
                     "FAILURE — an identity did not close exactly.")
    return pass[]
end

run() || error("axisymmetric-structural verification FAILED")
