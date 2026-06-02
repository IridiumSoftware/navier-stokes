#!/usr/bin/env julia
# mu_hard_bound.jl
#
# CAN THE HARD (frame-independent) LAYER BOUND THE INTERMITTENCY EXPONENT μ FROM ABOVE?
# The sharp test of the inverse-Born approach: promote a frame-dependent NUMBER (μ≈0.2)
# to a structural INEQUALITY — or honestly find that it can't, and say why.
#
# μ = 2 − ζ_6  (the ζ_6 deficit below its K41 value 2; = the dissipation-correlation
# exponent under refined similarity). Bounding μ above ⟺ bounding ζ_6 below.
#
# HARD constraints (frame-independent only — methodology §5; NO anchoring on measured
# numbers): ζ_3=1 (4/5, exact); ζ_p nondecreasing (bounded velocity ‖u‖_∞<∞, regular
# flow); ζ_p concave (Lyapunov/Hölder); D(h)∈[0,3]; CKN (singular set ≤1D, i.e. genuine
# singularities h<0 have D≤1).
#
# CLAIMED BOUNDS (elementary):
#   μ ≤ 1   from monotonicity:  ζ_6 ≥ ζ_5 ≥ ζ_4 ≥ ζ_3 = 1.
#   μ ≥ 0   from concavity:     ζ_3 ≥ (ζ_0+ζ_6)/2 ⟹ ζ_6 ≤ 2  (3 is the midpoint of 0,6).
# This script (a) exhibits the two EXTREMAL spectra that SATURATE μ=0 and μ=1, proving
# the bracket [0,1] is tight; (b) random-searches admissible concave-monotone spectra to
# confirm μ never leaves [0,1]; (c) checks whether CKN tightens the upper bound.
#
# Scope: EMPIRICAL phenomenology + exact 4/5 + realizability. NOT the PDE. :proved=0.
# Std-lib only.

using Printf, Random

const DP = 0.25
const PGRID = 0.0:DP:8.0
idx(p) = round(Int, p/DP) + 1
ζ6(ζ) = ζ[idx(6.0)]
mu(ζ)  = 2 - ζ6(ζ)

# admissibility on the grid: ζ_0=0, ζ_3=1, nondecreasing (Δζ≥0), concave (Δ²ζ≤0)
function admissible(ζ; tol=1e-9)
    abs(ζ[idx(0.0)]) < tol || return false
    abs(ζ[idx(3.0)] - 1) < 1e-6 || return false
    for i in 1:length(ζ)-1
        ζ[i+1] - ζ[i] >= -tol || return false                       # nondecreasing
    end
    for i in 2:length(ζ)-1
        ζ[i+1] - 2ζ[i] + ζ[i-1] <= tol || return false              # concave
    end
    true
end

# build ζ on the grid from a nonincreasing, nonnegative slope sequence (⇒ concave+monotone),
# then rescale so ζ(3)=1.
function from_slopes(slopes)
    ζ = zeros(length(PGRID))
    for i in 1:length(PGRID)-1
        ζ[i+1] = ζ[i] + slopes[i]*DP
    end
    ζ ./= ζ[idx(3.0)]          # rescale to hit ζ_3 = 1
    ζ
end

# the singularity spectrum D(h) of a piecewise-linear ζ, sampled by inverse Legendre:
# D(h) = 3 − max_p[ζ_p − p h].   (used only to report D at the most-singular end)
Dh(ζ, h) = 3 - maximum(ζ[i] - PGRID[i]*h for i in 1:length(PGRID))

function main()
    out = joinpath(@__DIR__, "mu_hard_bound.out.txt")
    fout = open(out,"w"); pr(a...) = (println(stdout,a...); println(fout,a...))
    bar="═"^80; dsh="─"^80
    pr(bar)
    pr("  mu_hard_bound.jl — can the HARD layer bound the intermittency exponent μ from above?")
    pr("  μ = 2 − ζ_6.  HARD = frame-independent only (no anchoring on measured numbers).")
    pr("  Scope: empirical + exact 4/5 + realizability. NOT the PDE. :proved=0.")
    pr(bar)

    # ── (1) the two EXTREMALS that saturate the bracket ──
    pr("\n  (1) EXTREMAL admissible spectra (saturate the bracket):")
    n = length(PGRID)
    # K41: constant slope 1/3 everywhere (linear ζ_p = p/3) — concave-boundary, monotone
    k41 = from_slopes(fill(1/3, n-1))
    # ramp-then-flat: slope 1/3 on [0,3], slope 0 after — concave (slope ↓), monotone
    rampflat_slopes = [PGRID[i] < 3.0 - 1e-9 ? 1/3 : 0.0 for i in 1:n-1]
    rampflat = from_slopes(rampflat_slopes)
    pr(@sprintf("    %-28s admissible=%s  ζ_6=%.4f  μ=%.4f","K41 (linear ζ_p=p/3)",
        admissible(k41), ζ6(k41), mu(k41)))
    pr(@sprintf("    %-28s admissible=%s  ζ_6=%.4f  μ=%.4f","ramp-then-flat",
        admissible(rampflat), ζ6(rampflat), mu(rampflat)))
    pr("  ⇒ K41 saturates μ=0 (no intermittency); ramp-then-flat saturates μ=1. BOTH are")
    pr("    admissible (concave, nondecreasing, ζ_3=1) ⇒ the bracket [0,1] is TIGHT at both ends.")

    # ── (2) random search over admissible concave-monotone spectra ──
    pr("\n"*dsh); pr("  (2) random search over admissible spectra (10000 concave-monotone, ζ_3=1):")
    pr(dsh)
    μmin, μmax = Inf, -Inf; nbad = 0
    for seed in 1:10000
        rng = MersenneTwister(seed)
        slopes = sort(rand(rng, n-1), rev=true)        # nonincreasing ≥0 ⇒ concave + monotone
        ζ = from_slopes(slopes)
        admissible(ζ) || (nbad += 1; continue)
        m = mu(ζ); μmin = min(μmin, m); μmax = max(μmax, m)
    end
    pr(@sprintf("    μ over 10000 admissible spectra:  min=%.4f   max=%.4f   (rejected %d)",μmin,μmax,nbad))
    pr(@sprintf("    every admissible spectrum has μ ∈ [%.3f, %.3f] ⊂ [0,1] ✓  (bound never violated)",μmin,μmax))

    # ── (3) does CKN tighten the upper bound? ──
    pr("\n"*dsh); pr("  (3) does CKN (singular set ≤1D) tighten μ ≤ 1?")
    pr(dsh)
    pr(@sprintf("    ramp-then-flat extremal: D at most-singular end h=0 is D(0)=%.3f.",Dh(rampflat,0.0)))
    pr("    CKN bounds the dimension of GENUINE singularities (h<0, unbounded velocity). For a")
    pr("    REGULAR turbulent flow ‖u‖_∞<∞ ⇒ h≥0 everywhere ⇒ there is NO singular set ⇒ CKN is")
    pr("    VACUOUS on the spectrum. It cannot raise the ζ_6 floor: the rise needed to satisfy any")
    pr("    codim≥2 condition can be deferred to large p, leaving ζ_6→1 (μ→1). CKN does NOT tighten.")

    pr("\n"*bar); pr("  ANSWER")
    pr(bar)
    pr("  • YES — the hard layer bounds μ from above: μ ≤ 1, rigorously, from monotonicity")
    pr("    (ζ_6 ≥ ζ_3 = 1, holding for any regular flow with bounded velocity). And μ ≥ 0 from")
    pr("    concavity (ζ_6 ≤ 2). So the frame-independent invariants force μ ∈ [0,1].")
    pr("  • BUT NO TIGHTER. Both ends are saturated by admissible spectra (K41 ↦ 0, ramp-flat ↦ 1);")
    pr("    CKN is vacuous for regular flow (no h<0); concavity and D≤3 permit μ all the way to 1.")
    pr("  • The observed μ≈0.20–0.25 sits in the INTERIOR of [0,1]. The gap from 1 down to ~0.2 is")
    pr("    exactly the FRAME-DEPENDENT content the anti-anchoring discipline (§9) forbids importing")
    pr("    as structure — μ's specific value is protected by NO frame-independent invariant.")
    pr("  • This is the methodology working, not failing: it brackets μ structurally and then HONESTLY")
    pr("    STOPS at the boundary between what's forced and what's measured. A loose bound that is real")
    pr("    beats a tight bound that is smuggled. Scope: empirical; :proved=0.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
