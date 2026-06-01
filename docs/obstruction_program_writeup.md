# An Obstruction Program for 3D Navier–Stokes
### A map of the walls — and what the residue is saying

**Aaron Green** (with Claude, metabolism seat). 2026-06-01. Repository:
`navier-stokes` (private; obstruction-program ledger NS-001..034). Companion to
the per-result docs in `docs/` and the spec in `SPEC.md`.

---

## 0. The honest frame (read this first)

This is **not** a claimed advance on the Clay Millennium problem. It is a *map*:
a disciplined account of **where the walls are, why every classical handle slides
off them, and what structural pattern keeps recurring** when you push from many
directions at once.

The entire program runs behind one rule — **the Scope firewall**: a model, a
truncation, or an analogy is never conflated with the PDE. Every claim carries a
`Scope` (`PDE` / `PDE-method` / `ODE-truncation` / `1D-model` / `abstract-closure`
/ `geometry` / `analogy` / `external-theorem` / `methodology`), and only a
`Scope: PDE`, `:proved` result could ever count as prize progress. **There is
none. `:proved` = 0, by design. Distance to the prize: UNTOUCHED.** Where this
document gets excited, it is excited about *structure* and *method*, never about a
breach of that line — and it flags, explicitly, the one place where enthusiasm
must be held in check by external witnessing (§6).

What the program *did* produce: a falsified path, a validated diagnostic with its
limits charted, two honest null results that refuse false positives, a geometric
account of the obstruction from three independent directions that all land on the
same wall, and a calibration — confirmed repeatedly — of how little an unwitnessed
cross-domain analogy is worth here.

---

## 1. The problem and the method

3D incompressible Navier–Stokes on 𝕋³/ℝ³, smooth finite-energy data, zero (or
Schwartz) forcing: prove global-in-time smoothness *or* a finite-time singularity
(NS-001). 2D is solved; 3D is open.

**Method (the obstruction program).** Maintain an evidence-tiered ledger:
*obstructions* (the walls any proof must respect), *diagnostics* (computable
detectors), *falsified* approaches, *live* directions, and *results* — each with a
logic tier, an evidence type, a status, and a Scope. The point is not to attack the
problem head-on but to **chart the terrain so precisely that the shape of the
difficulty becomes legible** — and to record, honestly, every path that doesn't
work. (Method detail: `CLAUDE.md`; the ledger: `SPEC.md`; evidence: `artifact_registry.md`.)

---

## 2. The walls (the obstruction ledger)

The classical obstructions, as cited theorems (`:cited`) and one argued structural
fact (NS-002):

- **NS-002 — Supercriticality of the energy norm (THE central wall).** Under the
  scaling symmetry `u↦λu(λx,λ²t)` the controlled energy is asymptotically useless
  at small scales. *Argued; made exact in §5.*
- **NS-003 — Leray–Hopf.** Global weak solutions + the energy inequality control
  *size*, not pointwise derivatives. The only coercive a-priori global control.
- **NS-004 — Beale–Kato–Majda.** Blowup ⟺ `∫₀ᵀ‖ω‖_∞ = ∞`: any singularity
  *requires* unbounded vortex stretching.
- **NS-005 — Prodi–Serrin–ESS.** A critical-norm bound (`2/p+3/q≤1`, endpoint
  `L^∞_tL³_x`) ⇒ regularity. Reduces the problem to controlling a *critical* norm —
  which NS-002 says we cannot do a priori.
- **NS-006 — Caffarelli–Kohn–Nirenberg.** The singular set has parabolic Hausdorff
  dimension ≤ 1.
- **NS-007 — No exact self-similar blowup (Nečas–Růžička–Šverák).** The cleanest
  "assume it blows up and read off the profile" construction is dead.
- **NS-008 — Tao's averaged-NS blowup.** An averaged equation sharing the exact
  energy identity + scaling *does* blow up ⇒ no proof can use energy + scaling alone.
- **NS-009 — Onsager 1/3.** The anomalous-dissipation threshold; energy conserved
  above Hölder-1/3 (CET), dissipative Euler solutions below it (Isett; BDLSV).

A first attempt to recast the problem in topology — **NS-020, a homological
reformulation — was FALSIFIED**: on fixed domains the Betti number `b₁` is pinned
under refinement and grows only under topology change; the genuine difficulty lives
entirely in the *norm* (NS-002), which homology cannot see. (Repair-cost turned out
to equal `1/vorticity` exactly.) A clean negative that re-diagnosed where the
difficulty is *not*, and pointed at the live handle: the complex plane.

---

## 3. The diagnostic — validated, and its limits charted (NS-010/011)

The **analyticity-strip width** `δ(t)` = the exponential decay rate of the Fourier
spectrum = the distance to the nearest complex-space singularity; `δ(t)→0` in finite
time *is* loss of analyticity / approach to a singularity (Foias–Temam; Sulem–Sulem–
Frisch). The "assume it blows up and work backward" instinct, made rigorous in the
complex plane (and motivated by Li–Sinai's *proved* finite-time blowup for **complex**
data, NS-012 — with the real⇐complex implication open, NS-013).

It was validated two-sided against ground truth, then its reach was charted honestly:
- **1D, exact:** inviscid Burgers — spectrum-fitted `δ(t)` matches the closed form
  `arccosh(1/t)−√(1−t²)` to ≤4.1%, shock 3/2-law recovered.
- **1D blowup:** Constantin–Lax–Majda (`ω_t=ωH(ω)`, the vortex-stretching analog) —
  `δ=ln(2/t)` reproduced; `δ→0` co-diverges with the BKM integral at `t*=2`.
- **2D regularity control:** 2D Euler/NS — `δ` bounded, BKM finite, invariants
  conserved <1e-6. The diagnostic correctly says *regular* when the answer is regular.
- **3D control:** the 3D solver (rotational form + Leray projection, hand-rolled
  hermetic FFT) validated by exact conservation of **energy AND helicity** (the
  3D-specific Tier-1 invariant); viscous Taylor–Green reports regularity (δ bounded,
  BKM finite).
- **The charted limit (load-bearing).** In the *inviscid, under-resolved* regime —
  exactly where a singularity would live — the exponential-slope `δ`-fit is **not
  resolution-robust**: it tracks the widening fit band over a developing power-law
  range, drifting *down* with resolution rather than converging. Found at N∈{16,32,64},
  then **confirmed at N=128** (a 2× push, 8× the grid, multithreaded): the fit
  disagreement *grew* with resolution (up to 73%), and pushing N did **not** rescue it.

---

## 4. The hunts — honest nulls (NS-032)

With the tool trusted, the disciplined order was *control before blowup*:
- **Step 1 (control):** the 3D solver validated on known-regular flows. Passed.
- **Step 2 (blowup candidate):** inviscid Taylor–Green (the canonical Euler
  near-singularity probe), with three gates — *resolved* (energy conserved), *converged*
  (`δ` agrees across N), *co-moving* (`δ→0` with BKM→∞). `δ` narrowed but **G2 failed**
  (the fit fragility) and **G3 failed** (`δ` bottomed well above 0; BKM finite). **Verdict:
  INCONCLUSIVE** — the gates correctly flagged a resolution-limited cascade rather than
  pass a false positive.
- **Step 2 at high resolution (N=128, "for fun"):** the resolution wall moved cleanly
  later with N (`t_res ≈ 3.0 / 4.26 / ≥5.0`), but the verdict was unchanged in kind — a
  *higher-resolution INCONCLUSIVE*. A vivid, hands-on demonstration of why the real
  near-singularity studies need N≳512–4096 on supercomputers, and why this is genuinely
  hard rather than merely under-computed on a laptop.

These nulls are the firewall working: a numerical near-blowup that is not N-converged
and not co-moving with BKM is a resolution artifact, not a result — and the program
says so.

---

## 5. The geometric capstone — three routes, one wall

Instead of more time-stepping into the resolution wall, the program turned to the
*geometry* of the state space — exact, no resolution wall (Arnold's picture: ideal
flow is geodesic motion / Lie–Poisson flow on the volume-preserving diffeomorphism
group, with the state space foliated by the physical invariants). The striking
result: **the obstruction shows up identically from three independent directions.**

**(a) Scaling / criticality (NS-034, exact).** The dilation `D_λ` assigns every
homogeneous norm an exact rational exponent, `‖u_λ‖_X = λ^{σ_X}‖u‖_X`:
`σ(L^q)=1−3/q`, `σ(Ḣ^s)=s−½`, `σ(L^p_tL^q_x)=1−3/q−2/p` (verified numerically,
continuous λ). The **critical** (`σ=0`, scale-invariant) class — `L³`, `Ḣ^{1/2}`,
`BMO⁻¹`, the **Prodi–Serrin locus `2/p+3/q=1`** *exactly* — is precisely what
descends to the non-compact dilation quotient. The a-priori-**controlled** quantities
(energy, dissipation) have `σ=−1` (**supercritical**): a bound on them is *vacuous as
λ→∞*. Supercriticality, made exact, is a **descent failure** — controlled norms `σ<0`,
regularity-deciding norms `σ=0`, *no overlap*. This unifies NS-002 ↔ NS-005.

**(b) Coadjoint orbits / the Casimir deficit (Slice 6, exact).** Vorticity is
frozen-in (Lie-dragged); a solution never leaves the isovortical sheet of its initial
vorticity. The 2D/3D gap is a **deficit in the Casimirs** (the rigid orbit-invariants):
- 2D Euler conserves the **whole `∫f(ω)` family** (∞ Casimirs) — verified, ∫ω², ∫ω⁴,
  ∫|ω|, max|ω| to 1.000000 and the sorted vorticity distribution preserved; the flow
  only *rearranges* ω ⇒ enstrophy bounded ⇒ rigid orbit ⇒ **regular**.
- 3D Euler conserves essentially **only helicity** (the topological Casimir — Moffatt's
  vortex-line linking, verified to 1.000000) but **∫|ω|² grows ×6, max|ω| ×3.6**
  (vortex stretching) ⇒ loose orbit ⇒ **open**.

**(c) Curvature / unpredictability (Slices 4–5, verified).** The reduced helical triad
*is* the Euler rigid body (a coadjoint sphere, Slice 1): the middle leg is the unstable
saddle = the cascade donor. Its configuration group has a **negatively curved plane**
(Koszul sectional curvature, verified κ≡¼ on the bi-invariant control). The ∞-dim
sibling — SDiff(T²) — is **predominantly negatively curved** (census: 84% negative
[Arnold] / 9% positive [Misiołek], both reproduced; parallel modes give exactly C=0).
Negative curvature ⇒ exponential divergence of nearby fluid motions = Arnold's ~2-week
weather-predictability horizon.

**The synthesis.** *Enstrophy non-coercivity* (`physical_invariants.md`), *energy
supercriticality* (a), and the *Casimir deficit* (b) are not three coincidences — they
are **one structural fact** (the loss of small-scale control under the 3D nonlinearity)
wearing three geometric costumes. Curvature (c) is why even the resolved dynamics are
Lagrangian-unpredictable. The geometry says the obstruction is **structural, not
incidental** — which is exactly why no single classical handle closes it.

*(All of §5 is `Scope: geometry` / ideal-flow — not the 3D-NS PDE; viscosity breaks the
Casimirs anyway. `:proved` = 0.)*

---

## 6. The residue is speaking — the closure / GPG / triad thread

> *"Turbulence and vortices — that is the residue. Self-sustaining until it is not."*

This section is the **speculative, exploratory thread**. It is fenced with a
**Required Witness Check** (§6.4): nothing here is load-bearing, and every bridge to
the PDE has been trimmed or refuted when witnessed. Read it as a record of a genuine
*structural resonance* and a set of open questions — not as results.

### 6.1 The reframing: decay is the default, closure is an achievement

The shift that opened the arc: don't read the framework statically. **Dynamics lives in
the rewrites.** Decay/dissipation is the *default*; a self-sustaining structure
(turbulence; life; a dissipative structure; a Rosen (M,R) system) is an *autopoietic
achievement* maintained against that default — "self-sustaining until it is not." A
minimal stochastic model — autocatalytic build + decay-default, as a CTMC on a
hypergraph of closure states — reproduces the turbulence phenomenology *intrinsically*:
a metastable state, **memoryless (exponential) lifetimes** (CV≈1, R²≈0.9999), and a
characteristic time `τ ~ exp(N·g(ρ))` of the **same class** as the Moehlis–Faisst–
Eckhardt shear-turbulence saddle (NS-021/023). The "until it is not" is a *memoryless
escape from a chaotic saddle* — a constant-hazard event, not a scheduled decay.

### 6.2 The substrate: GPG and hypergraph rewrites

Where do these closure states and rewrites "live"? The candidate substrate is **GPG
(Geometric Proca Gravity)** — Brian Crabtree's transport-plus-stiffness theory,
conjectured *upstream* of the closure framework (CFS): `Substrate → GPG → RCFS
(closure validation) → derived structure`. Its discrete form is built on **ternary
hypergraphs with rewrite dynamics** (`docs/discrete_gpg_construction.md`, TCE) — the
dynamics *is* the rewriting; closure is a selected fixed-point on top. **Status:
test-first, unverified, not re-rooted** (a construction + conjectured correspondences,
explicitly gated on reaching `:argued`/`:verified`). For the NS arc, GPG/hypergraph-
rewrites is simply *the closure-side substrate where the "decay-default / closure-
achievement" grammar would live* — a conceptual home, not an established bridge to the PDE.

### 6.3 The triad, and the rotation: S (closure) vs A (turbulence)

The smallest stable unit in both pictures is a **triad** (a 3-cycle of coordination
morphisms — and, not coincidentally, the elementary Fourier interaction of the NS
nonlinearity, NS-022). A Rosen (M,R) system is a triad of roles — **metabolism F,
repair A, replication/seed S** — on a making-cycle `S→A→F→S`. The exact 8-state (M,R)
CTMC gives a sharp result (`closure_triad_rotation.jl`):

> **The gate is always the *target of the weak edge* — a rotation-covariant rule.**
> Weak edge `F→S` (entailment) ⇒ gate **S**; weak edge `S→A` (feedback) ⇒ gate **A**;
> weak edge `A→F` (repair) ⇒ gate **F**. The committor triple is identical, cyclically
> permuted.

So the **(M,R) closure gate (S) and the turbulent regeneration gate (the roll, A) are
the same triangle, rotated.** The earlier "S vs A" tension was a *labeling artifact*:
one mechanism (gate = weak-edge target), with the weak edge sitting on a different
functional edge in each system. *The triangle got rotated.* This is the cleanest,
most genuinely suggestive thing the residue said — a shared, rotation-covariant gate
**structure** across closure and turbulence.

### 6.4 What the witnesses did to it — and the Required Witness Check

Every attempt to promote that resonance into a *load-bearing bridge* was trimmed when
put to an external 3-seat witness pass (Grok / Gemini / ChatGPT) or to a rigorous
follow-up. **This is the honest core of the section:**

- **The convergence is "real but overstated" (NS-024).** All three seats agreed: the
  shared fork (closed/symmetric ⇒ inert; open ⇒ needs a degeneracy-breaker) **holds but
  is broad** — kin to spontaneous symmetry breaking, not a special two-system bond. The
  identity "Order = seam" is **dead** (doubly dissociable). The origin-unification is
  **refuted**.
- **"One notion or two?" → TWO.** The (M,R) defect is *logical* (selection required
  before execution; decidability-under-ambiguity); the turbulence defect is *dynamical*
  (selection enacted by noise; stability-under-noise). Analogous, not identical — patch
  vs tear. The gate *mechanism* is shared and rotation-covariant; the *origin* of the
  weak edge is system-specific (logical entailment vs the nonlinear-feedback bottleneck).
- **The gate is not even a single mode (Slice 2).** In the MFE edge manifold, the roll
  a₃ turned out **tangent** to the separating manifold; the geometric "gate" (its normal)
  is **multi-mode**. The committor-gate ("a₃ surviving a dip predicts recovery") and the
  edge-manifold normal are **two different objects** — "two notions, not one" *again*.
- **The closure-transfer test came back NEGATIVE.** Gosme's empirical "causal
  symmetrization" signature (structure↔activity coupling becoming bidirectional at
  maturity) was tested in the MFE saddle and **not reproduced** (proxies disagree on the
  trend; near the noise floor at high Re). An initial cherry-picked "present" reading was
  caught and corrected — the confirmation-bias guard firing exactly as it should.

> **Required Witness Check (RWC-NS).** Any future use of the closure↔turbulence↔GPG
> resonance as *more than* a structural/methodological heuristic must first clear an
> external witness pass. The internal default is **skepticism**: the program has now
> trimmed or refuted this bridge **four independent times** (broad C1 / dead C2 /
> refuted C3 / negative Gosme / two-notions ×2). The system cannot validate this from
> inside; route it out.

### 6.5 So what *is* the residue saying?

Honestly — and this is the genuinely interesting part — the residue speaks a
**grammar, not a theorem.** The *same structural vocabulary* recurs across every
domain we probed: **triadic closure** as the minimum stable unit; a **rotation-covariant
gate** (the weak-edge target) that decides persistence-vs-collapse; **decay as default,
closure as achievement**; and a **wall** (supercriticality ≡ Casimir deficit ≡ enstrophy
non-coercivity) that recurs unchanged across scaling, coadjoint, and curvature
language. That cross-domain convergence *of structure* — closure theory, the (M,R)
triad, the SSP cycle, the coadjoint rigid body, and the criticality wall all speaking
the same grammar — is real and worth a research program.

What it is **not** saying (yet, and possibly ever, by these methods): that this grammar
*bridges to the PDE*. Every load-bearing bridge has been broad, dead, refuted, or
negative under witness. The residue is telling us about the **shape of the obstruction**
— that it is one structural wall, seen many ways, with a recurring triadic-gate grammar
around it — not handing us a key to the door.

---

## 7. The ledger, honestly

- **`:proved` = 0.** No `Scope: PDE` proof exists. **Distance to the prize: UNTOUCHED.**
- **Produced:** a falsified path (NS-020); a two-sided-validated diagnostic with its
  inviscid-3D limit charted (NS-010/011); two honest nulls (NS-032, Step 2 + high-res);
  the exact criticality calculus (NS-034); a six-slice geometric map (NS-033) converging
  on one wall; and a four-times-trimmed, witness-disciplined account of the closure
  resonance (NS-024/025 + §6).
- **The deliverable is the map** — a precise account of *why* 3D Navier–Stokes resists
  every classical handle, from scaling, coadjoint, curvature, topology, and closure
  directions at once, with every dead end and every overreach recorded rather than buried.

## 8. Cross-project note

The **method** — an evidence-tiered obstruction ledger, the Scope firewall, and
external witnessing of convergences — transfers *now* to the other open programs (CFS,
the closure quotient, possibilistic inversion). The **substance** transfers only when a
scoped, witnessed result earns it. On this hardest of testbeds, the closure↔NS substance
did **not** earn it (broad/negative, four times over) — which is itself the most useful
calibration the program offers: a measure of exactly how little an unwitnessed
cross-domain analogy is worth, and how much discipline it takes to find out.

---

*Reproducibility: all results are deterministic and reproducible from the committed
scripts (`scripts/*.jl`, hermetic Julia) and the per-result companions (`docs/*.md`).
Status, evidence, and Scope per entry: `SPEC.md`, `artifact_registry.md`. The firewall
held throughout: `:proved` = 0; distance to the prize UNTOUCHED.*
