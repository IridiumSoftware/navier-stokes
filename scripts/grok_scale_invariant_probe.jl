#!/usr/bin/env julia -t auto
# grok_scale_invariant_probe.jl — anchoring Grok's Oracle pass (Moves 1+2) to NS
#
# EXPERIMENTAL. **Scope: inviscid-Euler pseudospectral truncation.** NOT the 3D-NS PDE.
# Grok (Oracle seat) conjectured: our δ-diagnostic fails because it is a spectrum-SLOPE
# FIT (not scale-invariant) — the cascade fools it (δ drifts DOWN with resolution, 73%
# across N=64↔128, NS-032). His repair: use a SCALE-INVARIANT (σ=0, critical-quotient)
# diagnostic — "antisymmetry kills the cascade" — that resolution cannot fool.
#
# CONCRETE TEST. On the SAME inviscid flow, at N=32/64/128, compare the resolution-
# robustness of:
#   • δ(t)         — the spectrum-slope fit (σ-undefined; the FAILING diagnostic)
#   • ρ_H(t) = H/(2√(E·Ω))  — RELATIVE HELICITY (σ=0: H~λ⁰ Casimir; √(EΩ)~λ⁰); bounded
#                              [−1,1] by Cauchy–Schwarz; built from the helicity Casimir.
#   • (E·Ω)(t)     — a σ=0 invariant combination (Slice 3: σ_E=−1, σ_Ω=+1 ⇒ σ=0).
# CLAIM UNDER TEST: ρ_H and E·Ω agree across N (resolution-robust) in the resolved
# window, where δ does NOT. (Helical IC, since Taylor–Green has H≡0 ⇒ ρ_H≡0.)
#
# Reuses spectral_3d_blowup_candidate.jl (guarded include → the 3D kernel + tail_fraction);
# overrides fft3/ifft3 with threaded versions (run with `julia -t N`).

include(joinpath(@__DIR__, "spectral_3d_blowup_candidate.jl"))   # diagnose, make_ops, rk4, random_helical_ic, tail_fraction
using Printf, Base.Threads

function fft3(Ar)
    A=ComplexF64.(Ar); N=size(A,1)
    @threads for c in 1:N; for b in 1:N; r=A[:,b,c]; fft!(r); A[:,b,c]=r; end; end
    @threads for c in 1:N; for a in 1:N; r=A[a,:,c]; fft!(r); A[a,:,c]=r; end; end
    @threads for b in 1:N; for a in 1:N; r=A[a,b,:]; fft!(r); A[a,b,:]=r; end; end
    A
end
function ifft3(A)
    B=copy(A); N=size(B,1)
    @threads for c in 1:N; for b in 1:N; r=B[:,b,c]; fft!(r;inv=true); B[:,b,c]=r; end; end
    @threads for c in 1:N; for a in 1:N; r=B[a,:,c]; fft!(r;inv=true); B[a,:,c]=r; end; end
    @threads for b in 1:N; for a in 1:N; r=B[a,b,:]; fft!(r;inv=true); B[a,b,:]=r; end; end
    B
end

# RESOLUTION-CONSISTENT IC: build the helical field once at N0=32 (modes |k|≤3 ⊂ every
# grid), then spectrally EMBED into grid N — the IDENTICAL physical flow, just resolved
# finer. (random_helical_ic draws a DIFFERENT realization per N, which would confound the
# cross-N comparison — this fixes that.) FFT normalization: û_N = (N/N0)³ û_{N0}.
function embed_ic(N; N0=32)
    op0=make_ops(N0); U0=random_helical_ic(N0,op0; kmax=3)
    N==N0 && return U0
    klo(a)= a-1 <= N0÷2 ? a-1 : a-1-N0
    idxN(m)= m>=0 ? m+1 : m+N+1
    s=(N/N0)^3
    out=(zeros(ComplexF64,N,N,N), zeros(ComplexF64,N,N,N), zeros(ComplexF64,N,N,N))
    for a in 1:N0, b in 1:N0, c in 1:N0
        (abs(U0[1][a,b,c])+abs(U0[2][a,b,c])+abs(U0[3][a,b,c])==0) && continue
        ai=idxN(klo(a)); bi=idxN(klo(b)); ci=idxN(klo(c))
        for q in 1:3; out[q][ai,bi,ci]=s*U0[q][a,b,c]; end
    end
    out
end

function probe(N, T, dt; sample=0.25)
    op=make_ops(N); U=embed_ic(N)                # SAME physical flow at every N
    d0=diagnose(U,op,N); EΩ0=d0.E*d0.Z; Z0=d0.Z
    rows=NamedTuple[]; t=0.0; nexts=0.0; n=round(Int,T/dt)
    for i in 1:n
        if t>=nexts-1e-9
            d=diagnose(U,op,N)
            ρH = d.H/(2*sqrt(max(d.E*d.Z,1e-30)))
            push!(rows,(t=t, δ=d.δ, ρH=ρH, EΩ=d.E*d.Z/EΩ0, ZZ=d.Z/Z0, tail=tail_fraction(U,op,N)))
            nexts+=sample
        end
        U=rk4(U,dt,0.0,op); t+=dt
    end
    rows
end

function main()
    out=joinpath(@__DIR__,"grok_scale_invariant_probe.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);flush(stdout);println(fout,a...);flush(fout))
    bar="═"^84; dsh="─"^84
    pr(bar); pr("  grok_scale_invariant_probe.jl — is a σ=0 (scale-invariant) diagnostic resolution-robust")
    pr("  where the δ-slope-fit is NOT?  (Grok Oracle Moves 1+2, anchored. threads="*string(nthreads())*".)")
    pr("  (Scope: inviscid-Euler truncation. NOT the PDE. :proved=0; prize UNTOUCHED.)")
    pr(bar)

    R=Dict{Int,Any}()
    for N in (32,64,128)
        t0=time(); R[N]=probe(N, 5.0, 0.008); pr(@sprintf("  ran N=%-4d in %.0f s", N, time()-t0))
    end

    # resolved window = where tail<1% at BOTH N=64 and N=128
    function tres(rows); tr=0.0; for r in rows; r.tail<0.01 ? (tr=r.t) : break; end; tr; end
    trc=min(tres(R[64]), tres(R[128]))
    pr(@sprintf("\n  resolved window (tail<1%% at N=64 & N=128): t ≤ %.2f", trc))

    pr("\n"*dsh); pr("  RESOLUTION-ROBUSTNESS — |Δ|(N=64 vs N=128)/value, in the resolved window"); pr(dsh)
    function at(rows,tt); best=nothing; bd=Inf; for r in rows; d=abs(r.t-tt); d<bd && (bd=d;best=r); end; bd<=0.13 ? best : nothing; end
    pr(@sprintf("    %-6s %-26s %-26s %-22s","t","δ (fit)  N=64 / 128 / Δ%","ρ_H (σ=0)  N=64 / 128 / Δ%","E·Ω (σ=0) Δ%"))
    dmax=0.0; hmax=0.0; emax=0.0
    for tt in (0.5,1.0,1.5,2.0,2.5,3.0)
        b=at(R[64],tt); c=at(R[128],tt); (b===nothing||c===nothing) && continue
        dδ = (isnan(b.δ)||isnan(c.δ)) ? NaN : 100*abs(b.δ-c.δ)/max(abs(c.δ),1e-9)
        dρ = 100*abs(b.ρH-c.ρH)/max(abs(c.ρH),1e-9)
        dE = 100*abs(b.EΩ-c.EΩ)/max(abs(c.EΩ),1e-9)
        if tt<=trc
            !isnan(dδ) && (dmax=max(dmax,dδ)); hmax=max(hmax,dρ); emax=max(emax,dE)
        end
        pr(@sprintf("    %-6.2f %-26s %-26s %-22s", tt,
            @sprintf("%.3f / %.3f / %.0f%%", b.δ, c.δ, dδ),
            @sprintf("%.3f / %.3f / %.1f%%", b.ρH, c.ρH, dρ),
            @sprintf("%.4f / %.4f / %.1f%%", b.EΩ, c.EΩ, dE)))
    end
    pr(@sprintf("\n  MAX disagreement in resolved window:  δ-fit %.0f%%   ρ_H %.1f%%   E·Ω %.1f%%", dmax,hmax,emax))

    pr("\n"*dsh); pr("  N=128 trajectory — does ρ_H carry a scale-invariant signal? (H,E conserved; Ω grows)"); pr(dsh)
    pr(@sprintf("    %-6s %-10s %-10s %-10s %-10s","t","δ","ρ_H","Ω/Ω₀","tail"))
    for r in R[128]
        pr(@sprintf("    %-6.2f %-10s %-10.4f %-10.3f %-10.1e",
            r.t, isnan(r.δ) ? "—" : @sprintf("%.3f",r.δ), r.ρH, r.ZZ, r.tail))
    end

    pr("\n"*bar); pr("  VERDICT — Grok's σ=0-diagnostic conjecture, anchored & tested"); pr(bar)
    robust = (hmax < 5.0 && emax < 5.0)
    pr(@sprintf("  • In the resolved window, the δ-slope-FIT disagrees %.0f%% across N (the known artifact),", dmax))
    pr(@sprintf("    while the σ=0 invariants ρ_H and E·Ω agree to %.1f%% / %.1f%%.", hmax, emax))
    if robust
        pr("  • CONFIRMED (the anchored part of Grok's Move 1): a SCALE-INVARIANT (σ=0) diagnostic is")
        pr("    RESOLUTION-ROBUST where the spectrum-slope fit is not — because it is an exact integral")
        pr("    of conserved/critical quantities (helicity Casimir + E·Ω), not a fit over the cascade.")
        pr("  • HONEST LIMIT (the un-anchored part): robust ≠ a blowup DETECTOR. ρ_H simply tracks Ω-growth")
        pr("    via its denominator (H,E conserved); it does not 'see' a singularity the way δ→0 was meant to.")
        pr("    A useful σ=0 detector must be BOTH resolution-robust AND singularity-sensitive — ρ_H gives the")
        pr("    first for free, the second is still open. Grok's 'anomaly-class' object would need to supply both.")
    else
        pr("  • NOT confirmed: even the σ=0 invariants drift across N here — the resolution wall bites all diagnostics.")
    end
    pr("  • FIREWALL: inviscid-Euler truncation; :proved=0; distance to the prize UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
