#!/usr/bin/env julia
# kolmogorov_dissipation_hard_test.jl
#
# Same hard-vs-frame-dependent test as mu_hard_bound.jl, now on the KOLMOGOROV CONSTANT
# C_K (spectral amplitude) and the DISSIPATION ANOMALY coefficient C_ε ("zeroth law").
# Question (methodology §5): does any FRAME-INDEPENDENT invariant TOUCH them, or are they
# purely frame-dependent (like μ)? Anti-anchoring: the measured values (C_K≈1.6, C_ε≈0.5)
# are NOT used as constraints — only as a final convergence note.
#
# A constant is "touched" by the hard layer iff it appears in an EXACT relation (the 4/5
# law), a REALIZABILITY bracket (monotone+concave ζ_p), or a RIGOROUS NS INEQUALITY
# (the energy balance). We find a clean RANKING.
#
# Scope: EMPIRICAL phenomenology + exact 4/5 + realizability + the Doering–Foias bound.
# NOT the PDE. :proved=0. Std-lib only.

using Printf, Random

const DP = 0.25
const PGRID = 0.0:DP:8.0
idx(p) = round(Int, p/DP) + 1
zp(ζ, p) = ζ[idx(p)]

function from_slopes(slopes)               # nonincreasing ≥0 slopes ⇒ concave+monotone; rescale ζ_3=1
    ζ = zeros(length(PGRID))
    for i in 1:length(PGRID)-1; ζ[i+1] = ζ[i] + slopes[i]*DP; end
    ζ ./= ζ[idx(3.0)]; ζ
end
function admissible(ζ; tol=1e-9)
    abs(ζ[idx(0.0)]) < tol || return false
    abs(zp(ζ,3.0) - 1) < 1e-6 || return false
    all(ζ[i+1]-ζ[i] >= -tol for i in 1:length(ζ)-1) || return false           # nondecreasing
    all(ζ[i+1]-2ζ[i]+ζ[i-1] <= tol for i in 2:length(ζ)-1) || return false     # concave
    true
end

function main()
    out = joinpath(@__DIR__, "kolmogorov_dissipation_hard_test.out.txt")
    fout = open(out,"w"); pr(a...) = (println(stdout,a...); println(fout,a...))
    bar="═"^80; dsh="─"^80
    pr(bar)
    pr("  kolmogorov_dissipation_hard_test.jl — does the HARD layer touch C_K or C_ε?")
    pr("  (frame-independent invariants only; measured values NOT anchored on)")
    pr("  Scope: empirical + exact 4/5 + realizability + Doering–Foias. NOT the PDE. :proved=0.")
    pr(bar)

    # ════ PANEL A — the Kolmogorov constant C_K:  E(k)=C_K ε^{2/3} k^{−(1+ζ_2)} ════
    pr("\n  PANEL A — KOLMOGOROV CONSTANT C_K  (the inertial-range spectral AMPLITUDE)")
    pr(dsh)
    pr("  Split C_K's setting into SLOPE and AMPLITUDE:")
    pr("  • SLOPE −(1+ζ_2): the hard layer BRACKETS the 2nd-order exponent ζ_2.")
    n = length(PGRID)
    k41 = from_slopes(fill(1/3, n-1))                                  # linear ζ_p=p/3
    frontload = from_slopes([PGRID[i] < 2.0 - 1e-9 ? 1/2 : 0.0 for i in 1:n-1])  # fast then flat
    z2_lo = zp(k41,2.0); z2_hi = zp(frontload,2.0)
    pr(@sprintf("      K41 extremal:        admissible=%s  ζ_2=%.4f  ⇒ slope %.3f",
        admissible(k41), z2_lo, -(1+z2_lo)))
    pr(@sprintf("      front-loaded extremal: admissible=%s  ζ_2=%.4f  ⇒ slope %.3f",
        admissible(frontload), z2_hi, -(1+z2_hi)))
    # bracket proof: concavity-above-chord ⇒ ζ_2 ≥ (2/3)·ζ_3 = 2/3 ; monotone ⇒ ζ_2 ≤ ζ_3 = 1
    z2min, z2max = Inf, -Inf
    for seed in 1:8000
        rng = MersenneTwister(seed); ζ = from_slopes(sort(rand(rng,n-1),rev=true))
        admissible(ζ) || continue; v=zp(ζ,2.0); z2min=min(z2min,v); z2max=max(z2max,v)
    end
    pr(@sprintf("      random admissible search: ζ_2 ∈ [%.3f, %.3f] ⊂ [2/3, 1]  (8000 spectra)",z2min,z2max))
    pr("      ⇒ ζ_2 ∈ [2/3, 1] (concavity floor 2/3 = K41; monotone ceiling 1), TIGHT. So the")
    pr("        spectral SLOPE is structurally bracketed in [−2, −5/3]; measured ζ_2≈0.70 ⇒ −1.70,")
    pr("        sitting just off the K41 floor. THE SLOPE IS TOUCHED.")
    pr("  • AMPLITUDE C_K: NOT touched. The only exact law is the 4/5 law — a THIRD-order relation")
    pr("    (it pins the ζ_3 amplitude to exactly −4/5). There is NO exact law at second order, and")
    pr("    realizability bounds EXPONENTS, not amplitudes. C_K>0 is the only structural fact; its")
    pr("    value (≈1.6) is PURELY FRAME-DEPENDENT — like μ, but worse: μ has a [0,1] bracket, C_K")
    pr("    has no nontrivial structural bound at all.")

    # ════ PANEL B — the dissipation anomaly C_ε = εL/u'³ ("zeroth law") ════
    pr("\n  PANEL B — DISSIPATION ANOMALY C_ε = εL/u'³  (the 'zeroth law' coefficient)")
    pr(dsh)
    pr("  Three tiers — and C_ε is the MOST-touched of the three constants:")
    pr("  • C_ε ≥ 0:  trivial (ε = ν⟨|∇u|²⟩ ≥ 0). Structural but vacuous.")
    pr("  • C_ε < ∞:  RIGOROUS — Doering–Foias–Constantin upper bound from the NS energy balance")
    pr("    + Poincaré:  C_ε ≤ c_1/Re + c_2,  so as Re→∞, C_ε ≤ c_2 < ∞. A genuine theorem-level")
    pr("    structural touch (the FORM is frame-independent; the constant c_2 is forcing-geometry-")
    pr("    dependent). This is the one turbulence 'constant' NS bounds rigorously.")
    pr("  • C_ε > 0:  EMPIRICAL (the zeroth law) — NOT proven. It is exactly the statement that the")
    pr("    cascade is real (ε survives ν→0), equivalently that the 4/5 law's RHS (−⅘εr) is nonzero.")
    pr("    Tied to Onsager (NS-009); proving it = proving anomalous dissipation occurs (open).")
    pr("  ⇒ C_ε is bracketed (0, c_2]: upper end RIGOROUS (energy balance), lower end EMPIRICAL")
    pr("    (zeroth law), value ≈0.4–0.5 frame-dependent. PARTIALLY touched — more than C_K or μ.")

    # ════ PANEL C — the ranking and the principle ════
    pr("\n  PANEL C — THE RANKING  (how much the hard layer touches each constant)")
    pr(dsh)
    pr(@sprintf("    %-22s %-30s %s","constant","what the hard layer gives","kind"))
    pr(@sprintf("    %-22s %-30s %s","C_ε (dissipation)","rigorous UPPER bound (Doering–Foias)","NS energy-balance inequality"))
    pr(@sprintf("    %-22s %-30s %s","ζ_2, μ (exponents)","realizability BRACKETS [2/3,1],[0,1]","monotone+concave+ζ_3=1"))
    pr(@sprintf("    %-22s %-30s %s","C_K (amplitude)","only C_K>0 — no bound","PURELY frame-dependent"))
    pr("\n  THE PRINCIPLE (the discriminating finding):")
    pr("    NS's rigorous reach extends to (i) the THIRD-order exponent EXACTLY (the 4/5 law),")
    pr("    (ii) the lower-order EXPONENTS by realizability brackets, and (iii) the DISSIPATION RATE")
    pr("    by the energy-balance inequality — but NOT to spectral AMPLITUDES. 'Touchability' tracks")
    pr("    whether a constant appears in a rigorous NS relation. Exponents and the dissipation rate")
    pr("    do; the Kolmogorov amplitude C_K does not.")
    pr("\n"*bar); pr("  ANSWER")
    pr(bar)
    pr("  • C_K: PURELY frame-dependent (the worst case) — no exact law (4/5 is 3rd-order), no")
    pr("    realizability bound on an amplitude; only C_K>0. The SLOPE it sits on (ζ_2∈[2/3,1]) is")
    pr("    structurally bracketed; the AMPLITUDE is not.")
    pr("  • C_ε: PARTIALLY touched — a RIGOROUS finite upper bound (Doering–Foias, from the energy")
    pr("    balance); positivity is the empirical zeroth law; value frame-dependent. The most-")
    pr("    touched of {C_K, μ, C_ε}, because it is the one that sits inside a rigorous NS inequality.")
    pr("  • So the constants stratify: dissipation RATE > exponents > spectral AMPLITUDE. The hard")
    pr("    layer reaches exactly as far as NS's exact laws + realizability + energy balance do.")
    pr("    Measured C_K≈1.6, C_ε≈0.5 entered only here, as a convergence note. Scope: empirical;")
    pr("    :proved=0.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
