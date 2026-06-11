#!/usr/bin/env julia
# ns048_c0_boundary_transfer.jl
#
# (C0) BOUNDARY-TRANSFER FEASIBILITY TEST — the falsifiable gate the triad prescribed
# (docs/ns048_adaptive_solver_triad_verdict.md) before committing to option (C):
# reusing the NS-050 two-scale dynamic-rescaling estimator on the Hou–Luo WALL fixture.
#
# THE QUESTION (synthesis seat C2): does the two-scale estimator β = d lnℓ/d ln(1/A),
# ℓ = ‖f‖∞/‖∂f‖∞, A = ‖f‖∞ — validated on INTERIOR self-similar collapse (CLM/HL) —
# RECOVER a KNOWN exponent when the collapse is PINNED TO A FIXED WALL, within tolerance?
# And does a competing FIXED length-scale (a non-collapsing wall feature) contaminate it?
#
# Synthetic, no PDE solve. f(s,r) = A(s)·Φ(d(r)/λ(s)) with A=1/s, λ=s^c (TRUE β=c),
# Φ(ξ)=ξ·e^{−ξ²} pinned at the boundary (Φ(0)=0). Three scenarios:
#   (1) INTERIOR  : d=r−r0 — re-confirms the estimator (baseline).
#   (2) WALL      : d=R−r, structure concentrates AT the wall r=R — the transfer question.
#   (3) WALL+FIXED: wall collapse + a FIXED-width non-collapsing bump — the contamination stress.
# PASS = β recovered to within ~5% of c (wall ≈ interior). -- STABLE; stdlib only.

using Printf, Statistics

const C_TRUE = 2.0          # the known self-similar exponent to recover
const R = 1.0
const SVALS = [0.40,0.30,0.22,0.16,0.12,0.09,0.065,0.05]   # s=(T−t)→0 ; A=1/s, λ=s^c

Φ(ξ) = ξ*exp(-ξ^2)          # pinned profile: Φ(0)=0, peak at ξ=1/√2

function two_scale_beta(fieldfn, svals, rg, dr; sub=1:length(svals))
    A=Float64[]; ℓ=Float64[]
    for s in svals
        f = fieldfn(s, rg)
        Amax = maximum(abs.(f))
        df = similar(f)
        @inbounds for i in 2:length(f)-1; df[i]=(f[i+1]-f[i-1])/(2dr); end
        df[1]=df[2]; df[end]=df[end-1]
        push!(A, Amax); push!(ℓ, Amax/maximum(abs.(df)))
    end
    x = (-log.(A))[sub]; y = (log.(ℓ))[sub]        # β = slope of lnℓ vs ln(1/A)
    n=length(x); β = (n*sum(x.*y)-sum(x)*sum(y))/(n*sum(x.^2)-sum(x)^2)
    β, A, ℓ
end

function main()
    out="scripts/ns048_c0_boundary_transfer.out.txt"; fo=open(out,"w"); pr(a...)=(println(stdout,a...);println(fo,a...))
    pr("="^74); pr("  (C0) boundary-transfer feasibility — does NS-050's two-scale β survive a FIXED WALL?")
    pr(@sprintf("  true exponent c = %.2f ; estimator β = d lnℓ/d ln(1/A), ℓ=‖f‖∞/‖∂f‖∞", C_TRUE)); pr("="^74)
    N=8000; rg=collect(range(0.0, R, length=N)); dr=rg[2]-rg[1]
    λ(s)=s^C_TRUE; Amp(s)=1.0/s

    f_interior(s,r) = Amp(s) .* Φ.((r .- 0.5) ./ λ(s))
    f_wall(s,r)     = Amp(s) .* Φ.((R .- r) ./ λ(s))
    f_wallfix(s,r)  = f_wall(s,r) .+ 2.0 .* exp.(-((R .- r) ./ 0.05).^2)   # fixed-width non-collapsing bump

    βi,_,_ = two_scale_beta(f_interior, SVALS, rg, dr)
    βw,Aw,ℓw = two_scale_beta(f_wall, SVALS, rg, dr)
    deep = 4:length(SVALS)                                   # small-s: collapse dominates the fixed scale
    βf_all,_,_ = two_scale_beta(f_wallfix, SVALS, rg, dr)
    βf_deep,_,_ = two_scale_beta(f_wallfix, SVALS, rg, dr; sub=deep)

    pr(@sprintf("\n  (1) INTERIOR (baseline, re-confirm estimator) : β = %.3f   (true %.2f, err %.1f%%)", βi, C_TRUE, 100abs(βi-C_TRUE)/C_TRUE))
    pr(@sprintf("  (2) WALL-PINNED (the transfer question)        : β = %.3f   (true %.2f, err %.1f%%)", βw, C_TRUE, 100abs(βw-C_TRUE)/C_TRUE))
    pr(@sprintf("  (3) WALL + FIXED feature, all-s               : β = %.3f   (true %.2f, err %.1f%%)", βf_all, C_TRUE, 100abs(βf_all-C_TRUE)/C_TRUE))
    pr(@sprintf("      WALL + FIXED, deep-collapse subset (s≤%.3f): β = %.3f   (true %.2f, err %.1f%%)", SVALS[deep[1]], βf_deep, C_TRUE, 100abs(βf_deep-C_TRUE)/C_TRUE))
    pr("\n  per-s wall diagnostics (A=‖f‖∞ grows, ℓ=‖f‖/‖∂f‖ should ∝ λ=s^c):")
    pr("    s        A          ℓ          ℓ/s^c (should be ~const)")
    for (k,s) in enumerate(SVALS); pr(@sprintf("   %.3f  %9.2f  %9.5f   %.4f", s, Aw[k], ℓw[k], ℓw[k]/s^C_TRUE)); end

    tol=0.05
    wall_ok = abs(βw-C_TRUE)/C_TRUE < tol
    interior_ok = abs(βi-C_TRUE)/C_TRUE < tol
    deep_ok = abs(βf_deep-C_TRUE)/C_TRUE < 2tol
    pr("\n"*"="^74); pr("  (C0) VERDICT"); pr("="^74)
    pr(@sprintf("  interior estimator recovers c : %s", interior_ok ? "YES" : "NO"))
    pr(@sprintf("  WALL-PINNED recovers c        : %s  ⇒ the fixed wall %s break the two-scale estimator",
        wall_ok ? "YES" : "NO", wall_ok ? "does NOT" : "DOES"))
    pr(@sprintf("  robust to a competing FIXED scale (deep collapse) : %s", deep_ok ? "YES (collapse dominates)" : "NO (fixed scale contaminates)"))
    if wall_ok && interior_ok
        pr("\n  ⇒ (C) is ESTIMATOR-LICENSED: NS-050's two-scale β transfers to wall-pinned self-similar")
        pr("    collapse. The boundary is an anchor, not a contaminant (synthesis seat was right vs Grok's")
        pr("    'likely invalid'). REMAINING gate (C0b, data-sufficiency): can the real wall DNS's RESOLVED")
        pr("    phase supply a clean self-similar window before it goes unresolved? — a separate check.")
    else
        pr("\n  ⇒ (C) FAILS the transfer gate: bank (B). The fixed wall corrupts the estimator; the cheap")
        pr("    reuse path is not available without a boundary-adapted reformulation.")
    end
    pr(@sprintf("  Note (3): a competing FIXED scale %s — so on the REAL DNS, β is trustworthy ONLY where the",
        deep_ok ? "is overcome once collapse dominates (A≫fixed)" : "fools the fit"))
    pr("  collapse amplitude dominates fixed scales (domain/IC/viscous) — a checkable condition. :proved=0.")
    pr("="^74); close(fo); println(stdout,"\nwrote: $out")
    (wall_ok && interior_ok)
end

main()
