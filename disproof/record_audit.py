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


# ---------- B8-B13: Tao 1908.04958 §4 Carleman identities (ladder-0 transcription audit) ----------
# Source: arXiv 1908.04958 §4 (pp.27-36): Lemma 4.1 + Props 4.2/4.3. All identities below are the
# load-bearing computations of the section, transcribed at ladder-0 (2026-06-10) and checked here
# per the standing rule. Convention: L = ∂t + Δ (backwards heat), F := ∂tg − Δg − |∇g|²,
# S := Δ + ∇g·∇ − F/2 (the e^g-self-adjoint part of L).

xx, yy, zw = sp.symbols('xx yy zw', real=True)
XY = (xx, yy, zw)
def grad3(f): return [sp.diff(f, c) for c in XY]
def div3(v): return sum(sp.diff(v[i], XY[i]) for i in range(3))
def lap3(f): return div3(grad3(f))

uF = sp.Function('uu')(*XY); vF = sp.Function('vv')(*XY); gF = sp.Function('gg')(*XY)
FF = sp.Function('FF')(*XY)  # arbitrary F — the B9 cancellation is structural
eg = sp.exp(gF)

# B8: the pointwise divergence identity behind Lemma 4.1's IBP step:
#     Δ(uv)·e^g = div(∇(uv)e^g − uv·e^g·∇g) + uv(Δg+|∇g|²)e^g
uv = uF*vF
vec = [sp.diff(uv, c)*eg - uv*eg*sp.diff(gF, c) for c in XY]
chk("B8  Lemma 4.1 IBP: Δ(uv)e^g = div(...) + uv(Δg+|∇g|²)e^g",
    sp.expand(lap3(uv)*eg - (div3(vec) + uv*(lap3(gF) + sum(q**2 for q in grad3(gF)))*eg)),
    "Tao §4 Lemma 4.1 proof, first display chain")

# B9: S is e^g-self-adjoint up to an exact divergence (for ANY F):
#     (Su)v·e^g − u(Sv)·e^g = div((v∇u − u∇v)e^g)
def S_of(f): return lap3(f) + sum(sp.diff(gF, c)*sp.diff(f, c) for c in XY) - FF*f/2
vec2 = [(vF*sp.diff(uF, c) - uF*sp.diff(vF, c))*eg for c in XY]
chk("B9  (Su)v·e^g − u(Sv)·e^g = div((v∇u−u∇v)e^g)  [any F]",
    sp.expand((S_of(uF)*vF - uF*S_of(vF))*eg - div3(vec2)),
    "Tao §4: self-adjointness of S")

# B10: the bilinear expansion in the ∂t⟨Su,u⟩ chain:
#     ⟨Lu,Sv⟩+⟨Su,Lv⟩−2⟨Su,Sv⟩ = ½⟨Lu,Lv⟩ − ½⟨(L−2S)u,(L−2S)v⟩  (pure bilinear algebra)
Lu_, Lv_, Su_, Sv_ = sp.symbols('Lu_ Lv_ Su_ Sv_')
chk("B10 ⟨Lu,Sv⟩+⟨Su,Lv⟩−2⟨Su,Sv⟩ = ½⟨Lu,Lv⟩−½⟨(L−2S)u,(L−2S)v⟩",
    sp.expand((Lu_*Sv_ + Su_*Lv_ - 2*Su_*Sv_)
              - (sp.Rational(1,2)*Lu_*Lv_
                 - sp.Rational(1,2)*(Lu_ - 2*Su_)*(Lv_ - 2*Sv_))),
    "Tao §4 Lemma 4.1 proof, operator-algebra chain")

# B11: Prop 4.2 weight g = α(T0−t)|x| + |x|²/(C0·T):  the paper's F and LF displays, plus
#      Hess(|x|) = (I − x̂x̂ᵀ)/|x| (the PSD fact behind D²g ≥ (2/C0T)I on the annulus).
al, C0, Tb, T0b, tb = sp.symbols('alpha C0 T T0 t', positive=True)
r = sp.sqrt(xx**2 + yy**2 + zw**2)
sfac = T0b - tb
g42 = al*sfac*r + r**2/(C0*Tb)
F42 = sp.diff(g42, tb) - lap3(g42) - sum(q**2 for q in grad3(g42))
F42_paper = (-al*r - 2*al*sfac/r - 6/(C0*Tb) - al**2*sfac**2
             - 4*al*sfac*r/(C0*Tb) - 4*r**2/(C0**2*Tb**2))
chk("B11a Prop 4.2: F = −αr−2αs/r−6/C0T−α²s²−4αsr/C0T−4r²/C0²T²",
    sp.simplify(F42 - F42_paper), "s=T0−t; paper p.30 display")
LF42 = sp.diff(F42, tb) + lap3(F42)
LF42_paper = 2*al**2*sfac + 4*al*r/(C0*Tb) - 8*al*sfac/(C0*Tb*r) - 24/(C0**2*Tb**2)
chk("B11b Prop 4.2: LF = 2α²s+4αr/C0T−8αs/(C0Tr)−24/C0²T²",
    sp.simplify(LF42 - LF42_paper), "paper p.30 display")
Hess_r = sp.Matrix(3, 3, lambda i, j: sp.diff(r, XY[i], XY[j]))
Hess_r_closed = (sp.eye(3) - sp.Matrix(3,1,[xx,yy,zw])*sp.Matrix(1,3,[xx,yy,zw])/r**2)/r
chk("B11c Hess(|x|) = (I − x̂x̂ᵀ)/|x|  (PSD ⇒ D²g ≥ (2/C0T)I)",
    [sp.simplify(Hess_r[i,j] - Hess_r_closed[i,j]) for i in range(3) for j in range(3)],
    "convexity input for Prop 4.2")

# B12: Prop 4.3 weight g = −|x|²/4τ − (3/2)log τ − α·log(τ/(T0+t1)) + ατ/(T0+t1), τ=t+t1:
#      F = α/(T0+t1) − α/τ,  LF = α/τ²,  and  D²g = −I/(2τ) exactly.
t1b = sp.Symbol('t1', positive=True)
tau = tb + t1b
g43 = -r**2/(4*tau) - sp.Rational(3,2)*sp.log(tau) - al*sp.log(tau/(T0b+t1b)) + al*tau/(T0b+t1b)
F43 = sp.diff(g43, tb) - lap3(g43) - sum(q**2 for q in grad3(g43))
chk("B12a Prop 4.3: F = α/(T0+t1) − α/(t+t1)",
    sp.simplify(F43 - (al/(T0b+t1b) - al/tau)), "paper p.33 display")
LF43 = sp.diff(F43, tb) + lap3(F43)
chk("B12b Prop 4.3: LF = α/(t+t1)²",
    sp.simplify(LF43 - al/tau**2), "paper p.33 display")
Hess_g43 = sp.Matrix(3, 3, lambda i, j: sp.diff(g43, XY[i], XY[j]))
chk("B12c Prop 4.3: D²g = −I/(2(t+t1)) exactly",
    [sp.simplify(Hess_g43[i,j] + (sp.eye(3)/(2*tau))[i,j]) for i in range(3) for j in range(3)],
    "paper p.33: D²g(∇ψu,∇ψu) = −|∇ψu|²/2(t+t1)")

# B13: the elementary max inequality −a/t − b·log t ≤ b·log(b/(ae)) (paper p.35 'From elementary
#      calculus'). Verified via: critical point t*=a/b, value there equals the bound, and the
#      deficit b(1/u − 1 + log u) (u = tb/a) has d/du = (u−1)/u², value 0 at u=1, → +∞ at both ends
#      ⇒ unique global min 0 ⇒ inequality holds for all t>0.
ab, bb, tv, uvar = sp.symbols('a b t u', positive=True)
h = -ab/tv - bb*sp.log(tv)
tstar = ab/bb
chk("B13a max ineq: critical point h'(a/b)=0 and h(a/b)=b·log(b/(ae))",
    [sp.simplify(sp.diff(h, tv).subs(tv, tstar)),
     sp.simplify(h.subs(tv, tstar) - bb*sp.log(bb/(ab*sp.E)))],
    "paper p.35")
defic = 1/uvar - 1 + sp.log(uvar)
chk("B13b deficit: d/du(1/u−1+log u) = (u−1)/u² and value 0 at u=1",
    [sp.simplify(sp.diff(defic, uvar) - (uvar-1)/uvar**2), defic.subs(uvar, 1)],
    "unique interior critical point; limits at 0,∞ are +∞ ⇒ global min 0")

print()
print("ALL TRANSCRIBED IDENTITIES VERIFIED." if PASS else "AUDIT FAILURE — a transcribed identity did not close.")
raise SystemExit(0 if PASS else 1)
