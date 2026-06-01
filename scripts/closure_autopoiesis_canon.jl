#!/usr/bin/env julia
# closure_autopoiesis_canon.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# substrate_source: closure-v5 : gpg_bipartite_verified_a_q102_data.json +
#   gpg_bipartite_verified_a_kernel_basis.jls — canonical CFS "Q_102 zygote"
#   closure complex (n_cl=102, |E|=2571). Loader copied from float64_hodge.jl.
#   A7: named upstream object, cited; exploratory probe, not a spec entry.
# Firewall: tests whether the REAL CFS closure structure predicts the autopoietic
# GATING (which relation sits open most — the roll/A-role analog). No physics imported.
#
# Q_102 is dense (mean degree ≈99) & near-regular ⇒ extremely robust ⇒ full
# extinction τ is unsamplable. The closure-SPECIFIC question is GATING: does the
# CFS structure single out WHICH relation is the weak point? We measure the
# quasi-stationary per-relation occupancy (fraction of time intact) and correlate
# with structural weakness (degree, |Fiedler|). Generic result: heterogeneous
# complexes DO gate at the weak relation — is Q_102 heterogeneous enough to gate?

using JSON, LinearAlgebra, Serialization, SparseArrays, Statistics, Random, Printf
const CV5="/Users/aarongreen/Desktop/Research Papers/Relational_Emergence/Closure v5"

function load_level0()
    kdata=deserialize(joinpath(CV5,"gpg_bipartite_verified_a_kernel_basis.jls"))
    qdata=JSON.parsefile(joinpath(CV5,"gpg_bipartite_verified_a_q102_data.json"))
    n_cl=Int(qdata["n_cl"])
    orig=Int[Int(c)+1 for c in qdata["orig_idx"]]; conj=Int[Int(c)+1 for c in qdata["conj_idx"]]
    L=Matrix{Int64}(undef,n_cl,n_cl); La=[[Int(x) for x in row] for row in qdata["L"]]
    for i in 1:n_cl,j in 1:n_cl; L[i,j]=La[i][j]; end
    K=kdata.K_int_p1; co=ones(Int64,kdata.null_dim_p1)
    Mf=BigInt.(K)'*BigInt.(co); Mr=Matrix{BigInt}(reshape(Mf,length(orig),length(conj))')
    DF=zeros(BigInt,n_cl,n_cl)
    for il in 1:length(conj),jl in 1:length(orig); ci=conj[il];oj=orig[jl]; DF[ci,oj]=Mr[il,jl];DF[oj,ci]=Mr[il,jl]; end
    C=BigInt.(L)*DF+DF*BigInt.(L)
    edges=Tuple{Int,Int}[]; for i in orig,j in conj; C[i,j]!=0 && push!(edges,(i,j)); end
    sort!(edges); return n_cl, edges
end

corspearman_(x,y) = cor(Float64.(sortperm(sortperm(x))), Float64.(sortperm(sortperm(y))))

function main()
    out=joinpath(@__DIR__,"closure_autopoiesis_canon.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  closure_autopoiesis_canon.jl — autopoietic gating on the REAL CFS Q_102")
    pr("  EXPERIMENTAL. substrate_source: closure-v5 gpg_bipartite_verified_a (Q_102).")
    pr(bar)

    n_cl, edges = load_level0(); ne=length(edges)
    inc=[Int[] for _ in 1:n_cl]
    for (k,(i,j)) in enumerate(edges); push!(inc[i],k); push!(inc[j],k); end
    adj=[Int[] for _ in 1:ne]
    for v in 1:n_cl, a in inc[v], b in inc[v]; a!=b && push!(adj[a],b); end
    adj=[sort(unique(a)) for a in adj]; deg=[length(a) for a in adj]
    pr(@sprintf("\n  Q_102 closure complex: %d classes, %d relations (edges).", n_cl, ne))
    pr(@sprintf("  closure-coupling line graph: deg min/mean/max = %d/%.1f/%d (near-regular ⇒ homogeneous)",
                minimum(deg), mean(deg), maximum(deg)))
    Lap=zeros(ne,ne); for i in 1:ne; Lap[i,i]=deg[i]; for j in adj[i]; Lap[i,j]-=1.0; end; end
    e=eigen(Symmetric(Lap)); λ2=e.values[2]; fied=abs.(e.vectors[:,2])
    pr(@sprintf("  line-graph λ₂ = %.3f (high ⇒ very robust/expander-like).", λ2))

    ρ=2.0; β=ρ; δ=1.0; prop=zeros(ne); Ttot=0.0
    for run in 1:2
        rng=MersenneTwister(2024+run)
        s=trues(ne); k=copy(deg); nint=ne; Rd=δ*nint; Rr=0.0
        t=0.0; Tend=250.0; Trelax=50.0
        while t<Tend
            R=Rd+Rr; R<=0 && break
            dt=-log(rand(rng))/R
            if t>Trelax; @inbounds for i in 1:ne; s[i]&&(prop[i]+=dt); end; Ttot+=dt; end
            t+=dt; r=rand(rng)*R
            if r<Rd
                idx=floor(Int,r/δ)+1; c=0; sel=0
                @inbounds for i in 1:ne; if s[i]; c+=1; if c==idx; sel=i; break; end; end; end
                s[sel]=false; nint-=1; Rd-=δ; Rr+=β*k[sel]/deg[sel]
                @inbounds for j in adj[sel]; k[j]-=1; s[j]||(Rr-=β/deg[j]); end
            else
                r2=r-Rd; sel=0
                @inbounds for i in 1:ne
                    if !s[i]; rate=β*k[i]/deg[i]; if r2<rate; sel=i; break; else; r2-=rate; end; end
                end
                sel==0 && continue
                s[sel]=true; nint+=1; Rd+=δ; Rr-=β*k[sel]/deg[sel]
                @inbounds for j in adj[sel]; k[j]+=1; s[j]||(Rr+=β/deg[j]); end
            end
        end
    end
    surv=prop./Ttot

    pr("\n"*dsh); pr("  GATING on the canonical substrate (ρ=2.0, f*=0.50): per-relation occupancy")
    pr(dsh)
    sp_deg=corspearman_(surv, Float64.(deg)); sp_fie=corspearman_(surv, fied)
    pr(@sprintf("    survival propensity: min/mean/max = %.3f / %.3f / %.3f  (spread = %.1f%% of mean)",
                minimum(surv), mean(surv), maximum(surv), 100*(maximum(surv)-minimum(surv))/mean(surv)))
    pr(@sprintf("    Spearman(propensity, degree)    = %+.3f", sp_deg))
    pr(@sprintf("    Spearman(propensity, |Fiedler|) = %+.3f", sp_fie))

    pr("\n"*bar); pr("  CANONICAL VERDICT")
    pr(bar)
    homog=(maximum(deg)-minimum(deg))/mean(deg); spread=100*(maximum(surv)-minimum(surv))/mean(surv)
    pr(@sprintf("  • Q_102 near-regular (degree spread %.1f%%), highly connected (λ₂=%.0f): a clean,", 100*homog, λ2))
    pr("    symmetric algebraic quotient with little structural heterogeneity.")
    if abs(sp_deg)<0.2 && abs(sp_fie)<0.2
        pr(@sprintf("  • Per-relation occupancy is nearly UNIFORM (spread %.1f%%), uncorrelated with structure", spread))
        pr("    ⇒ Q_102 has NO distinguished gate; weakness is DELOCALIZED.")
        pr("  • HONEST READING: gating (a roll-like distinguished leg) is NOT generic to closure")
        pr("    complexes — it needs structural HETEROGENEITY (generic test). The canonical Q_102")
        pr("    is too symmetric to single one out: closure predicts gating WHERE heterogeneous,")
        pr("    and predicts ABSENCE of a gate on homogeneous Q_102 — a falsifiable, structure-derived call.")
    else
        pr(@sprintf("  • Occupancy correlates with structure (deg %+.2f, Fiedler %+.2f) ⇒ even on Q_102 the", sp_deg, sp_fie))
        pr("    CFS structure ranks the weak relations — gating predicted on the real substrate.")
    end
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

main()
