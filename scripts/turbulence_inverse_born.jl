#!/usr/bin/env julia
# turbulence_inverse_born.jl
#
# PUSH the inverse-Born further (after turbulence_nogo_map.jl): apply the closure-v5
# inverse-Born obstruction METHODOLOGY (Aaron Green, Apr 2026;
# closure-v5 BUSINESS/inverse_born_methodology.md) to the turbulence cascade.
#
# THE FLIP (methodology §3.2): do NOT ask "what cascade model produces the measured
# ζ_p?" (forward — the curve-fitting trap, §9). Ask: "given the OBSERVED structure,
# what class of cascade mechanisms is CONSISTENT, and what is FORBIDDEN?" Derive the
# cascade by OBSTRUCTION; the power is in what it forbids.
#
# TWO DISCIPLINES IMPORTED FROM THE METHODOLOGY:
#  (1) INVARIANT STRATIFICATION (§5): a constant may be used as a HARD constraint only
#      if it is FRAME-INDEPENDENT (invariant across time/scale/scope/resolution —
#      integers, exact laws, topological/realizability bounds). FRAME-DEPENDENT numbers
#      (C_K, μ, κ — they vary with flow/Re/scheme) are CONVERGENCE TARGETS, never anchors.
#      Match STRUCTURE (integers, hierarchies, the exact 4/5), not numbers.
#  (2) NULL-AS-CLARIFICATION (§3.3): proving a model CANNOT hold is the strongest move;
#      it promotes the phenomenon to a structural (possibilistic) statement.
#
# Scope: EMPIRICAL phenomenology of turbulence + exact 4/5 + realizability no-go's.
# NOT the 3D-NS PDE. :proved=0. Std-lib only.

using Printf

# ── the classified family of cascade / intermittency models (ζ_p formulas) ───────
k41(p)        = p/3                                              # no intermittency (monofractal)
lognormal(p, μ) = p/3 - (μ/18)*p*(p-3)                           # Kolmogorov-Obukhov 1962
beta(p, DF)   = p/3 + (3-DF)*(1 - p/3)                           # β-model (mono/bi-fractal, linear)
shelev(p)     = p/9 + 2*(1 - (2/3)^(p/3))                        # log-Poisson / She–Lévêque

# derivatives (slope = local exponent h(p); realizability needs ζ' ≥ 0 for all p≥0)
dlognormal(p, μ) = 1/3 - (μ/18)*(2p - 3)
dbeta(DF)        = (DF - 2)/3                                    # constant (linear ζ_p)
dshelev(p)       = 1/9 - (2/3)*log(2/3)*(2/3)^(p/3)

function main()
    out = joinpath(@__DIR__, "turbulence_inverse_born.out.txt")
    fout = open(out,"w"); pr(a...) = (println(stdout,a...); println(fout,a...))
    bar="═"^80; dsh="─"^80
    pr(bar)
    pr("  turbulence_inverse_born.jl — derive the cascade by OBSTRUCTION (inverse-Born push)")
    pr("  methodology: closure-v5 BUSINESS/inverse_born_methodology.md (A. Green, Apr 2026)")
    pr("  Scope: EMPIRICAL + exact 4/5 + realizability no-go's. NOT the PDE. :proved=0.")
    pr(bar)

    # ════ PANEL A — INVARIANT STRATIFICATION (the gate on what may be a HARD constraint) ════
    pr("\n  PANEL A — INVARIANT STRATIFICATION  (methodology §5: use a constant as a HARD")
    pr("  constraint only if FRAME-INDEPENDENT across all four dimensions; else it is a")
    pr("  CONVERGENCE TARGET we must NOT anchor on. ✓=invariant, ~=approx/varies, ✗=no.)")
    pr(dsh)
    pr(@sprintf("    %-26s %-5s %-5s %-5s %-5s  %s","invariant","time","scale","scope","res","verdict"))
    rows = [
      ("ζ_3 = 1  (4/5 law)",        "✓","✓","✓","✓","HARD — exact from NS"),
      ("D ≤ 3  (space dim)",         "✓","✓","✓","✓","HARD — definitional"),
      ("ζ_p nondecreasing+concave",  "✓","✓","✓","✓","HARD — realizability"),
      ("CKN: singular set ≤ 1D",     "✓","✓","✓","✓","HARD — theorem (resolution-protected)"),
      ("codim-2 (1D filament int.)", "✓","✓","~","✓","STRUCTURAL integer (model; CKN-consistent)"),
      ("C_K ≈ 1.6",                  "✓","~","~","~","convergence target — DO NOT anchor"),
      ("μ ≈ 0.20–0.25",              "✓","~","~","~","convergence target — DO NOT anchor"),
      ("ζ_p, p≥4 (values)",          "✓","~","~","~","convergence target — DO NOT anchor"),
      ("κ ≈ 0.41,  C_ε ≈ 0.5",       "✓","~","~","~","convergence target — DO NOT anchor"),
    ]
    for (n,t,s,sc,r,v) in rows; pr(@sprintf("    %-26s %-5s %-5s %-5s %-5s  %s",n,t,s,sc,r,v)); end
    pr("  ⇒ the obstruction below uses ONLY the five HARD rows. The numbers are never anchored —")
    pr("    they enter only as a final convergence check among the structurally-surviving models.")

    # ════ PANEL B — FINITE CLASSIFICATION + the obstruction test (HARD constraints only) ════
    pr("\n  PANEL B — OBSTRUCTION over the cascade-model family  (apply ONLY the HARD constraints)")
    pr(dsh)
    pr(@sprintf("    %-18s %-7s %-9s %-7s %-7s %-12s","model","ζ_3=1","ζ' ≥ 0","D≤3","D≥0","verdict"))

    # K41 — monofractal, no intermittency
    pr(@sprintf("    %-18s %-7s %-9s %-7s %-7s %-12s","K41 (monofractal)","yes","yes (=⅓)","yes","yes",
        "ALLOWED (degenerate: D=δ(h−⅓))"))

    # log-normal (K62) — the realizability NULL
    μ = 0.20; pstar = 3/μ + 3/2
    Δh = sqrt(2μ/3)                                  # |h−h₀| beyond which D(h)<0
    pr(@sprintf("    %-18s %-7s %-9s %-7s %-7s %-12s","log-normal (K62)","yes",
        @sprintf("NO (p*≈%.1f)",pstar),"yes","NO","FORBIDDEN"))
    pr(@sprintf("        └ realizability: ζ'_p=⅓−(μ/18)(2p−3) < 0 for p > p*=3/μ+3/2 (=%.1f at μ=%.2f,",pstar,μ))
    pr(@sprintf("          =%.1f at μ=0.25) ⇒ ζ_p turns DOWN (moments shrink) — impossible for bounded",3/0.25+1.5))
    pr(@sprintf("          increments. And D(h)=3−(9/2μ)(h−h₀)² < 0 for |h−h₀|>%.2f (negative dimension).",Δh))
    pr("          TWO independent HARD violations. A clean structural NULL (cf. P2-A/P2-B).")

    # β-model — allowed by hard constraints but monofractal (linear)
    DF = 2.8
    pr(@sprintf("    %-18s %-7s %-9s %-7s %-7s %-12s","β-model (D_F=2.8)","yes",
        @sprintf("yes (=%.2f)",dbeta(DF)),"yes","yes","ALLOWED*"))
    pr("        └ passes every HARD constraint, but ζ_p is LINEAR (monofractal) ⇒ predicts NO")
    pr("          curvature. Not forbidden by structure — disfavored only at the convergence layer")
    pr("          (the measured ζ_p are concave). Honest: a frame-DEPENDENT distinction, flagged *.")

    # She–Lévêque / log-Poisson — the survivor
    hmin = dshelev(1e3); Dtrunc = 3 - shelev(40.0) + 40*dshelev(40.0)   # finite-p (p=40) value
    mono = all(dshelev(p) > 0 for p in 0:0.5:30)
    pr(@sprintf("    %-18s %-7s %-9s %-7s %-7s %-12s","log-Poisson (SL)","yes",
        mono ? "yes (>⅑)" : "NO","yes","yes","SURVIVES"))
    pr(@sprintf("        └ monotone (ζ'≥⅑>0), concave, ζ_3=1, bounded h_min=⅑=%.3f; D(h_min)=1 EXACTLY",hmin))
    pr(@sprintf("          by the codim-2 construction (=%.3f at the p=40 truncation, →1 from above as p→∞)",Dtrunc))
    pr("          ⇒ MEETS the CKN ≤1D edge exactly. Survives because it is built on STRUCTURAL INTEGERS")
    pr("          (codimension-2 = 1-D vortex filaments; the discrete log-Poisson hierarchy), NOT on")
    pr("          fitted numbers — exactly the 'match structure, not numbers' discipline.")

    # ════ PANEL C — the inverse-Born verdict ════
    pr("\n  PANEL C — THE INVERSE-BORN VERDICT")
    pr(dsh)
    pr("  • THE NULL (clarifying): the log-normal cascade is FORBIDDEN — not by data preference but")
    pr("    by two HARD structural constraints (ζ_p non-monotone past p*; negative D(h)). This is a")
    pr("    possibilistic-layer result: realizability alone kills it, at every Re, in every flow.")
    pr("    Phase-promotion (§3.3): 'why not log-normal' moves from 'the data disfavor it' to")
    pr("    'it is structurally impossible.'")
    pr("  • THE SURVIVORS: K41 (degenerate), β (monofractal), and the log-Poisson/multifractal class")
    pr("    all pass the HARD layer. Among them ONLY the convergence layer (the measured concavity +")
    pr("    CKN-saturation) selects log-Poisson — and that selection is explicitly the WEAKER,")
    pr("    frame-dependent layer. We do NOT promote it to structural on the strength of the numbers.")
    pr("  • WHAT IS ACTUALLY FORCED (structure, not numbers): any admissible cascade has ζ_3=1")
    pr("    (the 4/5 tangent), monotone-concave ζ_p, and a most-singular end at D≤1 (CKN). The")
    pr("    surviving multifractal class meets these via the codim-2 filament integer — the same")
    pr("    kind of structural integer ('3 colours', 'codim 2') the closure-v5 programme trusts.")
    pr("  • ANTI-ANCHORING (§9): C_K, μ, κ, C_ε never entered as constraints — only as a final")
    pr("    consistency check among structural survivors. No model was tuned to a number.")
    pr("\n"*bar)
    pr("  ONE LINE: realizability + the 4/5 law + CKN FORBID the log-normal cascade and PIN every")
    pr("  survivor to ζ_3=1 with a ≤1-D singular end — the cascade's structure is obstructed into")
    pr("  shape by the no-go's, with the measured numbers held back as convergence targets only.")
    pr("  Scope: empirical; :proved=0; the prize was not the target.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
