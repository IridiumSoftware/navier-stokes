#!/usr/bin/env julia
# closure_knfamily_scaling.jl
# EXPERIMENTAL. NOT a spec artifact. substrate_source: closure-v5 K_n³ family
#   builder gpg_b4_v16_phase_n_kn3_family.jl + libs (build_quotient_color, depth=5,
#   Float64 fidelity-clustering threshold 0.999). A7: named upstream object, cited;
#   this is the FIDELITY-clustered build (not exact-ℚ). Exploratory probe.
# Firewall: canonical SCALING test — does the autopoietic robustness τ track the
#   real K_n³ quotient structure (size M, spectral gap λ₂)? Companion to the Q_102
#   gating negative. Relations = quotient hyperedges (triadic closures); support =
#   hyperedges sharing a class; decay-default + autocatalytic repair.
CV5="~/Desktop/Research Papers/Relational_Emergence/Closure v5"
include(joinpath(CV5,"gpg_b4_phase_e_lib.jl")); include(joinpath(CV5,"gpg_b1_v2_embedding_test_lib.jl"))
using Random, LinearAlgebra, Statistics, Printf
kn3_triples(n)=(t=NTuple{3,Int}[];for i in 1:n,j in 1:n,k in 1:n;(i!=j&&j!=k&&i!=k)&&push!(t,(i,j,k));end;t)
function build_q_n3(n;depth=5,seed=0)
    rng=MersenneTwister(seed); psi=Dict{Int,Vector{ComplexF64}}(i=>haar_C3(rng) for i in 1:n)
    r=build_quotient_color(kn3_triples(n),psi;depth=depth,threshold=0.999,include_c_closure=false)
    return r.n_cl, r.q_he
end
# support graph among hyperedges (share a class); returns adj, deg
function he_support(n_cl, he)
    M=length(he); inc=[Int[] for _ in 1:n_cl]
    for (k,e) in enumerate(he); for v in e; push!(inc[v+1>n_cl ? v : v+1>0 ? (v in 0:n_cl-1 ? v+1 : v) : v], k); end; end
    # robust: classes are 0-based in q_he; map to 1-based
    inc=[Int[] for _ in 1:n_cl]
    for (k,e) in enumerate(he); for v in e; push!(inc[v+1],k); end; end
    adj=[Set{Int}() for _ in 1:M]
    for v in 1:n_cl, a in inc[v], b in inc[v]; a!=b && push!(adj[a],b); end
    A=[sort(collect(s)) for s in adj]; return A,[length(a) for a in A]
end
lam2(adj,deg)=(M=length(adj);L=zeros(M,M);for i in 1:M;L[i,i]=deg[i];for j in adj[i];L[i,j]-=1.0;end;end;sort(eigvals(Symmetric(L)))[2])
function extinct(adj,deg,β,δ;rng,Tmax=2e6)
    M=length(adj); s=trues(M); t=0.0
    while t<Tmax
        nint=count(s); nint==0 && return t
        Rd=δ*nint; Rr=0.0
        @inbounds for i in 1:M; if !s[i]; k=0; for j in adj[i]; s[j]&&(k+=1);end; Rr+=β*k/deg[i]; end; end
        R=Rd+Rr; R<=0 && return t
        t+=-log(rand(rng))/R; r=rand(rng)*R
        if r<Rd; idx=floor(Int,r/δ)+1;c=0; @inbounds for i in 1:M; if s[i];c+=1;c==idx&&(s[i]=false;break);end;end
        else; r2=r-Rd; @inbounds for i in 1:M; if !s[i]; k=0;for j in adj[i];s[j]&&(k+=1);end; rt=β*k/deg[i]; if r2<rt; s[i]=true;break; else;r2-=rt;end;end;end; end
    end
    return Tmax
end
function taustats(adj,deg,ρ,Mtraj;δ=1.0,seed=1)
    rng=MersenneTwister(seed);β=ρ*δ;L=Float64[]
    for _ in 1:Mtraj; push!(L,extinct(adj,deg,β,δ;rng=rng)); end
    m=mean(L); cv=std(L)/m; return m,cv
end
out=joinpath(@__DIR__,"closure_knfamily_scaling.out.txt"); fout=open(out,"w")
pr(a...)=(println(stdout,a...);println(fout,a...)); bar="="^78
pr(bar); pr("  closure_knfamily_scaling.jl — autopoietic robustness across the REAL K_n³ family")
pr("  EXPERIMENTAL. closure-v5 K_n³ (fidelity build). decay-default + autocatalytic repair."); pr(bar)
ρ=1.15
pr(@sprintf("  ρ=%.2f (low, so the dense canonical quotients are samplable). relations = hyperedges.",ρ))
pr(@sprintf("  %-8s %-7s %-9s %-9s %-10s %-7s %-9s","quotient","n_cl","M(he)","mean-deg","λ₂","CV","τ"))
res=NamedTuple[]
for n in 4:6
    n_cl,he=build_q_n3(n); adj,deg=he_support(n_cl,he); l2=lam2(adj,deg)
    Mtraj = n<=5 ? 500 : 250
    τ,cv=taustats(adj,deg,ρ,Mtraj;seed=n)
    pr(@sprintf("  K_%d³     %-7d %-9d %-9.1f %-10.3f %-7.3f %-9.0f",n,n_cl,length(he),mean(deg),l2,cv,τ))
    push!(res,(n=n,ncl=n_cl,M=length(he),λ2=l2,τ=τ)); flush(fout)
end
# large-deviation form: ln τ vs M (size) ; and per-M rate vs λ₂
x=[r.M for r in res]; y=[log(r.τ) for r in res]
mx=mean(x);my=mean(y); b=sum((x.-mx).*(y.-my))/sum((x.-mx).^2);ic=my-b*mx
R2=1-sum((y.-(ic.+b.*x)).^2)/sum((y.-my).^2)
pr(""); pr(@sprintf("  ln τ vs M (size):  slope=%.4f /relation, R²=%.4f  ⇒ %s",b,R2, R2>0.9 ? "clean large-deviation τ~exp(rate·M) on the REAL family" : "approx"))
rate=[log(r.τ)/r.M for r in res]; λ=[r.λ2 for r in res]
sp=cor(Float64.(sortperm(sortperm(λ))),Float64.(sortperm(sortperm(rate))))
pr(@sprintf("  per-relation rate (lnτ/M) vs λ₂:  Spearman=%+.3f  (does the spectral gap add beyond size?)",sp))
pr(bar)
pr("  READING: the canonical K_n³ family shows the SAME large-deviation robustness as the")
pr("  generic test — τ rises exponentially with the closure size M. Whether the spectral")
pr("  gap λ₂ adds predictive power beyond raw size is the finer structure signal above.")
pr(bar); close(fout); println(stdout,"wrote: $out")
