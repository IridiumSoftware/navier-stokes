#!/usr/bin/env julia
# step2_gate.jl — the NS-010 Stage 1c-3D STEP 2 gate (TEST_SPEC T-06 + T-08), applied to a
# GPU inviscid blowup-candidate run. This script does NOT run any flow; it reads the trajectory
# files produced by metal/dns_gpu.swift + scripts/load_gpu_snapshot.jl and renders the GATED
# verdict. The whole design is built around NOT producing a false positive — the honest default
# is INCONCLUSIVE/NULL. :proved=0; Scope: 3D pseudospectral truncation (inviscid Euler limit),
# NOT the 3D-NS PDE.
#
# THE GATE (a reported δ→0 is evidence of approach-to-singularity ONLY if ALL hold; T-06+T-08):
#   G1 RESOLVED   — energy still conserved (inviscid: E/E0≈1). δ is meaningless past the
#                   resolution wall (where E leaks = the cascade has hit the 2/3 grid cutoff).
#   G2 CONVERGED  — the δ(t) curve agrees across resolution (N=256 vs N=512) in the resolved
#                   window. The δ-slope-fit is window-sensitive (TEST_SPEC caveat); non-
#                   convergence ⇒ the decline is a fit/resolution artifact, not physics.
#   G3 CO-MOVING  — δ→0 co-diverges with BKM ∫‖ω‖∞→∞ at the SAME finite t* (NS-004).
#   FORM          — the discriminator: δ/(−δ̇). Constant ⇒ exponential δ~e^{−t/τ} ⇒ t*=∞ ⇒
#                   REGULAR. Linearly decreasing to zero at finite t* ⇒ finite-time candidate.
#   (T-08 CKN dimension guard is applied separately from the peak-time box-dimension load.)
#
# Usage: julia step2_gate.jl <label> <scalar256.txt> <delta256.dat> <scalar512.txt> <delta512.dat>
#   scalar*.txt : a dns_gpu NS_OUT log (rows "  t  E/E0=..  Z/Z0=..  winf=..").
#   delta*.dat  : two columns "t  δ" (from the NS_DELTAONLY=1 loader; one row per snapshot).
using Printf, Statistics

# --- parsers -------------------------------------------------------------------------------
function parse_scalar(path)
    t=Float64[]; erel=Float64[]; zrel=Float64[]; winf=Float64[]; N=0
    for ln in eachline(path)
        mn = match(r"N=([0-9]+)", ln); (mn!==nothing && N==0) && (N=parse(Int,mn[1]))
        m = match(r"^\s*([0-9.]+)\s+E/E0=([0-9.eE+-]+)\s+Z/Z0=([0-9.eE+-]+)\s+H=\S+\s+winf=([0-9.eE+-]+)", ln)
        m === nothing && continue
        push!(t,parse(Float64,m[1])); push!(erel,parse(Float64,m[2]))
        push!(zrel,parse(Float64,m[3])); push!(winf,parse(Float64,m[4]))
    end
    (t=t, erel=erel, zrel=zrel, winf=winf, N=N)
end
function read_delta(path)
    ts=Float64[]; ds=Float64[]
    for ln in eachline(path)
        startswith(strip(ln),"#") && continue
        sp=split(strip(ln)); length(sp)<2 && continue
        push!(ts,parse(Float64,sp[1])); push!(ds,parse(Float64,sp[2]))
    end
    (t=ts, δ=ds)
end

# --- analysis primitives -------------------------------------------------------------------
# resolution wall: first time E leaks by > tol (inviscid Euler conserves E until the cascade
# reaches the 2/3 grid cutoff). Everything past t_res is UNDER-RESOLVED ⇒ G1 fails there.
function t_resolved(sc; tol=1e-4)
    for i in eachindex(sc.t); abs(sc.erel[i]-1) > tol && return sc.t[i]; end
    return sc.t[end] + 1   # never leaked in this window ⇒ fully resolved here
end
# trapezoidal BKM integral ∫‖ω‖∞ dt
function bkm(sc)
    b=zeros(length(sc.t)); for i in 2:length(sc.t)
        b[i]=b[i-1]+0.5*(sc.winf[i]+sc.winf[i-1])*(sc.t[i]-sc.t[i-1]); end; b
end
# linear regression y~a+b·x → (slope, intercept, R²)
function linreg(x,y)
    xm=mean(x); ym=mean(y); sxx=sum((x.-xm).^2); sxy=sum((x.-xm).*(y.-ym))
    b=sxy/sxx; a=ym-b*xm; yh=a.+b.*x; ss=sum((y.-yh).^2); st=sum((y.-ym).^2)
    (slope=b, intercept=a, r2=(st>0 ? 1-ss/st : NaN))
end
# FORM discriminator on a decaying positive series q(t): g = q/(−q̇) via centered differences.
# g≈const ⇒ exponential decay (t*=∞). g linear-decreasing ⇒ finite-time zero at t* = −intercept/slope.
function finite_time(t,q)
    g=Float64[]; tg=Float64[]
    for i in 2:length(t)-1
        dq=(q[i+1]-q[i-1])/(t[i+1]-t[i-1]); dq>=0 && continue   # only while decreasing
        push!(g, q[i]/(-dq)); push!(tg, t[i])
    end
    length(g)<3 && return (tstar=NaN, slope=NaN, r2=NaN, gmean=length(g)>0 ? mean(g) : NaN, tg=tg, g=g)
    lr=linreg(tg,g); tstar = lr.slope<0 ? -lr.intercept/lr.slope : Inf
    (tstar=tstar, slope=lr.slope, r2=lr.r2, gmean=mean(g), tg=tg, g=g)
end

# --- main ----------------------------------------------------------------------------------
function gate(label, sc256, dl256, sc512, dl512)
    s2=parse_scalar(sc256); s5=parse_scalar(sc512); d2=read_delta(dl256); d5=read_delta(dl512)
    kcut2 = s2.N ÷ 3; kcut5 = s5.N ÷ 3
    # δ·k_cut > thresh ⇒ analyticity strip wider than the grid scale ⇒ RESOLVED (project standard
    # ≈6–7; the LEADING indicator). Energy-leak is the LAGGING one (E barely moves until the tail
    # is already substantial). Use the stricter (earlier) wall for the verdict.
    dkthresh = 6.0
    dkwall(d,kcut) = (g=[d.t[i] for i in eachindex(d.t) if d.δ[i]*kcut > dkthresh]; isempty(g) ? 0.0 : maximum(g))
    trE2=t_resolved(s2); trE5=t_resolved(s5)            # energy-leak walls (lagging)
    trD2=dkwall(d2,kcut2); trD5=dkwall(d5,kcut5)        # δ·k_cut walls (leading, conservative)
    tr = min(trD2, trD5)                                 # conservative common resolved window
    @printf("\n================ STEP-2 GATE — %s ================\n", label)
    @printf("Scope: inviscid 3D pseudospectral Euler truncation; NOT the PDE. :proved=0. Default verdict NULL.\n\n")
    @printf("G1 RESOLVED (resolution wall; δ·k_cut>%.0f = strip wider than grid, the leading test):\n", dkthresh)
    @printf("  N=%d (k_cut=%d): δ·k_cut wall t=%.2f   energy-leak wall t=%.2f\n", s2.N, kcut2, trD2, trE2)
    @printf("  N=%d (k_cut=%d): δ·k_cut wall t=%.2f   energy-leak wall t=%.2f\n", s5.N, kcut5, trD5, trE5)
    @printf("  ⇒ conservative common resolved window for the verdict: t ≤ %.2f\n", tr)
    @printf("  (past the wall the spectral tail has hit the 2/3 cutoff ⇒ δ there is a truncation artifact.)\n\n")

    # restrict δ series to the resolved window
    sel(d)= [i for i in eachindex(d.t) if d.t[i] < tr + 1e-9]
    i2=sel(d2); i5=sel(d5)
    @printf("δ(t) in the resolved window (analyticity-strip width):\n")
    @printf("   t      δ(N=256)   δ(N=512)   |Δ|/δ\n")
    for tt in sort(intersect(round.(d2.t[i2],digits=3), round.(d5.t[i5],digits=3)))
        k2=findfirst(x->isapprox(x,tt;atol=1e-3), d2.t); k5=findfirst(x->isapprox(x,tt;atol=1e-3), d5.t)
        (k2===nothing||k5===nothing) && continue
        rel=abs(d5.δ[k5]-d2.δ[k2])/d2.δ[k2]
        @printf("  %.2f    %.4f     %.4f     %.1f%%\n", tt, d2.δ[k2], d5.δ[k5], 100rel)
    end

    # G2 CONVERGED: max relative δ-difference over the common resolved times
    common = [tt for tt in d2.t[i2] if any(x->isapprox(x,tt;atol=1e-3), d5.t[i5])]
    reldiffs=Float64[]
    for tt in common
        k2=findfirst(x->isapprox(x,tt;atol=1e-3), d2.t); k5=findfirst(x->isapprox(x,tt;atol=1e-3), d5.t)
        push!(reldiffs, abs(d5.δ[k5]-d2.δ[k2])/d2.δ[k2])
    end
    g2max = isempty(reldiffs) ? NaN : maximum(reldiffs)
    conv = g2max < 0.15
    @printf("\nG2 CONVERGED: max |δ_512−δ_256|/δ_256 over the resolved window = %.1f%%  ⇒ %s\n",
            100g2max, conv ? "CONVERGED (<15%)" : "NOT CONVERGED (≥15% ⇒ δ-decline is resolution-sensitive)")

    # FORM + G3: finite-time extraction on δ (toward 0) and on 1/winf (BKM proxy), N=512, resolved window
    ft_d = finite_time(d5.t[i5], d5.δ[i5])
    iw = [i for i in eachindex(s5.t) if s5.t[i] < tr + 1e-9 && s5.winf[i] > 0]
    ft_w = finite_time(s5.t[iw], 1.0 ./ s5.winf[iw])   # 1/winf → 0 at finite t* ⇔ BKM blowup
    @printf("\nFORM discriminator (N=512, resolved window) — δ/(−δ̇) constant ⇒ exponential (t*=∞, REGULAR):\n")
    @printf("  δ:      g=δ/(−δ̇)  slope=%.4f (r²=%.2f) ⇒ t*(δ→0)   = %s\n",
            ft_d.slope, ft_d.r2, isfinite(ft_d.tstar) ? @sprintf("%.2f", ft_d.tstar) : "∞ (exponential)")
    @printf("  1/winf: slope=%.4f (r²=%.2f) ⇒ t*(BKM→∞) = %s\n",
            ft_w.slope, ft_w.r2, isfinite(ft_w.tstar) ? @sprintf("%.2f", ft_w.tstar) : "∞")
    comoving = isfinite(ft_d.tstar) && isfinite(ft_w.tstar) && abs(ft_d.tstar-ft_w.tstar) < 1.0
    @printf("\nG3 CO-MOVING: δ→0 and BKM→∞ at the SAME finite t*?  ⇒ %s\n",
            comoving ? @sprintf("co-moving near t*≈%.2f", 0.5*(ft_d.tstar+ft_w.tstar)) :
                       "NO common finite t* (δ and/or BKM extrapolate to t*=∞ within the resolved window)")

    # verdict — default NULL; only a finite t* INSIDE the resolved window, N-converged, and co-moving survives.
    fintime_inside = isfinite(ft_d.tstar) && ft_d.tstar < tr
    verdict = (fintime_inside && conv && comoving) ?
        "BLOWUP-CANDIDATE (finite t* inside resolved window, N-converged, co-moving) — ESCALATE to T-08 box-dim + scrutiny" :
        (!conv ? "INCONCLUSIVE — δ-decline not N-converged (resolution-sensitive)" :
         (!fintime_inside ? "REGULAR-LEANING / NULL — δ declines but extrapolates to t*=∞ (exponential) within the resolved window; no finite-time δ→0" :
          "INCONCLUSIVE — finite-time signal not co-moving with BKM"))
    @printf("\n>>> GATE VERDICT (%s): %s\n", label, verdict)
    @printf("    (T-08 CKN dimension guard — box-dim ≤1 AND N-stable at the peak — applied separately; required before any non-NULL reading.)\n")
    @printf("====================================================================\n")
end

# CLI
if abspath(PROGRAM_FILE) == @__FILE__
    length(ARGS) < 5 && error("usage: julia step2_gate.jl <label> <scalar256> <delta256> <scalar512> <delta512>")
    gate(ARGS[1], ARGS[2], ARGS[3], ARGS[4], ARGS[5])
end
