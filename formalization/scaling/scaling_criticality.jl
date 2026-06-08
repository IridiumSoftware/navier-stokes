# scaling_criticality.jl — Rung 0 of the formalization ladder (ALGEBRAIC evidence)
#
# Exact-arithmetic verification of the Navier–Stokes scaling-criticality calculus
# (the program's NS-034 / NS-002 scaling skeleton). Pure `Rational` — no deps
# (Julia Base only), hermetic. This is the "algebraic proof" rung: every scaling
# exponent is derived from the change-of-variables bookkeeping and every
# criticality condition is checked as an EXACT rational identity. Float64 is never
# used (that would be computational, not algebraic, evidence).
#
# CONVENTIONS IN FORCE (declared per the project commenting standard):
#  - Rescaling:  u_λ(x,t) = λ^f · u(λ x, λ² t)   with field power f (=1 for velocity).
#                (Parabolic NS scaling: length ∼ λ⁻¹, time ∼ λ⁻², velocity ∼ λ.)
#  - Scaling exponent [X] of a norm X is DEFINED by  ‖u_λ‖_X = λ^{[X]} ‖u‖_X.
#  - A norm is CRITICAL iff [X] = 0 (scale-invariant); SUBcritical iff [X] > 0
#    (sees small scales); SUPERcritical iff [X] < 0 (vanishes under blow-up
#    rescaling λ→∞, hence useless at the singularity scale — this is NS-002).
#  - `Inf` Lebesgue exponents (p=∞, q=∞) are handled exactly via 1/∞ := 0.
#  - DEPENDENCIES: none (Julia Base only) — hermetic; the only pin is the Julia
#    version (recorded in formalization/README.md).

# --- exact 1/p with the ∞ convention (returns a Rational; 1/∞ = 0) ---
inv_exp(p) = (p == Inf) ? 0//1 : (1//1) / (p isa Rational ? p : (p//1))

# === Lebesgue mixed-norm scaling exponent =====================================
# For the (possibly axially-weighted) mixed norm  ‖ |x₃|^α u ‖_{L^q_t L^p_x}
# with field power f, weight α (a Rational), spatial Lebesgue p, time Lebesgue q.
#
# Derivation (change of variables, EXACT — each step is an exponent of λ):
#   spatial L^p:  ‖|x₃|^α λ^f u(λx,λ²t)‖_{L^p_x}
#       field           → +f
#       weight |x₃|^α   → −α      (x₃ = y₃/λ ⇒ |x₃|^{αp} contributes λ^{−αp}; /p ⇒ −α)
#       Jacobian dx     → −3/p    (dx = λ^{−3} dy; /p ⇒ −3/p)
#     ⇒ e_spatial = f − α − 3/p
#   time L^q:   dt = λ^{−2} ds  ⇒ −2/q
#     ⇒ [X] = (f − α − 3/p) − 2/q .
function lebesgue_exponent(; f::Rational=1//1, α::Rational=0//1, p, q=Inf)
    return f - α - 3*inv_exp(p) - 2*inv_exp(q)
end

# === Homogeneous Sobolev Ḣ^s scaling exponent =================================
# Fourier side: û_λ(ξ,t) = λ^{f−3} û(ξ/λ, λ²t); ‖u_λ‖_{Ḣ^s}² = λ^{2(f−3)} ∫|ξ|^{2s}|û(ξ/λ)|²
#   = λ^{2(f−3)} · λ^{2s} · λ^{3} ‖u‖²_{Ḣ^s}  (|ξ|^{2s}=λ^{2s}|η|^{2s}, dξ=λ³dη)
#   ⇒ [Ḣ^s] = (f−3) + s + 3/2 = s + f − 3/2.  (f=1 ⇒ s − 1/2.)
sobolev_exponent(s::Rational; f::Rational=1//1) = s + f - 3//2

# === The criticality classifier ===============================================
classify(e::Rational) = e == 0 ? :critical : (e > 0 ? :subcritical : :supercritical)

# ============================================================================ #
#                         THE ALGEBRAIC VERIFICATION                            #
# ============================================================================ #
function run()
    println("Rung 0 — scaling-criticality calculus (exact Rational; algebraic evidence)\n")
    pass = Ref(true)
    chk(name, cond, detail) = begin
        ok = cond
        pass[] &= ok
        println(rpad(ok ? "  PASS" : "  FAIL", 8), rpad(name, 44), detail)
    end

    # --- (1) L^p spatial norm: critical iff p = 3 (NS critical Lebesgue space) ---
    eL3  = lebesgue_exponent(p=3)
    eL2  = lebesgue_exponent(p=2)            # the energy norm
    eLinf= lebesgue_exponent(p=Inf)
    chk("[L^p] = 1 − 3/p",            lebesgue_exponent(p=6)  == 1 - 3//6, "[L^6]=$(lebesgue_exponent(p=6))")
    chk("L^3 is CRITICAL",            eL3 == 0 && classify(eL3)==:critical,        "[L^3]=$eL3")
    chk("L^2 (energy) is SUPERcrit.", eL2 == -1//2 && classify(eL2)==:supercritical,"[L^2]=$eL2  (NS-002)")
    chk("L^∞ is SUBcritical",         eLinf == 1 && classify(eLinf)==:subcritical,  "[L^∞]=$eLinf")

    # --- (2) Ḣ^s: critical iff s = 1/2 ; and Ḣ^0 = L^2 consistency ---
    eH12 = sobolev_exponent(1//2)
    eH0  = sobolev_exponent(0//1)
    chk("Ḣ^{1/2} is CRITICAL",        eH12 == 0,                  "[Ḣ^{1/2}]=$eH12")
    chk("Ḣ^0 = L^2 (both −1/2)",      eH0 == eL2,                 "[Ḣ^0]=$eH0 = [L^2]")

    # --- (3) the supercriticality GAP (NS-002): energy sits one full step below critical ---
    chk("energy gap [L^2]−[Ḣ^{1/2}] = −1/2", eL2 - eH12 == -1//2, "the σ=−1 vs σ=0 wall")

    # --- (4) anisotropic |x₃|^α criticality:  [X]=0  ⟺  2/q + 3/p = 1 − α  (WHWY) ---
    # Verify the iff EXACTLY on admissible triples, and that off-criticality ⇒ exponent ≠ 0.
    crit_triples = [( (1//4), 6//1, 8//1 ),       # CRITICAL, weighted: 2/8+3/6 = 1/4+1/2 = 3/4 = 1−1/4 ✓
                    ( (0//1), 3//1, Inf  ),       # CRITICAL, Serrin endpoint L^∞L^3: 0+1 = 1 = 1−0 ✓
                    ( (1//8), 4//1, 8//1 )]       # CONTROL (not critical): 2/8+3/4 = 1 ≠ 7/8 = 1−1/8
    for (α,p,q) in crit_triples
        lhs = 2*inv_exp(q) + 3*inv_exp(p)        # 2/q + 3/p
        rhs = 1 - α                               # 1 − α
        e   = lebesgue_exponent(α=α, p=p, q=q)
        iff_holds = (e == 0) == (lhs == rhs)      # the criticality IFF, exact
        chk("|x₃|^α iff (α=$α,p=$p,q=$q)", iff_holds,
            "2/q+3/p=$lhs, 1−α=$rhs, [X]=$e ⇒ $(classify(e))")
    end

    # --- (5) the iff as a SYMBOLIC identity over the exponent algebra ---------
    # [X] = (1 − α − 3/p) − 2/q = 0  ⟺  2/q + 3/p = 1 − α.  Rearranged exactly:
    let α=3//7, p=5//1, q=11//1
        e = lebesgue_exponent(α=α, p=p, q=q)
        rearr = (1 - α) - (2*inv_exp(q) + 3*inv_exp(p))
        chk("[X] ≡ (1−α) − (2/q+3/p)", e == rearr, "exponent algebra closes exactly")
    end

    println()
    println(pass[] ? "ALL EXACT IDENTITIES VERIFIED — algebraic evidence (Rung 0)." :
                     "FAILURE — an identity did not close exactly.")
    return pass[]
end

run() || error("scaling-criticality verification FAILED")
