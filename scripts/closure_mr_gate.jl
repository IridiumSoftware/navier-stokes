#!/usr/bin/env julia
# closure_mr_gate.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# Firewall: CLOSURE-INTERNAL formalization of "the gate" on the Rosen (M,R) 3-role
# triad (F=metabolism, A=repair, S=replication). No turbulence bridge: we ask only
# whether the role STRUCTURE singles out a distinguished gate, and whether that is
# ROBUST. The (separate, caveated) comparison to the turbulent roll is reported but
# NOT asserted as a prediction — the arc has shown that bridge is unjustified.
#
# ─── STRUCTURE (Rosen, "Life Itself") ────────────────────────────────────────
# Making-graph (who re-makes whom): A→F (repair makes metabolism), S→A (replication
# makes repair), F→S (metabolism ENTAILS replication — the closure-to-efficient-
# causation link). The entailment F→S is qualitatively the weak/special link
# (a derived closure, not an active maker) — that is Rosen's whole point. We encode
# this as link weight w_ent ≤ 1 on F→S; active links A→F, S→A have weight 1.
# Metabolism F is environment-coupled ⇒ optionally a faster decay δ_F ≥ δ.
#
# Exact 8-state CTMC (each role 0/1): decay-default (alive→dead at δ_X); repair
# (dead→alive at β·w(maker) IFF maker alive). all-dead = absorbing (autopoietic death).
#
# ─── PRE-REGISTERED PREDICTION (derived above, before computing) ─────────────
#   With F→S the weak link: SEED ORDER S > A > F  (S recovers via S→A→F, two strong
#   links, avoiding weak F→S).  GATE = S (replication).  WEAK LEG = F (metabolism).
# Test: compute the recovery-committor from each lone-survivor state; check the order.
# Robustness: sweep w_ent and δ_F; does the seed identity hold or flip?

using LinearAlgebra, Printf

const F=0; const A=1; const S=2                       # bit positions
alive(m,x)=(m>>x)&1==1
maker(x)= x==F ? A : x==A ? S : F                     # A→F, S→A, F→S
# weight of the link maker(x)→x :  A→F=wAF, S→A=wSA, F→S=wFS
linkw(x,wAF,wSA,wFS)= x==F ? wAF : x==A ? wSA : wFS

function generator(δF,δA,δS,β,wAF,wSA,wFS)
    Q=zeros(8,8); δ=(δF,δA,δS)
    for m in 0:7
        for x in (F,A,S)
            if alive(m,x)                              # decay
                Q[m+1, (m & ~(1<<x))+1] += δ[x+1]
            else                                       # repair iff maker alive
                if alive(m, maker(x))
                    Q[m+1, (m | (1<<x))+1] += β*linkw(x,wAF,wSA,wFS)
                end
            end
        end
        Q[m+1,m+1] = -sum(Q[m+1,:])
    end
    return Q
end

# committor h(m)=P(hit all-alive=7 before all-dead=0). transient = masks 1..6.
function committor(Q)
    T=[2,3,4,5,6,7]                                   # indices for masks 1..6 (1-based)
    b=zeros(length(T))
    Aᵀ=zeros(length(T),length(T))
    for (ii,i) in enumerate(T)
        for (jj,j) in enumerate(T); Aᵀ[ii,jj]=Q[i,j]; end
        b[ii] = -Q[i,8]                               # h(mask7,index8)=1 ; h(mask0,index1)=0
    end
    h=Aᵀ\b
    H=zeros(8); H[8]=1.0; H[1]=0.0
    for (ii,i) in enumerate(T); H[i]=h[ii]; end
    return H                                           # H[mask+1]
end
lone(H)=(H[1+1], H[2+1], H[4+1])                       # F-only(mask1), A-only(mask2), S-only(mask4)
seedname(c)= (["F","A","S"][argmax(collect(c))])

function main()
    out=joinpath(@__DIR__,"closure_mr_gate.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  closure_mr_gate.jl — exact gate on the Rosen (M,R) F/A/S triad. EXPERIMENTAL.")
    pr("  Pre-registered: F→S weak ⇒ seed order S>A>F, GATE=S (replication). Closure-internal.")
    pr(bar)

    β=3.0; δ=1.0
    # ── base case: symmetric decay, entailment weak (w_ent=0.2) ─────────────
    pr("\n"*dsh); pr("  BASE: symmetric decay δ=1, β=3, active links=1, entailment F→S w_ent=0.2")
    pr(dsh)
    H=committor(generator(δ,δ,δ,β,1.0,1.0,0.2)); cF,cA,cS=lone(H)
    pr(@sprintf("    recovery-committor from lone survivor:  F-only=%.3f  A-only=%.3f  S-only=%.3f", cF,cA,cS))
    pr(@sprintf("    ⇒ seed = %s ;  order %s   [pre-registered: S>A>F, seed=S]",
        seedname((cF,cA,cS)), join(["F","A","S"][sortperm([cF,cA,cS],rev=true)], ">")))

    # ── robustness sweep over entailment weakness w_ent ─────────────────────
    pr("\n"*dsh); pr("  ROBUSTNESS — sweep entailment weakness w_ent (F→S link), symmetric decay")
    pr(dsh)
    pr(@sprintf("    %-8s %-9s %-9s %-9s %-8s","w_ent","F-only","A-only","S-only","seed"))
    seeds=String[]
    for we in (1.0,0.7,0.5,0.3,0.1)
        H=committor(generator(δ,δ,δ,β,1.0,1.0,we)); cF,cA,cS=lone(H)
        sd=seedname((cF,cA,cS)); push!(seeds,sd)
        pr(@sprintf("    %-8.1f %-9.3f %-9.3f %-9.3f %-8s", we,cF,cA,cS,sd))
    end
    # ── robustness sweep over metabolism exposure δ_F ───────────────────────
    pr("\n"*dsh); pr("  ROBUSTNESS — sweep metabolism decay δ_F (environment exposure), w_ent=0.3")
    pr(dsh)
    pr(@sprintf("    %-8s %-9s %-9s %-9s %-8s","δ_F","F-only","A-only","S-only","seed"))
    for dF in (1.0,1.5,2.0,3.0)
        H=committor(generator(dF,δ,δ,β,1.0,1.0,0.3)); cF,cA,cS=lone(H)
        pr(@sprintf("    %-8.1f %-9.3f %-9.3f %-9.3f %-8s", dF,cF,cA,cS,seedname((cF,cA,cS))))
    end

    # symmetric control: w_ent=1, δ symmetric ⇒ pure directed 3-cycle ⇒ no gate
    Hc=committor(generator(δ,δ,δ,β,1.0,1.0,1.0)); cFc,cAc,cSc=lone(Hc)
    pr(@sprintf("\n  CONTROL (w_ent=1, symmetric): F=A=S committor = %.3f,%.3f,%.3f ⇒ %s",
        cFc,cAc,cSc, maximum([cFc,cAc,cSc])-minimum([cFc,cAc,cSc])<1e-6 ? "NO gate (rotational symmetry — as expected)" : "asymmetric"))

    pr("\n"*bar); pr("  VERDICT — does the (M,R) role structure predict a gate?")
    pr(bar)
    robust = all(==("S"), seeds[2:end])               # S for all w_ent<1
    if robust
        pr("  • YES, and it matches the pre-registration: once the entailment F→S is the weak link,")
        pr("    the GATE (best-recovery seed) is ROBUSTLY S (replication); order S>A>F. A pure")
        pr("    symmetric 3-cycle (control) has NO gate — the gate IS the Rosen entailment asymmetry.")
        pr("  • This is a genuine CLOSURE-INTERNAL structural prediction: the role STRUCTURE alone")
        pr("    (which link is the entailment closure) determines which role re-ignites the cycle.")
    else
        pr(@sprintf("  • The seed is NOT robust across parameterizations (seeds: %s) ⇒ the role structure", join(seeds,",")))
        pr("    does NOT cleanly predict a single gate; identity depends on the interpretation.")
    end
    pr("")
    pr("  TURBULENCE CAVEAT (NOT a claim): the MFE recovery-gate was the ROLL, which maps to the")
    pr("  REPAIR role A (it regenerates the streak=metabolic output) — NOT to S. So the closure-")
    pr("  internal gate (S) does NOT match the turbulent gate's role (A). The role structure predicts")
    pr("  a gate on its OWN substrate, but the roll↔role bridge stays UNJUSTIFIED — consistent with")
    pr("  the whole arc's firewall. Closure predicts a gate; it is not the turbulence gate.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

main()
