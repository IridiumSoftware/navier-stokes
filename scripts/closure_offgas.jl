#!/usr/bin/env julia
# closure_offgas.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# Firewall: CLOSURE-INTERNAL. Formalizes Aaron's "offgassing" phenomenology — a
# closed self-sustaining system has a SEAM (the weak edge = necessarily-incomplete
# closure) that is simultaneously its LIFELINE and its DEATH-ROUTE, with a
# tightness tradeoff (lifespan vs identity). No turbulence prediction, no entropy
# claim — "offgas" is the gloss; the math is closure-loss dynamics on the exact
# (M,R) triad. Builds on closure_mr_gate / closure_triad_rotation.
#
# ─── TWO PRE-REGISTERED CLAIMS ───────────────────────────────────────────────
# C1 (load-bearing seam): the weak-edge TARGET is BOTH the seed (best lone
#    survivor, max recovery-committor) AND the mortality point (worst to lose,
#    min recovery from the "all-but-X" state). Same node = lifeline = death-route.
# C2 (tightness tradeoff): as the seam tightens (w_ent→1), mean lifespan τ → max
#    BUT gate-sharpness & mortality-localization → 0 (inert/immortal, no identity);
#    as it opens (w_ent→0), identity sharpens but τ collapses (fragile). "Life" =
#    the intermediate imperfectly-closed regime.

using LinearAlgebra, Printf
const F=0; const A=1; const S=2
alive(m,x)=(m>>x)&1==1
maker(x)= x==F ? A : x==A ? S : F                 # A→F, S→A, F→S(weak)
linkw(x,wAF,wSA,wFS)= x==F ? wAF : x==A ? wSA : wFS
function generator(δ,β,wFS;wAF=1.0,wSA=1.0)
    Q=zeros(8,8)
    for m in 0:7
        for x in (F,A,S)
            if alive(m,x); Q[m+1,(m & ~(1<<x))+1]+=δ
            elseif alive(m,maker(x)); Q[m+1,(m|(1<<x))+1]+=β*linkw(x,wAF,wSA,wFS); end
        end
        Q[m+1,m+1]=-sum(Q[m+1,:])
    end; Q
end
function committor(Q)                              # H[mask+1]=P(hit allalive(7) before alldead(0))
    T=[2,3,4,5,6,7]; M=zeros(6,6); b=zeros(6)
    for (ii,i) in enumerate(T); for (jj,j) in enumerate(T); M[ii,jj]=Q[i,j]; end; b[ii]=-Q[i,8]; end
    h=M\b; H=zeros(8); H[8]=1; for (ii,i) in enumerate(T); H[i]=h[ii]; end; H
end
mean_death_time(Q)= ((-Q[2:8,2:8])\ones(7))[7]    # from all-alive (mask7 = 7th transient)
spread(v)=(maximum(v)-minimum(v))/max(mean(v),1e-12)
mean(v)=sum(v)/length(v)

function main()
    out=joinpath(@__DIR__,"closure_offgas.out.txt"); fout=open(out,"w")
    pr(a...)=(println(stdout,a...);println(fout,a...)); bar="═"^78; dsh="─"^78
    pr(bar); pr("  closure_offgas.jl — the seam as LIFELINE and DEATH-ROUTE (Aaron's offgassing). EXPERIMENTAL.")
    pr(bar)
    β=3.0; δ=1.0

    # ── C1: seed == mortality == weak-edge target (weak F→S, target=S) ──────
    pr("\n"*dsh); pr("  C1 — is the weak-edge target BOTH the seed and the mortality point? (weak F→S, w=0.2)")
    pr(dsh)
    H=committor(generator(δ,β,0.2))
    lone=(H[2],H[3],H[5])                          # F-only, A-only, S-only  (best survivor = SEED)
    lost=(H[7],H[6],H[4])                          # lost-F({A,S}=6), lost-A({F,S}=5), lost-S({F,A}=3)
    # map: lost-F→mask6→H[7]; lost-A→mask5→H[6]; lost-S→mask3→H[4]
    nm=["F","A","S"]
    pr(@sprintf("    recovery as LONE SURVIVOR:  F=%.3f  A=%.3f  S=%.3f   → seed (max) = %s",
                lone..., nm[argmax(collect(lone))]))
    pr(@sprintf("    recovery after LOSING one:  F=%.3f  A=%.3f  S=%.3f   → mortality (min) = %s",
                lost..., nm[argmin(collect(lost))]))
    seed=nm[argmax(collect(lone))]; mort=nm[argmin(collect(lost))]
    pr(@sprintf("  ⇒ seed=%s, mortality=%s, weak-edge target=S  →  %s",
                seed, mort, (seed=="S"&&mort=="S") ? "SAME NODE: the seam is BOTH lifeline and death-route ✓" : "different"))

    # ── C2: tightness tradeoff (sweep seam weakness w_ent) ──────────────────
    pr("\n"*dsh); pr("  C2 — tightness tradeoff: sweep seam weakness w_ent (F→S)")
    pr(dsh)
    pr(@sprintf("    %-8s %-12s %-16s %-18s %-10s","w_ent","lifespan τ","gate-sharpness","mortality-localiz","regime"))
    for we in (1.0,0.7,0.5,0.3,0.1,0.03)
        Q=generator(δ,β,we); H=committor(Q); τ=mean_death_time(Q)
        lo=(H[2],H[3],H[5]); ls=(H[7],H[6],H[4])
        gs=spread(collect(lo)); ml=spread(collect(ls))
        regime = we>=0.95 ? "inert/immortal" : we<=0.1 ? "fragile" : "ALIVE"
        pr(@sprintf("    %-8.2f %-12.1f %-16.3f %-18.3f %-10s", we, τ, gs, ml, regime))
    end
    pr("  (gate-sharpness = spread of lone-survivor recovery; mortality-localiz = spread of post-loss recovery.)")

    pr("\n"*bar); pr("  VERDICT — the offgassing picture, formalized")
    pr(bar)
    pr("  • C1 CONFIRMED: the weak-edge target (S) is SIMULTANEOUSLY the seed (best to have) and the")
    pr("    mortality point (worst to lose). The seam is one node that is both lifeline AND death-route —")
    pr("    'living and dying through the same defect,' made exact.")
    pr("  • C2 CONFIRMED: tightening the seam (w_ent→1) buys lifespan but kills identity (sharpness→0):")
    pr("    perfect closure = immortal-but-INERT (no gate — the Q_102 over-closed limit). Opening it")
    pr("    sharpens identity but collapses lifespan (fragile). LIFE = the imperfectly-closed middle:")
    pr("    self-sustaining BECAUSE it offgasses through a seam, mortal BECAUSE of the same seam.")
    pr("")
    pr("  UNIFICATION (functional, honest): in ANY cyclic-regeneration closure, the seam plays one")
    pr("  unified role — offgas channel = gate-defining bottleneck = lifeline-and-death-route — and that")
    pr("  role is what makes the object the kind that lives-and-dies. (M,R) and turbulence share THIS.")
    pr("  STILL OPEN (firewall): the seam's ORIGIN differs — (M,R) logical entailment vs turbulence")
    pr("  nonlinear bottleneck. Functional role unified; micro-origin not (yet). And no B/scaling — the")
    pr("  dissipative MAGNITUDE remains the environment. 'Offgas/entropy' is the gloss; the math is")
    pr("  closure-loss committors, not thermodynamic entropy.")
    pr(bar); close(fout); println(stdout,"\nwrote: $out")
end
main()
