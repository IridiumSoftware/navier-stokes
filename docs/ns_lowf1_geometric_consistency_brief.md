# Triad-witness brief — LOW #1 geometric-consistency ({NS-013, NS-039, NS-040})

**To:** Grok (edge-witness Φ) and Gemini (synthesis). **From:** Aaron + Claude (metabolism).
**Date:** 2026-06-05. **Repo:** navier-stokes obstruction program.

**Your job is to REFUTE, not endorse.** Validators (you, and Claude's own endorsements) tend to
pass plausible arguments uniformly — we have seen this fail in this program. Assume the claim below
is *wrong somewhere* and find where. "Sound / elegant" is useless; we want the strongest counter,
the hidden assumption, the proxy wearing the real object's clothes. Default to "refuted / not
established" unless you cannot break it.

**Firewall (do not cross; flag us if WE cross it):** this is an *obstruction-map* corollary about a
famous open problem (3D NS regularity). It claims **no** regularity-or-blowup result. `:proved`=0.
The DNS evidence is a *resolved, viscous, regular-by-construction truncation* (Re=1600), NOT the PDE.
If any part reads as a step toward the Clay prize, that is over-reach and you must call it.

---

## The claim under witness

**The reduction (NS-013, already :argued).** Real-data regularity, in its witness-survivable form,
reduces to the **Constantin–Fefferman / Hou–Li geometric depletion**: control of the vorticity-
direction field ξ = ω/|ω| (smooth ξ where |ω| is large ⟹ the stretching term ω·Sω is depleted ⟹
no blowup). Conditional, **open**.

**The geometric-consistency lemma (what we want broken).** The depletion that CFM/Hou–Li *requires*
is **exhibited, and controllably strengthened, in the resolved DNS** — three independent measurements
all pointing the *depleting* way:
  (i)  NS-038: the strain–vorticity alignment c²_int = cos²(ω, e_int) peaks at 0.72 at the stretching
       maximum and then RELAXES ("Hou–Li depletion observed directly");
  (ii) NS-039: at the worst structure (vortex-tube reconnection) the intense-production set does NOT
       concentrate to ≤1-D — the D30→0.99 touch was a RESOLUTION ARTIFACT (lifts to 1.426 at N=512;
       N-convergence runs upward, away from 1);
  (iii) NS-040: a geometric constraint (helicity) demonstrably DEPLETES stretching (enstrophy grows
       2–4× slower) — depletion is not just observed but can be dialed up.
We claim: theory and our own data agree — and we claim this is a CONSISTENCY ONLY, with zero PDE
purchase (the DNS cannot blow up; CFM/Hou–Li is conditional-and-open; NS-039 shows resolution can
fake either sign).

**The sharpened sub-question we want adjudicated.** The blowup-relevant quantity is not the *peak*
alignment but the **conditional persistence in time of the strain–vorticity alignment on the intense-
production set, and its trend with resolution/Re.** Decisive probe: does conditional-alignment-
persistence CONVERGE as N/Re rise (depletion structural — bad for a singular scenario) or DRIFT toward
de-alignment (depletion weakening — a crack worth chasing)?

---

## Pre-registered witness questions (answer each; try to break it)

**Q1 (vacuity — for Grok edge-Φ).** The DNS is regular-by-construction, so it MUST deplete (else it
would blow up). Does the observed depletion carry ANY information beyond "this regular flow is
regular"? Is the lemma FALSIFIABLE by these flows — is there a measurement outcome that would have
refuted the CFM/Hou–Li picture — or is "agreement" empty (necessary-not-sufficient dressed as
support)? Find the strongest sense in which it is informative, or state precisely why it is vacuous.

**Q2 (proxy / category-fit — for Gemini synthesis).** CFM's rigorous criterion is about the SMOOTHNESS
of the vorticity-direction field ξ (control of ∫|∇ξ|²|ω| where |ω| is large); Hou–Li is about
cancellation in the nonlinear term. We measure the POINTWISE alignment c²_int = cos²(ω, e_int) and a
box-dimension. Are these the same object, or a proxy that can agree with CFM/Hou–Li while missing the
actual hypothesis? Concretely: could c²_int relax (look depleting) while ∇ξ blows up (CFM violated)?
Could the production set stay ≳1.4-D while ξ develops a singular kink? Find the gap or close it.

**Q3 (is the sub-question decidable? — both).** We propose conditional-alignment-persistence and its
N/Re-trend as the discriminator. (a) Could persistence converge at EVERY reachable N/Re yet still fail
in the singular limit — i.e., is the probe structurally unable to settle the question (an
unfalsifiable will-o'-the-wisp)? (b) If it instead DRIFTS, is that distinguishable from ordinary
under-resolution (the NS-039 trap in reverse — a fake de-alignment from too-coarse a grid)? State
what trend would count as a genuine crack versus an artifact, or argue no trend can.

**Q4 (does NS-040 actually CUT AGAINST us? — both).** Helicity is our "causal lever," but helicity is
itself a SPECIAL geometric constraint, and a generic/worst-case blowup scenario need not be helical.
Does "a special constraint can be tuned to deplete stretching" support GENERIC depletion (the
blowup-relevant case), or the opposite — that depletion is a FEATURE OF SPECIAL, CONSTRAINED FLOWS and
could be ABSENT in the unconstrained worst case? Make the strongest case that NS-040 REFUTES the
consistency lemma (depletion needs a crutch; remove it and stretching is less restrained).

Return: per-question verdict (refuted / holds-under-attack / can't-decide-here) with specific
reasoning. If you converge with the other seat, say so explicitly — we will still treat convergence
as "broad/generic" until it survives this adversarial pass (cf. NS-024). And flag any place WE have
crossed the firewall (read the consistency as PDE evidence).
