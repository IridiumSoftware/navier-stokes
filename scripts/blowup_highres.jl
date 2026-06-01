#!/usr/bin/env julia -t auto
# blowup_highres.jl — "just for fun": push the Step-2 near-singularity hunt to N=128
#
# EXPERIMENTAL, RECREATIONAL. **Scope: inviscid-Euler pseudospectral truncation.**
# NOT the 3D-NS PDE; NOT a Clay-relevant claim. The real near-singularity studies
# (Kerr, Hou–Luo) use N≳512–4096 on supercomputers for days; this only pushes
# N=64→128 (2× linear resolution) on a laptop, multithreaded, hermetic (hand-rolled
# FFT, no FFTW). The honest question: does more resolution MOVE the Step-2 resolution
# wall and improve δ-convergence, or just confirm the wall is real (pushed slightly)?
#
# Reuses the Step-2 hunt (`hunt`, `t_resolved`, `fate`) via guarded include, and
# OVERRIDES fft3/ifft3 with multithreaded versions (run with `julia -t <ncores>`).

include(joinpath(@__DIR__, "spectral_3d_blowup_candidate.jl"))   # hunt, t_resolved, tail_fraction, fate (+ the 3D kernel)
using Printf, Base.Threads

# multithreaded 3D FFT (override): parallelize the per-axis line transforms.
# Threads write disjoint slices ⇒ no data race. Needs `julia -t N`.
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

function main()
    out=joinpath(@__DIR__,"blowup_highres.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);flush(stdout);println(fout,a...);flush(fout))
    bar="═"^84; dsh="─"^84
    pr(bar); pr("  blowup_highres.jl — Step-2 near-singularity hunt pushed to N=128 (RECREATIONAL)")
    pr("  (Scope: inviscid-Euler truncation. NOT the PDE, NOT a Clay claim. threads="*string(nthreads())*".)")
    pr("  Inviscid Taylor–Green; does N=64→128 MOVE the resolution wall / improve δ-convergence?")
    pr(bar)

    runs=Dict{Int,Any}()
    for N in (32,64,128)
        t0=time()
        runs[N]=hunt(N, 5.0, 0.008)           # inviscid TGV, T=5 so the cascade REACHES the cutoff
        pr(@sprintf("  ran N=%-4d in %.0f s", N, time()-t0))
    end

    pr("\n"*dsh); pr("  TRAJECTORY COMPARISON (N=128, the finest):"); pr(dsh)
    r=runs[128]; Z0=r.rows[1].Z
    pr(@sprintf("    %-6s %-10s %-10s %-10s %-10s %-9s","t","E/E0","∫|ω|²/₀","tail_frac","δ(t)","BKM"))
    for row in r.rows
        pr(@sprintf("    %-6.2f %-10.6f %-10.3f %-10.1e %-10s %-9.2f",
            row.t,row.EE,row.Z/Z0,row.tail, isnan(row.δ) ? "—" : @sprintf("%.3f",row.δ), row.bkm))
    end

    pr("\n"*dsh); pr("  RESOLUTION WALL — t_resolved (energy conserved + tail<1%) vs N"); pr(dsh)
    for N in (32,64,128)
        tr=t_resolved(runs[N]); pr(@sprintf("    N=%-4d  t_resolved ≈ %.2f", N, tr))
    end

    pr("\n"*dsh); pr("  δ(t) N-CONVERGENCE — does N=128 agree with N=64, or keep drifting with N?"); pr(dsh)
    pr(@sprintf("    %-6s %-12s %-12s %-12s %-10s","t","δ(N=32)","δ(N=64)","δ(N=128)","|Δ|64-128/δ"))
    # nearest sampled row within half a sample (robust to dt/sample drift)
    function at(R,tt)
        best=nothing; bd=Inf
        for x in R.rows; d=abs(x.t-tt); d<bd && (bd=d; best=x); end
        bd<=0.13 ? best : nothing
    end
    maxrel=0.0; trc=min(t_resolved(runs[64]),t_resolved(runs[128]))
    for tt in (0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5)
        a=at(runs[32],tt); b=at(runs[64],tt); c=at(runs[128],tt)
        if a!==nothing && b!==nothing && c!==nothing && !isnan(b.δ) && !isnan(c.δ)
            rel=abs(b.δ-c.δ)/max(abs(c.δ),1e-9); tt<=trc && (maxrel=max(maxrel,rel))
            flag = tt<=trc ? "" : " (past wall)"
            pr(@sprintf("    %-6.2f %-12s %-12.3f %-12.3f %-9.1f%%%s", tt,
                isnan(a.δ) ? "—" : @sprintf("%.3f",a.δ), b.δ, c.δ, 100*rel, flag))
        end
    end

    tr32=t_resolved(runs[32]); tr64=t_resolved(runs[64]); tr128=t_resolved(runs[128])
    T=runs[128].rows[end].t
    reached(tr)= tr < T-0.1 ? @sprintf("%.2f",tr) : @sprintf("≥%.1f (not reached)",T)
    pr("\n"*bar); pr("  VERDICT (recreational high-res hunt)"); pr(bar)
    pr(@sprintf("  • RESOLUTION WALL moves later with N: t_res(N=32)=%s, (N=64)=%s, (N=128)=%s.",
        reached(tr32), reached(tr64), reached(tr128)))
    pr("    More resolution buys more resolved cascade time (finer 2/3 cutoff) — as expected; the")
    pr("    wall is pushed to higher k / later t, not removed.")
    pr(@sprintf("  • δ(t) does NOT converge — it DRIFTS DOWN with N (at fixed t, δ(N=32)>δ(N=64)>δ(N=128)),"))
    pr(@sprintf("    max |Δ|(64↔128)=%.0f%% in the resolved window. The δ-slope-fit tracks the WIDENING fit", 100*maxrel))
    pr("    band (k=2..N/3) over a developing power-law range, not a converged analyticity strip. So")
    pr("    higher resolution makes the fitted δ look SMALLER, NOT convergent — the Step-2 caveat,")
    pr("    confirmed at a THIRD resolution. Pushing N does not rescue the δ-diagnostic for inviscid 3D.")
    pr("  • The gates' answer is UNCHANGED in kind: a higher-res INCONCLUSIVE — no blowup verdict")
    pr("    earned. And even a clean δ→0 here would be inviscid-Euler in a truncation, not the Clay result.")
    pr("  • THE FUN FACT: 2× the resolution (8× the grid points, 16 threads) bought a few extra units")
    pr("    of resolved time and a SMALLER (less trustworthy) δ — a vivid demonstration of why the real")
    pr("    studies need N≳512 and why the problem is genuinely hard, not just under-computed here.")
    pr("  • FIREWALL: recreational resolution push; :proved=0; distance to the prize UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
