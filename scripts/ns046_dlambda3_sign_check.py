#!/usr/bin/env python3
# ns046_dlambda3_sign_check.py — the NS-046 sign REQUIRED-CHECK, closed exactly (sympy).
#
# WHAT THIS PINS. The NS-046 probes (ns046_{gradxi_pressure,uniform_domination,
# integral_cancellation}) ADOPT the convention "e₃ᵀ(∇²p)e₃ > 0 ⇒ the nonlocal pressure
# DEPLETES the max-stretch growth", resting on the claim Dλ₃/Dt ⊃ −e₃ᵀ(∇²p)e₃ — which was
# never rigorously derived in-repo (flagged as a Required Check in the integral probe).
# This script machine-verifies the full derivation chain SYMBOLICALLY (sympy, exact):
#
#   I1  gradient-of-NS:        D A/Dt = −A² − ∇²p + νΔA          (A_ik = ∂u_i/∂x_k)
#   I2  symmetrization:        sym(A²) = S² + Ω²                  (⇒ DS/Dt = −S² − Ω² − ∇²p + νΔS)
#   I3  rotation term:         Ω² = ¼(ω⊗ω − |ω|² I)              (Ω_ij = −½ ε_ijk ω_k, ω=∇×u)
#   I4  eigen-derivative:      dλ₃/dt = e₃ᵀ (dS/dt) e₃            (simple λ₃; Hellmann–Feynman)
#
#   ⇒  Dλ₃/Dt = −λ₃² + ¼(|ω|² − (ω·e₃)²) − e₃ᵀ(∇²p)e₃ + ν e₃ᵀ(ΔS)e₃
#
# so the pressure-Hessian projection enters with coefficient −1: the adopted convention is
# CORRECT iff every identity below verifies to 0. Caveat carried with the result: I4 requires
# λ₃ SIMPLE (a.e. true; eigenvalue crossings excluded), and matches the published eigenframe
# dynamics (Meneveau Annu. Rev. Fluid Mech. 2011 form: dλ_i/dt = −λ_i² + ¼(|ω|²−ω̃_i²) − P_ii^eig + visc).
#
# Evidence class: algebraic (exact symbolic). Scope: a kinematic/structural identity of the
# NS equations — NOT a regularity statement. :proved=0; distance UNTOUCHED. -- STABLE

import sympy as sp

ok_all = True
def report(name, expr_zero, detail=""):
    global ok_all
    ok = all(sp.simplify(e) == 0 for e in expr_zero)
    ok_all &= ok
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}{('  — ' + detail) if detail else ''}")
    return ok

print("=" * 74)
print("  NS-046 sign Required-Check — Dλ₃ ⊃ −e₃ᵀ(∇²p)e₃  (exact, sympy)")
print("=" * 74)

# ── I1: gradient of NS ⇒ DA/Dt = −A² − ∇²p + νΔA ────────────────────────────
x, y, z, t, nu = sp.symbols('x y z t nu', real=True)
X = (x, y, z)
u = [sp.Function(f'u{i}')(x, y, z, t) for i in range(3)]
p = sp.Function('p')(x, y, z, t)

NS = [sp.diff(u[i], t) + sum(u[j] * sp.diff(u[i], X[j]) for j in range(3))
      + sp.diff(p, X[i]) - nu * sum(sp.diff(u[i], X[j], 2) for j in range(3))
      for i in range(3)]                                   # NS_i = 0 on solutions

A = sp.Matrix(3, 3, lambda i, k: sp.diff(u[i], X[k]))      # A_ik = ∂u_i/∂x_k
P = sp.Matrix(3, 3, lambda i, k: sp.diff(p, X[i], X[k]))   # pressure Hessian
DADt = sp.Matrix(3, 3, lambda i, k: sp.diff(A[i, k], t)
                 + sum(u[j] * sp.diff(A[i, k], X[j]) for j in range(3)))
LapA = sp.Matrix(3, 3, lambda i, k: sum(sp.diff(A[i, k], X[j], 2) for j in range(3)))
gradNS = sp.Matrix(3, 3, lambda i, k: sp.diff(NS[i], X[k]))

resid_I1 = (DADt + A * A + P - nu * LapA) - gradNS         # must vanish IDENTICALLY (no eqns assumed)
report("I1  ∂_k(NS_i) ≡ [DA/Dt + A² + ∇²p − νΔA]_ik", list(resid_I1),
       "so on NS solutions DA/Dt = −A² − ∇²p + νΔA")

# ── I2: sym(A²) = S² + Ω² for generic A ──────────────────────────────────────
a = sp.Matrix(3, 3, lambda i, j: sp.Symbol(f'a{i}{j}', real=True))
S = (a + a.T) / 2
Om = (a - a.T) / 2
resid_I2 = ((a * a + (a * a).T) / 2) - (S * S + Om * Om)
report("I2  sym(A²) = S² + Ω²", list(resid_I2),
       "⇒ DS/Dt = −S² − Ω² − ∇²p + νΔS (Hessian is symmetric)")

# ── I3: Ω² = ¼(ω⊗ω − |ω|²I), with ω built FROM the same generic A ────────────
w = sp.Matrix([a[2, 1] - a[1, 2], a[0, 2] - a[2, 0], a[1, 0] - a[0, 1]])  # ω_i = ε_ijk A_kj
I3_rhs = (w * w.T - (w.T * w)[0] * sp.eye(3)) / 4
resid_I3 = Om * Om - I3_rhs
report("I3  Ω² = ¼(ω⊗ω − |ω|²I)", list(resid_I3),
       "⇒ e₃ᵀ(−Ω²)e₃ = ¼(|ω|² − (ω·e₃)²) ≥ 0 (the vorticity FEED)")

# ── I4: eigen-derivative lemma dλ₃/dt = e₃ᵀ(dS/dt)e₃ on a parametrized family ─
# S(t) = R(t) diag(λ_i(t)) R(t)ᵀ with R(t) a one-parameter rotation composition (generic axis).
th1, th2 = sp.Function('theta1')(t), sp.Function('theta2')(t)
l1, l2, l3 = sp.Function('lam1')(t), sp.Function('lam2')(t), sp.Function('lam3')(t)
Rz = sp.Matrix([[sp.cos(th1), -sp.sin(th1), 0], [sp.sin(th1), sp.cos(th1), 0], [0, 0, 1]])
Rx = sp.Matrix([[1, 0, 0], [0, sp.cos(th2), -sp.sin(th2)], [0, sp.sin(th2), sp.cos(th2)]])
R = Rz * Rx
St = R * sp.diag(l1, l2, l3) * R.T
e3 = R[:, 2]                                               # unit eigenvector of λ₃ (R orthogonal)
lhs_I4 = sp.diff(l3, t)
rhs_I4 = (e3.T * sp.diff(St, t) * e3)[0]
report("I4  dλ₃/dt = e₃ᵀ(dS/dt)e₃ (λ₃ simple)", [lhs_I4 - rhs_I4],
       "Hellmann–Feynman; rotation terms cancel exactly")

# ── Assembly: project DS/Dt onto e₃ ──────────────────────────────────────────
# By I1+I2(+symmetry of P): DS/Dt = −S² − Ω² − P + νΔS. By I4: Dλ₃/Dt = e₃ᵀ(DS/Dt)e₃.
# A1: the self-term projection e₃ᵀS²e₃ = λ₃² — verified symbolically on the I4 family,
# where Se₃=λ₃e₃ holds by construction (the general case is the 1-line operator identity
# e₃ᵀS²e₃ = (Se₃)·(Se₃) = λ₃², S symmetric, |e₃|=1):
resid_A1 = (e3.T * St * St * e3)[0] - l3 ** 2
report("A1  e₃ᵀS²e₃ = λ₃²  (so e₃ᵀ(−S²)e₃ = −λ₃²)", [resid_A1],
       "the λ₃ 'self' term — note the sign: self-DAMPING for the max eigenvalue")

print("-" * 74)
if ok_all:
    print("  ⇒ Dλ₃/Dt = −λ₃² + ¼(|ω|² − (ω·e₃)²) − e₃ᵀ(∇²p)e₃ + ν e₃ᵀ(ΔS)e₃")
    print("  ⇒ the pressure-Hessian projection enters with coefficient −1:")
    print("    e₃ᵀ(∇²p)e₃ > 0  ⇒  DEPLETES the max-stretch growth.   CONVENTION PINNED.")
    print("  NOTE (honest sharpening): for λ₃ itself the −λ₃² term is SELF-DAMPING; the")
    print("  growth feed is the vorticity term ¼(|ω|²−(ω·e₃)²) (maximal for ω ⊥ e₃). The")
    print("  probes' ratio R = e₃ᵀ∇²p e₃ / λ₃² remains a sensible magnitude comparison")
    print("  (λ₃² is the dynamics' scale), but 'λ₃² = self-amplification OF λ₃' is loose.")
    print("  Caveat: I4 needs λ₃ simple (a.e.; crossings excluded). :proved=0.")
else:
    print("  ✗ A FAIL above — the convention is NOT pinned; re-read the probes' sign before use.")
print("=" * 74)
raise SystemExit(0 if ok_all else 1)
