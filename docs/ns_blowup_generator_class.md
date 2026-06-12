# NS — The admissible blow-up generator class (MDAGC synthesis)

**Date:** 2026-06-07. **A SYNTHESIS artifact — it reorganizes the existing ledger into one positive
object; it adds no new claim and is NOT PDE progress.** `:proved`=0; distance UNTOUCHED. Implements the
SPEC mission framing (generator-class reduction / search-space compression = ORSI's **MDAGC**, Minimal
Decontaminated Admissible Generator Class). Every external no-go carries its C0–C5 tier; each constraint is
labelled **hard** (theorem-backed impossibility) vs **soft** (current techniques fail / framing) vs
**witness** (within-truncation computational — heuristic), and **global** (a whole method-class) vs
**local**.

**The deepest standing caveat (meta-review §C.3, accepted):** the value of *this* document is exactly its
test — does assembling the constraints **compress the search space** (genuine), or merely produce an
**internally-coherent narrative** with weak external forcing (the structured-local-coherence hazard)?
Independent mathematical uptake, not internal elegance, decides. It is offered as compression; treat it as
a map of *assumptions*, not of *impossibilities*.

---

## 0. The frame

Let `G` = the set of configurations a hypothetical 3D-NS finite-time singularity could be. Each established
no-go is a **constraint** carving `G` down; a blow-up, if one exists, must lie in the intersection. The
compression is real to the extent the **hard** constraints (theorems) shrink `G`; the **soft** and
**witness** constraints narrow the *search heuristically* and may change representation. Below, `G#` =
hard, `S#` = soft, `W#` = witness.

---

## 1. HARD necessary conditions (theorem-backed — the genuine compression)

**G1 — Blows a critical (σ=0) norm.** A singularity at `T` forces `limsup_{t→T}‖u(t)‖_{L³}=∞`
(Escauriaza–Seregin–Šverák endpoint of Prodi–Serrin–Ladyzhenskaya), and indeed *every* critical Besov norm
`Ḃ^{-1+3/p}_{p,q}` (`1<p,q<∞`) blows up (Gallagher–Koch–Planchon).
- NS-005 / NS-016. **Tier: ESS C2; GKP C1** (secondary). **Global, hard.**

**G2 — Singular set is ≤1-D.** The singular set `S` has parabolic Hausdorff dimension ≤1 (`𝒫¹(S)=0`) —
a curve in space-time, not a region (Caffarelli–Kohn–Nirenberg).
- NS-006. **Tier: C2** (statement; `ε₀` constants C1). **Global, hard.**

**G3 — Not exactly self-similar.** No nontrivial backward `(−1/2)`-self-similar profile exists in `L³`
(Nečas–Růžička–Šverák) or in the weaker local-energy class, and asymptotically-self-similar singularities
are excluded too (Tsai). The cleanest backward construction is dead.
- NS-007. **Tier: NRŠ C2 (via Tsai's faithful reproduction) / Tsai C3 (line-read).** **Global, hard.**

**G4 — Type-I ⇒ a nontrivial ancient solution; else Type-II.** A first singular time is **Type-I**
(`sup_{t<T}√(T−t)‖u(t)‖_∞<∞`, or a bounded scaled local energy) **or Type-II** (strictly faster). Type-I
⇒ parabolic rescaling + CKN compactness extract a **nontrivial bounded mild ancient solution** on
`ℝ³×(−∞,0)` (KNSS, Prop 6.1), which by **G3** is *non-self-similar*. Albritton–Barker upgrade this to an
**equivalence — but Type-I-CONDITIONED** (`I<∞`, scaled-energy; *not* pointwise `C/√(T−t)`): NS-048 (Type-I
exclusion) ≡ the *Type-I-conditioned* ancient Liouville. The **unconditioned** ancient Liouville (the KNSS
conjecture) is strictly stronger and open. Type-II gives **no** compact rescaled limit.
- Albritton–Barker arXiv:1811.00502 **C3** (line-verified, Type-I-conditioned); KNSS Acta 2009 **C3**.
  **Global, hard** (with the conditioning made explicit — correcting the earlier "general Liouville"
  framing, v0.1.85).

**G5 — Not excludable by energy-only methods.** An *averaged* 3D-NS sharing the exact energy identity and
scaling **does** blow up (Tao). So no proof of regularity can use only the energy identity + scaling; any
successful exclusion must use finer nonlinear structure (vortex-stretching geometry).
- NS-008. **Tier: C2** (statement; the precise killed method-class C2, not line-verified). **Global, hard —
  a method-class exclusion.**

---

## 2. SOFT constraints (framing / reduction — narrow the search; representation may change)

**S1 — Supercritical descent failure.** The only coercive a-priori control, energy (`σ=−1`), is vacuous at
the small scales where a singularity lives; the regularity-deciding norms are `σ=0`; **no overlap**. This
is *why* G1 cannot be closed a priori — the controlled and deciding quantities sit on opposite sides of the
scaling quotient.
- NS-002 / NS-034. **Tier: C2+ consensus; exact exponents algebraic (in-repo).** **Global, soft.**

**S2 — The vortex-stretching production is the breaker.** Regularity ⟸ bounded enstrophy (`σ=+1`) ⟸
bounded production `P=∫ω·Sω=∫|ω|²(ξ·Sξ)` (the exact interpolation `‖u‖²_{Ḣ^{1/2}}≤‖u‖_{L²}‖u‖_{Ḣ¹}`, energy
always controlled). The only a-priori control is insufficient (G5). So the generator's enstrophy must be
a-priori unbounded — the `σ=+1` rung loses its Casimir (helicity alone, `σ=0` and sign-indefinite, does
not coerce it). The live attack object is therefore the production geometry, not energy.
- NS-036. **Tier: in-repo argued + algebraic (interpolation + ideal-flow Casimirs).** **Reduction (sufficient
  route, not unique framing).**

---

## 3. WITNESS constraints (within-truncation, computational — heuristic structure; weakest tier)

**W1 — The production is a phase-coherence object.** In the resolved DNS truncation, a random-phase
surrogate that preserves the full amplitude spectrum `|û(k)|` (hence `E,Z,H` exactly) and div-free, but
destroys the cubic/triadic phase coherence, **collapses the production `∫ω·Sω` ~97–99%** while the
controlled `L²` invariants are pinned to ~1e-16. ⇒ the generator's production cannot be carried by the
amplitude spectrum; it must live in a **phase-coherent, small-scale, intermittent** structure. (1D exact
analog: `∫g³≡0` on the one-sided/analytic-signal complex-blowup class — Fourier support.)
- NS-013 arc (`ns013_phase_production_3d.jl`, `ns013_phase_norm_split.jl`, `ns013_realcomplex_production.jl`).
  **Tier: in-repo computed, within-truncation (vacuity cap).** **Heuristic generator-structure.**

**W2 — Sharpest detector is the vorticity critical-Besov.** Of the `σ=0` norms that all must blow (G1), the
generator is seen sharpest by `‖ω‖_{Ḃ⁰_{∞,1}}` (and `‖ω‖_∞`), bluntest by the velocity `‖u‖_{L³}` (the
theorem-norm), on a resolved reconnection — the small-scale-vorticity-weighted critical norms, consistent
with G2 (≤1-D / localized) and W1 (small-scale phase coherence). Practical: monitor `Ḃ⁰_{∞,1}`/`‖ω‖_∞`.
- `ns046_critical_norm_race.jl`. **Tier: in-repo computed, within-truncation.** **Heuristic (detector
  selection).**

---

## 4. ② Is the phase-blindness (W1) a NEW hard method-exclusion, or a soft sharpening of S1?

The adversarial sub-test (could W1 upgrade to a `G`?). **Verdict: it sharpens S1; it does NOT become a new
hard method-exclusion — the "phase-blind methods cannot work" reading is declined (a declined over-reach;
the soft≠hard rule — the program over-reach ledger is maintained centrally in `changelog.md`).**

- **What is rigorous (a genuine sharpening of S1).** The phase-scramble is an explicit **counterexample
  family**: divergence-free fields with *identical* `(E,Z,H` and full amplitude spectrum `|û(k)|)` whose
  production `P=∫ω·Sω` differs by ~30×. So `P` is provably **not a function** of the coercive quadratic
  invariants, nor of the amplitude spectrum. This is stronger than NS-002's *scaling* argument: not merely
  "energy is supercritical," but "the entire coercive/spectral information fails to determine the
  production, with a concrete witness family," and it **broadens** the heuristic from *energy* to *any
  amplitude-spectrum quantity*. The counterexample is elementary and re-derivable (**~C4**).
- **Why it is NOT a hard `G` (the over-reach declined).** A regularity *method* controls `P` through the
  **time-evolution** (which encodes phase information indirectly), not from the **instantaneous** spectrum.
  The phase-scramble counterexample is instantaneous; it shows `P` is not an instantaneous function of the
  coercive invariants, which is a *refinement of S1*, **not** a dynamic exclusion of a method class. Any
  spectral bound on `P` must be the worst-case-over-phases (achieved by maximally-coherent fields) — finite
  but not improved by the coercive information; that is the precise content, and it stays *soft*.
- **Net:** W1 is promoted from a standalone curiosity to a **counterexample-backed sharpening of S1**
  (global, soft) — the supercriticality framing now carries an explicit witness family showing the
  controlled invariants cannot determine the production. It is **not** a new hard method-exclusion, and
  claiming so would conflate instantaneous insufficiency with dynamic impossibility (the soft≠hard rule).

---

## 5. The admissible generator class, assembled

> **A 3D-NS finite-time singularity, if one exists, must be a configuration satisfying
> `G1 ∧ G2 ∧ G3 ∧ G4 ∧ G5`** — i.e. a **non-self-similar (G3), ≤1-D-concentrated (G2),
> critical-norm-blowing (G1), energy-method-invisible (G5)** event that is **either a nontrivial
> Type-I-conditioned bounded mild ancient solution or a Type-II event (G4)** — sitting inside the framing
> `S1` (controlled energy can't reach it) `∧ S2` (its driver is unbounded vortex-stretching production),
> with heuristic structure `W1` (the production lives in small-scale phase coherence, invisible to the
> controlled invariants) `∧ W2` (sharpest-seen by the vorticity critical-Besov norm).

**What is dead (the compression, in one line):** energy-/spectrum-only methods (G5, S1, W1·sharpened),
exact self-similar profiles (G3), and any region-filling singularity (G2). **What any live attack must
engage:** the production geometry at `σ=0` (S2 → the NS-046 static frontier) **or** the ancient/Type-II
rescaled objects (G4 → the NS-048 dynamic frontier).

### 5a. The what-NOT-to-do checklist (the dead-ends triple {NS-007, NS-008, NS-020}, made explicit)

Before any 3D attack design, check it is **none** of these — each is a mapped dead-end with a named killer:

- [ ] **Not exact self-similar** — NRŠ/Tsai delete the `(−1/2)`-self-similar profile in `L³` (NS-007, G3).
      A DSS (discretely-self-similar) variant must engage the DSS-removal conditions (arXiv:1610.09464).
- [ ] **Not energy-only** — Tao's averaged-NS blows up with every energy-class estimate intact (NS-008, G5);
      any method surviving the averaging cannot prove regularity.
- [ ] **Not spectrum-only** — the production `∫ω·Sω` is invisible to `E(k)` and every quadratic invariant
      (W1: phase-scramble kills 97–99% of it with the spectrum fixed); spectral hypotheses alone carry no
      production control.
- [ ] **Not topology-only** — our own falsified arc (NS-020): discrete homology/Betti diagnostics carry no
      regularity signal (`b₁` identical for blowup and regular flows).
- [ ] **Not region-filling** — CKN bounds the singular set's parabolic dimension ≤1 (NS-006, G2); any
      mechanism needing a fat singular set is excluded.
- [ ] **Not pointwise-domination** — the NS-046 probes show the pressure-Hessian depletion is non-uniform
      (bulk-negative); pointwise coercivity is the wrong form, and any *integral* form must state its weight
      and measure against the FEED `¼(|ω|²−(ω·e₃)²)`, not `λ₃²` (triad-trimmed, 2026-06-11).

---

## 6. The two holes where the class is still non-empty (= the prize)

- **Hole A (static / NS-046):** control the production `P` at `σ=0` (the critical coercive deformation
  inequality; critical-Besov route live per NS-047) — equivalently bound the `σ=+1` rung uniformly.
- **Hole B (dynamic / NS-048):** exclude the ancient solution (general/unconditioned Liouville beyond the
  Type-I-conditioned Albritton–Barker equivalence; only 2D + restricted axisymmetric closed) **and** the
  Type-II branch (no compact limit; modulation theory; fully open).

These are *one wall through two structures* (NS-046 the inequality, NS-048 the exclusion). Closing the
generator class = emptying both holes = the prize. The map says the surviving generator is heavily
constrained but **non-empty** — `:proved`=0.

---

## 7. Honest scope

This is **reorganization, not progress.** The hard constraints (G1–G5) are others' theorems, tier-tagged
(several C1/C2 — the universal force is gated by `tier × independence × scope-match`); the soft constraints
(S1–S2) are framings; the witness constraints (W1–W2) are within-truncation (vacuity cap — a regular
truncation cannot reach the singular limit, so they bound *structure heuristically*, never certify it). The
single deliverable is the **compression** (what is dead, what must be engaged) and the **home** it gives
the recent NS-013/046 arc as *generator-structure constraints* rather than standalone witnesses — directly
answering the structured-local-coherence critique by subordinating the local findings to the
necessary-conditions object. Whether this is genuine compression or coherent narrative is decided by
independent uptake, not by this document. `:proved`=0; distance to the prize UNTOUCHED.
