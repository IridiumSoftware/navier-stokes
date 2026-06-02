# SPEC.md — Navier–Stokes Obstruction Program ledger

**v0.1.0 (2026-05-31).** Every entry: `NS-ID | Class | Statement | Evidence |
Status | Scope | Source`. `:cited` = established external theorem (not ours).
`:falsified` = ruled-out approach. `:tested` = we computed it (read the Scope).
`:argued` = manual argument. `:open` = unresolved. `:proved` = rigorous proof of a
PDE statement — **none; reserved.** Firewall: only `Scope: PDE` + `:proved` could
ever count as prize progress; there is none.

Counts: 1 PROBLEM, 8 OBSTRUCTION, 2 DIAGNOSTIC, 1 live RESULT/CONJECTURE (external),
1 CONJECTURE, 6 our RESULTS/FALSIFIED, 2 RELATED (external), 2 PROGRAM, 1 GEOMETRY,
1 ANALYSIS (scaling calculus). `:proved` = 0. (25 entries.)

---

## PROBLEM

**NS-001 — The Clay statement.**
For 3D incompressible Navier–Stokes on 𝕋³ or ℝ³ with smooth, finite-energy
initial data and zero forcing (or Schwartz forcing), prove **either** global-in-
time existence of smooth finite-energy solutions, **or** a finite-time
singularity. 2D is solved (global regularity); 3D is open.
- Evidence: external-theorem (problem statement). **Status: :open.** Scope: PDE.
- Source: Fefferman, *Existence and smoothness of the Navier–Stokes equation*,
  Clay Millennium Prize official problem description (2000/2006).

---

## OBSTRUCTIONS (the walls any proof must respect)

**NS-002 — Supercriticality of the energy norm (THE central obstruction).**
Under the NS scaling symmetry `u_λ(x,t) = λ u(λx, λ²t)`, the energy norm scales as
`‖u_λ‖_{L²}² = λ^{-1}‖u‖_{L²}² → 0` as `λ→∞` (zooming into small scales). So the
*controlled* quantity (energy) is asymptotically **useless at the scales where a
singularity would live**. The scale-*invariant* ("critical") norms — `L³`,
`Ḣ^{1/2}`, `BMO^{-1}` — are exactly the borderline ones, and none is globally
controlled a priori. This supercriticality is the structural reason 3D is open
and 2D (where the controlled enstrophy sits on the right side of scaling) is not.
- Evidence: argued (standard), now backed by the **exact scaling-exponent calculus
  (NS-034)** — the criticality classification is derived and numerically verified
  in-repo (energy σ=−1 supercritical; critical locus σ=0 = {L³, Ḣ^{1/2},
  Prodi–Serrin 2/p+3/q=1}). **Status: :argued** (framing/no-go, not a proof). Scope: PDE.
- Source: standard (Tao's criticality expositions); rigorous form in
  `scripts/manifold_3b_criticality.jl` (NS-034).

**NS-003 — Energy is the only coercive global control (Leray).**
Global weak (Leray–Hopf) solutions exist for all time and obey the energy
inequality, controlling `‖u(t)‖_{L²}` and `∫₀ᵀ‖∇u‖_{L²}²`. This controls *size*,
not *derivatives pointwise*; weak solutions may be non-unique / non-smooth.
- Evidence: external-theorem. **Status: :cited.** Scope: PDE.
- Source: Leray (1934); Hopf (1951).

**NS-004 — Beale–Kato–Majda: blowup ⇒ unbounded vortex stretching.**
A solution smooth on `[0,T)` extends past `T` iff `∫₀ᵀ ‖ω(t)‖_{L∞} dt < ∞`. So any
finite-time singularity **requires** the vorticity-`L∞` integral to diverge —
i.e. unbounded vortex stretching. Any blowup construction must engineer this.
- Evidence: external-theorem. **Status: :cited.** Scope: PDE.
- Source: Beale–Kato–Majda (1984). *Corroborated computationally:* the δ(t)↔BKM
  co-divergence is exhibited in the CLM vortex-stretching model (NS-010 Stage 1b,
  T-04 PASS) — `scripts/spectral_clm_blowup.jl`. Scope of that demo: 1D-model.

**NS-005 — Conditional (critical-norm) regularity: Prodi–Serrin–Ladyzhenskaya.**
If `u ∈ L^p_t L^q_x` with `2/p + 3/q ≤ 1`, `q>3`, the solution is smooth (endpoint
`L^∞_t L³_x`: Escauriaza–Seregin–Šverák 2003). ⇒ a singularity requires a
*critical* norm to blow up. Reduces "prove regularity" to "control a critical
norm" — which NS-002 says we cannot do a priori.
- Evidence: external-theorem. **Status: :cited.** Scope: PDE.
- Source: Prodi (1959), Serrin (1962), Ladyzhenskaya; ESS (2003).

**NS-006 — Caffarelli–Kohn–Nirenberg partial regularity.**
For suitable weak solutions, the singular set `S` has parabolic Hausdorff
dimension `≤ 1` (1D in space-time). Singularities, if they exist, are small and
cannot fill a region.
- Evidence: external-theorem. **Status: :cited.** Scope: PDE.
- Source: Caffarelli–Kohn–Nirenberg (1982); Scheffer.
- **Scope-localization probe (Ryan-M\*↔CKN):** track the minimal scope carrying the
  vortex-stretching production `|ω·(ω·∇)u|`. First cut (`ryan_ckn_scope_localization.jl`): the
  volume fraction f50 LOCALIZES (0.16→0.06) + shrinks with N — *looked* like a ≤1D-singular
  signature. **But the conclusive, scope-INVARIANT measure (box-counting DIMENSION =
  what CKN bounds, `ryan_ckn_box_dimension.jl`, box-counter validated line/plane/volume→1/2/3)
  CORRECTS it:** D ≈ **2.3, resolution-ROBUST (N=64≈128, ±0.09) and time-stable** — the
  production is an **intermittent ~2.3-D fractal** (vortex sheets/tubes, real-turbulence
  value), **not** a forming ≤1D singular set and **not** space-filling. f50's "localization"
  was a resolution-coupled artifact. **D>1 ⇒ no resolved singular set** (CKN's ≤1 not
  approached at N≤128; a true verdict needs N≳512). Scope: inviscid-3D-truncation;
  Ryan-principle (NS-035) validated — the scope measure was right where the resolution-coupled
  one misled. See `docs/move4_ckn_probes_companion.md`.

**NS-007 — No exact self-similar blowup (the easiest backward path is dead).**
Leray's (-1/2)-self-similar blowup ansatz `u(x,t)=(2a(T−t))^{-1/2}U((x−x₀)/√(2a(T−t)))`
has **no nontrivial solution** in `L³`/energy space. The cleanest "assume it blows
up and read off the profile" construction is ruled out; only asymptotically /
discretely self-similar profiles survive, none constructed for real NS.
- Evidence: external-theorem. **Status: :cited (rules out an approach).** Scope: PDE.
- Source: Nečas–Růžička–Šverák (1996); Tsai (1998).

**NS-008 — Tao's averaged-NS blowup (a no-go for energy-only methods).**
An *averaged* 3D NS equation sharing the exact energy identity and scaling **does
blow up in finite time** (a self-replicating cascade gadget). Therefore **no proof
of regularity can use only the energy identity + scaling**, because such a proof
would falsely also rule out the averaged equation. Any successful method must use
finer structure of the true nonlinearity (e.g. vortex-stretching geometry).
- Evidence: external-theorem. **Status: :cited (barrier on methods).** Scope: PDE.
- Source: Tao (2016), *Finite time blowup for an averaged 3D NS equation*, JAMS.

**NS-009 — Onsager / anomalous-dissipation threshold = 1/3.**
Energy is conserved for Euler solutions above Hölder `1/3` (Constantin–E–Titi
1994); dissipative weak Euler solutions exist at/below `1/3` (Isett 2018;
Buckmaster–De Lellis–Székelyhidi–Vicol 2019). The exponent `1/3` is simultaneously
Kolmogorov's increment law `δu(ℓ)~(εℓ)^{1/3}` and the root of the exact 4/5 law.
Frames the inviscid limit / cascade rigorously.
- Evidence: external-theorem. **Status: :cited.** Scope: PDE (Euler) / inviscid limit.
- Source: CET (1994); Isett (2018); BDLSV (2019); Onsager (1949).

---

## DIAGNOSTICS (computable detectors of blowup — the live tools)

**NS-010 — Analyticity-strip width δ(t) (THE blowup diagnostic).**
A smooth solution is Gevrey-/real-analytic and extends to complex spatial
arguments, analytic in a strip `|Im z| < δ(t)`; `δ(t)` equals the exponential
decay rate of the Fourier spectrum, `|û(k,t)| ~ C(t) e^{−δ(t)|k|}`. **`δ(t)→0` in
finite time is exactly a loss of analyticity / approach to singularity.** Directly
computable from a spectral solution.
- Evidence: external-theorem (method) + **computed (validated).**
  **Status: :tested** — the spectrum-fitted δ(t) reproduces the EXACT inviscid
  Burgers closed form `δ(t)=arccosh(1/t)−√(1−t²)` to ≤4.1% (T-01 PASS), with the
  shock-approach exponent 1.519 (theory 1.5). The viscous case keeps δ bounded.
- **Scope: PDE-method, VALIDATED in a 1D-model.** The *tool* is validated; PDE-
  applicability is the cited result (Foias–Temam). The 3D-NS computation is Stage 1b.
- **Stage 1b (CLM, pseudospectral):** the diagnostic + a real RK4/dealiased
  spectral solver reproduce the exact CLM strip `δ(t)=ln(2/t)` to <1% (N-robust,
  N∈{512,1024,2048}), and δ→0 co-diverges with the BKM integral (T-04 PASS) at the
  vortex-stretching blowup t*=2. Validates the tool chain on the NS-004 mechanism.
- **Stage 1c-2D (2D control, pseudospectral):** the diagnostic correctly reports
  REGULARITY — δ bounded (≥0.23, never →0), BKM finite, and energy/enstrophy/‖ω‖∞
  conserved to <1e-6 (2D Euler — solver-validation via the Tier-1 invariants) — thus
  DISTINGUISHING 2D regularity from CLM blowup (Stage 1b, δ→0). The 2D side of the
  NS-004 / 2D-3D-gap invariant story (`physical_invariants.md`).
- **Stage 1c-3D Step 1 (3D control, pseudospectral — the open regime):** the 3D
  solver (rotational form + Leray projection, hand-rolled 3D FFT, vortex stretching
  LIVE) is VALIDATED by exact conservation of the two 3D Tier-1 Euler invariants —
  ENERGY and **HELICITY** (both to 0.0000%, `div_max≈1e-12`); helicity is the
  3D-specific check 2D could not give. On the viscous, well-resolved Taylor–Green
  control the diagnostic correctly reports REGULARITY (δ bounded ≥0.605, BKM finite
  ≈14.2, energy decays). **CAVEAT (documented):** the exponential-strip δ-fit is
  **NOT resolution-robust in the inviscid/under-resolved regime** — it varies ~50%
  non-monotonically across N∈{16,32,64} on a developing inviscid cascade (the fit
  band is window-sensitive once a power-law range forms). The solver is robust; the
  δ-slope-fit is the fragile piece — exactly where a blowup hunt operates. ⇒ any
  Step-2 δ→0 must be gated on BKM co-movement (T-06) + true spectral N-convergence,
  not the slope alone. Scope: 3D-truncation; still not the PDE.
  - **Better-diagnostic-CLASS finding (Grok-Oracle follow-up, `docs/grok_oracle_anchoring_companion.md`):**
    σ=0 (scale-invariant) invariants — relative helicity `ρ_H=H/(2√(EΩ))` and `E·Ω` —
    are **resolution-robust** (≤1% across N=64↔128 on one embedded flow) where the δ-fit
    drifts 63%, because they are exact integrals (not spectrum-slope fits). **But ρ_H is
    robust-yet-BLIND** (just tracks Ω-growth).
  - **The right detector class (production skewness, `grok_production_skewness_probe.jl`):**
    `S_ω=P/⟨|ω|²⟩^{3/2}` with `P=⟨ω·(ω·∇)u⟩` (verified `dΩ/dt=P`) is **both** resolution-robust
    (4.8% across N) **and** singularity-relevant (the stretching efficiency; `dΩ/dt=c·Ω^{3/2}`
    blows up iff S_ω bounded below). **AMENDMENT (no free lunch):** robustness↔sensitivity are
    in TENSION — S_ω is *less* robust than ρ_H (4.8% vs 0.5%) precisely because it depends on
    the strain (small scales = the cutoff-sensitive part); sensitivity to the singularity *is*
    small-scale dependence. S_ω peaks ~0.18 (resolved) then decays, but the decay is
    resolution-contaminated (no clean verdict). The right OBJECT; the verdict stays resolution-gated.
    **PRINCIPLE (NS-035, Ryan):** the diagnostic must be SCOPE-coupled (resolution-invariant), not
    resolution-coupled — δ failed because resolution differences are epistemic (Class I); a real
    singularity is scope-coupled (Class II), detectable only by a resolution-converged scope-divergence.
- Source: Foias–Temam (1989); Sulem–Sulem–Frisch (1983);
  `scripts/burgers_analyticity_strip.jl`, `docs/ns010_analyticity_strip_companion.md`;
  `scripts/spectral_clm_blowup.jl`, `docs/ns010_stage1b_clm_companion.md`;
  `scripts/spectral_2d_control.jl`, `docs/ns010_stage1c_2d_companion.md`;
  `scripts/spectral_3d_control.jl`, `docs/ns010_stage1c_3d_companion.md`.

**NS-011 — Complex-singularity tracking.**
The nearest complex-space singularity (pole/branch point) of the analytic
continuation, at distance `δ(t)` from the real axis; **its migration to the real
axis = blowup.** Tracked via the spectrum's decay rate and form. The rigorous home
of the "assume it blows up and work backward" instinct.
- Evidence: external-theorem (method) + **computed (validated).** **Status: :tested**
  — the nearest complex singularity `ξ*=i·arccosh(1/t)` (from `cos ξ*=1/t`) was
  tracked exactly and matches the spectrum decay (T-02 PASS, inviscid).
- **Scope: PDE-method, validated in 1D-model.** Source: Sulem–Sulem–Frisch (1983);
  Matsumoto–Bec–Frisch; `scripts/burgers_analyticity_strip.jl`.

---

## LIVE APPROACHES & CONJECTURES

**NS-012 — Li–Sinai: finite-time blowup for COMPLEX initial data.**
Finite-time blowup is **proved** for 3D NS with complex initial data via a
renormalization-group / fixed-point construction. The backward (blowup-
construction) path **succeeds in the complex setting**; the real-data problem
remains open. Strong reason to take the complex plane seriously (NS-010/011).
- Evidence: external-theorem. **Status: :cited.** Scope: PDE with complex data
  (NOT the real-data prize). Source: Dong Li & Ya. G. Sinai (2008), JEMS.

**NS-013 — Does complex-data blowup inform real-data regularity?**
Open. Complex blowup (NS-012) and the analyticity-strip picture (NS-010) suggest
the real-data question is "does the nearest complex singularity reach the real
axis," but no implication real⇐complex is established.
- Evidence: none. **Status: :open.** Scope: PDE. Source: —
- **Reality-stabilizer probe (Grok Move 4, `scripts/complex_burgers_reality_leakage.jl`):**
  1D complex viscous Burgers (real-data heat-protected; complex-data φ-zero blowup — the 1D
  Li–Sinai analog). A tunable reality leakage λ damping `Im(u)`: λ=0 blows up at t*=5.54
  (Cole–Hopf-validated), and reality PROTECTS with a boundary λ_c∈(0.02,0.05) — T* rises ~22%
  below it (delay), regular above it. Sharpens the conjecture: real regularity ⟺ the
  conjugate complex-singularity pair stays off the real axis. Scope: 1D-model — illustrates
  the mechanism, does NOT establish real⇐complex for 3D-NS. See `docs/move4_ckn_probes_companion.md`.

---

## OUR RESULTS (this arc — every one scoped; none is PDE progress)

**NS-020 — Homological reformulation: FALSIFIED.**
A proposed reformulation casting incompressibility/closure in chain-complex
homology (H₁, "repair cost") was tested and falsified: on fixed domains `b₁` is
pinned under mesh refinement (𝕋³→3, ℝ³→0); it grows only under topology change;
and the genuine difficulty lives entirely in the **norm choice** (= NS-002), which
homology cannot see. Repair-cost = 1/vorticity exactly.
- Evidence: computed. **Status: :falsified.** Scope: discrete-topology diagnostic.
- Source: `scripts/navier_stokes_homology_diagnostic.jl` (+ .out.txt).
- **Update (2026-06-01) — independent rediscovery (via Grok), confirmatory.**
  The finite-incidence / chain-complex reformulation was re-derived independently:
  flux closure `∂₁q=0` vs. repair closure `q∈im ∂₂` on a 2-complex, with a
  refinement-tower extension via repair-cost `R_X(q)`. It reproduces the same `H₁`
  obstruction we already mapped. On fixed-topology domains (𝕋³/ℝ³) `dim H₁` stays
  pinned under refinement; vortex filaments are not new domain 1-cycles
  (`ω=∇×u` is always exact). The emergent `R_X(q)≈1/|ω|` relation *inverts* the
  intended turbulence criterion and confirms the genuine difficulty lives in the
  norms (supercriticality NS-002, Casimir deficit, enstrophy non-coercivity — §5 of
  the write-up), not in topology/homology. "Repair fires out of turn" is the classic
  vortex-stretching / production–dissipation race in new language. NSA / surreal-number
  lifts on this foundation remain speculative scaffolding only. `:proved`=0; no PDE
  path reopened; distance to prize untouched. (Cross-ref: `obstruction_program_writeup.md`
  §2, §5; the rediscovery accepted this verdict.)

**NS-021 — Turbulence-as-residue phenomenology (MFE saddle).**
The Moehlis–Faisst–Eckhardt 9-mode model (eqs pinned to source) reproduces the
self-sustaining-process phenomenology: a metastable turbulent state with
**memoryless (exponential) lifetime**, `τ(Re) ~ exp(B·Re)` with `B≈0.013–0.015`
(amplitude-invariant, geometry-dependent), and recovery **gated by the roll mode
a₃** (committor decomposition).
- Evidence: computed. **Status: :tested.**
  **Scope: ODE-truncation / phenomenology — a 9-variable ODE is smooth for all
  time by construction; NO bearing on PDE regularity.**
- Source: `scripts/mfe_self_sustaining.jl`, `mfe_lifetime_scaling.jl`,
  `mfe_B_universality.jl`, `mfe_escape_mechanism.jl`, `mfe_committor_decomposition.jl`.

**NS-022 — Helical triad: cascade direction is an ensemble property.**
The Waleffe-1992 reduced helical triad (exact E & H conservation to ~1e-13) shows
the intermediate-signed leg is the unstable donor with a conservation-fixed split,
but the *isolated* triad merely oscillates — forward vs inverse transfer is a
*driven-ensemble* property, not the triad algebra.
- Evidence: computed. **Status: :tested. Scope: 3-ODE model / phenomenology.**
- Source: `scripts/triad_closure_vs_cascade.jl`.

**NS-023 — Autopoietic-closure phenomenology + the (M,R) gate.**
Decay-default + autocatalytic closure (stochastic CTMC) reproduces the same
metastable + memoryless + `τ(ρ)~exp(N·g(ρ))` class *intrinsically*. The Rosen
(M,R) 3-role triad has an exact, pre-registered, null-controlled **gate = target
of the weak edge, rotation-covariant**; the seam is simultaneously *lifeline and
death-route*, with a lifespan-vs-identity tightness tradeoff. Canonical CFS
quotient (Q₁₀₂) is too symmetric to localize a gate (robust negative).
- Evidence: computed. **Status: :tested.**
  **Scope: abstract closure theory — a SEPARATE domain, NOT NS.** A self-contained
  result about autopoietic closure; included here as the arc's record.
- Source: `scripts/closure_autopoiesis_{small,structured,canon}.jl`,
  `closure_{knfamily_scaling,mr_gate,q102_richgate,triad_rotation,offgas}.jl`.

**NS-024 — Closure↔turbulence convergence: witness-trimmed to broad/generic.**
A claimed convergence (the GPG-foundations confluence/Order result vs the seam
arc) was put to a 3-seat external witness pass (Grok/Gemini/ChatGPT). Verdict:
**C1 holds but is broad** (closed/symmetric=inert; open=needs a degeneracy-breaker
— kin to spontaneous symmetry breaking, not a special bond); **C2 "Order=seam"
identity is DEAD** (doubly dissociable); **C3 origin-unification REFUTED**. The
deep "is the seam's incompleteness one notion or two?" answered **two**.
- Evidence: argued (externally witnessed). **Status: :argued.**
  **Scope: abstract structural analogy — NO analytic purchase on the PDE.**
- Source: `docs/seam_order_convergence_witness_{brief,verdict}.md`.

---

## RELATED (external work bearing on the closure-theory side — NOT the PDE)

**NS-025 — Gosme: causal symmetrization as an empirical signature of operational
closure.** Anthony Gosme, *Causal symmetrization as an empirical signature of
operational autonomy in complex systems*, arXiv:2512.09352 (Dec 2025). Empirically
operationalizes the closure-to-efficient-causation / (M,R) / autopoiesis framework
on **50 collaborative software ecosystems** (11,042 system-months). Order parameter
`Γ` (structural persistence under component turnover) is **bimodal** (Hartigan dip
p=0.0126; phase transition exploratory→mature, 1.77× variance collapse); at maturity
**"causal symmetrization"** emerges — Granger structure↔activity coupling shifts
0.71 (activity-driven) → 0.94 (bidirectional). A composite viability index
(activity+structural persistence) beats activity-alone (AUC 0.88 vs 0.81), flagging
**"structural zombies"** (sustained activity masking architectural decay). Author is
explicit: a *necessary statistical* signature *consistent with* operational closure,
**not** biological life or mechanistic closure; substrate-independent.
- Evidence: external-theorem (empirical study). **Status: :cited.**
- **Scope: software-ecosystems / phenomenology — NOT NS-PDE.** A Tier-2
  phenomenological diagnostic (per `physical_invariants.md`); **cannot bear on the
  prize.** Bears on NS-023/024 (the closure-theory side), not on regularity.
- Relevance: (a) an *independent external operationalization* of the (M,R)/closure
  framework we modeled abstractly (NS-023); (b) a concrete, testable bridge to our
  models — *does the symmetrization signature appear in the MFE saddle?* (structure
  = streak `a₂`/roll `a₃`, activity = fluctuation energy Σ₄..₉, directional Granger).
- **QUEUED EXPERIMENT — DONE, NEGATIVE (`scripts/mfe_gosme_symmetrization.jl`).** Ran
  the Granger symmetrization test across Re=250..400 (Gosme's exploratory→mature ↦ Re↑).
  Sanity passed (white noise ⇒ G≈0). **Result: NO robust maturity-symmetrization
  signature.** The roll `a₃` is activity-DRIVEN at every Re (G(A→S)≫G(S→A); symmetrization
  index SI low even if rising); the streak `a₂` is bidirectional at low–mid Re (SI≈0.997
  at Re=300) but DE-symmetrizes by Re=400; the two proxies disagree on the trend, and the
  high-Re coupling is near the noise floor. **The Gosme signature is NOT reproduced in the
  MFE saddle** — an honest negative, consistent with NS-024's broad/generic verdict. (An
  initial cherry-picked "present" reading was caught and corrected — confirmation-bias guard.)
  Scope: ODE-truncation; bears on NS-021/NS-024, not the PDE.
- **CAUTION (flagged, NOT claimed):** Gosme's "symmetrization" (bidirectional
  *causal coupling* = mature closure) is a *different sense of symmetry* from our
  (M,R) result "*structural* symmetry → inert / the seam makes it alive" (NS-023).
  Do not conflate; witness any convergence before believing it (cf. NS-024).
  ("Structural zombie" rhymes with our "self-sustaining until it is not" —
  resonance to examine in the closure domain, not a PDE bridge.)

**NS-035 — Ryan: emergence is coupled to SCOPE, not level (the diagnostic principle).**
Alex Ryan, *Emergence is coupled to scope, not level*, arXiv:nlin/0609011 (2006);
*Complexity* (Wiley). Replaces "level" with **scope S** (the spatial/temporal extent —
which components), **resolution R** (finest distinguishable distinction; *epistemic*),
and state. Class I (**weak/epistemic**) emergence = macro & micro differ only in
**resolution** (a coarse-graining map exists ⇒ a limitation of the observer). Class II
(**novel/ontological**) emergence = differ in **scope** (present only at a minimal
macrostate M\*, absent in any narrower scope; e.g. the Möbius χ — a resolution-independent
topological invariant). **Why it bears (near-literal map: resolution↔grid N, scope↔domain
integral):**
- Gives the **principle** behind the diagnostic arc (NS-010/NS-032): the δ-slope-fit is a
  *resolution* operation (Class I, epistemic — drifts with N, categorically blind to a
  genuine singularity); the σ=0 invariants (helicity, E·Ω, S_ω) are *scope* quantities
  (Class II — where novel/ontological emergence, incl. real blowup, would live). δ was the
  WRONG CLASS.
- The **robustness↔sensitivity tension** (Grok probe) = the scope(ontological/robust)–
  resolution(epistemic/fine) split, irreducible.
- **Re-reads:** helicity/the Casimirs = Ryan-novel-emergent (scope-coupled topological)
  invariants ⇒ the Casimir deficit (Slice 6) = a deficit of ontological invariants;
  supercriticality (NS-002/NS-034) = a resolution-coupled control vs a scope-coupled question.
- **New criterion:** a true (Class II) singularity ⟺ a SCOPE quantity diverges and the
  divergence CONVERGES as N→∞ (a resolution-coupled δ→0 drift is Class I, inconclusive).
  Ryan's minimal macrostate M\* ↔ CKN (NS-006): track the minimal scope carrying the
  production (localizing ≤1D = Class II; spreading = Class I).
- Evidence: external-theorem (conceptual framework). **Status: :cited.** **Scope:
  conceptual lens / methodology — NOT the PDE.** A frame on the truncations + diagnostics,
  not a result; the interpretive claim ("blowup = Ryan-novel-emergent") is witness-gated
  (RWC-NS). Bears on NS-010, NS-032, NS-034, NS-006. `:proved` unchanged (0).
- Source: arXiv:nlin/0609011; companion `docs/ryan_scope_resolution_lens.md`.

---

## PROGRAM (method & cross-project)

**NS-030 — The obstruction-program method (the transferable contribution).**
Maintain an evidence-tiered ledger of obstructions / diagnostics / falsified /
live approaches, with a firewall against conflating models with the PDE and
external witnessing of convergences. This *method* is the part that transfers to
the other open programs (CFS, closure-quotient, possibilistic-inversion);
substantive transfer requires per-claim scope + witness (cf. NS-024).
- Evidence: argued. **Status: :argued.** Scope: methodology.

**NS-031 — The program's own triadic coordination structure (TCE self-map).**
Running TCE's `Discovery.Triadic` engine (via `SpecBridge`) on this obstruction
ledger — encoded as a 20-node corpus with `deps` = the genuine logical premises,
`layer` = program depth, and `logic` tier carrying the Scope firewall
(`classical` = PDE-analysis domain; `other:closure` = the model arc;
`bridge` = NS-024/NS-030 only) — yields a stable triadic structure:
- **Keystone obstruction triad {NS-002, NS-003, NS-004} @ 1.0** (supercriticality
  + energy-only-coercivity + BKM): the tightest coordination unit; the trio any
  3D proof must coordinate.
- **Live complex-plane attack triad {NS-011, NS-012, NS-013} @ 0.70**
  (complex-singularity tracking + Li–Sinai complex blowup + the open real⇐complex
  conjecture): the frontier.
- **PDE bridge {NS-003, NS-004, NS-010} @ 0.83**: the walls → the validated
  diagnostic tool (a 3D δ(t)→0 is meaningful only if it co-moves with BKM).
- The closure arc {NS-021..025} is **tier-walled**: a programmatic scan of all
  64 triads finds **zero** that mix the PDE-analysis tier with the closure tier;
  the bridge NS-024 has one pairwise cross-tier edge (→NS-009) that never closes
  a triangle — an *independent* engine-side reproduction of NS-024's witnessed
  "broad/generic, no PDE purchase" verdict.
- Evidence: computed (deterministic, reproducible). **Status: :tested.**
  **Scope: methodology — a self-map of the program's dependency graph, NOT the
  PDE.** `:proved` count unchanged (0).
- Depends_on: NS-030 (structurally references NS-001..025).
- Source: `discovery/ns_obstruction_corpus.json`,
  `discovery/ns_triad_discovery.out.txt`, `docs/ns_triad_discovery_companion.md`.

**NS-032 — Stage 1c-3D Step 2: gated blowup hunt (inviscid Taylor–Green) — NULL.**
The canonical Euler near-singularity probe (Brachet TGV, vortex stretching
unopposed), run at N=32 and N=64 with the three gates from Step 1 / NS-031: G1
RESOLVED (energy conserved), G2 CONVERGED (δ agrees N=32 vs 64), G3 CO-MOVING
(δ→0 with BKM→∞). Result: δ narrows 2.10→0.37 (resolved window), but **G2 FAILS**
(δ disagrees ~50% across N — the Step-1 δ-fit fragility) and **G3 FAILS** (δ
bottoms at 0.37, never near 0; BKM finite). **Verdict: INCONCLUSIVE / no blowup
evidence at accessible resolution** — the gates correctly flag a resolution-limited
inviscid cascade rather than pass a false positive. (A real near-singularity study
needs N≳512 / FFTW; the established result is that the gate protocol returns the
honest NULL.) The decline *decelerates*, weakly consistent with (not evidence for)
the literature's no-finite-time-singularity reading.
- Evidence: computed. **Status: :tested (null result). Scope: inviscid-3D-truncation
  — NOT the PDE.** `:proved` count unchanged (0).
- **High-res confirmation (recreational, `scripts/blowup_highres.jl`):** pushed the
  hunt to N=128 (2× linear, 8× grid, 16 threads, hermitic hand-rolled FFT). The
  resolution wall moves cleanly with N (t_res ≈ 3.0/4.26/≥5.0 for N=32/64/128) — more
  resolution buys more resolved time, not removal. δ does NOT converge: it drifts DOWN
  monotonically with N (|Δ|₆₄,₁₂₈ up to 73%), confirming the δ-slope-fit tracks the
  widening fit band, not a converged strip — the verdict stays a higher-res INCONCLUSIVE.
  (Even a clean δ→0 would be inviscid Euler in a truncation; real studies need N≳512.)
- Depends_on: NS-010 (Stage 1c-3D Step 1), NS-004 (BKM gate T-06), NS-031 (gates).
- Source: `scripts/spectral_3d_blowup_candidate.jl` (+ `.out.txt`);
  `scripts/blowup_highres.jl` (+ `.out.txt`, N=128 confirmation).

**NS-033 — Geometric structure of the NS state-space manifold (4-slice study).**
A CFS-style geometric reconnaissance (exact, no resolution wall) of the Euler/NS
truncations' state space as a Lie–Poisson manifold foliated by the physical
invariants:
- **Slice 1 (coadjoint orbit, exact):** the triad's state space is the Euler
  rigid body — Casimir=energy sphere, helicity-Hamiltonian polhodes; middle leg =
  saddle (cascade donor), homoclinic separatrix, invariants to ~1e-13.
- **Slice 2 (edge manifold, MFE):** laminar|turbulent boundary located by edge
  tracking; logarithmic critical slowing (σ≈0.19); edge state shear+streak
  dominated. **Correction: the edge-manifold normal (the geometric "gate") is
  multi-mode and the roll a3 is ~TANGENT — the naive "a3=gate" is refuted; the
  NS-023 committor-gate is a distinct conditional notion (two notions, not one).**
- **Slice 3 (invariant/scaling quotient):** rotation-invariant scalars (E,Ω,P,H to
  1e-15); the scaling (NS-002) non-compact direction makes E,Ω,P gauge — only
  scale-invariant H and E·Ω descend. **Supercriticality = energy's physical
  exponent −1, which requires the domain (λ⁻³) rescaling, not field-scaling alone.**
- **Slice 4 (Arnold curvature):** sectional curvature via Koszul, **verified κ≡¼
  on bi-invariant SO(3)**; the anisotropic rigid-body metric has a negative plane
  (κ(2,3)=−0.91); Lyapunov λ>0 on the chaotic MFE saddle vs ≈0 on the integrable
  triad — Arnold's unpredictability, measured. (Slices 1 & 4 = one rigid body, two
  sides.)
- **Slice 5 (Arnold curvature of SDiff(T²), ∞-dim):** 2D ideal flow as geodesics on
  the area-preserving diffeo group; algebra built exactly ([v_k,v_l]=−(k×l)v_{k+l},
  energy metric |k|², ∇=½([,]−B−B)). **Verified k∥l⇒C=0 (flat) + symmetry.** Sign
  census (2256 sections): **84% negative (Arnold) / 9% positive (Misiołek)** — both
  reproduced (data, not asserted). Negative curvature ⇒ exponential geodesic
  divergence = Arnold's ~2-week weather-predictability horizon. (Slices 1,4,5 = one
  Lie-group object.)
- **Slice 6 (3D-Euler coadjoint / isovortical structure — the CASIMIR DEFICIT):**
  Euler = coadjoint-orbit flow (ω frozen-in). Demonstrated exactly: **2D Euler
  conserves the whole ∫f(ω) family** (∫ω²,∫ω⁴,∫|ω|,max|ω| to 1.000000) + the sorted
  vorticity distribution — only REARRANGES ω (∞ Casimirs, isovortical ⇒ rigid orbit
  ⇒ regular); **3D Euler conserves HELICITY to 1.000000** (the topological Casimir)
  but **∫|ω|² grows ×6, max|ω| ×3.6** (vortex stretching) — only ~1 Casimir ⇒ loose
  orbit ⇒ open. The Casimir deficit (∞→1) is the coadjoint-geometric form of the
  2D/3D gap — same wall as enstrophy non-coercivity + energy supercriticality (NS-034).
- Evidence: computed (exact where stated; Slice-4 κ≡¼ verified, Slice-5 k∥l⇒0+symmetry,
  Slice-6 helicity conserved / enstrophy not). **Status: :tested. Scope: geometry of
  2D & 3D ideal flow / finite truncations — NOT the 3D-NS PDE.** `:proved` unchanged (0).
- Depends_on: NS-021, NS-022, NS-010, NS-002, NS-004.
- Source: `scripts/manifold_{1,2,3,4,5,6}_*.jl` (+ `.out.txt`), `docs/manifold_study_companion.md`.
- **Rigorous follow-up of Slice 3:** NS-034 (the exact scaling-exponent calculus).

**NS-034 — The scaling-exponent (criticality) calculus: supercriticality made exact.**
The rigorous form of Slice 3. The NS dilation `D_λ: u↦λu(λx,λ²t)` (λ∈ℝ₊,
NON-COMPACT) assigns every homogeneous norm an **exact rational exponent** σ_X with
`‖u_λ‖_X=λ^{σ_X}‖u‖_X` (change of variables on ℝ³): `σ(L^q)=1−3/q`,
`σ(Ḣ^s)=s−½`, `σ(L^p_tL^q_x)=1−3/q−2/p`. Classification: **CRITICAL** (σ=0,
scale-invariant, **descends to the dilation quotient**) = {L³, Ḣ^{1/2}, BMO⁻¹, and
the **Prodi–Serrin–ESS locus 2/p+3/q=1** exactly}; **SUPERCRITICAL** (σ<0) = the
a-priori-controlled energy (σ_E=−1) and dissipation (σ=−1). **Supercriticality is
a precise DESCENT FAILURE:** the regularity question is scale-invariant (lives on
the quotient), but the controlled quantities have σ<0 (do not descend; a bound
`‖u‖_{L²}≤M` gives `‖u_λ‖_{L²}≤λ^{−½}M→0` — vacuous at the small scales where a
singularity lives), while the regularity-deciding norms have σ=0 (uncontrolled).
Controlled σ<0, deciding σ=0, **no overlap = the wall**. This **unifies NS-002
(supercriticality) and NS-005 (the critical-norm criterion)**: the regularity
threshold IS the scale-invariant quotient.
- Evidence: **algebraic** (exact scaling exponents, change of variables) +
  **computed** (continuous-λ verification: `σ(Ḣ^s)=s−½` recovered to quadrature
  precision; PS borderline ⟺ σ=0). **Status: :argued.** Scope: PDE (framing of the
  obstruction — standard criticality theory re-derived + verified; **NOT** a
  regularity proof; does not close the σ<0 / σ=0 gap). `:proved` unchanged (0).
- Depends_on: NS-002, NS-005.
- Source: `scripts/manifold_3b_criticality.jl` (+ `.out.txt`).

**NS-036 — The criticality–Casimir hinge: supercriticality (NS-034) ≡ the Casimir
deficit (NS-033 Slice 6), joined at enstrophy; curvature is independent.**
The §5 capstone "three routes, one wall" made exact. Put the controlled and the
deciding quantities on one homogeneous-Sobolev ladder (NS-034 exponents; σ = the
dilation exponent of the **quadratic** quantity): energy `‖u‖²_{L²}` at **σ=−1**,
critical `‖u‖²_{Ḣ^{1/2}}` (≅ `L³`, the Prodi–Serrin locus) at **σ=0**, enstrophy
`‖u‖²_{Ḣ¹}=‖ω‖²_{L²}` at **σ=+1**. Energy and enstrophy are **symmetric about the
critical line σ=0**, and the deciding quantity is *exactly* their geometric-mean
midpoint by an elementary exact interpolation (Cauchy–Schwarz, `|k|=|k|⁰·|k|¹`):
`‖u‖²_{Ḣ^{1/2}} ≤ ‖u‖_{L²}·‖u‖_{Ḣ¹}`. Hence **bounded energy + bounded enstrophy ⇒
bounded critical norm ⇒ regular**, and the 3D question collapses to **one rung — can
enstrophy be a-priori bounded? — which IS the Casimir question** (Slice 6) verbatim:
2D conserves enstrophy (`(ω·∇)u≡0`) ⇒ controlled ⇒ regular; 3D's Casimir family
collapses to **helicity alone**, itself **σ=0 and sign-indefinite** (coercive over no
norm) ⇒ the σ=+1 rung loses its conservation law ⇒ open. The common mechanism is the
vortex-stretching production `P=∫ω·Sω` — the term that breaks the enstrophy Casimir
(b), the reason the σ=+1 rung is uncontrolled (a), and (up to normalization) the
production skewness `S_ω` of the DIAGNOSTICS track (NS-010/011). So "enstrophy
non-coercivity" is the **name of the joint** of (a) and (b), not a third fact. **Correction:** curvature
(NS-033 Slices 4–5) is a *logically independent* companion, not a third costume —
Arnold's negative curvature is on SDiff(𝕋²), the **2D, regular** case, so negative
curvature ⇒ *unpredictability/sensitivity*, **not** *singularity* (same two-notions
distinction as Slice 2). The honest synthesis is **(a) ≡ (b)** (one fact) **with (c)
independent**.
- Evidence: **algebraic** (exact exponents + the elementary interpolation inequality +
  the exact 2D/3D Euler Casimir algebra of Slice 6) + **computed** (interpolation hinge
  verified in `criticality_casimir_hinge.jl`: ratio ≤ 0.87 for generic multi-scale
  spectra, **= 1.000 iff scale-pure** [single `|k|`-shell] — the gap below 1 *is* the
  multi-scale/cascade content). The computed test covers the **interpolation sub-claim**;
  the entry-level equivalence remains an argument. **Status: :argued.** Scope: NS scaling
  + elementary interpolation + ideal-flow Casimirs — **sharpens the wall to a single
  inequality on a single rung; does NOT close it.** `:proved` unchanged (0).
- Depends_on: NS-034, NS-033 (Slice 6), NS-002, NS-005.
- Source: `scripts/criticality_casimir_hinge.jl` (+ `.out.txt`);
  `docs/criticality_casimir_hinge_companion.md`; `docs/obstruction_program_writeup.md` §5.

---

*Stage 1a DONE (NS-010/011 `:tested`, validated on Burgers, T-01/T-02 PASS). Open
priority (see `dashboard.md`): Stage 1b — apply the validated δ(t) diagnostic to a
spectral Euler/NS truncation, with the BKM (NS-004) and critical-norm (NS-005)
co-movement check (T-04). Remains a diagnostic in models, not a PDE proof.*
