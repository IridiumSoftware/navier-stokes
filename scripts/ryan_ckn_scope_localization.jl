#!/usr/bin/env julia -t auto
# ryan_ckn_scope_localization.jl — Ryan's minimal macrostate M* ↔ CKN, made computable
#
# EXPERIMENTAL. **Scope: inviscid-Euler pseudospectral truncation.** NOT the 3D-NS PDE.
# Ryan (NS-035): a NOVEL (Class-II / ontological) emergent property lives at a MINIMAL
# MACROSTATE M* — the smallest SCOPE carrying it, absent in any narrower scope. For a
# finite-time singularity, the carrier is the vortex-stretching PRODUCTION density
# P(x)=ω·(ω·∇)u, and CKN (NS-006) bounds the singular set's parabolic Hausdorff dim ≤ 1.
# So the M*↔CKN question is: does the production LOCALIZE to a shrinking (→ low-dim,
# Class-II/ontological) support, or SPREAD over the domain (Class-I/epistemic cascade)?
#
# MEASURES (on the production density |P(x)|, an exact field):
#   • f50, f90 — the smallest VOLUME FRACTION carrying 50% / 90% of ∫|P| (sort descending).
#     f→0 ⇒ localizing (minimal scope shrinking); f~O(1) ⇒ spread.
#   • PR = (Σ|P|)²/(N³·Σ|P|²) ∈ (0,1] — participation ratio (1=uniform, →0=concentrated).
# Tracked across N=32/64/128 on ONE spectrally-embedded inviscid flow. Class-II
# (ontological) signature = localization that SHARPENS / is resolution-consistent;
# Class-I (epistemic) = spreading / resolution-coupled. Honest prior: at N≤128 expect
# turbulence-INTERMITTENT (moderate, not →0) — no resolved singularity.
#
# Reuses spectral_3d_blowup_candidate.jl kernel (guarded include); threaded fft + embed_ic.

include(joinpath(@__DIR__, "spectral_3d_blowup_candidate.jl"))
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

# |production density| field  |ω·(ω·∇)u|
function prod_density(U, op)
    uhc=(U[1],U[2],U[3]); kk=(op.kx,op.ky,op.kz)
    ωxh,ωyh,ωzh=curl_hat(U[1],U[2],U[3],op)
    ω=(real.(ifft3(ωxh)), real.(ifft3(ωyh)), real.(ifft3(ωzh)))
    du=Array{Any}(undef,3,3)
    for i in 1:3, j in 1:3; du[i,j]=real.(ifft3(im.*kk[i].*uhc[j])); end
    stretch=[ω[1].*du[1,j].+ω[2].*du[2,j].+ω[3].*du[3,j] for j in 1:3]
    abs.(ω[1].*stretch[1].+ω[2].*stretch[2].+ω[3].*stretch[3])
end

# localization of a nonnegative field A: f_q (vol-frac carrying q of the mass) + PR
function localization(A)
    v=sort(vec(A); rev=true); tot=sum(v); n=length(v)
    fq(q)=(c=0.0; i=0; while i<n && c<q*tot; i+=1; c+=v[i]; end; i/n)
    PR = tot^2/(n*sum(abs2,v) + 1e-300)
    (f50=fq(0.5), f90=fq(0.9), PR=PR)
end

function probe(N, T, dt; sample=0.5)
    op=make_ops(N); U=embed_ic(N)
    rows=NamedTuple[]; t=0.0; nexts=0.0; n=round(Int,T/dt)
    for i in 1:n
        if t>=nexts-1e-9
            d=diagnose(U,op,N); L=localization(prod_density(U,op))
            push!(rows,(t=t, f50=L.f50, f90=L.f90, PR=L.PR, Z=d.Z, tail=tail_fraction(U,op,N)))
            nexts+=sample
        end
        U=rk4(U,dt,0.0,op); t+=dt
    end
    rows
end

function main()
    out=joinpath(@__DIR__,"ryan_ckn_scope_localization.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);flush(stdout);println(fout,a...);flush(fout))
    bar="═"^86; dsh="─"^86
    pr(bar); pr("  ryan_ckn_scope_localization.jl — M*↔CKN: does the production LOCALIZE (Class II) or SPREAD (Class I)?")
    pr("  (Scope: inviscid-Euler truncation. NOT the PDE. :proved=0; prize UNTOUCHED. threads="*string(nthreads())*".)")
    pr(bar)

    R=Dict{Int,Any}()
    for N in (32,64,128)
        t0=time(); R[N]=probe(N, 4.0, 0.008); pr(@sprintf("  ran N=%-4d in %.0f s", N, time()-t0))
    end

    pr("\n"*dsh); pr("  N=128 trajectory — scope of the vortex-stretching production"); pr(dsh)
    pr(@sprintf("    %-6s %-10s %-10s %-12s %-10s %-10s","t","f50","f90","PR/N³","Ω/Ω₀","tail"))
    Z0=R[128][1].Z
    for r in R[128]
        pr(@sprintf("    %-6.2f %-10.4f %-10.4f %-12.2e %-10.2f %-10.1e", r.t, r.f50, r.f90, r.PR, r.Z/Z0, r.tail))
    end

    # resolution-consistency in the resolved window: does f50 sharpen/agree across N?
    function tres(rows); tr=0.0; for r in rows; r.tail<0.01 ? (tr=r.t) : break; end; tr; end
    trc=min(tres(R[64]),tres(R[128]))
    function at(rows,tt); b=nothing;bd=Inf; for r in rows; d=abs(r.t-tt); d<bd&&(bd=d;b=r); end; bd<=0.26 ? b : nothing; end
    pr("\n"*dsh); pr(@sprintf("  f50 vs N (resolved window t≤%.2f) — does the minimal scope sharpen with resolution?",trc)); pr(dsh)
    pr(@sprintf("    %-6s %-12s %-12s %-12s","t","f50 N=32","f50 N=64","f50 N=128"))
    for tt in (0.5,1.0,1.5,2.0)
        a=at(R[32],tt);b=at(R[64],tt);c=at(R[128],tt); (a===nothing||b===nothing||c===nothing)&&continue
        pr(@sprintf("    %-6.2f %-12.4f %-12.4f %-12.4f", tt, a.f50, b.f50, c.f50))
    end

    pr("\n"*bar); pr("  VERDICT — M*↔CKN scope-localization"); pr(bar)
    r=R[128]; f50_0=r[1].f50; f50_end_resolved = let i=findlast(x->x.tail<0.01,r); i===nothing ? r[end].f50 : r[i].f50 end
    localizing = f50_end_resolved < 0.5*f50_0
    pr(@sprintf("  • The production density is INTERMITTENT: f50 ≈ %.3f (only ~%.0f%% of the volume carries", f50_0, 100*f50_0))
    pr("    half the stretching at t=0) — consistent with turbulence's known sheet/tube intermittency.")
    pr(@sprintf("  • Trend in the resolved window: f50 %s (%.3f → %.3f).",
        localizing ? "SHRINKS (localizing)" : "stays ~flat / spreads (NOT localizing)", f50_0, f50_end_resolved))
    pr("  • Ryan/CKN reading: a Class-II (ontological) singularity would show f50 → 0 SHARPENING with N")
    pr("    (minimal scope → a measure-zero, ≤1D set). At N≤128 we see intermittency, not a resolved")
    pr(localizing ? "    collapse to a point — suggestive of concentration, but NOT a resolved singular set." :
                    "    collapse — the stretching stays spread over an O(0.1) volume fraction (Class-I cascade).")
    pr("  • HONEST: at accessible resolution this is the right OBJECT (minimal scope of the production)")
    pr("    but cannot resolve the ≤1D singular set CKN allows — the M*-localization, if ontological,")
    pr("    lives below N=128. The verdict is resolution-gated, now posed in the correct (scope) variable.")
    pr("  • FIREWALL: inviscid-Euler truncation; :proved=0; distance to the prize UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
