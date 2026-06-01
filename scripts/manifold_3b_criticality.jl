#!/usr/bin/env julia
# manifold_3b_criticality.jl — NS MANIFOLD STUDY, Slice 3 (RIGOROUS): the scaling-
#                              exponent calculus and the supercriticality quotient
#
# EXPERIMENTAL. **Scope: PDE — the exact scaling (criticality) calculus of the NS
# norms.** This is the rigorous version of Slice 3's reading "supercriticality =
# the non-compact scaling quotient." It does NOT prove regularity (it is the exact
# FRAMING of the obstruction NS-002, unifying it with the critical-norm criterion
# NS-005). `:proved` = 0; distance to the prize UNTOUCHED.
#
# THE SCALING ACTION (precise). On ℝ³ the NS scaling symmetry is the dilation
#   D_λ : u(x,t) ↦ u_λ(x,t) = λ u(λx, λ²t),  p ↦ λ²p,   fixed ν,  λ∈ℝ₊.
# It is the unique (up to translation/rotation/Galilean) 1-parameter symmetry, and
# ℝ₊ is NON-COMPACT. In Fourier (space): û_λ(k) = λ⁻² û(k/λ).
#
# SCALING EXPONENT. For a homogeneous norm/functional X, D_λ multiplies it by a
# pure power: ‖u_λ‖_X = λ^{σ_X} ‖u‖_X. The exponent σ_X (a RATIONAL number, exact
# by change of variables) classifies X:
#     σ_X > 0  SUBCRITICAL    (grows at small scales λ→∞; controlling it ⇒ regularity,
#                              but not a-priori bounded — e.g. enstrophy, the 3D battleground)
#     σ_X = 0  CRITICAL       (SCALE-INVARIANT ⇒ DESCENDS to the dilation quotient;
#                              the regularity-deciding class — L³, Ḣ^{1/2}, PS-borderline)
#     σ_X < 0  SUPERCRITICAL  (→0 at small scales ⇒ a bound is VACUOUS where a
#                              singularity lives — e.g. ENERGY, dissipation)
#
# THE QUOTIENT (precise). ℝ₊ acts on the data; the orbits are scale-classes; a
# functional DESCENDS to the quotient ⟺ σ_X = 0. The regularity question is
# scale-invariant (u smooth ⟺ u_λ smooth) ⇒ it lives ON the quotient. The
# a-priori-controlled quantities (energy, dissipation) have σ<0 ⇒ they do NOT
# descend ⇒ they cannot control the quotient where regularity is decided. That
# descent failure — controlled norms σ<0, deciding norms σ=0, no overlap — IS
# supercriticality (NS-002), made exact.
#
# Std-lib Julia. (A) the exact exponent calculus; (B) continuous-λ numeric
# verification on an analytic spectrum; (C) the Prodi–Serrin borderline = {σ=0};
# (D) the obstruction, quantified.

using Printf

# ── exact scaling exponents (rational, by change of variables on ℝ³) ────────────
σ_Lq(q)      = 1 - 3/q                 # ‖u_λ‖_{L^q(ℝ³)} = λ^{1-3/q}‖u‖
σ_Hs(s)      = s - 1/2                 # ‖u_λ‖_{Ḣ^s(ℝ³)} = λ^{s-1/2}‖u‖
σ_PS(p,q)    = 1 - 3/q - 2/p           # ‖u_λ‖_{L^p_t L^q_x} = λ^{1-3/q-2/p}‖u‖
classify(σ)  = σ>1e-12 ? "SUBcritical" : (σ<-1e-12 ? "SUPERcritical" : "CRITICAL (scale-inv)")

# ── analytic radial velocity spectrum |û(k)| for the numeric verification ──────
uhat(k) = k*exp(-k^2)                  # smooth, vanishes at k=0, fast decay

# ‖u_λ‖_{Ḣ^s}² via the radial integral 4π∫₀^∞ k^{2s+2} |û_λ(k)|² dk, û_λ(k)=λ⁻²û(k/λ).
# Fine trapezoidal quadrature (integrand smooth & fast-decaying ⇒ essentially exact).
function Hs_norm2(s, λ; kmax=40.0, M=400000)
    dk=kmax/M; acc=0.0
    for i in 1:M
        k=(i-0.5)*dk
        uh=λ^(-2)*uhat(k/λ)
        acc += k^(2s+2)*uh^2*dk
    end
    4π*acc
end

function main()
    out=joinpath(@__DIR__,"manifold_3b_criticality.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^82; dsh="─"^82
    pr(bar); pr("  MANIFOLD STUDY — Slice 3 (RIGOROUS): the SCALING-EXPONENT CALCULUS")
    pr("  (Scope: PDE — exact criticality calculus of the NS norms. Framing of NS-002, NOT a proof.)")
    pr(bar)
    pr("  Dilation D_λ: u↦λu(λx,λ²t), λ∈ℝ₊ (NON-COMPACT). ‖u_λ‖_X=λ^{σ_X}‖u‖_X.")
    pr("  σ>0 SUBcritical · σ=0 CRITICAL (scale-invariant, descends to the quotient) · σ<0 SUPERcritical.")

    # ── (A) the exact exponent table ────────────────────────────────────────────
    pr("\n"*dsh); pr("  (A) EXACT scaling exponents (rational, by change of variables on ℝ³)")
    pr(dsh)
    pr(@sprintf("    %-26s %-12s %-s","norm / functional","σ (exact)","class"))
    rows=[("L²  = energy norm",        σ_Hs(0)),
          ("Ḣ^{1/2} (critical)",       σ_Hs(0.5)),
          ("Ḣ¹  (∝ √enstrophy)",       σ_Hs(1.0)),
          ("L³  (critical)",           σ_Lq(3)),
          ("L²  (q=2)",                σ_Lq(2)),
          ("L^∞",                      σ_Lq(Inf))]
    for (nm,σ) in rows
        pr(@sprintf("    %-26s %-12s %-s", nm, @sprintf("%+.3f",σ), classify(σ)))
    end
    pr("    derived functionals (square/integrate the above):")
    funcs=[("ENERGY  E=½‖u‖_{L²}²",            2*σ_Hs(0)),
           ("ENSTROPHY ½‖ω‖²=½‖u‖_{Ḣ¹}²",      2*σ_Hs(1)),
           ("HELICITY ∫u·ω",                    σ_Hs(0)+σ_Hs(1)+0.0),   # = -1/2+1/2 = 0
           ("DISSIPATION ∫₀^T‖∇u‖²dt",          2*σ_Hs(1)-2)]            # space 2·(1/2); time λ⁻²
    for (nm,σ) in funcs
        pr(@sprintf("    %-26s %-12s %-s", nm, @sprintf("%+.3f",σ), classify(σ)))
    end
    pr("    ⇒ CONTROLLED quantities (Leray): ENERGY σ=−1 and DISSIPATION σ=−1 are BOTH SUPERcritical.")
    pr("      HELICITY σ=0 is the scale-invariant Casimir (Slice 1). The CRITICAL (σ=0) norms")
    pr("      L³, Ḣ^{1/2} are exactly NS-002's list — and none is a-priori controlled.")

    # ── (B) continuous-λ numeric verification of σ_{Ḣ^s}=s−½ ────────────────────
    pr("\n"*dsh); pr("  (B) VERIFY σ_{Ḣ^s}=s−½ numerically, CONTINUOUS λ (analytic spectrum, fine quadrature)")
    pr(dsh)
    base=Dict(s=>Hs_norm2(s,1.0) for s in (0.0,0.25,0.5,0.75,1.0))
    pr(@sprintf("    %-8s %-10s %-10s %-10s %-10s  %-14s","s","λ=0.5","λ=2","λ=4","fit σ","exact σ=s−½"))
    for s in (0.0,0.25,0.5,0.75,1.0)
        # norm RATIO ‖u_λ‖/‖u‖ = sqrt(Hs_norm2(s,λ)/base) ; fit slope of log-ratio vs log λ
        λs=[0.5,1.0,2.0,4.0]; r=[sqrt(Hs_norm2(s,λ)/base[s]) for λ in λs]
        x=log.(λs); y=log.(r); mx=sum(x)/4; my=sum(y)/4
        σfit=sum((x.-mx).*(y.-my))/sum((x.-mx).^2)
        pr(@sprintf("    %-8.2f %-10.4f %-10.4f %-10.4f %-10.4f  %-14.4f",
            s, r[1], r[3], r[4], σfit, s-0.5))
    end
    pr("    ⇒ fit σ matches s−½ to quadrature precision. At s=½ the ratio is ≡1 (FLAT in λ) —")
    pr("      the CRITICAL norm is scale-invariant. At s=0 (energy) the ratio is λ^{−½} (DECAYS).")

    # ── (C) Prodi–Serrin: the critical locus {σ=0} is exactly 2/p+3/q=1 (NS-005) ─
    pr("\n"*dsh); pr("  (C) PRODI–SERRIN–ESS (NS-005): the scale-invariant locus {σ=0} ⟺ 2/p+3/q=1")
    pr(dsh)
    pr(@sprintf("    σ(L^p_t L^q_x) = 1 − 3/q − 2/p.  Check standard (p,q):"))
    pr(@sprintf("    %-16s %-10s %-12s %-s","(p,q)","2/p+3/q","σ","on PS borderline?"))
    for (p,q,lbl) in ((Inf,3.0,"L^∞_t L³_x (ESS)"),(2.0,Inf,"L²_t L^∞_x"),(4.0,6.0,"L⁴_t L⁶_x"),
                      (5.0,5.0,"L⁵_t L⁵_x (sub)"),(2.0,2.0,"L²_t L²_x (super)"))
        s=σ_PS(p,q); psum=2/p+3/q
        pr(@sprintf("    %-16s %-10.3f %-12s %-s", lbl, psum, @sprintf("%+.3f",s),
            abs(s)<1e-9 ? "YES (critical, σ=0)" : (s>0 ? "subcritical" : "supercritical")))
    end
    pr("    ⇒ the Prodi–Serrin–ESS regularity threshold IS the scale-invariant (critical) locus.")
    pr("      The regularity criteria live exactly on the dilation quotient (σ=0). NS-002 ↔ NS-005 unified.")

    # ── (D) the obstruction, quantified: a controlled bound is vacuous at small scales ─
    pr("\n"*dsh); pr("  (D) SUPERCRITICALITY as a descent failure — ‖u_λ‖_X/‖u‖_X vs scale λ")
    pr(dsh)
    pr(@sprintf("    %-22s %-10s %-10s %-10s %-10s %-s","norm (σ)","λ=1","λ=10","λ=100","λ=1000","λ→∞"))
    for (nm,s) in (("ENERGY L² (σ=−½)",0.0),("CRITICAL Ḣ^{1/2} (σ=0)",0.5),("ENSTROPHY Ḣ¹ (σ=+½)",1.0))
        f(λ)=λ^(s-0.5)
        pr(@sprintf("    %-22s %-10.3f %-10.3f %-10.3f %-10.3f %-s",
            nm, f(1),f(10),f(100),f(1000), s<0.5 ? "→ 0 (VACUOUS)" : (s>0.5 ? "→ ∞" : "≡ 1 (controls all scales)")))
    end
    pr("    ⇒ a Leray bound ‖u‖_{L²}≤M gives ‖u_λ‖_{L²}≤λ^{−½}M → 0 as λ→∞: it says NOTHING at the")
    pr("      small scales (λ→∞) where a singularity would live. A CRITICAL bound (σ=0) would control")
    pr("      ALL scales uniformly ⇒ regularity (NS-005) — but no critical norm is a-priori controlled.")
    pr("      THE WALL, exactly: controlled norms have σ<0; regularity-deciding norms have σ=0; no overlap.")

    pr("\n"*bar); pr("  READING (Slice 3 rigorous — the criticality calculus)")
    pr(bar)
    pr("  • EXACT: the dilation D_λ assigns every homogeneous NS norm a rational exponent σ_X. The")
    pr("    CRITICAL (σ=0) class — L³, Ḣ^{1/2}, BMO⁻¹, the Prodi–Serrin locus 2/p+3/q=1 — is precisely")
    pr("    the SCALE-INVARIANT one that DESCENDS to the non-compact dilation quotient.")
    pr("  • The a-priori CONTROLLED quantities (energy, dissipation) have σ=−1 (SUPERcritical) ⇒ they do")
    pr("    NOT descend; a bound on them is vacuous as λ→∞. This descent failure IS supercriticality (NS-002).")
    pr("  • NS-002 and NS-005 are UNIFIED: the regularity-sufficient norms are exactly the σ=0 quotient")
    pr("    coordinates; the a-priori-controlled ones are exactly the σ<0 (off-quotient) ones. The gap is")
    pr("    the open problem, stated as a descent/scaling fact (not closed by it).")
    pr("  • This is the RIGOROUS form of the Slice-3 reading: 'some scales are not meaningful' = the σ≠0")
    pr("    (gauge) directions; the meaningful coordinates are the σ=0 quotient = the critical class.")
    pr("  • FIREWALL: this is the exact FRAMING of the obstruction, standard criticality theory")
    pr("    (Tao/Cannone/…) re-derived + verified in-repo. It is NOT a regularity proof. :proved=0.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
