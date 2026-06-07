#!/usr/bin/env julia
# ns013_phase_production_3d.jl — NS-013: does reality's PHASE structure gate the 3D production?
#
# WHY. The 1D real-vs-complex probe (ns013_realcomplex_production.jl) found the production object
# `∫g³≡0` on the complex-blowup class (one-sided / analytic-signal spectrum) by Fourier support, and
# reality (the two-sided conjugate-symmetric spectrum) ACTIVATES it. The honest non-transfer note: the 3D
# production `∫ω·Sω` is NOT a single one-sided cubic, so "identically zero" does not transfer — what
# transfers is the QUESTION: does reality's spectral/phase structure gate the 3D production? This probe
# answers it directly.
#
# THE TEST (phase-scrambled surrogate, the faithful 3D analog). `P=∫ω·Sω = ∫ω_iS_{ij}ω_j` is a CUBIC
# (triadic) functional of û — its value is the k=0 mode of a cubic field, a sum over triads `k₁+k₂+k₃=0`
# that, in a real field, close through the conjugate-phase structure `û(−k)=conj û(k)`. Build a surrogate
# that multiplies each mode by a random phase `e^{iφ(k)}` with `φ(−k)=−φ(k)` (so the field stays REAL) and
# `φ=0` on self-conjugate modes:
#   • preserves |û(k)| per component ⇒ the FULL spectrum E(k), and hence E, enstrophy Z, AND helicity H,
#     are EXACTLY preserved (helicity too: ω̂=ik×û picks up the same e^{iφ}, so û·conj(ω̂) per k is
#     invariant) — all the QUADRATIC invariants are untouched;
#   • preserves div-free (a per-k phase preserves k·û=0);
#   • DESTROYS the cubic/triadic phase coherence (the coherent-structure / odd-moment content).
# A partial sweep `φ→α·φ` interpolates coherent (α=0) → fully scrambled (α=1). If `P` (and the skewness
# `S_ω`) COLLAPSE toward 0 as α→1 while E,Z,H stay pinned, the production is carried by the phase
# coherence (reality's structure), not the amplitude spectrum — the 3D shadow of the 1D result (one-
# sidedness being one specific way to kill the production-supporting phase structure).
#
# HONEST SCOPE. Resolved-ish 3D pseudospectral DNS truncation. NOT the PDE; within-truncation witness
# (a phase surrogate is a diagnostic of WHERE the production lives in the field, not an analytic step).
# `:proved`=0; prize UNTOUCHED. Reuses the validated dns_tg256 solver chain. CHAIN_CONVENTION: n/a.
# Run: julia -t auto scripts/ns013_phase_production_3d.jl   (SMOKE=1 for the N=16 invariant-gate first)
# Env: NS_N(64) NS_TDEV(4.0) NS_DT(0.01) NS_NU(1/1600) NS_NSEED(5)

using Printf, Random, Statistics
include(joinpath(@__DIR__, "dns_tg256.jl"))   # → solver + field_diag + diagnose + ICs + fft3/ifft3

# Random-phase surrogate: û → e^{iα·φ(k)} û, φ(−k)=−φ(k), φ=0 on self-conjugate modes. Preserves the
# full amplitude spectrum (⇒ E,Z,H), div-free; α scales the phase perturbation (0=identity, 1=full).
function phase_scramble(U, op, seed; α=1.0)
    N=size(U[1],1); Random.seed!(seed)
    φ=zeros(N,N,N)
    cidx(a)= a==1 ? 1 : N+2-a
    li(a,b,c)= a + (b-1)*N + (c-1)*N*N
    @inbounds for c in 1:N, b in 1:N, a in 1:N
        ac,bc,cc = cidx(a),cidx(b),cidx(c)
        (ac==a && bc==b && cc==c) && continue        # self-conjugate (k=0, Nyquist) ⇒ φ=0 (stay real)
        if li(a,b,c) < li(ac,bc,cc)                   # assign once per conjugate pair
            θ = α*(2π*rand()-π); φ[a,b,c]=θ; φ[ac,bc,cc]=-θ
        end
    end
    ph=exp.(im.*φ)
    (U[1].*ph, U[2].*ph, U[3].*ph)
end

# (E,Z,H,P,Sw,c2int) on a state
function measure(U, op, N)
    d=diagnose(U,op,N); fd=field_diag(U,op)
    (E=d.E, Z=d.Z, H=d.H, divmax=d.divmax, P=mean3(fd.Pd), Sw=fd.Sw, c2int=fd.cos2int)
end

# ── N=1 invariant-preservation gate ──────────────────────────────────────────
function smoke()
    println("── SMOKE (N=16): phase-surrogate invariant gate ──")
    N=16; op=make_ops(N); U=random_helical_ic(N,op)   # H≠0 ⇒ helicity-preservation is a real check
    for _ in 1:5; U=rk4(U,0.01,1/1600,op); end          # develop some structure
    m0=measure(U,op,N); Us=phase_scramble(U,op,12345; α=1.0); ms=measure(Us,op,N)
    @printf("  coherent : E=%.6f Z=%.6f H=%+.6f P=%+.4e Sw=%+.4f\n", m0.E,m0.Z,m0.H,m0.P,m0.Sw)
    @printf("  scrambled: E=%.6f Z=%.6f H=%+.6f P=%+.4e Sw=%+.4f\n", ms.E,ms.Z,ms.H,ms.P,ms.Sw)
    okE=abs(ms.E-m0.E)/abs(m0.E)<1e-8; okZ=abs(ms.Z-m0.Z)/abs(m0.Z)<1e-8
    okH=abs(ms.H-m0.H)/max(abs(m0.H),1e-12)<1e-6; okdiv=ms.divmax<1e-9
    okP=abs(ms.P-m0.P)>1e-12*max(abs(m0.P),1e-12)      # production DID change (surrogate does something)
    @printf("  E preserved %s  Z preserved %s  H preserved %s  div-free %s  P changed %s\n",
            okE ? "✓" : "✗", okZ ? "✓" : "✗", okH ? "✓" : "✗", okdiv ? "✓" : "✗", okP ? "✓" : "✗")
    println(okE&&okZ&&okH&&okdiv&&okP ? "  SMOKE PASS ✓" : "  SMOKE FAIL ✗")
end

# partial-scramble sweep on a developed field, averaged over seeds
function sweep(label, U, op, N, pr; nseed=5, αs=(0.0,0.25,0.5,0.75,1.0))
    m0=measure(U,op,N)
    pr(@sprintf("# %s — developed field: E=%.5f Z=%.5f H=%+.4e P0=%+.4e Sw0=%+.4f c2int=%.4f",
                label, m0.E,m0.Z,m0.H,m0.P,m0.Sw,m0.c2int))
    pr("#  alpha  P/P0(mean±std)     Sw(mean±std)       c2int(mean)  |dE|/E   |dZ|/Z   |dH|")
    for α in αs
        Ps=Float64[]; Sws=Float64[]; c2s=Float64[]; dEs=Float64[]; dZs=Float64[]; dHs=Float64[]
        for s in 1:nseed
            Us = α==0.0 ? U : phase_scramble(U,op,1000+s; α=α)
            m=measure(Us,op,N)
            push!(Ps, m.P/m0.P); push!(Sws, m.Sw); push!(c2s, m.c2int)
            push!(dEs, abs(m.E-m0.E)/abs(m0.E)); push!(dZs, abs(m.Z-m0.Z)/abs(m0.Z)); push!(dHs, abs(m.H-m0.H))
            α==0.0 && break                           # α=0 is deterministic (identity)
        end
        pr(@sprintf("  %5.2f  %+7.3f ± %.3f   %+7.4f ± %.4f   %7.4f     %.1e  %.1e  %.1e",
                    α, mean(Ps), std(Ps;corrected=false), mean(Sws), std(Sws;corrected=false),
                    mean(c2s), mean(dEs), mean(dZs), mean(dHs)))
    end
    (P0=m0.P, Sw0=m0.Sw)
end

function main()
    if get(ENV,"SMOKE","")=="1"; smoke(); return; end
    N=parse(Int,get(ENV,"NS_N","64")); Tdev=parse(Float64,get(ENV,"NS_TDEV","4.0"))
    dt=parse(Float64,get(ENV,"NS_DT","0.01")); ν=parse(Float64,get(ENV,"NS_NU",string(1/1600)))
    nseed=parse(Int,get(ENV,"NS_NSEED","5")); op=make_ops(N)
    out=joinpath(@__DIR__,"ns013_phase_production_3d$(N==64 ? "" : "_N$(N)").out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout);flush(stdout))
    pr("# NS-013 phase-surrogate probe — does reality's PHASE coherence gate the 3D production ∫ω·Sω?")
    pr("# Surrogate preserves |û(k)| (⇒ E,Z,H exact) + div-free; α scrambles the cubic/triadic phase.")
    pr(@sprintf("# N=%d  Re=%.0f  Tdev=%.1f  dt=%.3f  nseed=%d  threads=%d  Scope: DNS truncation; NOT the PDE; :proved=0.",
                N, 1/ν, Tdev, dt, nseed, Threads.nthreads()))
    # develop each flow to Tdev, then sweep the phase scramble
    for (lbl, U0) in (("TG (H=0)", taylor_green_ic(N,op)), ("HELICAL (H≠0)", random_helical_ic(N,op)))
        U=U0; t=0.0; while t<Tdev-1e-9; U=rk4(U,dt,ν,op); t+=dt; end
        pr(""); sweep("$lbl @ t=$(round(Tdev,digits=1))", U, op, N, pr; nseed=nseed)
    end
    pr("")
    pr("# READ: if P/P0 → ~0 and Sw → ~0 as α→1 while |dE|/E,|dZ|/Z,|dH| stay ~machine, the production is")
    pr("# carried by the PHASE coherence (reality's conjugate/triadic structure), not the amplitude")
    pr("# spectrum — the 3D shadow of the 1D `one-sided ⇒ ∫g³=0` result. Within-truncation; :proved=0.")
    pr("# DONE")
    close(fout); println(stdout,"wrote: $out")
end

if abspath(PROGRAM_FILE)==@__FILE__; main(); end
