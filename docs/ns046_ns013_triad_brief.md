# Adversarial triad brief (two parts) — NS-046 integral-cancellation finding + NS-013 consolidated reduction

**You are an adversarial referee. Your job is to REFUTE.** Default verdict for every claim below is
**"NOT established."** Promote only if you cannot find an error, over-reach, hidden assumption, vacuity, or
missed alternative after genuinely trying. Be especially hostile to (i) within-truncation results being read
as more than witnesses (every probe here is a *resolved, regular* DNS — no singular set exists; the vacuity
cap is load-bearing), (ii) "the apparent X is an artifact of Y" narratives (they can themselves be artifacts
of the chosen Y), (iii) results that restate textbook facts in program vocabulary, and (iv) single-fixture /
single-resolution / single-snapshot generalizations.

Self-contained; do not assume the author is right. Two independent parts — verdict each separately.

---

# PART 1 — NS-046: the integral / cancellation finding

## 0. Background (established; assume given)

NS-046 (the static hole): prove that the nonlocal pressure-Hessian counter-transport `−e₃ᵀ(∇²p)e₃` plus
viscous dissipation coercively dominates strain self-amplification at critical scaling on CKN sets — an OPEN
analytic target ("needs an idea the program does not have"; 6 prior over-reaches caught on this entry).

Prior within-truncation probes (Kerr anti-parallel vortex tubes, ~zero helicity = the worst case for the
helicity safety-valve; resolved pseudospectral DNS, Re=1600, N=64↔128 where stated):
- **Idea-3:** enstrophy-weighted ⟨e₃ᵀ∇²p e₃⟩/⟨λ₃²⟩ ≈ 1.5–11× over the run (N-converged 64↔128) — the
  depletion mechanism is real *in aggregate*.
- **Uniform-domination:** but conditioned on production intensity, the UNWEIGHTED conditional-mean ratio is
  **negative on the bulk** (pressure *enhances* stretch — Vieillefosse) and turns positive only at the
  top-0.1% `|ω|` cores; viscosity ≪1 on the intense set.
- **Sign Required-Check (CLOSED, algebraic — sympy + exact-rational Julia):**
  `Dλ₃/Dt = −λ₃² + ¼(|ω|²−(ω·e₃)²) − e₃ᵀ(∇²p)e₃ + ν e₃ᵀ(ΔS)e₃` (λ₃ simple). The convention
  `e₃ᵀ∇²p e₃>0 ⇒ depletes` is machine-verified correct. You may trust this chain; challenge its *use*.

**The new probe** (`ns046_integral_cancellation_probe`, N=64, ONE snapshot at the enstrophy peak t=6):
the PRODUCTION-WEIGHTED integral `R_int = Σ_w(e₃ᵀ∇²p e₃ + ν|∇ω|²)/Σ_w(λ₃²)`, `w=|ω|²`, letting
bulk-negatives and core-positives cancel. Results: `R_int(full) = 2.42` (pressure part 1.52, viscous 0.90);
on top-q `|ω|²` sets it *strengthens*: top-10% 2.47, top-1% 3.05, top-0.1% 3.81. Scale-resolved (binned by
local `k_loc=|∇ω|/|ω|`): R_int ≈ 2.49 (large scales) → ~1.39–1.49 (mid) → 1.73 (smallest bin), i.e. shrinks
toward 1 but stays >1.

## 1. The claims to refute

**P1-C1 (weighting-artifact reading).** "Much of the apparent non-uniformity [from the uniform-domination
probe] is a WEIGHTING ARTIFACT: the production weight `|ω|²` concentrates on the cores where the pressure
term is favorable, so the integral form — the form the inequality actually takes — dominates (R_int≥1)."
*(Attack: is `w=|ω|²` the right weight for "the form the inequality takes"? The production is `ω·Sω`, not
`|ω|²`; a different physically-motivated weight (|ω·Sω|, |λ₃||ω|², strain-energy) could reverse the verdict.
Is calling the non-uniformity an "artifact" itself an artifact of choosing the favorable weight?)*

**P1-C2 (scale-margin reading).** "The scale-resolved margin shrinking toward 1 at small scales locates the
analytic difficulty (marginal cancellation at critical scaling) at the small/singular scales."
*(Attack: the smallest bin UPTICKS to 1.73 (non-monotone); `k_loc=|∇ω|/|ω|` is a crude local-scale proxy;
in a regular truncation the small-scale margin is forced >1 by viscosity anyway (smallness "as it must") —
does this bin trend carry ANY information beyond the vacuity cap?)*

**P1-C3 (single-everything).** The probe is ONE fixture (Kerr tubes), ONE snapshot (enstrophy peak), ONE
resolution (N=64), with NO N-convergence check — unlike the prior probes (64↔128). *(Attack: pre-flagged by
the author. Is any reading at all licensed before an N-trend and a second fixture? Or is the honest verdict
"suggestive single-point, unconverged"?)*

**P1-C4 (the sharpening).** "For λ₃ itself, −λ₃² is self-DAMPING and the vorticity term ¼(|ω|²−(ω·e₃)²) is
the growth feed; 'strain self-amplification of λ₃' is loose phrasing, though R=⟨pressure⟩/⟨λ₃²⟩ remains a
sensible magnitude comparison." *(Attack: is the "λ₃² remains a sensible scale" save itself loose? If the
feed is the vorticity term, should the domination target be restated against ¼(|ω|²−(ω·e₃)²) instead of λ₃²
— and would the probes' R≥1 verdicts survive that restatement?)*

# PART 2 — NS-013: the consolidated reduction

## 0. Background (established; assume given)

NS-013 asked whether complex-data blowup (Li–Sinai) informs real-data regularity. The original obstruction-map
was **triad-refuted and withdrawn** (recorded). The surviving `:argued` reduction (post-witness, NOT
re-witnessed — that is what you are now doing): *reality's Hermitian phase constraint per se supplies no
protection (real turbulence is the prototypical strong cascade); the regularity-relevant protective direction
reduces to the EMERGENT geometric depletion — the Constantin–Fefferman(–Majda)/Hou–Li conditional criterion
(vorticity direction ξ=ω/|ω| regular where |ω| is large ⟹ no blowup; conditional, unproven for general data).*

Two witnesses now support it (both resolved DNS, vacuity-capped):
- **Claim-1 witness** (`ns013_phase_production_3d`, N=64, TG + helical, 5 seeds): a phase-scramble preserving
  the spectrum AND all quadratic invariants (E, Z, helicity to ~1e-16, div-free) removes **97%/99%** of the
  production `∫ω·Sω` and relaxes alignment c²_int 0.63→0.36. Production is a phase-coherence object.
- **Claim-2 witness** (`ns013_cfm_conditioned_probe`, N=64, Kerr tubes, enstrophy peak): enstrophy-weighted
  direction-roughness `⟨|∇ξ|²⟩_w` conditioned on `|ω|`-intensity: full 369 → top-10% 246 → top-1% 165 →
  **top-0.1% 212**. Cores are SMOOTHER than bulk (ratio 0.57) — CFM-regular-leaning — but note the
  **1%→0.1% UPTICK (165→212, +28%)**, pre-flagged. N-trend GPU-deferred (single resolution!).

## 1. The claims to refute

**P2-C1 (claim-1 is non-trivial).** "The 97–99% production collapse under invariant-preserving phase-scramble
establishes that the production lives in reality's dynamical phase coherence — supporting the reduction."
*(Attack the triviality reading: a cubic functional of a phase-randomized field vanishing is close to the
textbook fact that odd moments of Gaussian/phase-random fields vanish. Is this witness ANY evidence for the
*reduction*, or a calibrated restatement of Gaussianity? What would a NEGATIVE result even have looked like?)*

**P2-C2 (claim-2's reading).** "ξ is comparatively smooth where |ω| peaks (ratio 0.57 vs bulk) — the
CFM-regular-leaning, geometrically-organized scenario." *(Attack: (a) the 165→212 core UPTICK — is the
extreme-core trend actually ROUGHENING, with the 0.57 headline cherry-picking the bulk comparison?
(b) single resolution N=64, no N-trend — the NS-039 lesson is that exactly such readings lift with N;
(c) smoothing by |ω|-conditioning has a kinematic confound: high-|ω| regions are tubes whose cores are
locally laminar-aligned almost by construction — does ⟨|∇ξ|²⟩ low there say anything CFM-relevant?)*

**P2-C3 (the reduction itself).** "NS-013's protective direction reduces to the emergent CFM/Hou–Li geometric
depletion — not to reality-as-energy nor reality's phase symmetry." *(Attack: is this a *reduction* or a
*relabeling* — CFM is a known conditional criterion for ALL of NS regularity; saying 'the protective direction
is CFM' may be content-free (true of any flow) unless the complex⇏real comparison adds discriminating content.
What, specifically, does the NS-013 (complex-data) angle contribute that plain CFM-for-real-NS does not?)*

**P2-C4 (consolidation status).** "The surviving reduction is `:argued` + witness-supported." *(Attack: do
the two witnesses actually support the REDUCTION, or only its uncontroversial halves — (1) phases matter,
(2) cores are organized? If the load-bearing step (protective direction ⟶ CFM specifically) is untouched by
both witnesses, the honest status is `:argued` + two adjacent witnesses, support unestablished.)*

---

## 2. What to return

For EACH of P1-C1..C4, P2-C1..C4: a verdict in {REFUTED, NOT ESTABLISHED, CORRECT-AS-STATED} with the specific
error / over-reach / hidden assumption / counterexample / missed alternative — or why you genuinely cannot
break it. Highest-priority targets: **P1-C1** (the weight choice), **P2-C2(a)** (the core uptick), **P2-C3**
(reduction vs relabeling). Flag anything that, if correct, would constitute PDE progress — that would mean it
is wrong (`:proved`=0 stands; every result here is a witness).

## 3. Internal pre-screen (Claude; confirmation-bias-prone — verify, challenge, find what it MISSED)

- **P1-C1: lean CORRECT-with-caveat.** `w=|ω|²` is the enstrophy density — the natural weight for the
  enstrophy-production route — but I did NOT test alternative weights; the "artifact" phrasing should perhaps
  be "weight-dependent". *Test: would |ω·Sω|-weighting flip R_int<1?*
- **P1-C2: lean NOT ESTABLISHED** (the small-scale bin upticks; viscous floor confounds; the "difficulty
  locus" reading may be vacuous in a regular truncation).
- **P1-C3: agree — unconverged single-point**; flagged at creation. The N-trend + second-fixture run is the
  fix if the seats deem the finding worth it.
- **P1-C4: the restatement question is genuinely open** — I do not know whether R against the vorticity-feed
  term survives; nobody has computed it.
- **P2-C1: vulnerable to the triviality reading** — my §3 anchor ("skewness vanishes for Gaussian fields")
  already concedes most of it; the non-trivial residue is quantitative (97% vs 100%, helicity held exactly).
- **P2-C2: the uptick is real and my headline glossed it** (pre-flagged here); single-N stands.
- **P2-C3: this is the load-bearing claim and the hardest** — my honest answer to "what does the complex
  angle add" is thin: the 1D Fourier-support mechanism (∫g³≡0 one-sided) is the only genuinely complex-side
  input, and it does not transfer to 3D except as analogy.
- **P2-C4: likely the honest landing** — "two adjacent witnesses" may be the right downgrade.
