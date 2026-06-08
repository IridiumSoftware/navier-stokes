# axisym_operators.jl — Rung 1 completion (ALGEBRAIC evidence)
#
# The two deferred operator pieces of the axisymmetric structural calculus:
#   (III) the FULL Ω = ω^θ/r evolution operator — the transformation ω^θ → Ω that
#         (a) cancels the stretching term (u^r/r)ω^θ, (b) turns the viscous operator
#         ∂_r²+(1/r)∂_r−1/r²+∂_z²  into  ∂_r²+(3/r)∂_r+∂_z², and (c) turns the ω^θ
#         swirl source ∂_z((u^θ)²/r) into S = (1/r⁴)∂_z(Γ²); with the pressure
#         eliminated because mixed partials commute (the curl kills ∇p);
#   (IV)  the BIOT–SAVART elliptic operator: with the Stokes stream function ψ
#         (u^r = −∂_zψ, u^z = (1/r)∂_r(rψ)),  ω^θ = −(∂_r²+(1/r)∂_r−1/r²+∂_z²)ψ,
#         and incompressibility ∇·b = 0 holds identically.
#
# Together with axisym_structural.jl (I)+(II), this verifies the full operator
# structure of the Ω-equation  ∂_tΩ + b·∇Ω = ν(∂_r²+(3/r)∂_r+∂_z²)Ω + S.
#
# METHOD: the same hermetic exact Laurent-polynomial engine (Julia Base only;
# mirrors axisym_structural.jl). Formal differential identities ⇒ exact on
# Laurent monomials/polynomials. DEPENDENCIES: none (Base only).

const Exp = NTuple{3,Int}                      # (e_r, e_z, e_t)
const Field = Dict{Exp, Rational{BigInt}}
mono(er, ez, et, c=1) = Field((er,ez,et) => Rational{BigInt}(c))
prune(a::Field) = Field(k => v for (k,v) in a if v != 0)
function padd(a::Field, b::Field); r=copy(a); for (k,v) in b; r[k]=get(r,k,0//1)+v; end; prune(r); end
psub(a::Field, b::Field) = padd(a, Field(k => -v for (k,v) in b))
pscale(a::Field, c) = prune(Field(k => v*Rational{BigInt}(c) for (k,v) in a))
function pmul(a::Field, b::Field)
    r=Field(); for (ka,va) in a, (kb,vb) in b
        k=(ka[1]+kb[1],ka[2]+kb[2],ka[3]+kb[3]); r[k]=get(r,k,0//1)+va*vb; end; prune(r)
end
rpow(a::Field, n::Int) = Field((k[1]+n,k[2],k[3]) => v for (k,v) in a)
d_r(a::Field) = prune(Field((k[1]-1,k[2],k[3]) => v*k[1] for (k,v) in a))
d_z(a::Field) = prune(Field((k[1],k[2]-1,k[3]) => v*k[2] for (k,v) in a))
d_t(a::Field) = prune(Field((k[1],k[2],k[3]-1) => v*k[3] for (k,v) in a))
iszerofield(a::Field) = isempty(prune(a))

# operators
L_visc(u) = padd(padd(d_r(d_r(u)), rpow(d_r(u),-1)), padd(pscale(rpow(u,-2),-1), d_z(d_z(u))))
#   L_visc u = ∂_r²u + (1/r)∂_r u − u/r² + ∂_z²u   (vector-Laplacian angular part = Biot–Savart operator)
L_Omega(w) = padd(padd(d_r(d_r(w)), pscale(rpow(d_r(w),-1),3)), d_z(d_z(w)))
#   L_Ω w    = ∂_r²w + (3/r)∂_r w + ∂_z²w

function run()
    println("Rung 1 completion — Ω-operator + Biot–Savart (exact Laurent polynomials; algebraic evidence)\n")
    pass = Ref(true)
    chk(name, cond, detail="") = (pass[] &= cond;
        println(rpad(cond ? "  PASS" : "  FAIL", 8), rpad(name, 52), detail))

    # generic test fields
    Ω  = padd(padd(mono(2,1,0,3), mono(-1,2,1,2//5)), mono(1,0,2,7))
    ur = padd(mono(1,0,0,1), mono(0,2,1,-4//3)); uz = padd(mono(0,1,0,5), mono(2,0,1,1//2))
    pp = padd(padd(mono(2,1,0,4), mono(1,3,1,-5//3)), mono(0,0,2,9))      # pressure
    uθ = padd(mono(1,1,0,2), mono(0,3,1,-1//4)); Γ = rpow(uθ,1)
    ψ  = padd(padd(mono(3,1,0,2), mono(1,2,1,-3//7)), mono(2,0,2,5//6))   # stream function

    # ---- (III-a) pressure elimination: ∂_z∂_r p = ∂_r∂_z p (curl kills ∇p) ----
    chk("(III-a) ∂_z∂_r p = ∂_r∂_z p (mixed partials)", iszerofield(psub(d_z(d_r(pp)), d_r(d_z(pp)))),
        "the pressure gradient drops from the curl")

    # ---- (III-b) ω^θ swirl source from the centrifugal term: ∂_z((u^θ)²/r) = (1/r³)∂_z(Γ²) ----
    src_ωθ = d_z(rpow(pmul(uθ,uθ), -1))                                  # ∂_z((u^θ)²/r)
    chk("(III-b) ∂_z((u^θ)²/r) = (1/r³)∂_z(Γ²)", iszerofield(psub(src_ωθ, rpow(d_z(pmul(Γ,Γ)),-3))),
        "swirl centrifugal term → ω^θ source")

    # ---- (III-c) stretching cancellation + transport:  with ω^θ = rΩ,
    #      ∂_t(rΩ) + b·∇(rΩ) − (u^r/r)(rΩ) = r(∂_tΩ + b·∇Ω)   [the (u^r/r)ω^θ stretching cancels] ----
    ωθ = rpow(Ω, 1)
    lhsLin = psub(padd(d_t(ωθ), padd(pmul(ur,d_r(ωθ)), pmul(uz,d_z(ωθ)))), rpow(pmul(ur,Ω),0)) # −(u^r/r)·rΩ = −u^rΩ
    rhsLin = rpow(padd(d_t(Ω), padd(pmul(ur,d_r(Ω)), pmul(uz,d_z(Ω)))), 1)
    chk("(III-c) stretching cancels: LHS = r(∂_t+b·∇)Ω", iszerofield(psub(lhsLin, rhsLin)),
        "the (u^r/r)ω^θ term vanishes under ω^θ=rΩ")

    # ---- (III-d) viscous operator transform: L_visc(rΩ) = r·L_Ω(Ω)  (the (3/r)∂_r emerges) ----
    okV = true
    for a in -1:4, b in 0:4
        m = mono(a,b,0); okV &= iszerofield(psub(L_visc(rpow(m,1)), rpow(L_Omega(m),1)))
    end
    chk("(III-d) L_visc(rΩ) = r·L_Ω(Ω)  [(3/r)∂_r emerges]", okV, "all monomials; (1/r²) cancels")

    # ---- (III-e) source transform: (1/r)·ω^θ-source = S = (1/r⁴)∂_z(Γ²) ----
    chk("(III-e) (1/r)·(1/r³)∂_z(Γ²) = (1/r⁴)∂_z(Γ²) = S",
        iszerofield(psub(rpow(rpow(d_z(pmul(Γ,Γ)),-3),-1), rpow(d_z(pmul(Γ,Γ)),-4))), "Ω = ω^θ/r divide")

    # ---- (IV-a) Biot–Savart: u^r=−∂_zψ, u^z=(1/r)∂_r(rψ) ⇒ ω^θ = −L_visc(ψ) ----
    okBS = true
    for a in -1:4, b in 0:4
        ψm  = mono(a,b,0)
        urψ = pscale(d_z(ψm), -1)                       # u^r = −∂_zψ
        uzψ = rpow(d_r(rpow(ψm,1)), -1)                 # u^z = (1/r)∂_r(rψ)
        ωθψ = psub(d_z(urψ), d_r(uzψ))                  # ω^θ = ∂_z u^r − ∂_r u^z
        okBS &= iszerofield(psub(ωθψ, pscale(L_visc(ψm), -1)))
    end
    chk("(IV-a) ω^θ = −(∂_r²+(1/r)∂_r−1/r²+∂_z²)ψ", okBS, "stream function → azimuthal vorticity")

    # ---- (IV-b) incompressibility of the stream-function field: ∇·b = 0 ----
    urψ = pscale(d_z(ψ), -1); uzψ = rpow(d_r(rpow(ψ,1)), -1)
    divb = padd(d_r(urψ), padd(rpow(urψ,-1), d_z(uzψ)))  # ∂_r u^r + u^r/r + ∂_z u^z
    chk("(IV-b) ∇·b = ∂_r u^r + u^r/r + ∂_z u^z = 0", iszerofield(divb), "stream function ⇒ divergence-free")

    println()
    println(pass[] ? "ALL EXACT IDENTITIES VERIFIED — algebraic evidence (Rung 1 completion)." :
                     "FAILURE — an identity did not close exactly.")
    return pass[]
end

run() || error("axisymmetric-operators verification FAILED")
