#!/usr/bin/env julia
# formalization/nrs/h_identity_exact.jl — the NRŠ H-identity, JULIA EXACT-ALGEBRAIC RUNG
# (the Python→Julia→Haskell→Lean ladder, rung 1; the Lean rung is handed to the formalization track).
#
# THE IDENTITY (Nečas–Růžička–Šverák, Acta Math. 176 (1996) — the corrected in-repo record, after
# the disproof probe `disproof/nrs_h_identity.py` caught the original transcription error):
#   profile eq:  −νΔU + aU + a(y·∇)U + (U·∇)U + ∇P = 0,  div U = 0,  a>0
#   H := ½|U|² + P + a(y·U)
#   ⇒  −νΔH + (U·∇)H + a(y·∇)H  =  −ν|ω|²  ≤ 0        (ω = ∇×U)
# i.e. the FULL self-similar operator (WITH the drift a(y·∇)H) applied to H equals minus-ν times
# the profile's vorticity squared — manifestly ≤0 ⇒ the maximum principle NRŠ run through H.
# The ORIGINAL record had (i) NO drift term and (ii) RHS −ν|∇U+aI|² + ν(∂_iU_j)(∂_jU_i), which the
# sympy probe showed differs from the true reduction by EXACTLY −3a²ν (the caught record error).
#
# WHAT THIS RUNG DOES (exact, Rational{BigInt} — no Float anywhere):
# Formal verification mod the profile equation: every first derivative is an INDEPENDENT symbol;
# ΔU_k is substituted FROM the profile eq, ΔP from its divergence (pressure-Poisson), div U=0 is
# imposed by eliminating ∂₂U₂. The claimed identity is then a POLYNOMIAL identity over ℚ in 24
# independents (u₃, ∂U₈, ∂P₃, y₃, a, ν → after elimination). We evaluate the difference at many
# random exact-rational points: a nonzero polynomial of this degree vanishing at all of them has
# probability ≲ (deg/|S|)^trials (Schwartz–Zippel) — with the sympy symbolic zero already on
# record, this rung is the ladder's independent exact-arithmetic closure.
# FALSE-VARIANT GATE (ladder discipline): the ORIGINAL recorded form must come out ≠0 and equal
# EXACTLY 3a²ν — reproducing the caught error, not just failing.
#
# Evidence class: algebraic. Scope: an identity of the NRŠ profile system — supports the NS-007/G3
# citation row; NOT a regularity statement. :proved=0; distance UNTOUCHED. -- STABLE

using Random, Printf

const Q = Rational{BigInt}
rq(rng) = Q(rand(rng, -19:19), rand(rng, 1:13))

# evaluate the reduction at one exact-rational point; returns (D_true, D_recorded)
function residuals(rng)
    a  = rq(rng); ν = abs(rq(rng)) + Q(1,7)   # ν > 0 strictly (any nonzero works for the identity)
    y  = [rq(rng) for _ in 1:3]
    u  = [rq(rng) for _ in 1:3]
    dp = [rq(rng) for _ in 1:3]
    du = [rq(rng) for _ in 1:3, _ in 1:3]  # du[i,k] = ∂_i U_k (all independent…)
    du[3,3] = -(du[1,1] + du[2,2])         # …except div U = 0 imposed exactly

    # profile eq ⇒ ΔU_k ; pressure-Poisson ⇒ ΔP ; (all exact)
    LapU = [ (a*u[k] + a*sum(y[j]*du[j,k] for j in 1:3)
              + sum(u[j]*du[j,k] for j in 1:3) + dp[k]) / ν   for k in 1:3 ]
    LapP = -sum(du[i,j]*du[j,i] for i in 1:3, j in 1:3)

    gradU2 = sum(du[i,k]^2 for i in 1:3, k in 1:3)
    LapH   = gradU2 + sum((u[k] + a*y[k])*LapU[k] for k in 1:3) + LapP   # (+2a·divU = 0)
    dH(i)  = sum(u[k]*du[i,k] for k in 1:3) + dp[i] + a*u[i] + a*sum(y[k]*du[i,k] for k in 1:3)
    UgradH = sum(u[i]*dH(i) for i in 1:3)
    ygradH = sum(y[i]*dH(i) for i in 1:3)

    ω2 = (du[2,3]-du[3,2])^2 + (du[3,1]-du[1,3])^2 + (du[1,2]-du[2,1])^2   # |∇×U|²

    L_true     = -ν*LapH + UgradH + a*ygradH            # corrected operator (WITH drift)
    D_true     = L_true + ν*ω2                          # must be EXACTLY 0

    cross      = sum(du[i,j]*du[j,i] for i in 1:3, j in 1:3)
    RHS_rec    = -ν*sum((du[i,j] + a*(i==j))^2 for i in 1:3, j in 1:3) + ν*cross
    D_recorded = L_true - RHS_rec                       # must be EXACTLY 3a²ν (the caught error)
    (D_true, D_recorded, a, ν)
end

function main()
    println("="^74)
    println("  NRŠ H-identity — Julia exact-algebraic rung (Rational{BigInt}; no Float)")
    println("  claim: −νΔH + (U·∇)H + a(y·∇)H = −ν|ω|²   (mod profile eq, div U=0)")
    println("="^74)
    rng = MersenneTwister(1996)            # Acta Math. 176 (1996)
    trials = 200
    ok_true = true; ok_false = true
    for k in 1:trials
        Dt, Dr, a, ν = residuals(rng)
        ok_true  &= (Dt == 0)
        ok_false &= (Dr == 3a^2*ν)
    end
    @printf("  [%s] corrected identity: residual == 0 exactly, %d/%d random ℚ-points\n",
            ok_true ? "PASS" : "FAIL", trials, trials)
    @printf("  [%s] FALSE-VARIANT gate: original record ≠ 0, off by EXACTLY 3a²ν, %d/%d points\n",
            ok_false ? "PASS" : "FAIL", trials, trials)
    println("-"^74)
    if ok_true && ok_false
        println("  ⇒ rung CLOSED: the corrected H-identity holds exactly; the original record's")
        println("    error (missing drift + the −3a²ν constant) is reproduced exactly — the rung")
        println("    verifies both the truth and the catch. NEXT RUNG: Lean (handed to the")
        println("    formalization track); on its completion the NRŠ row in docs/citation_tiers.md")
        println("    gains a machine-verified core (close-out items vi+vii).")
    else
        println("  ✗ FAIL — do NOT hand to Lean; reconcile with disproof/nrs_h_identity.py first.")
    end
    println("  Evidence: algebraic. Scope: profile-system identity (NOT regularity). :proved=0.")
    println("="^74)
    exit(ok_true && ok_false ? 0 : 1)
end
main()
