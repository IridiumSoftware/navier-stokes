#!/usr/bin/env python3
"""
Systematic record-audit — every closed-form identity transcribed into our docs/SPEC that was
NOT already machine-verified (Rungs 0-1, NRŠ probe), checked symbolically. Triggered by the NRŠ
H-identity catch: one transcribed identity was false, so sweep the rest.

B1  G=∂_zΓ equation            ns048_swirl_sign_condition_attack.md (C-ii)
B2  u₁=Γ/r² heat substitution  ns048_swirl_sign_condition_attack.md (§4, sharpened note)
B3  Γ-operator form consistency ns048_swirl_source_frontier.md:37 vs sign-condition doc
B4  pressure-Poisson           ns046_target.md:27
B5  3D vorticity equation      ns048_machinery_study.md:286
B6  production algebra ω·∇u·ω=ω·Sω   SPEC NS-036 / ns046_target.md production
B7  NS rescaling covariance    ns048_machinery_study.md:43 (M1 cornerstone)

Method: sympy. B1-B3 on generic Function('..')(r,z,t) (operator-level; derivatives unevaluated,
expand & subtract). B4/B5/B7 on generic polynomial instances with u = curl(A) (div-free identically)
and generic polynomial p — same generic-instance philosophy as the Rung-1 Laurent checks.
"""
import sympy as sp

PASS = True
def chk(name, expr_zero, detail=""):
    global PASS
    ok = (expr_zero == 0) if not isinstance(expr_zero, (list, tuple)) \
         else all(e == 0 for e in expr_zero)
    PASS = PASS and ok
    print(f"  {'PASS' if ok else 'FAIL':4}  {name:58} {detail}")

print("== Systematic record-audit of transcribed closed-form identities ==\n")

# ---------- B1-B3: axisymmetric operator identities (generic functions of r,z,t) ----------
r, z, t, nu = sp.symbols('r z t nu', positive=True)
G_  = sp.Function('Gamma')(r, z, t)
ur_ = sp.Function('ur')(r, z, t)
uz_ = sp.Function('uz')(r, z, t)
u1_ = sp.Function('u1')(r, z, t)

L_Gam = lambda f: sp.diff(f, r, 2) - sp.diff(f, r)/r + sp.diff(f, z, 2)
Lap_axi = lambda f: sp.diff(f, r, 2) + sp.diff(f, r)/r + sp.diff(f, z, 2)   # axisym scalar Laplacian

# B1: differentiate the Γ-equation in z; recorded G-eq: ∂_tG+b·∇G = νL_ΓG − [(∂_zu^r)∂_rΓ+(∂_zu^z)G]
Gam_eq_lhs = sp.diff(G_, t) + ur_*sp.diff(G_, r) + uz_*sp.diff(G_, z) - nu*L_Gam(G_)
G = sp.diff(G_, z)
G_eq_lhs = (sp.diff(G, t) + ur_*sp.diff(G, r) + uz_*sp.diff(G, z) - nu*L_Gam(G)
            + sp.diff(ur_, z)*sp.diff(G_, r) + sp.diff(uz_, z)*G)
chk("B1  G=∂_zΓ equation == ∂_z(Γ-equation)",
    sp.expand(sp.diff(Gam_eq_lhs, z) - G_eq_lhs),
    "sign-condition doc (C-ii)")

# B2: L_Γ(r²u₁) = r²(∂_r²+(3/r)∂_r+∂_z²)u₁  (the 4-D radial-heat substitution)
chk("B2  L_Γ(r²u₁) = r²(∂_r²+(3/r)∂_r+∂_z²)u₁",
    sp.expand(L_Gam(r**2*u1_) - r**2*(sp.diff(u1_, r, 2) + 3*sp.diff(u1_, r)/r + sp.diff(u1_, z, 2))),
    "sign-condition doc §4")

# B3: frontier-doc form ∂_tΓ+b·∇Γ+(2/r)∂_rΓ−ΔΓ=0 (ν=1) ⇔ L_Γ form:  Δ_axi − (2/r)∂_r = L_Γ
chk("B3  Δ_axi f − (2/r)∂_r f = L_Γ f  (frontier-doc form)",
    sp.expand(Lap_axi(G_) - 2*sp.diff(G_, r)/r - L_Gam(G_)),
    "swirl_source_frontier:37 consistent")

# ---------- B4/B5/B7: 3D Cartesian, generic polynomial instances ----------
x, y, zz, tt, lam = sp.symbols('x y z2 t2 lam', real=True)
X = (x, y, zz)
# vector potential A: generic cubic polynomials in (x,y,zz) with t-dependence → u = curl A is div-free
def poly(coeffs_seed):
    c = sp.symbols(f'c{coeffs_seed}_0:12')
    return (c[0] + c[1]*x + c[2]*y + c[3]*zz + c[4]*x*y + c[5]*y*zz + c[6]*x*zz
            + c[7]*x**2 + c[8]*y**2 + c[9]*zz**2 + c[10]*tt + c[11]*x*y*zz)
A = [poly(1), poly(2), poly(3)]
u = [sp.diff(A[2], y) - sp.diff(A[1], zz),
     sp.diff(A[0], zz) - sp.diff(A[2], x),
     sp.diff(A[1], x) - sp.diff(A[0], y)]
p = poly(4)
assert sp.expand(sum(sp.diff(u[i], X[i]) for i in range(3))) == 0   # div u ≡ 0 by construction

Lap = lambda f: sum(sp.diff(f, X[i], 2) for i in range(3))
mom = [sp.diff(u[i], tt) + sum(u[k]*sp.diff(u[i], X[k]) for k in range(3))
       + sp.diff(p, X[i]) - nu*Lap(u[i]) for i in range(3)]

# B4: div(momentum) = Δp + ∂_iu_j ∂_ju_i   (⇒ pressure-Poisson −Δp = ∂_iu_j∂_ju_i on solutions)
divmom = sp.expand(sum(sp.diff(mom[i], X[i]) for i in range(3)))
chk("B4  div(momentum) = Δp + ∂_iu_j∂_ju_i",
    sp.expand(divmom - Lap(p)
              - sum(sp.diff(u[i], X[j])*sp.diff(u[j], X[i]) for i in range(3) for j in range(3))),
    "ns046_target:27 pressure-Poisson")

# B5: curl(momentum) = ∂_tω + (u·∇)ω − (ω·∇)u − νΔω   (vorticity equation; doc has ν=1)
w = [sp.diff(u[2], y) - sp.diff(u[1], zz),
     sp.diff(u[0], zz) - sp.diff(u[2], x),
     sp.diff(u[1], x) - sp.diff(u[0], y)]
curlmom = [sp.diff(mom[2], y) - sp.diff(mom[1], zz),
           sp.diff(mom[0], zz) - sp.diff(mom[2], x),
           sp.diff(mom[1], x) - sp.diff(mom[0], y)]
vort_rhs = [sp.diff(w[i], tt) + sum(u[k]*sp.diff(w[i], X[k]) for k in range(3))
            - sum(w[k]*sp.diff(u[i], X[k]) for k in range(3)) - nu*Lap(w[i]) for i in range(3)]
chk("B5  curl(momentum) = ∂_tω+(u·∇)ω−(ω·∇)u−νΔω",
    [sp.expand(curlmom[i] - vort_rhs[i]) for i in range(3)],
    "machinery:286 (doc writes ν=1: normalization)")

# B6: production algebra  ωᵀ(∇u)ω = ωᵀSω,  S=(∇u+∇uᵀ)/2  (antisymmetric part annihilates)
M = sp.Matrix(3, 3, sp.symbols('m0:9')); wv = sp.Matrix(sp.symbols('w0:3'))
chk("B6  ωᵀ(∇u)ω = ωᵀSω (S = sym ∇u)",
    sp.expand((wv.T*M*wv)[0] - (wv.T*((M + M.T)/2)*wv)[0]),
    "SPEC NS-036 / ns046 production")

# B7: rescaling covariance — u_λ(x,t)=λu(x₀+λx, T+λ²t), p_λ=λ²p(...):
#     NSop(u_λ,p_λ)(x,t) = λ³ · NSop(u,p)(x₀+λx, T+λ²t)        [machinery:43, M1]
x0 = sp.symbols('a0:3'); T0 = sp.Symbol('T0')
shift = {x: x0[0] + lam*x, y: x0[1] + lam*y, zz: x0[2] + lam*zz, tt: T0 + lam**2*tt}
ul = [lam*u[i].subs(shift, simultaneous=True) for i in range(3)]
pl = lam**2*p.subs(shift, simultaneous=True)
mom_l = [sp.diff(ul[i], tt) + sum(ul[k]*sp.diff(ul[i], X[k]) for k in range(3))
         + sp.diff(pl, X[i]) - nu*Lap(ul[i]) for i in range(3)]
mom_shifted = [lam**3*mom[i].subs(shift, simultaneous=True) for i in range(3)]
chk("B7  NSop(u_λ,p_λ) = λ³·NSop(u,p)(x₀+λx, T+λ²t)",
    [sp.expand(mom_l[i] - mom_shifted[i]) for i in range(3)],
    "machinery:43 M1 rescaling cornerstone")

print()
print("ALL TRANSCRIBED IDENTITIES VERIFIED." if PASS else "AUDIT FAILURE — a transcribed identity did not close.")
raise SystemExit(0 if PASS else 1)
