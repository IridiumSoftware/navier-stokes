# Triad-witness brief — the NS-046 arc (Idea-3 complementarity + uniform-domination + the target)

**Panel:** Grok (edge-Φ, adversarial) + Gemini (synthesis, adversarial) + ChatGPT (NAIVE core witness).
**From:** Aaron + Claude (metabolism). **Date:** 2026-06-06. **Repo:** navier-stokes obstruction program.
**Outcome:** C1 refuted-as-general (IC-specific), C2 over-reach-corrected (data holds, "blocks the
reduction" removed), C3 refuted-as-established. See `ns046_arc_triad_verdict.md`.

**Your job is to REFUTE, not endorse.** These claims were recorded data-driven, un-witnessed. The author
has over-reached FIVE times this arc (four witness-refuted: LOW#1, MID, §5-"≡", NS-047-C1; one
probe-refuted: "pressure dominates ⇒ inequality"). Treat that as a strong prior. Default to "not
established" unless you cannot break it.

**Firewall.** All three claims are within-truncation DNS findings + an open-target statement. They assert
NO regularity result and NO bound on the PDE. :proved=0; distance UNTOUCHED. If any reads as more than
"observed in a regular Re=1600 truncation" / "a restatement of the open problem," call it.

## Background you need (self-contained — you do NOT need the repo spec)

This program maps obstructions to the 3D Navier–Stokes regularity problem; every claim is firewalled
(:proved=0; a model/truncation is never the PDE). What's relevant here:

- Regularity follows from controlling a CRITICAL (scale-invariant, σ=0) norm (Prodi–Serrin–ESS). A
  sufficient route is bounding ENSTROPHY ∫|ω|², whose growth is driven by the vortex-stretching
  PRODUCTION P = ∫ω·Sω = ∫|ω|²(ξ·Sξ), with ξ=ω/|ω|, S the strain. The only a-priori control (energy)
  is supercritical — useless at small scales; no energy-only method can work (Tao's averaged-NS).
- NS-046 (the open analytic target): a coercive σ=0 inequality in which the NONLOCAL pressure Hessian
  −e₃ᵀ(∇²p)e₃ (∇²p from the singular-integral Poisson solve −Δp = ∂_iu_j∂_ju_i) + viscosity dominate P,
  localized to Caffarelli–Kohn–Nirenberg (CKN) sets (the singular set has parabolic dimension ≤1).
- NS-047's "C2": the maximal-function absorption of the nonlocal pressure tail needs a LOCAL-REYNOLDS
  SMALLNESS that fails on the ≤1-D singular set (local Reynolds O(1)) — the obstacle is UNIFORMITY on
  the singular set. (The harmonic-analytic route is otherwise LIVE — critical Besov Ḃ⁰_{∞,1} escapes the
  Beale–Kato–Majda L^∞ endpoint.)
- NS-045: strong helicity depletes vortex stretching by BELTRAMIZATION (u∥ω suppresses the Lamb vector).
- e₃ = the eigenvector of the strain S with the largest eigenvalue λ₃; Dλ₃/Dt = −λ₃² − (vorticity term)
  − e₃ᵀ(∇²p)e₃ + ν(…), so e₃ᵀ∇²p e₃ > 0 DEPLETES the max stretch.

## The claims under witness

**C1 — Idea-3 complementarity.** NS-045 Beltramization (high H) and the NS-046 pressure-Hessian
counter-transport are COMPLEMENTARY depletion mechanisms, anti-correlated with helicity (pressure
dominant at the zero-helicity Kerr-tube worst case; control bursts most). N-converged 64↔128.

**C2 — uniform-domination finding.** Conditioning ⟨e₃ᵀ∇²p e₃⟩/⟨λ₃²⟩ and ⟨ν|∇ω|²⟩/⟨ω·Sω⟩ on
top-{100,10,1,0.1}% production: pressure ratio NEGATIVE on the bulk (enhances — Vieillefosse), positive
only at the extreme cores; viscosity ≪1 on the intense set. ⇒ non-uniform; "makes NS-047's C2 visible"
and "blocks the analytic pressure-dominates-⇒-inequality reduction."

**C3 — the NS-046 target framing.** The single irreducible difficulty of NS-046 is the non-uniformity;
route is LIVE (NS-047, Besov), gap = uniform domination on the CKN singular set.

## Adversarial seats — Grok + Gemini

**Q1 (LOAD-BEARING — relevance/vacuity).** The truncation is regular-by-construction; no singular set.
Does C2 bear on the ANALYTIC uniformity, or is it the LOW#1 VACUITY — a regular flow's intense set is not
a singular set? Could the coercive bound hold (Besov/cancellation) even if pointwise conditioned ratios
are non-uniform? If so "blocks the reduction" over-reaches.

**Q2 (sign/weighting/eigenframe robustness).** Is e₃ᵀ∇²p e₃>0 "depletes" right, and is the
"bulk-enhances/cores-deplete" split robust or conditioning-dependent (enstrophy-weighting vs
production-conditioning; Vieillefosse attribution)?

**Q3 (C1 IC-specific?).** The RANDOM control is also ≈zero-helicity yet does NOT show pressure dominance
(bursts most); only the symmetric Kerr-tube does. Is the complementarity general or a tube-artifact?

**Q4 (over-reach/scope/is C3 a result?).** Is "the irreducible difficulty IS the non-uniformity"
established or asserted? Is the "precise target" content or restatement? Where does the language exceed
"observed in a truncation"?

## Naive core witness — ChatGPT (cold read)
(N1) findings or restatements? (N2) which claim moves too fast? (N3) first objection? (N4) should the
truncation evidence tell us anything about the analytic inequality?
