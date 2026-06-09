#!/usr/bin/env python3
"""
NRŠ H-identity — symbolic attack (disproof probe).

Nečas–Růžička–Šverák, Acta Math. 176 (1996), self-similar profile:
    profile eq:  −ν ΔU + a U + a (y·∇)U + (U·∇)U + ∇P = 0,   div U = 0,  a>0.
    H := ½|U|² + P + a (y·U).
RECORDED identity (our line-read doc):  −νΔH + (U·∇)H = −ν|∇U+aI|² + ν (∂_iU_j)(∂_jU_i)  ( ≤ 0 ).

We verify the identity as a FORMAL consequence of the profile equation: treat every partial
derivative as an independent symbol; substitute ΔU_k from the profile eq and ΔP from the
pressure-Poisson relation (= div of the profile eq, using div U=0); impose div U=0. If the
identity holds for solutions, the difference must reduce to 0.

We test the recorded operator −νΔH+(U·∇)H AND the natural self-similar operator that also carries
the drift, −νΔH+(U·∇)H+a(y·∇)H, against the recorded RHS — and print what each operator actually
reduces to, so a discrepancy (in our record or the RHS form) is exposed, not hidden.
"""
import sympy as sp

a, nu = sp.symbols('a nu', positive=True)
y = sp.symbols('y0 y1 y2')
u = sp.symbols('u0 u1 u2')                                   # U_k
du = [[sp.Symbol(f'du_{i}{k}') for k in range(3)] for i in range(3)]   # ∂_i U_k
dp = sp.symbols('dp0 dp1 dp2')                               # ∂_k P
kron = lambda i, j: 1 if i == j else 0

# profile eq solved for the Laplacian trace ΔU_k ; pressure-Poisson for ΔP
LapU = [(a*u[k] + a*sum(y[j]*du[j][k] for j in range(3))
            + sum(u[j]*du[j][k] for j in range(3)) + dp[k]) / nu for k in range(3)]
LapP = -sum(du[i][j]*du[j][i] for i in range(3) for j in range(3))
div  = sum(du[k][k] for k in range(3))

gradU2 = sum(du[i][k]**2 for i in range(3) for k in range(3))                 # |∇U|²
LapH   = gradU2 + sum((u[k] + a*y[k])*LapU[k] for k in range(3)) + LapP + 2*a*div
dH = lambda i: (sum(u[k]*du[i][k] for k in range(3)) + dp[i]
                + a*u[i] + a*sum(y[k]*du[i][k] for k in range(3)))           # ∂_i H
UgradH = sum(u[i]*dH(i) for i in range(3))
ygradH = sum(y[i]*dH(i) for i in range(3))

L_recorded = -nu*LapH + UgradH                # the operator as recorded
L_withdrift = -nu*LapH + UgradH + a*ygradH    # natural self-similar operator (with drift)

gradUaI_sq = sum((du[i][j] + a*kron(i, j))**2 for i in range(3) for j in range(3))   # |∇U+aI|²
cross      = sum(du[i][j]*du[j][i] for i in range(3) for j in range(3))             # (∂_iU_j)(∂_jU_i)
RHS_recorded = -nu*gradUaI_sq + nu*cross

sub_div = {du[2][2]: -(du[0][0] + du[1][1])}                 # impose div U = 0
red = lambda e: sp.expand(e.subs(sub_div))

print("== NRŠ H-identity symbolic attack ==")
print("D1 = (−νΔH+(U·∇)H) − RHS_recorded         :", red(L_recorded - RHS_recorded))
print("D2 = (−νΔH+(U·∇)H+a(y·∇)H) − RHS_recorded :", red(L_withdrift - RHS_recorded))
print()
print("−νΔH+(U·∇)H            reduces to :", red(L_recorded))
print("−νΔH+(U·∇)H+a(y·∇)H    reduces to :", red(L_withdrift))
print("RHS_recorded           reduces to :", red(RHS_recorded))
print()
# also report the difference (true LHS) − (−ν|∇U+aI|²) to see if the cross term / drift is the story
print("(−νΔH+(U·∇)H+a(y·∇)H) − (−ν|∇U+aI|²)        :", red(L_withdrift + nu*gradUaI_sq))
