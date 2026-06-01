#!/usr/bin/env julia
# closure_q102_richgate.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# substrate_source: closure-v5 : gpg_bipartite_verified_a_q102_data.json +
#   _kernel_basis.jls — canonical CFS Q_102. A7: named upstream object, cited.
# Firewall: "flush out Q_102" — the v1 canonical gating negative was only against
# UNWEIGHTED degree/Fiedler. Here we test the RICHER, real CFS structure:
#   • |C| closure-coupling weight per relation (and weighted degree),
#   • q_tier (A/B), cl_origin, and the triplet-derived F/A/S role,
# in a WEIGHTED autopoietic dynamics (repair support ∝ neighbours' coupling
# strength; decay still the uniform default). A relation's OWN weight does NOT
# enter its own rate (only neighbours' weights do), so correlating occupancy with
# own-|C| / tier / role is non-circular. Does ANY real CFS structure localize a gate?

using JSON, LinearAlgebra, Serialization, SparseArrays, Statistics, Random, Printf
const CV5="/Users/aarongreen/Desktop/Research Papers/Relational_Emergence/Closure v5"

function load_q102()
    kdata=deserialize(joinpath(CV5,"gpg_bipartite_verified_a_kernel_basis.jls"))
    q=JSON.parsefile(joinpath(CV5,"gpg_bipartite_verified_a_q102_data.json"))
    n_cl=Int(q["n_cl"])
    orig=Int[Int(c)+1 for c in q["orig_idx"]]; conj=Int[Int(c)+1 for c in q["conj_idx"]]
    L=Matrix{Int64}(undef,n_cl,n_cl); La=[[Int(x) for x in row] for row in q["L"]]
    for i in 1:n_cl,j in 1:n_cl; L[i,j]=La[i][j]; end
    K=kdata.K_int_p1; co=ones(Int64,kdata.null_dim_p1)
    Mf=BigInt.(K)'*BigInt.(co); Mr=Matrix{BigInt}(reshape(Mf,length(orig),length(conj))')
    DF=zeros(BigInt,n_cl,n_cl)
    for il in 1:length(conj),jl in 1:length(orig); ci=conj[il];oj=orig[jl]; DF[ci,oj]=Mr[il,jl];DF[oj,ci]=Mr[il,jl]; end
    C=BigInt.(L)*DF+DF*BigInt.(L)
    edges=Tuple{Int,Int}[]; w=Float64[]
    for i in orig,j in conj
        if C[i,j]!=0; push!(edges,(i,j)); push!(w, Float64(abs(C[i,j]))); end
    end
    # roles from triplets: position 1=F,2=A,3=S (Rosen fab/assembly/replication)
    role=fill(:none, n_cl)
    for trip in q["triplets"]
        for (pos,c) in enumerate(trip); cl=Int(c)+1
            role[cl] = pos==1 ? :F : pos==2 ? :A : :S      # first-assignment dominant
        end
    end
    tier=String[string(t) for t in q["q_tier"]]
    origin=String[string(o) for o in q["cl_origin"]]
    return (n_cl=n_cl, edges=edges, w=w, role=role, tier=tier, origin=origin)
end

corsp(x,y)=cor(Float64.(sortperm(sortperm(x))),Float64.(sortperm(sortperm(y))))

function main()
    out=joinpath(@__DIR__,"closure_q102_richgate.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  closure_q102_richgate.jl — does the REAL CFS structure localize a gate on Q_102?")
    pr("  EXPERIMENTAL. Weighted autopoietic dynamics; richer predictors. closure-v5 Q_102.")
    pr(bar)

    Q=load_q102(); ne=length(Q.edges)
    inc=[Int[] for _ in 1:Q.n_cl]
    for (k,(i,j)) in enumerate(Q.edges); push!(inc[i],k); push!(inc[j],k); end
    adj=[Int[] for _ in 1:ne]
    for v in 1:Q.n_cl, a in inc[v], b in inc[v]; a!=b && push!(adj[a],b); end
    adj=[sort(unique(a)) for a in adj]
    w=Q.w
    pr(@sprintf("\n  Q_102: %d relations.  |C| weight: min/med/max = %.0f / %.0f / %.0f  (spread = %.0f×)",
        ne, minimum(w), median(w), maximum(w), maximum(w)/minimum(w)))
    Wdeg=[sum(w[j] for j in adj[i]) for i in 1:ne]      # weighted degree = Σ neighbour |C|
    # per-edge role/tier/origin from endpoints
    edge_hasrole = [ (Q.role[i]!=:none || Q.role[j]!=:none) for (i,j) in Q.edges ]
    edge_tierB   = [ Float64((Q.tier[i]!="A")+(Q.tier[j]!="A")) for (i,j) in Q.edges ]  # #non-A endpoints
    pr(@sprintf("  endpoints in a triplet (have F/A/S role): %d of %d relations", count(edge_hasrole), ne))

    # ── WEIGHTED autopoietic QSD (incremental) ──────────────────────────────
    ρ=2.0; β=ρ; δ=1.0
    W=[sum(w[j] for j in adj[i]) for i in 1:ne]          # constant weighted degree
    prop=zeros(ne); Ttot=0.0
    for run in 1:4
        rng=MersenneTwister(700+run)
        s=trues(ne); S=copy(W)                            # S_i = Σ intact-neighbour weight (all intact)
        nint=ne; Rd=δ*nint; Rr=0.0
        t=0.0; Tend=320.0; Trelax=60.0
        while t<Tend
            R=Rd+Rr; R<=0 && break
            dt=-log(rand(rng))/R
            if t>Trelax; @inbounds for i in 1:ne; s[i]&&(prop[i]+=dt); end; Ttot+=dt; end
            t+=dt; r=rand(rng)*R
            if r<Rd                                       # DECAY uniform
                idx=floor(Int,r/δ)+1; c=0; m=0
                @inbounds for i in 1:ne; if s[i]; c+=1; if c==idx; m=i; break; end; end; end
                s[m]=false; nint-=1; Rd-=δ; Rr+=β*S[m]/W[m]
                @inbounds for j in adj[m]; S[j]-=w[m]; s[j]||(Rr-=β*w[m]/W[j]); end
            else                                          # REPAIR ∝ weighted intact support
                r2=r-Rd; m=0
                @inbounds for i in 1:ne
                    if !s[i]; rate=β*S[i]/W[i]; if r2<rate; m=i; break; else; r2-=rate; end; end
                end
                m==0 && continue
                s[m]=true; nint+=1; Rd+=δ; Rr-=β*S[m]/W[m]
                @inbounds for j in adj[m]; S[j]+=w[m]; s[j]||(Rr+=β*w[m]/W[j]); end
            end
        end
    end
    surv=prop./Ttot

    pr("\n"*dsh); pr("  GATING vs RICHER STRUCTURE (weighted dynamics, ρ=2.0, 4 runs)")
    pr(dsh)
    pr(@sprintf("    occupancy: min/mean/max = %.3f / %.3f / %.3f", minimum(surv),mean(surv),maximum(surv)))
    pr(@sprintf("    Spearman(occupancy, own |C|)          = %+.3f", corsp(surv, w)))
    pr(@sprintf("    Spearman(occupancy, weighted degree)  = %+.3f", corsp(surv, W)))
    pr(@sprintf("    Spearman(occupancy, #non-A endpoints) = %+.3f", corsp(surv, edge_tierB)))
    # role contrast: edges touching an F/A/S triplet-class vs not
    inrole=[surv[k] for k in 1:ne if edge_hasrole[k]]; norole=[surv[k] for k in 1:ne if !edge_hasrole[k]]
    if !isempty(inrole) && !isempty(norole)
        pr(@sprintf("    occupancy: triplet-role edges %.3f  vs  no-role edges %.3f  (Δ=%.3f)",
            mean(inrole), mean(norole), mean(inrole)-mean(norole)))
    end

    pr("\n"*bar); pr("  Q_102 RICH-GATE VERDICT")
    pr(bar)
    best=maximum(abs.([corsp(surv,w),corsp(surv,W),corsp(surv,edge_tierB)]))
    if best<0.2
        pr(@sprintf("  • Even the REAL CFS structure (|C| weights spread %.0f×, weighted degree, tier,", maximum(w)/minimum(w)))
        pr("    triplet-role) does NOT localize a gate: all |Spearman| < 0.2. Occupancy is")
        pr("    delocalized on Q_102. The v1 negative SURVIVES the richer test.")
        pr("  • HONEST READING: Q_102 is a clean, symmetric quotient with no roll-like weak leg —")
        pr("    not even its coupling-weights or roles single one out. Gating needs heterogeneity")
        pr("    that this canonical object lacks. (A heterogeneous closure complex DOES gate — generic test.)")
    else
        pr(@sprintf("  • A real CFS feature predicts gating (best |Spearman|=%.2f): the structure DOES", best))
        pr("    localize a weak relation on Q_102 once weights/roles are used. Flips the v1 negative.")
    end
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

main()
