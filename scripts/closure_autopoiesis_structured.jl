#!/usr/bin/env julia
# closure_autopoiesis_structured.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# Firewall: GENERIC scale-up of the autopoietic closure model. Tests the
# closure-SPECIFIC claim: does the STRUCTURE of a closure complex predict its
# escape dynamics? (Canonical CFS K_n³ substrate is the next step.) No physics
# imported — decay is the default, closure the autopoietic achievement.
#
# ─── MODEL ───────────────────────────────────────────────────────────────────
# A closure complex = a support graph G on M relations. Relation i is repaired
# only if its supporting neighbours are intact (autopoietic / Rosen (M,R):
# "repair needs the surrounding closure running").
#   state s ∈ {0,1}^M  (s_i = relation i intact?)
#   DECAY (default):   each intact relation → not-intact at rate δ.
#   REPAIR (structure-dependent, autocatalytic):
#     each not-intact relation i → intact at rate β · (intact neighbours)/deg(i).
#   all-dead = ABSORBING (no neighbours ⇒ no repair ⇒ autopoietic death).
#   control ρ = β/δ. Mean-field fixed point f* = 1−1/ρ is STRUCTURE-INDEPENDENT,
#   so any τ difference across graphs at fixed ρ,deg is a STRUCTURE effect.
#
# ─── TWO PREDICTANDS (read from structure BEFORE the dynamics) ───────────────
#  (1) SCALING: at fixed M, fixed degree, fixed ρ, does the metastable lifetime
#      τ track the algebraic connectivity λ₂ (Fiedler value) of G? Prediction:
#      better-connected (harder-to-fragment) complexes are more robust ⇒ larger τ.
#  (2) GATING: on an irregular complex, does per-relation survival-propensity
#      (fraction of metastable time intact) track structural weakness (low degree
#      / Fiedler component)? Prediction: the structurally weakest relation is the
#      gate — intact least, dies first. (The graph analogue of "the roll gates
#      recovery.")

using Printf, Random, Statistics, LinearAlgebra

# ── graph builders (adjacency lists, 1-based) ────────────────────────────────
function circulant(n, S)
    adj=[Int[] for _ in 1:n]
    for i in 0:n-1, s in S
        push!(adj[i+1], mod(i+s,n)+1); push!(adj[i+1], mod(i-s,n)+1)
    end
    return [sort(unique(a)) for a in adj]
end
complete_g(n) = [[j for j in 1:n if j!=i] for i in 1:n]
function er_graph(n, p; rng)            # connected Erdős–Rényi
    while true
        adj=[Int[] for _ in 1:n]
        for i in 1:n-1, j in i+1:n
            if rand(rng)<p; push!(adj[i],j); push!(adj[j],i); end
        end
        all(!isempty, adj) && lambda2(adj)>1e-9 && return adj   # connected
    end
end
function laplacian(adj); n=length(adj); L=zeros(n,n)
    for i in 1:n; L[i,i]=length(adj[i]); for j in adj[i]; L[i,j]-=1.0; end; end; L; end
lambda2(adj) = sort(eigvals(Symmetric(laplacian(adj))))[2]
fiedler(adj)  = (e=eigen(Symmetric(laplacian(adj))); e.vectors[:,2])

# ── autopoietic CTMC; returns (lifetime, absorbed, per-node intact-time, Ttot) ─
function extinct(adj, β, δ; rng, Tmax=2e5, track=false)
    n=length(adj); deg=[length(a) for a in adj]
    s=trues(n)                                  # born fully closed
    t=0.0; prop=zeros(n); Ttot=0.0
    while t<Tmax
        nint=count(s); nint==0 && return (t,true,prop,Ttot)
        Rd=δ*nint; Rr=0.0
        @inbounds for i in 1:n
            if !s[i]
                k=0; for j in adj[i]; s[j] && (k+=1); end
                Rr += β*k/deg[i]
            end
        end
        R=Rd+Rr; R<=0 && return (t,false,prop,Ttot)
        dt=-log(rand(rng))/R
        if track; @inbounds for i in 1:n; s[i] && (prop[i]+=dt); end; Ttot+=dt; end
        t+=dt
        r=rand(rng)*R
        if r<Rd                                  # decay: uniform among intact
            idx=floor(Int,r/δ)+1; c=0
            @inbounds for i in 1:n; if s[i]; c+=1; if c==idx; s[i]=false; break; end; end; end
        else                                     # repair: prop to k/deg among dead
            r2=r-Rd
            @inbounds for i in 1:n
                if !s[i]
                    k=0; for j in adj[i]; s[j] && (k+=1); end
                    rate=β*k/deg[i]
                    if r2<rate; s[i]=true; break; else; r2-=rate; end
                end
            end
        end
    end
    return (Tmax,false,prop,Ttot)
end

function tau_stats(adj, ρ, M; δ=1.0, Tmax=2e5, seed=1)
    rng=MersenneTwister(seed); β=ρ*δ; L=Float64[]; nc=0
    for _ in 1:M
        l,ab,_,_=extinct(adj,β,δ;rng=rng,Tmax=Tmax); push!(L,l); ab||(nc+=1)
    end
    m=mean(L); cv=std(L)/m
    xs=Float64[];ys=Float64[]
    for tq in range(quantile(L,0.05),stop=quantile(L,0.9),length=12)
        S=count(>(tq),L)/M; S<=0&&continue; push!(xs,tq);push!(ys,log(S))
    end
    R2=NaN
    if length(xs)>=4
        mx=mean(xs);my=mean(ys);sl=sum((xs.-mx).*(ys.-my))/sum((xs.-mx).^2);ic=my-sl*mx
        R2=1-sum((ys.-(ic.+sl.*xs)).^2)/sum((ys.-my).^2)
    end
    return (τ=m, cv=cv, R2=R2, cens=nc/M)
end

spearman(x,y)=cor(sortperm(sortperm(x)).+0.0, sortperm(sortperm(y)).+0.0)

function main()
    out=joinpath(@__DIR__,"closure_autopoiesis_structured.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  closure_autopoiesis_structured.jl — does closure STRUCTURE predict the dynamics?")
    pr("  EXPERIMENTAL. Generic scale-up (varied support graphs). No physics imported.")
    pr(bar)
    M=20; ρ=2.0
    pr(@sprintf("  M=%d relations, ρ=β/δ=%.1f (f*=%.2f, structure-independent). δ≡1.", M, ρ, 1-1/ρ))

    # ── (1) SCALING: τ vs algebraic connectivity λ₂ ─────────────────────────
    pr("\n"*dsh); pr("  (1) SCALING — fixed M & ρ; vary support structure; τ vs λ₂(Fiedler)")
    pr(dsh)
    fam = Tuple{String,Vector{Vector{Int}}}[]
    push!(fam, ("ring C20 (deg2)", circulant(M,[1])))
    for s in 2:9                                            # 8 DEG-4 circulants
        push!(fam, ("circ(1,$s) deg4", circulant(M,[1,s])))
    end
    push!(fam, ("circ(1..4) deg8", circulant(M,[1,2,3,4])))
    push!(fam, ("complete K20 (d19)", complete_g(M)))
    pr(@sprintf("    %-20s %-6s %-9s %-11s %-7s %-7s", "complex","deg","λ₂","τ","CV","R²surv"))
    rows=NamedTuple[]
    for (name,adj) in fam
        d=length(adj[1]); l2=lambda2(adj); st=tau_stats(adj,ρ,600; seed=hash(name)%10000)
        pr(@sprintf("    %-20s %-6d %-9.4f %-11.0f %-7.3f %-7.3f", name, d, l2, st.τ, st.cv, st.R2))
        push!(rows,(name=name,deg=d,λ2=l2,τ=st.τ))
    end
    # clean test: deg-4 subset only (degree held fixed ⇒ pure structure effect)
    d4=[r for r in rows if r.deg==4]
    x=[r.λ2 for r in d4]; y=[log(r.τ) for r in d4]
    if length(d4)>=4
        mx=mean(x);my=mean(y);b=sum((x.-mx).*(y.-my))/sum((x.-mx).^2);ic=my-b*mx
        R2=1-sum((y.-(ic.+b.*x)).^2)/sum((y.-my).^2); ρs=spearman(x,y)
        pr(@sprintf("\n  DEG-4 SUBSET (%d graphs, degree FIXED ⇒ isolates structure):", length(d4)))
        pr(@sprintf("    Spearman(λ₂, ln τ) = %+.3f   [monotonicity — the primary test]", ρs))
        pr(@sprintf("    linear ln τ = %+.3f·λ₂ + c,  R²=%.3f   [form; <1 ⇒ saturating, not non-monotone]", b, R2))
        verdict = ρs>0.85 ? "τ RISES MONOTONICALLY with connectivity λ₂ at FIXED degree ⇒ STRUCTURE predicts robustness" :
                  ρs>0.5  ? "τ tends to rise with λ₂ (weak)" : "no monotone structure→τ relation"
        pr("    ⇒ "*verdict)
    end
    pr("  (ring→complete also shown: degree confounds there; the deg-4 set is the clean test.)")

    # ── (2) GATING: survival-propensity vs structural weakness ─────────────
    pr("\n"*dsh); pr("  (2) GATING — irregular complex: does the weakest relation gate collapse?")
    pr(dsh)
    adjg = er_graph(16, 0.22; rng=MersenneTwister(42))
    n=length(adjg); deg=[length(a) for a in adjg]; fv=abs.(fiedler(adjg))
    β=ρ*1.0; rng2=MersenneTwister(99)
    prop=zeros(n); Ttot=0.0
    for _ in 1:400
        _,_,p,T=extinct(adjg,β,1.0;rng=rng2,Tmax=2e5,track=true); prop.+=p; Ttot+=T
    end
    surv=prop./Ttot                                   # per-relation intact propensity
    pr(@sprintf("    %d relations; degrees %d–%d. Per-relation survival propensity vs structure:", n, minimum(deg), maximum(deg)))
    # correlations
    pr(@sprintf("    Spearman(survival-propensity, degree)       = %+.3f", spearman(surv, deg.+0.0)))
    pr(@sprintf("    Spearman(survival-propensity, |Fiedler|)    = %+.3f  (weak node = high |Fiedler|)", spearman(surv, fv)))
    wk=argmin(surv); st=argmin(deg)
    pr(@sprintf("    weakest relation (lowest survival) = #%d  (deg %d, |Fiedler| %.3f)", wk, deg[wk], fv[wk]))
    pr(@sprintf("    lowest-degree relation             = #%d  (deg %d)  → match: %s", st, deg[st], wk==st ? "YES ✓" : "near"))
    pr("  ⇒ if survival-propensity correlates with degree (+) and the lowest-survival relation")
    pr("    is the structurally weakest, the closure STRUCTURE predicts the gate.")

    pr("\n"*bar); pr("  GENERIC SCALE-UP VERDICT")
    pr(bar)
    pr("  Read the two tests above:")
    pr("   • SCALING: if (deg-4) ln τ rises with λ₂, the complex's CONNECTIVITY — a")
    pr("     CFS-computable invariant — predicts its robustness/lifetime FORM. Structure,")
    pr("     not just rates. (Environment still sets the absolute scale via ρ.)")
    pr("   • GATING: if survival-propensity tracks degree/Fiedler, the structurally")
    pr("     weakest relation is the collapse gate — structure predicts WHICH leg.")
    pr("  Together they are the closure-SPECIFIC prediction the mean-field model lacked.")
    pr("  NEXT (canonical): replace the generic support graph with the actual CFS K_n³")
    pr("  closure complex; test whether ITS spectral gap / role structure predicts τ and")
    pr("  the gate — i.e. whether CFS's own computed structure carries the dynamics.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

main()
