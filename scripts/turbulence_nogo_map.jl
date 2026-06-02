#!/usr/bin/env julia
# turbulence_nogo_map.jl
#
# A no-go / possible / probable map of turbulence's MEASURED constants, on two
# coupled manifolds — the inverse-Born (possibilistic) complement to the obstruction
# ledger. We spent the program mapping NECESSITY (the walls: what is impossible).
# This maps the other two modes on the natural manifolds of the *physical* phenomenon:
#   necessity (□)  = the no-go walls (forced)
#   possibility (◇) = what the walls do NOT exclude (the admissible envelope)
#   probability     = what turbulence ACTUALLY does (the measured spectrum / constants)
#
# The inverse-Born is LITERAL here (not analogy): the multifractal formalism
# (Parisi–Frisch) is a large-deviation/Born structure —
#   moments  S_p(r)=⟨δu_r^p⟩ ~ r^{ζ_p},   ζ_p = inf_h[ p h + 3 − D(h) ]   (saddle point)
# so the measured exponents ζ_p (the "probabilities") are the Legendre transform of the
# singularity spectrum D(h) (the "possibility structure" = log-possibility of exponent h,
# = the large-deviation rate function = |amplitude|² in the WKB/stationary-phase sense).
# INVERSE-BORN = inverse Legendre:  D(h) = 3 − max_p[ ζ_p − p h ]  — recover the possibility
# structure from the observed moments. The no-go theorems then become CONSTRAINTS on the
# admissible D(h): the no-go map of the (h, D) manifold.
#
# Scope: EMPIRICAL / phenomenology of turbulence, + the one EXACT law (4/5) + the no-go
# constraints. NOT the 3D-NS PDE existence/smoothness problem (prize focus deliberately
# dropped for this map). Tags below: [EXACT] / [MEASURED] / [MODEL]. Std-lib only.

using Printf

# ── She–Lévêque structure-function exponents (the parameter-free MODEL) ──────────
# ζ(p) = p/9 + 2[1 − (2/3)^{p/3}].  Built so ζ(3)=1 (matches the 4/5 law EXACTLY).
sl_zeta(p) = p/9 + 2*(1 - (2/3)^(p/3))
# h(p)=ζ'(p):  d/dp (2/3)^{p/3} = (2/3)^{p/3}·(1/3)ln(2/3)
sl_h(p)    = 1/9 - (2/3)*log(2/3)*(2/3)^(p/3)          # = 1/9 + (2/3)|ln(2/3)|(2/3)^{p/3}
# parametric singularity spectrum: D(h(p)) = 3 − ζ(p) + p·h(p)   (Legendre duality)
sl_D(p)    = 3 - sl_zeta(p) + p*sl_h(p)

# ── MEASURED exponents (consensus: Anselmet 1984 / She–Lévêque review), ±~0.03 ──
const P_MEAS = [1,2,3,4,5,6,7,8]
const Z_MEAS = [0.37, 0.70, 1.00, 1.28, 1.53, 1.77, 2.01, 2.23]   # ζ_3=1 [EXACT]; rest [MEASURED]

# discrete inverse-Legendre from the measured moments: D(h)=3 − max_p[ζ_p − p h]
function D_from_measured(h)
    3 - maximum(Z_MEAS[i] - P_MEAS[i]*h for i in eachindex(P_MEAS))
end

# ── small ASCII renderer for the (h,D) curve with the no-go walls ────────────────
function ascii_spectrum(ps)
    hmin, hmax = 0.10, 0.40; Dmin, Dmax = 0.0, 3.0
    W, H = 46, 16
    grid = fill(' ', H, W)
    col(h) = clamp(1 + round(Int, (h-hmin)/(hmax-hmin)*(W-1)), 1, W)
    row(D) = clamp(H - round(Int, (D-Dmin)/(Dmax-Dmin)*(H-1)), 1, H)
    for c in 1:W; grid[row(3.0), c] = '─'; end          # D≤3 ceiling (forced)
    for c in 1:W; grid[row(1.0), c] = '·'; end          # CKN edge D=1 (forced)
    for p in ps
        h = sl_h(p); (hmin<=h<=hmax) && (grid[row(sl_D(p)), col(h)] = '*')
    end
    grid[row(3.0),   col(sl_h(0.0))] = 'P'              # peak (most probable)
    grid[row(sl_D(1.45)), col(1/3)]  = 'K'              # K41 / Onsager pivot (h=1/3)
    grid[row(1.0),   col(1/9)]       = 'C'              # CKN filament edge
    lines = String[]
    for r in 1:H
        Dval = Dmax - (r-1)/(H-1)*(Dmax-Dmin)
        push!(lines, @sprintf("  D=%.1f │%s", Dval, String(grid[r,:])))
    end
    push!(lines, "        └" * "─"^W)
    push!(lines, @sprintf("         h=%.2f%shp=%.2f%sh=%.2f", hmin, " "^16, (hmin+hmax)/2, " "^15, hmax))
    join(lines, "\n")
end

function main()
    out = joinpath(@__DIR__, "turbulence_nogo_map.out.txt")
    fout = open(out,"w"); pr(a...) = (println(stdout,a...); println(fout,a...))
    bar="═"^80; dsh="─"^80
    pr(bar)
    pr("  turbulence_nogo_map.jl — the inverse-Born / possibilistic map of turbulence's constants")
    pr("  necessity (no-go walls) ▸ possibility (admissible envelope) ▸ probability (measured)")
    pr("  Scope: EMPIRICAL phenomenology + the EXACT 4/5 law + the no-go constraints. NOT the PDE.")
    pr(bar)

    # ════ PANEL 1 — the inertial (h, D) singularity-spectrum manifold (HIT) ════
    pr("\n  PANEL 1 — INERTIAL MANIFOLD  (h = local scaling exponent, D(h) = its set-dimension)")
    pr(dsh)
    pr("  Forward (Born): ζ_p = inf_h[ p h + 3 − D(h) ].   Inverse-Born: D(h)=3−max_p[ζ_p−p h].")
    pr(@sprintf("\n    %-4s %-12s %-12s %-10s","p","ζ_p measured","ζ_p She-Lév","tag"))
    for i in eachindex(P_MEAS)
        p=P_MEAS[i]
        tag = p==3 ? "[EXACT 4/5]" : "[MEASURED]"
        pr(@sprintf("    %-4d %-12.3f %-12.3f %-10s", p, Z_MEAS[i], sl_zeta(float(p)), tag))
    end
    pr("    (She–Lévêque [MODEL] is parameter-free and reproduces ζ_3=1 by construction.)")

    pr("\n  Inverse-Born → the singularity spectrum D(h)  [the recovered possibility structure]:")
    pr(@sprintf("    %-22s %-9s %-9s %-9s","landmark","h","D(h)","meaning"))
    pr(@sprintf("    %-22s %-9.3f %-9.3f %s","peak (most PROBABLE)", sl_h(0.0), sl_D(0.0), "D=3: space-filling bulk"))
    # K41/Onsager pivot: h=1/3 ⟺ p≈1.45 on SL
    pK = 1.45
    pr(@sprintf("    %-22s %-9.3f %-9.3f %s","K41 / Onsager pivot", sl_h(pK), sl_D(pK), "ζ_3=1, h=1/3 ⟺ σ=0"))
    pr(@sprintf("    %-22s %-9.3f %-9.3f %s","CKN filament edge", sl_h(1e3), sl_D(1e3), "D→1: most-singular ≤1D"))
    pr(@sprintf("    measured inverse-Legendre check:  D(h=1/3)=%.3f   D(h=0.30)=%.3f   D(h=0.20)=%.3f",
        D_from_measured(1/3), D_from_measured(0.30), D_from_measured(0.20)))

    pr("\n  THE NO-GO MAP of the (h,D) manifold  (* = She–Lévêque spectrum):")
    pr("    ─ = D≤3 ceiling [EXACT];  · = CKN edge D=1 [EXACT no-go];  P peak  K K41/Onsager  C CKN")
    pr(ascii_spectrum(0.0:0.1:40.0))   # dense + long p-range so the curve runs down to the CKN edge
    pr("\n  ⇒ FORCED  (□): D≤3 ceiling; concavity/realizability; ζ_3=1 (4/5 law) pins the slope-3")
    pr("     tangent; CKN ⇒ the most-singular end cannot lift above D=1 (≤1D filaments).")
    pr("  ⇒ POSSIBLE (◇): any concave D(h)≤3 touching the ζ_3=1 tangent with low-h endpoint ≤1.")
    pr("  ⇒ PROBABLE   : the measured spectrum — peak D=3 at h≈0.38, mean h=1/3, and it RUNS DOWN")
    pr("     TO the CKN wall (D=1 at h=1/9). The data SATURATE the CKN no-go at the singular end.")
    pr("     [consistency, not identity: SL's most-intense structures are 1D filaments; CKN bounds")
    pr("      a hypothetical SINGULAR set ≤1D — same geometry, different objects. Flagged honestly.]")

    # ════ PANEL 2 — the σ-ladder overlay (contact with NS-036) ════
    pr("\n  PANEL 2 — σ-LADDER OVERLAY  (the local h-manifold meets the global criticality ladder)")
    pr(dsh)
    pr("    h is LOCAL (Hölder/Besov, increments); σ is GLOBAL (Sobolev norms, NS-036). They meet")
    pr("    at ONE rigorous point — the regularity threshold — and orient the two sides:")
    pr(@sprintf("      %-16s %-14s %-22s","h region","σ-ladder","role"))
    pr(@sprintf("      %-16s %-14s %-22s","h > 1/3 (smooth)","σ < 0","energy side — CONTROLLED (supercritical bound)"))
    pr(@sprintf("      %-16s %-14s %-22s","h = 1/3 (pivot)","σ = 0","CRITICAL: 4/5 law ⟺ Onsager ⟺ Ḣ^{1/2}/L³"))
    pr(@sprintf("      %-16s %-14s %-22s","h < 1/3 (rough)","σ > 0","enstrophy side — stretching, the singular structures live here"))
    pr("  ⇒ the intermittent / CKN-edge structures (h<1/3) sit on the SAME side of criticality as")
    pr("    the uncontrolled enstrophy rung (NS-036). The local spectrum and the global ladder agree")
    pr("    on WHERE the difficulty is — at and below h=1/3 / σ=0. (Pivot rigorous; sides qualitative.)")

    # ════ PANEL 3 — the wall-bounded manifold (Re, y⁺): a DIFFERENT structure ════
    pr("\n  PANEL 3 — WALL-BOUNDED MANIFOLD  (Re, y⁺) — onset + log-overlap, NOT multifractal")
    pr(dsh)
    pr("    Two possibilistic boundaries, both Reynolds-keyed:")
    pr("    (i) ONSET Re_c  [MEASURED]:")
    pr(@sprintf("        pipe Re_c≈%d (Avila 2011);  plane Couette Re_c≈%d.", 2040, 325))
    pr("        Re < Re_c ⇒ turbulence FORBIDDEN (laminar forced, □);  Re > Re_c ⇒ POSSIBLE (◇),")
    pr("        subcritical — survives with a finite lifetime (the NS-021 memoryless τ(Re)).")
    pr("    (ii) LOG LAW  U⁺ = (1/κ)ln(y⁺)+B,  κ≈0.41, B≈5.0  [MEASURED, ~universal]:")
    pr("        FORCED form by the inner/outer overlap (Millikan matching) — but the overlap WINDOW")
    pr("        only OPENS as Re→∞ (η ≪ log layer ≪ δ). So κ is the PROBABLE constant; the log")
    pr("        window is the POSSIBLE region; it is EMPTY (forbidden) at low Re.")
    pr("  ⇒ FORCED: laminar below Re_c; the log FORM given an overlap. POSSIBLE: turbulent above")
    pr("    Re_c; the log window opening with Re. PROBABLE: κ≈0.41, and the inertial (h,D) spectrum")
    pr("    of PANEL 1 is what lives INSIDE this window once it is open. The two manifolds couple")
    pr("    through Re: PANEL 3 says WHEN/WHERE turbulence exists; PANEL 1 says WHAT it looks like.")

    # ════ the dissipation anomaly — the hinge between the panels ════
    pr("\n  HINGE — the dissipation anomaly (the 'zeroth law'):  C_ε = εL/u'³ → ≈0.5 as Re→∞")
    pr("    [MEASURED, ν-INDEPENDENT]. This is the empirical face of Onsager (NS-009): ε stays")
    pr("    finite as ν→0 ⇒ the spectrum must reach h=1/3 (the 4/5 law) ⇒ PANEL 1 has a singular")
    pr("    end at all. It is WHY the (h,D) manifold extends below h=1/3 — the probable, measured")
    pr("    reason the no-go walls are APPROACHED rather than sitting idle.")

    pr("\n"*bar); pr("  THE MAP, IN ONE LINE PER MODE")
    pr(bar)
    pr("  □ NECESSITY (no-go, forced):  D≤3; concavity; ζ_3=1 [4/5, EXACT]; CKN ⇒ singular end ≤1D;")
    pr("    laminar below Re_c; log FORM by overlap. (= the obstruction ledger, on these manifolds.)")
    pr("  ◇ POSSIBILITY (admissible):   concave D(h)≤3 through the 4/5 tangent, low-h endpoint ≤1;")
    pr("    turbulence above Re_c; the log/inertial window opening as Re→∞.")
    pr("  ▸ PROBABILITY (measured):     D(h) peak 3 @ h≈0.38, mean h=1/3, RUNNING DOWN TO the CKN")
    pr("    wall (D=1 @ h=1/9); C_K≈1.6, ζ_p anomalous, μ≈0.2, C_ε≈0.5, κ≈0.41. The attractor")
    pr("    SITS AGAINST the CKN no-go and is ANCHORED by the exact 4/5 law at h=1/3 / σ=0.")
    pr("  Inverse-Born delivered: from the measured moments we recovered D(h) (the possibility")
    pr("  structure) and located it inside the forced envelope. Scope: empirical; :proved=0;")
    pr("  the PRIZE is untouched and was deliberately not the target here.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
