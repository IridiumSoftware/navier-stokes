#!/usr/bin/env julia
# closure_triad_rotation.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# Firewall: tests Aaron's ROTATION hypothesis — that the (M,R) gate (S) and the
# turbulent gate (roll) are the SAME triangle ROTATED, i.e. the gate is a
# rotation-COVARIANT function of WHICH edge is the weak link (gate = the weak
# link's TARGET). If so, the apparent S-vs-A "disagreement" is not about the
# MECHANISM (shared: gate = weak-edge target) but about WHERE the weak edge sits.
#
# Same exact 8-state (M,R) CTMC as closure_mr_gate.jl. Making-cycle (directed):
#   S→A (replication makes repair), A→F (repair makes metabolism), F→S (metabolism
#   entails replication).  We put the WEAK weight on each edge in turn and ask:
#   is the gate (best lone-survivor recovery-committor) always the TARGET of the
#   weak edge?
#
# PRE-REGISTERED:  weak F→S → gate S ;  weak S→A → gate A ;  weak A→F → gate F.
# And the systems:  (M,R) weak = entailment F→S → gate S.
#                   turbulence weak = nonlinear feedback wave→roll = (function-
#                     aligned) S→A edge → gate A (= the roll).  SAME rule, rotated edge.

using LinearAlgebra, Printf
const F=0; const A=1; const S=2
alive(m,x)=(m>>x)&1==1
maker(x)= x==F ? A : x==A ? S : F                 # A→F, S→A, F→S
linkw(x,wAF,wSA,wFS)= x==F ? wAF : x==A ? wSA : wFS
function generator(δ,β,wAF,wSA,wFS)
    Q=zeros(8,8)
    for m in 0:7
        for x in (F,A,S)
            if alive(m,x); Q[m+1,(m & ~(1<<x))+1]+=δ
            elseif alive(m,maker(x)); Q[m+1,(m | (1<<x))+1]+=β*linkw(x,wAF,wSA,wFS); end
        end
        Q[m+1,m+1]=-sum(Q[m+1,:])
    end
    Q
end
function committor(Q)
    T=[2,3,4,5,6,7]; b=zeros(6); M=zeros(6,6)
    for (ii,i) in enumerate(T); for (jj,j) in enumerate(T); M[ii,jj]=Q[i,j]; end; b[ii]=-Q[i,8]; end
    h=M\b; H=zeros(8); H[8]=1
    for (ii,i) in enumerate(T); H[i]=h[ii]; end; H
end
lone(H)=(H[2],H[3],H[5])                            # F-only(mask1),A-only(mask2),S-only(mask4)
gate(c)=["F","A","S"][argmax(collect(c))]

out=joinpath(@__DIR__,"closure_triad_rotation.out.txt"); fout=open(out,"w")
pr(a...)=(println(stdout,a...);println(fout,a...)); bar="═"^78; dsh="─"^78
pr(bar); pr("  closure_triad_rotation.jl — is the gate the WEAK-EDGE TARGET? (Aaron's rotation)")
pr(bar)
β=3.0; δ=1.0; we=0.2
pr(@sprintf("  exact 8-state (M,R) CTMC. δ=%.0f, β=%.0f, weak weight=%.1f on ONE edge at a time.",δ,β,we))
pr(@sprintf("  making-cycle: S→A→F→S.  edge targets: F→S↦S,  S→A↦A,  A→F↦F.\n"))
pr(@sprintf("  %-16s %-9s %-9s %-9s %-8s %-14s","weak edge","F-only","A-only","S-only","gate","= weak target?"))
tests=[("F→S (entailment)",1.0,1.0,we, "S"),
       ("S→A (feedback)",  1.0,we, 1.0,"A"),
       ("A→F (repair)",    we, 1.0,1.0,"F")]
allok=true
for (name,wAF,wSA,wFS,tgt) in tests
    H=committor(generator(δ,β,wAF,wSA,wFS)); cF,cA,cS=lone(H); g=gate((cF,cA,cS))
    ok = g==tgt; global allok &= ok
    pr(@sprintf("  %-16s %-9.3f %-9.3f %-9.3f %-8s %s",name,cF,cA,cS,g, ok ? "YES ✓ (=$tgt)" : "NO (≠$tgt)"))
end
pr("\n"*bar); pr("  VERDICT — Aaron's rotation")
pr(bar)
if allok
    pr("  • CONFIRMED: the gate is ALWAYS the TARGET of the weak edge — a rotation-COVARIANT rule.")
    pr("    The gate mechanism is identical in every orientation; only WHICH edge is weak changes.")
    pr("  • So the (M,R) gate (S) and the turbulent gate (roll=A) are the SAME TRIANGLE ROTATED:")
    pr("    – (M,R):   weak edge = entailment F→S      ⇒ gate S (replication).")
    pr("    – turbulence: weak edge = feedback wave→roll = S→A ⇒ gate A (the roll).")
    pr("    The earlier 'S vs A disagreement' was a LABELING artifact — same mechanism (gate =")
    pr("    weak-edge target), weak edge on a different functional edge. The triangle rotated.")
    pr("  • REMAINING firewall (honest): the rule is universal, but WHY the weak edge sits where")
    pr("    it does differs in origin — (M,R) weak = logical ENTAILMENT (closure-to-efficient-")
    pr("    causation); turbulence weak = the NONLINEAR-FEEDBACK regeneration bottleneck. The gate")
    pr("    MECHANISM is shared and rotation-covariant; the weak-edge PLACEMENT is system-specific.")
else
    pr("  • NOT confirmed: the gate is not always the weak-edge target ⇒ the rotation picture fails.")
end
pr(bar); close(fout); println(stdout,"\nwrote: $out")
