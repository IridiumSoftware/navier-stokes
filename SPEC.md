# SPEC.md — Navier–Stokes Obstruction Program ledger

**v0.6.1 (2026-06-09).** Every entry: `NS-ID | Class | Statement | Evidence |
Status | Scope | Source`. `:cited` = established external theorem (not ours).
`:falsified` = ruled-out approach. `:tested` = we computed it (read the Scope).
`:argued` = manual argument. `:open` = unresolved. `:proved` = rigorous proof of a
PDE statement — **none; reserved.** Firewall: only `Scope: PDE` + `:proved` could
ever count as prize progress; there is none.

Counts: 1 PROBLEM, 8 OBSTRUCTION, 2 DIAGNOSTIC, 1 live RESULT/CONJECTURE (external),
1 CONJECTURE, 6 our RESULTS/FALSIFIED, 2 RELATED (external), 2 PROGRAM, 1 GEOMETRY,
2 ANALYSIS (NS-034 scaling calculus + NS-036 criticality–Casimir), 1 POSSIBILISTIC (NS-037),
3 RESOLVED-DNS (NS-038/039/040), 5 FORWARD-TARGET (NS-045 `:tested` mechanism audit + NS-046/048 `:open`
static/dynamic frontiers + NS-049 `:open` Lockwood conditional-criterion audit + NS-050 `:open`
modulation/Type-II map). `:proved` = 0. (35 entries.)

Active-turbulence phenomenology track → `SIM_SPEC.md` (AT-1..5), Scope ≠ PDE.

**Citation reliability (C0–C5)** — added 2026-06-07 (program meta-review,
`docs/program_meta_review_chatgpt_2026-06-07.md`). Every externally-cited theorem (`:cited`, and any
no-go resting on one) carries a tier — the don't-bluff rule made typed: **C0** unverified mention ·
**C1** secondary-source / restatement only (incl. paywalled-original-via-survey) · **C2** primary
statement read · **C3** proof line-verified · **C4** core mechanism independently re-derived · **C5**
adversarially checked. A no-go's confidence is gated by `tier × independence × scope-match`, and
*citations are witnessable objects, not trusted primitives* — the citation analog of echo≠convergence
(many papers agreeing can inherit one disciplinary blind spot ⇒ a map of assumptions, not of
impossibilities). Tag external citations with their tier when load-bearing; flag every C0/C1. (Worked
example on the NS-048 arc: meta-review doc §4.)

**Mission framing** — added 2026-06-07. This ledger is a **generator-class reduction / search-space
compression engine** (= ORSI's MDAGC, the Minimal Decontaminated Admissible Generator Class), **not** a
proof-contender: it iteratively shrinks the admissible class of plausible attacks by building a
high-fidelity obstruction manifold. Prize value still requires `Scope: PDE` + `:proved` (none). The map's
*acceleration* comes from **global no-go** (a whole method-class excluded — NS-002 supercriticality,
NS-008 averaged-NS, NS-007 self-similar) over **local no-go** ("this specific attempt stalls here");
prefer global, and label which an entry is. **Soft no-go** ("current techniques fail here") ≠ **hard
no-go** (theorem-backed impossibility) — never conflate; the representation may change.
The realized MDAGC object — the positive *necessary-conditions* synthesis ("what any 3D-NS finite-time
singularity must be," `G1∧…∧G5` hard / `S1,S2` soft / `W1,W2` witness, each tier-tagged) — is
`docs/ns_blowup_generator_class.md` (2026-06-07; reorganization, not progress; `:proved`=0). It also fixes
the home of the NS-013/046 phase-coherence arc as a *sharpening of S1* (NS-002), not a new no-go.

**Reading & audit guide** — added 2026-06-10 (after an external naive-read re-raised already-covered
concerns; the standing audit layer is the **A0–A7 cross-audit**, latest `audit_2026-06-09.md`). Before
re-raising "scope creep / undefined promotion / untaxonomized claims," note where each discipline lives:
- **Claim taxonomy** = the **Class** field on every entry (PROBLEM / OBSTRUCTION / DIAGNOSTIC / RESULT /
  CONJECTURE / ANALYSIS / GEOMETRY / RESOLVED-DNS / FORWARD-TARGET / RELATED / PROGRAM / FALSIFIED).
- **Scope matrix** = the **`Scope:`** tag on every entry (PDE / 1D-model / ODE-/3D-truncation / model-DNS /
  phenomenology / methodology). **Only `Scope: PDE` + `:proved` is prize-relevant.**
- **Sub-claim ≠ entry** (conjunctive-claim rule): a verified *part* of a bundled row does **not** upgrade
  the row; the entry holds at the weakest necessary tier with the partial coverage noted (e.g. NS-036).
- **Witness ≠ evidence**: a within-truncation / toy-model computation is a `W#` **witness** (heuristic
  structure), never a `G#` hard constraint — `docs/ns_blowup_generator_class.md` enforces the
  hard/soft/witness split, and every computed entry carries a vacuity cap.
- **Negative results**: `:falsified` requires explicit ruling-out evidence (NS-020); a dead road is logged
  with kill criteria (NS-046 §4) and in the **over-reach ledger** (`changelog.md`), which records every
  declined "sharpens"/"proves" claim.
- **Citation force** = `tier (C0–C5) × independence × scope-match`; *echo ≠ convergence* (many sources can
  share one blind spot).

**Status promotion rubric** (the single state machine; this ledger uses six statuses; `:proved`=0 by
construction). `:verified`/`:benchmarked` are TCE-engine statuses, **not used here**.

| from | to | gate |
|---|---|---|
| — | `:open` | claim stated, no evidence yet |
| any | `:argued` | a written manual argument; **terminal** without machine evidence (never → `:proved`) |
| any | `:cited` | an established **external** theorem; fixed by the literature (we do not upgrade others' theorems); carries a C0–C5 tier |
| any | `:tested` | an **in-repo** computation that **passes its `TEST_SPEC` row** (closed-form / exact-invariant / cross-method / published-number / qualitative-signature) — rises **only within its Scope**; a `:tested` model/truncation result **never** becomes a PDE statement |
| any | `:falsified` | the approach is ruled out, with evidence |
| any | `:proved` | **machine** evidence (lean-proved / type-checked / algebraic-exact) **and** `Scope: PDE`. **Reserved; empty.** A `:tested`/`:argued` result reaches `:proved` only via a *separate* limit/convergence argument that is itself a new `:proved` entry |

**Independence note** — for the MDAGC count, related entries that **rephrase one obstruction in different
language count once**, not as independent confirmations (the C0–C5 force-rule weights `independence`
explicitly). Known clusters:
- **One supercriticality/criticality wall:** NS-002 (scaling) ≡ NS-034 (σ-calculus) ≡ NS-036
  (criticality–Casimir hinge; itself notes NS-034≡NS-033-Slice6) ≡ the NS-013 phase-coherence *sharpening*
  — facets, not four no-gos.
- **One critical-norm/deformation target:** NS-005 (criterion) ↔ NS-036 (enstrophy rung) ↔ NS-046 (the
  deformation inequality that would control it).
- **One wall, two structures:** NS-046 (static inequality) ↔ NS-048 (dynamic exclusion), with NS-049
  (Lockwood conditional) and NS-050 (modulation/Type-II) attacking the same frontier — `docs/ns_blowup_generator_class.md` §6.
- **One diagnostic:** NS-010 ≡ NS-011 (the δ analyticity-strip).
- **One resolved-DNS family:** NS-038/039/040/045 share the TG/helical/tubes machinery — refinements of one
  computation, not independent confirmations.
The **independent hard constraints** are the `G1–G5` of `docs/ns_blowup_generator_class.md`; that doc is the
source of truth for what is genuinely independent.

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
- **Phase-space face (witness, 2026-06-07):** in the DNS truncation the controlled L² invariants (E,Z,H)
  are phase-BLIND (preserved exactly under a random-phase surrogate) while the regularity-deciding
  production `∫ω·Sω` is phase-SENSITIVE (collapses ~97–99% under the same scramble) — a concrete
  illustration that the controlled quantities cannot see the phase coherence carrying the production
  (the NS-013 phase arc, `scripts/ns013_phase_norm_split.jl`). Within-truncation; not a proof; `:proved`=0.

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
- **Detector race (witness, 2026-06-07, `scripts/ns046_critical_norm_race.jl`).** All σ=0 critical norms
  must blow up at a singularity (GKP 2016 / ESS) — but they differ sharply as practical DETECTORS. Raced on
  the Kerr-tube reconnection (Re=1600, N=64): by peak/baseline sharpness the **vorticity Kozono–Taniuchi
  `‖ω‖_{Ḃ⁰_{∞,1}}` is the sharpest (2.5×)** while the **velocity ESS-endpoint `‖u‖_{L³}` is the bluntest
  (1.0×, decays through the event)**; `‖u‖_{Ḃ⁻¹_{∞,∞}}` 1.6×, `‖u‖_{Ḣ^{1/2}}` 1.1×; the controlled energy
  `‖u‖_{L²}` (σ−1) is flat (blind, as it must be). **The theorem-norm ≠ the detector-norm:** the
  velocity-integral critical norms are large-scale-dominated, so the localized small-scale reconnection is
  a tiny fraction of their budget — another face of supercriticality (NS-002) and of the phase/intermittency
  finding (`ns013_phase_norm_split`: the sharp detectors are the intermittency-sensitive ones). Practical:
  monitor `Ḃ⁰_{∞,1}`/`‖ω‖∞` (with the δ-diagnostic NS-010), not `L³`. Scope: within-truncation, REGULAR
  flow — a sensitivity ranking on an intense transient, NOT a blowup race; N=64 (ranking likely strengthens
  with N). `:proved`=0. Companion `docs/ns046_critical_norm_race_companion.md`.

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
- Evidence: **manual (an argued reduction; post-witness, NOT re-witnessed).** **Status: :argued**
  — the PDE question itself remains genuinely open; the argued content is the *reduction below*, not
  an answer. Scope: PDE. Source: `docs/ns013_complex_real_obstruction.md` + `docs/ns013_triad_verdict.md`.
- **Attack + triad-witness (2026-06-04).** An obstruction-map (Li–Sinai exploits the *absent* energy
  bound; reality = the energy bound + conjugate-phase symmetry ⇒ complex⇏real vacuous, real-protection
  ⟺ the NS-002/036 enstrophy wall), corroborated by a reality-leakage ladder (Burgers/CLM/2D/3D), was
  **triad-witnessed → REFUTED on all four checks** (Grok edge-Φ + Gemini synthesis, convergent:
  "vacuous" asserted-not-argued; reduction loose; ladder definitional / gradient a mode-density
  artifact; firewall over-reach). **Withdrawn as a logical barrier.** The sharpened, witness-survivable
  **reduction (the argued content):** reality's Hermitian phase does NOT generically deplete the
  cascade (*real turbulence cascades*), so the protective direction reduces not to "reality=energy"
  but to the **emergent Constantin–Fefferman / Hou–Li geometric depletion** (vorticity-direction
  regularity ⟹ no blowup — conditional, open), connecting NS-013 → NS-006 (CKN geometric) →
  **NS-038's measured `c²_int`** (≈0.72 at the stretching max). Model fact kept: controlled models
  protect, CLM does not; the criticality-gradient *interpretation* is witness-refuted. `:proved`=0;
  distance UNTOUCHED. Sources: `scripts/ns013_reality_ladder{,_2d,_3d}.jl` (+ `.out.txt`); companions
  `docs/ns013_complex_real_obstruction.md`, `ns013_triad_verdict.md`, brief `ns013_triad_brief.md`.
- **Reality-stabilizer probe (Grok Move 4, `scripts/complex_burgers_reality_leakage.jl`):**
  1D complex viscous Burgers (real-data heat-protected; complex-data φ-zero blowup — the 1D
  Li–Sinai analog). A tunable reality leakage λ damping `Im(u)`: λ=0 blows up at t*=5.54
  (Cole–Hopf-validated), and reality PROTECTS with a boundary λ_c∈(0.02,0.05) — T* rises ~22%
  below it (delay), regular above it. Sharpens the conjecture: real regularity ⟺ the
  conjugate complex-singularity pair stays off the real axis. Scope: 1D-model — illustrates
  the mechanism, does NOT establish real⇐complex for 3D-NS. See `docs/move4_ckn_probes_companion.md`.
- **Production-object probe (real-vs-complex, 2026-06-07, `scripts/ns013_realcomplex_production.jl`).**
  Runs the comparison ON the production object. In 1D the exact gradient budget `d/dt½∫g²=−½∫g³−ν∫g_x²`
  makes `P≡−½∫g³` the shadow of the 3D `∫ω·Sω`. **Result (exact, by Fourier support):** the complex-blowup
  class = Cole–Hopf ANALYTIC SIGNALS (one-sided spectrum) ⇒ `∫g³=2π·(g³)_{k=0}=0` (three positive
  wavenumbers cannot sum to 0) ⇒ the production object is **identically zero** through the entire complex
  blowup (`|P|≈1e-16`, `Skew≡0` while `∫|g|²→∞`, `δ→0`); a second one-sided IC confirms it (`|Skew|~1e-15`).
  **Imposing reality (λ↑) restores the two-sided conjugate-symmetric spectrum `û(−k)=conj û(k)` ⇒ `∫g³≠0`,
  Skew climbs 0→0.67** — reality does NOT deplete production, its two-sidedness CREATES it. So the
  complex-blowup channel (off-axis analyticity) and the real-flow production channel are **disjoint
  objects**, **corroborating** the triad "complex⇏real is vacuous." Scope: 1D-model; the Fourier-support
  cubic argument is 1D-specific (3D `∫ω·Sω` is not a single one-sided cubic, so "identically zero" does NOT
  transfer) — what transfers is the *question* (does reality's spectral structure gate the 3D production?).
  `:proved`=0; prize UNTOUCHED. Companion `docs/ns013_realcomplex_production_companion.md`.
- **3D phase-structure follow-ups (2026-06-07).** Answer the production-object probe's flagged 3D question
  via phase-scrambled DNS surrogates (`û→e^{iφ(k)}û`, `φ(−k)=−φ(k)`: preserves `|û(k)|` ⇒ E,Z,H exact +
  div-free, destroys the cubic/triadic phase coherence). (i) **Phase-production**
  (`scripts/ns013_phase_production_3d.jl`): scrambling collapses the 3D production `∫ω·Sω` by **97% (TG) /
  99% (helical)** and `S_ω→~0` while E,Z,H are pinned to ~1e-16 ⇒ the production is a PHASE-COHERENCE
  object, not a spectrum object — the 3D shadow of the 1D `one-sided ⇒ ∫g³=0` result; the "what transfers"
  question answered **YES**. (ii) **Phase-norm split** (`scripts/ns013_phase_norm_split.jl`): the
  controlled L² invariants E,Z,H are phase-BLIND while the production/`S_ω` are phase-SENSITIVE ⇒ a concrete
  phase-space face of supercriticality (→NS-002). HONEST: the BKM/critical-Besov norms `‖ω‖∞`,`Ḃ⁰_{∞,1}` are
  phase-sensitive only for the COHERENT flow (TG `‖ω‖∞`→0.44) and flat for the already-incoherent
  random-helical IC — an intermittency effect, NOT a universal collapse (a 14th over-reach declined).
  Scope: DNS truncation; a phase surrogate diagnoses content-location, not an analytic step; `:proved`=0.
  Companions `docs/ns013_phase_production_3d_companion.md`, `docs/ns013_phase_norm_split_companion.md`.

**NS-049 — Lockwood "Singularity Surgery": the anisotropy-depletion CKN-deformation program (live,
conditional, UNVERIFIED).** James Lockwood's five-part *Singularity Surgery* (working papers, 2026-04-13)
is a serious analytic attack on 3D-NS regularity — a deformation of the Caffarelli–Kohn–Nirenberg local
contradiction in which **anisotropy of the high-vorticity set depletes vortex stretching**. Mechanism: the
dangerous principal strain is a Riesz/CZ operator on the *perpendicular* vorticity,
`S₃₃ = R₁R₃ω₂ − R₂R₃ω₁`, so a small **weighted anisotropy defect** `δ_Λ = 1 − λ_max(M_Λ)/tr(M_Λ)`
(`M_Λ=∫∫χ(|ω|/Λ)ω⊗ω`) forces depletion. The contradiction splits into Case A (low-activity, closed by a
div–curl/energy argument) and Case B (hard). Across Parts I–V the open content is *isolated* (never a
completed proof — his own framing) to a **compactness-rigidity strict-core theorem** (persistent active
enstrophy + vanishing defect ⇒ a frozen-direction core in the limit) and, by Part V, two "final selection"
theorems (core-amplitude selection + harmonic Neumann-trace identification) — reducing regularity to "the
identification of the admissible trace class," with the depletion lemma claimed resolved by the later parts.
- **Evidence: external working papers** — self-contained, AI-chat-developed, single-author, NO bibliography,
  unpublished, no external verification. **Tier: C0/C1. Status: :open** (conditional program; the "resolved"
  depletion lemma + strict-core theorem are themselves **unverified** — do NOT cite as established). Scope:
  PDE (a regularity-attack program, not a result). `:proved`=0; prize UNTOUCHED.
- **Why it bears (and why Lockwood is the right external reviewer):** his depletion mechanism is a candidate
  for exactly the σ=0 production control **NS-046** targets and *uses* the CZ/Riesz structure **NS-047**
  found live; his depletion via **weighted perpendicular-vorticity smallness is explicitly weaker than the
  pointwise Lipschitz-ξ (Constantin–Fefferman) condition** — a refinement of the **NS-013/045** geometric-
  depletion arc; his strict-core rigidity sits in the family of **NS-048**'s ancient-solution rigidity. Two
  independent convergences with this program: (i) his depletion is a **weighted/integral** control, NOT
  pointwise — independently reaching NS-046's conclusion that *any closing inequality must use Besov/integral
  controls, not pointwise domination*; (ii) his **anisotropy** trigger (one-directionality → 2D collapse) is
  a different geometry than this program's **helicity/Beltramization** depletion (NS-040/045, `u∥ω`) —
  relation open.
- **VERIFICATION (2026-06-07, `docs/ns049_lockwood_verification.md`) — engaged the math (line-read I–V).
  The central conditionality is on `δ_Λ→0`, ASSUMED not derived; the multi-directional case is open and
  unadvertised.** The two-scale contraction (Part III Thm 8.1) holds only "with `δ_Λ(0,1)≤ε`"; Part IV's
  Lemma 3.1 (eq 21) converts *absolute* defect smallness to *relative* (`Y_b/Z_n ≤ (ℓM_ω/4m_*)δ_Λ(0,1)`)
  using the Case-B enstrophy lower bound, but the `→0` is still driven by the external `δ_Λ(0,1)→0`. So the
  program proves a **conditional** statement (asymptotically one-directional intense vorticity ⇒ regular);
  the `δ_Λ` bounded-below (multi-directional) case is nowhere addressed — and **our own NS-038**
  (intermediate-eigenvector alignment, sheet/tube reconnection, NOT frozen-direction) is direct evidence
  that this *unhandled* case is the physically-indicated geometry. **Internal probe (2026-06-07,
  `scripts/ns049_anisotropy_defect_probe.jl`, companion `docs/ns049_anisotropy_defect_companion.md`):
  measured `δ_Λ` directly — the resolved dynamics drive it UP, not toward 0.** At the Kerr reconnection
  `δ_Λ` of the top-0.1% `|ω|` cores rises 0.008→0.35→0.59 through the event (the bridge adds directions;
  structure rank-1→3D); at peak intensity the cores sit at δ≈0.32 (TG, planar/sheet) / 0.35 (tubes) / 0.54
  (helical) — bounded well above one-directional in all flows. So *nothing in the resolved flow forces
  `δ_Λ→0`* — it runs the other way at the events where a singularity would form. **Synthesis:** therefore
  `δ_Λ→0` could hold (if at all) only on the **rescaled ancient / Type-I blow-up limit**, not the resolved
  geometry — linking NS-049 to **NS-048** (the sharp fair question: does the ancient limit one-directionalize
  even though resolved reconnections drive `δ_Λ` up?). Vacuity cap: this is *resolved* evidence, not proof
  about the singular limit. Secondary: the depletion lemma is a
  sound-but-unfinalized **skeleton** (his admission; interpolation checks; commutators/harmonic asserted);
  the strict-core "rigidity" is essentially the **definitional** identity `∫χ|ω×e|²=tr(M_Λ)·δ_Λ` (soft once
  `δ_Λ→0`). **Honest reading:** not the unconditional proof its "corners the program" framing implies, but a
  genuine **conditional anisotropic regularity criterion** in the Constantin–Fefferman family with a
  *weaker, integral* one-directionality trigger — citable as such, NOT the prize. (My conditionality finding
  is C3-on-line-read; I may be missing a `δ_Λ→0` derivation — that is the sharpest open question to put to
  Lockwood.) Status stays **C0/C1 `:open` UNVERIFIED**; `:proved`=0.
- **CAUTION (structured-local-coherence, per the meta-review):** a self-contained, internally-coherent,
  AI-assisted reduction claiming to corner NS to a final selection problem is precisely the export-surplus
  hazard this program names. The depletion-lemma and strict-core "resolutions" require **independent
  verification** before any promotion above C1; line-reading Parts III–V (the depletion proof + the strict-
  core rigidity) is the substantive engagement, not a citation.
- Depends_on: NS-046, NS-047, NS-013, NS-045, NS-048, NS-006 (the CKN framework deformed).
- Source: J. Lockwood, *Singularity Surgery* Parts I–V (working papers, 2026-04-13; on file).
  `substrate_source: external@Lockwood-2026:Singularity_Surgery_Part_{I–V}.pdf` (C0/C1, unverified).

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
- **Update (2026-06-01) — the "repair-cost grows" claim tested directly, REFUTED.**
  A further `discrete.rtfd` pass escalated repair-cost into a "dual-closure uplift"
  asserting the PDE is "the wrong model" because repair cost *grows exponentially under
  3D stretching* ("repair overflow → turbulence"), proxied by enstrophy. Tested on the
  validated 3D solver: the real minimal filling of the vorticity is the **velocity**
  (`R_X(ω)=min{‖z‖:∇×z=ω}=‖curl⁻¹ω‖=‖u‖=√(2E)`, one derivative smoother than `ω`). On
  inviscid Taylor–Green, enstrophy½ grows ×3.34 (‖ω‖∞ ×10) while `R_X` drifts ×1.0000
  (= the *conserved* energy); ratio `R_X/‖ω‖` decays 0.577→0.173 (the `1/vorticity`,
  now verified under stretching). The "grows" claim holds only of the enstrophy **proxy**
  it was swapped for; the real cost is the energy-side (σ=−½, supercritical) quantity —
  same wall as NS-036, relabeled. `:proved`=0. Source: `scripts/repair_cost_under_stretching.jl`
  (+ .out.txt), `docs/repair_cost_under_stretching_companion.md`. (Scope of refutation:
  the field/Hodge `L²`-repair version + the general derivative-smoother argument; the
  explicit 2-chain Seifert-surface version is the DEC-sandbox follow-up.)
- **Update (2026-06-01) — DEC sandbox (the 2-chain version + "b₁ pinned"), confirmed.**
  Built a genuine structure-preserving cubical chain complex on 𝕋³ (Serre operators,
  `∂∂=0` to machine zero — a legitimate DEC/mimetic substrate). Two results on the *actual
  mesh*: (i) **`dim H₁(𝕋³)=3` at every resolution N∈{3,4,6}** — refinement does not
  manufacture new 1-cycle classes; `b₁` is pinned (the structural core of this entry,
  confirmed). (ii) The genuine **2-chain repair cost** `min{‖z₂‖:∂₂z₂=c₁}` of a filament
  1-cycle does NOT overflow: peak label `‖z‖∞` *decreases* (0.66→0.38) as the loop grows,
  total grows only sub-linearly (below √area); the only infinite-cost cycles are the 3
  fixed H₁ generators. Completes the part-1 field/Hodge refutation in the chain picture.
  The discrete substrate is real and kept as a sandbox; it does NOT support the
  "dual-closure uplift / PDE-is-wrong" claim. `:proved`=0. Source:
  `scripts/dec_repair_sandbox.jl` (+ .out.txt), `docs/dec_repair_sandbox_companion.md`.

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
- **Re-run v2 (2026-06-04, MATURED 30-node ledger NS-001..040; corpus + out.txt updated).** The
  engine independently recovered the new clusters: **{NS-038,039,040} resolved-DNS** (HIGH @0.95),
  **{NS-010,011,032} diagnostic→blowup-hunt** (HIGH @1.0), and elevated the **critical-norm cluster
  {NS-005,008,033,034}** (HIGH) — NS-005 (the one open backward path NS-002 leaves) is the structural
  HUB, also dominating the MID band. The enstrophy-rung convergence {NS-002,006,036} reads as a
  *loose MID-band coordination* (a reduction chain, not a tight triad), and the NS-013↔DNS geometric-
  depletion link surfaces at LOW ({NS-013,039,040} @0.70) — corroborating the c²_int consistency. The
  closure tier-wall (NS-024/030/031 the only bridges) still holds at 30 nodes. Consolidation:
  `docs/ns_corollaries_synthesis.md` (the no-go corollaries + this self-map). Status unchanged `:tested`.
- **Re-run v3 (2026-06-06, 32-node ledger; added NS-045 + NS-046; corpus + out.txt updated).** The two
  new entries slot in self-consistently, disturbing no established cluster: **NS-045 (Beltramization)
  joins the resolved-DNS family — {NS-038,039,040,045} is now a tight HIGH-band clique @0.90–0.95**;
  **NS-046 (the deformation-inequality target) lands in the MID band on the criticality cluster
  {NS-034,036,046} @0.83** (the apex of the hinge, not floating free); and the NS-045↔NS-046 link reads
  **LOW** ({NS-040,045,046} @0.68) — the engine independently rates the mechanism↔target coordination as
  *loose*, corroborating the §10 witness verdict that the "complementarity" is IC-specific, not a tight
  law. 155 candidates; closure tier-wall intact. Status unchanged `:tested`.

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
- **N=256↔512 GPU confirmation (the N≳512 the entry called for; `metal/dns_gpu.swift`,
  MPSGraph/Metal 4, ν=0):** ran the candidate at N=256 and N=512 with the full **T-06 (G1
  δ·k_cut>6 / G2 spectral-N-convergence / G3 BKM co-movement) + T-08** gate, scored by
  `scripts/step2_gate.jl`. **Verdict still INCONCLUSIVE / regular-leaning:** in the strict
  resolved window (t≤4.5) the full-band δ-fit differs **42–48% between N=256 and N=512** (G2
  FAILS — the documented window-sensitivity, now pinned at real resolution), δ extrapolates to
  t*=∞ (exponential), and does **not** co-move with the winf/BKM growth (G3 FAILS). A naive δ→0
  would be a resolution artifact; the gate refuses it. Extends the N=32/64/128 NULL to N=512 and
  validates the gate protocol itself. Companion `docs/step2_gate_inviscid_tg_companion.md`.
- Depends_on: NS-010 (Stage 1c-3D Step 1), NS-004 (BKM gate T-06), NS-031 (gates),
  NS-039 (T-08 dimension-guard calibration).
- Source: `scripts/spectral_3d_blowup_candidate.jl` (+ `.out.txt`);
  `scripts/blowup_highres.jl` (+ `.out.txt`, N=128 confirmation); `scripts/step2_gate.jl` +
  `metal/dns_gpu.swift` + `metal/euler_tg{256,512}.txt` + `metal/delta_tg{256,512}.dat` (N=512 GPU).
- **N>512 push SIZED + DEFERRED (2026-06-06).** Measured the GPU cost directly: `metal/dns_gpu.swift`
  inviscid TG runs at **10.4 s/step at N=512** (inviscid ⇒ the spectrum fills the grid ⇒ full FFT every
  step). So the N>512 push is **~10–15 hr at N=768** (mixed-radix `2⁸·3`) **to ~33 hr at N=1024** (clean
  power-of-2; + real OOM risk on the M5 Max). **Deferred** — the trade is poor: it is **vacuity-capped**
  (a finite truncation can never settle the PDE; a δ→0 there is suggestive-in-a-truncation, never a
  proof) and **most likely another gated INCONCLUSIVE** (the N=256↔512 δ-fit was already 42–48%
  non-converged; the inviscid-TG near-singularity needs N≫1024 to resolve, so one resolution step most
  probably re-hits the wall). NS-032 stays the open computational frontier, now with a concrete price
  tag. Status unchanged (`:tested`/null); `:proved`=0; distance UNTOUCHED.

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

**NS-036 — The criticality–Casimir hinge: supercriticality (NS-034) and the Casimir
deficit (NS-033 Slice 6) are the *same bottleneck* (enstrophy non-coercivity) through two structures,
joined at enstrophy; curvature is independent.**
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
distinction as Slice 2). The honest synthesis (sharpened 2026-06-05 per external review): **(a) and
(b) are the same bottleneck — enstrophy non-coercivity — through two different structures (scaling-
descent-failure / Casimir-loss), linked by the interpolation but at different logical levels; mutually
illuminating, NOT literally one fact** — **with (c) independent**. ("≡" was an over-compression: scaling
says what estimates can't close, Casimirs say what invariants exist.)
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

## POSSIBILISTIC / EMPIRICAL MAP (prize-focus deliberately dropped — maps the *phenomenon*)

**NS-037 — Inverse-Born / possibilistic map of turbulence's measured constants.**
A deliberate pivot off the Clay problem: instead of mapping *necessity* (the walls), map
*possibility* (what the no-go's do not exclude) and *probability* (what turbulence actually
does — the measured constants) of the physical phenomenon, on its natural manifolds, using
the closure-v5 **inverse-Born obstruction methodology** (`closure-v5
BUSINESS/inverse_born_methodology.md`, A. Green, Apr 2026). Three results:
- **(a) The map (descriptive).** The multifractal formalism is a literal large-deviation /
  Born structure: `ζ_p = inf_h[ph+3−D(h)]`, so measured moments `ζ_p` are the Legendre
  transform of the singularity spectrum `D(h)` (the possibility structure / rate function).
  **Inverse-Born = inverse Legendre** `D(h)=3−max_p[ζ_p−ph]` recovers `D(h)` from data. The
  recovered spectrum peaks at `D=3` (h≈0.38), passes the K41/Onsager pivot (h=1/3 ⟺ σ=0,
  NS-036), and **runs down to the CKN wall** (D=1 at h=1/9): the attractor sits *against*
  the no-go. (Wall manifold: onset `Re_c` = laminar-forbidden→possible, NS-021; log law
  forced-by-overlap. Hinge: the dissipation anomaly forces the spectrum to h=1/3.)
- **(b) The obstruction (the cascade by no-go).** Applying only the **frame-independent**
  hard invariants (ζ_3=1, D≤3, ζ_p monotone+concave [realizability], CKN, the codim-2
  integer) over the finite family of cascade models: the **log-normal (K62) cascade is
  FORBIDDEN** — `ζ′_p<0` past `p*=3/μ+3/2≈16.5` and `D(h)<0` (two realizability violations) —
  a clean structural NULL. The log-Poisson/She–Lévêque class survives, pinned by structural
  integers (codim-2 = 1-D filaments, `D(h_min)=1` exactly), not fitted numbers.
- **(c) The forced/frame-dependent boundary (the discipline's payoff).** The hard layer
  promotes the intermittency exponent to the **structural inequality `μ ∈ [0,1]`** (μ≤1 from
  monotonicity ζ_6≥ζ_3=1; μ≥0 from concavity ζ_6≤2), **tight** (K41 saturates 0, ramp-then-
  flat saturates 1) — but **no tighter**: CKN is vacuous for regular flow (h≥0, no singular
  set), so the observed μ≈0.2 (interior) is frame-dependent and cannot be imported as
  structure. The map cleanly separates what is *forced* (ζ_3=1, the ≤1-D filament integer)
  from what is *frame-dependent* (μ, C_K, κ — convergence targets, never anchored).
  **Refinement — a "touchability" RANKING of the constants** (`kolmogorov_dissipation_hard_test.jl`):
  the same test on C_K and C_ε stratifies how far NS's rigour reaches. **C_ε** (dissipation
  anomaly) is the *most*-touched: it has a RIGOROUS finite upper bound (Doering–Foias–Constantin,
  `C_ε ≤ c_1/Re + c_2`, from the NS energy balance), with positivity the empirical zeroth law
  and value frame-dependent. **Exponents** (ζ_2∈[2/3,1], μ∈[0,1]) are bracketed by realizability.
  **C_K** (a 2nd-order *amplitude*) is the *least*-touched — purely frame-dependent: the 4/5 law
  is 3rd-order so touches it not at all, realizability bounds exponents not amplitudes, only
  C_K>0 holds. Principle: NS's rigorous reach = exact laws (4/5, 3rd-order) + realizability
  (exponents) + the energy balance (dissipation rate); it does NOT reach spectral amplitudes.
- Evidence: **algebraic** (the Legendre duality; ζ_3=1; the realizability/concavity bounds
  μ∈[0,1]; the log-normal `ζ′<0`/`D<0` violations — all exact) + **computed** (`D(h)`
  inversion; the obstruction grid; the μ-bracket extremals + 10⁴-sample non-violation check).
  **Status: :argued.** Scope: **EMPIRICAL phenomenology + the exact 4/5 law + realizability
  no-go's — NOT the 3D-NS PDE.** The prize was deliberately not the target; `:proved`=0;
  distance to the prize UNTOUCHED.
- Depends_on: NS-006 (CKN), NS-009 (Onsager / 4-5 law), NS-036 (criticality–Casimir hinge),
  NS-021 (subcritical lifetimes / onset).
- Source: `scripts/turbulence_nogo_map.jl`, `turbulence_inverse_born.jl`, `mu_hard_bound.jl`,
  `kolmogorov_dissipation_hard_test.jl` (+ `.out.txt` each); companions
  `docs/turbulence_nogo_map_companion.md`, `turbulence_inverse_born_companion.md`,
  `mu_hard_bound_companion.md`, `kolmogorov_dissipation_hard_test_companion.md`.
- **Honesty notes (recorded):** (i) the data "saturating CKN" is a geometric *consistency*,
  not an identity (intense filaments vs hypothetical singular set); (ii) the random-ensemble
  μ-minimum 0.200 coincides with the observed μ but is a *sampling artifact*, not a bound
  (true lower end is 0). Both flagged so they are not mistaken for derivations.

---

## RESOLVED DNS — the boundary-exploration program (N=256, FFTW-validated)

**NS-038 — Resolved N=256 DNS verdicts across three flows (the boundary queue A→B→C).**
The first runs to use the real ~6-hour compute budget: a *resolved* viscous pseudospectral
DNS at **N=256, Re=1600** (hand-rolled radix-2 FFT, later FFTW-validated; `δ·k_cut≈6.5–7.5`
⇒ the analyticity strip is wider than the grid scale ⇒ resolved), **validated against the
literature** (Taylor–Green enstrophy/dissipation peak at **t≈9.0**, matching Brachet 1983).
Three boundaries, energy-matched (E≈0.125):
- **A — Taylor–Green (H=0).** `S_ω` **bounded ≈0.2** (transient peak 0.29 at t≈4); `δ`
  bounded (min 0.077, never→0); the top-production box-dimension is **dynamic** — D30 floors
  ~1.33, D50 ~1.82, **never ≤1** under distributed stretching; the strain–vorticity alignment
  `c²_int` **peaks at 0.72 at the stretching maximum** then relaxes (geometric depletion of
  nonlinearity, Hou–Li, observed directly). Energy decays monotonically.
- **B — helical (H≠0, ρ_H≈1% — weakly helical).** Same qualitative verdicts (S_ω bounded
  ≈0.147, δ bounded, D dips-then-recovers, regular) ⇒ **the verdicts are IC-robust, not
  TG-specific.** Quantitative differences (earlier/lower enstrophy peak; D50 floors at 2.07,
  *less* localized) *suggest* helicity reduces localized stretching but are **confounded**
  (weak helicity + low-k-random IC) — a clean test needs a strongly-helical (ABC/Beltrami) IC.
- **C — anti-parallel vortex tubes (Kerr, the near-singular IC).** A genuine **reconnection
  event** at t≈5.5–6: ‖ω‖∞ spikes ~4× (26→97), S_ω doubles (0.10→0.24), δ dips to its min
  (0.088), and the most-intense-30% set **D30 transiently reads ≈0.99 — momentarily at the
  CKN ≤1 filament edge** — then recovers. **Flow stays REGULAR** (δ bounded + resolved;
  alignment stable). The ≤1 touch is **reconnection-specific** (A/B's distributed stretching
  floors D30 ≥1.33), confirming it is a real reconnection-localization, not a TG artifact.
- Evidence: **computed** (resolved DNS, literature-validated; FFTW≡hand-rolled cross-check
  passes at N=64 bit-equal and N=256 on all physics). **Status: :tested.** Scope: **resolved
  3D pseudospectral DNS truncation — NOT the 3D-NS PDE.** All flows REGULAR (as Re=1600 must
  be); these are *resolved diagnostics*, not a blowup test. `:proved`=0; distance UNTOUCHED.
- Depends_on: NS-010 (δ diagnostic), NS-004 (BKM/‖ω‖∞), NS-006 (CKN ≤1), NS-037 (the (h,D) /
  multifractal framing the D-dimension instantiates).
- Source: `scripts/dns_tg256.jl` (+ `dns_tg256{,_helical,_tubes}.out.txt`); companion
  `docs/dns_tg256_companion.md` (A/B/C + FFTW-validation addenda); diagnostics validated in
  `docs/triad_verdict_dns_localization.md`.
- **Required Witness Check (RWC-038, carried from the triad).** Any future claim of an
  "approach to the singular set" from this program MUST clear: (i) **threshold-robustness**
  (D not an artifact of the top-X% cut — D is threshold- AND resolution-dependent; the D30≤1
  touch is the noisiest signal, top-30%, ±0.15, single sample, recovers in one Δt); (ii) a
  **resolution-robust dimension estimator**; (iii) **IC-independence**; (iv) **N-convergence**.
  The C reconnection peak (‖ω‖∞≈97) is at the **edge of N=256** ⇒ a true ≤1D verdict *at
  reconnection* needs **N≥512** (the open frontier; GPU/Metal territory). The discriminator
  for regular-vs-singular is the *functional form* of δ(t) (algebraic collapse vs exponential
  leveling), practically near-degenerate at N≤256.

**NS-039 — GPU N=512 resolves the RWC-038 frontier: the C reconnection D30≈0.99 ≤1 touch
is a resolution artifact.** RWC-038 required N≥512 to decide whether C's vortex-tube
reconnection `D30≈0.99` (the CKN ≤1 filament edge, single sample at the edge of N=256) is
physical or numerical. Built a GPU spectral solver (`metal/dns_gpu.swift`, MPSGraph/Metal 4,
M5 Max; rotational-form rhs + RK4 entirely in-graph, float32) feeding the **same
CPU-validated Julia diagnostics** via spectral-field snapshots (`scripts/load_gpu_snapshot.jl`).
Validated float32-GPU ≡ float64-CPU **to 5–6 digits**: TG N=256 Brachet peak Z/Z0=27.3902
(CPU 27.3901), snapshot D30/50/70=1.650/1.963/2.191 (identical); tubes N=256 reconnection
D30 1.718/**0.986**/1.590 (CPU identical) — the ≤1 touch reproduced to the digit where found.
- **Verdict (N=256→N=512, dt and IC fixed; tubes; div-free throughout, divRel~5e-7).** The
  reconnection D30 minimum lifts **0.986 (N=256) → 1.426 (N=512)**, finely time-sampled
  (Δt=0.25: D30 = 2.019/2.013/**1.426**/1.721/1.563 at t=5.0/5.25/5.5/5.75/6.0) — the dip is
  *not* undersampled; its minimum sits at t=5.5 (same as N=256), bracketed above 1.7. The ≤1
  touch **does not survive resolution**.
- **Why an artifact, not a singular-set approach.** (a) N-convergence is *upward, away from 1*
  (a genuine ≤1-D filament sharpens *toward* ≤1; a +0.44 jump is under-resolution at N=256 —
  whole spectrum lifts: D50 1.657→1.980, D70 1.856→2.111). (b) N=512 resolves a *more intense*
  reconnection (winf 84→97 at t=5.5, 97→124 at t=6.0) that is *less* localized by D — opposite
  to a singularity approach. (c) RWC-038 pre-flagged exactly this (noisiest signal, ±0.15).
- **TG N=512 resolution cross-check (the literature anchor):** Brachet enstrophy peak
  Z/Z0=27.4254 at t=9 (N=256 27.39; resolution-robust); D50/D70=1.965/2.186 ≈ N=256
  1.963/2.191; D30 1.650→1.767 (rises with N, same direction, stays ≫1) — confirms the box
  estimator holds/rises with N, never drifts toward ≤1.
- RWC-038 status: (i) threshold — whole D-spectrum lifts; (ii) estimator — same CPU-validated
  box-count, cross-checked on TG; (iii) IC — touch is tubes-specific (A/B floor D30≥1.33);
  (iv) N-convergence — 0.986→1.426. **All four cleared.** The δ(t) functional-form
  discriminator remains near-degenerate at these N and is **not** claimed resolved.
- Evidence: **computed** (resolved DNS; GPU float32 ≡ CPU float64 to 5–6 digits;
  literature-validated on the Brachet TG peak). **Status: :tested.** Depends_on: NS-038
  (A→B→C program & RWC-038), NS-006 (CKN ≤1), NS-004 (BKM/‖ω‖∞).
- Source: `metal/dns_gpu.swift`, `scripts/load_gpu_snapshot.jl`,
  `metal/gpu_tubes{256,512,512_fine}.txt`, `metal/gpu_tg{256,512}.txt`; companion
  `docs/dns_gpu_metal_companion.md`. Snapshots gitignored (3.2 GB at N=512).
- Scope: **resolved 3D pseudospectral DNS truncation — NOT the 3D-NS PDE.** All flows REGULAR
  (Re=1600); this *removes a false ≤1D "approach to singular set" signal*, asserts no
  regularity/blowup result. `:proved`=0; distance UNTOUCHED.

**NS-040 — Strong helicity depletes (delays + concentrates) vortex stretching: the clean
matched-spectrum test.** Resolves NS-038 case B (confounded, ρ_H≈1%, low-k-random). A GPU
controlled pair — `helical` (ρ_H=0.97) vs a NON-helical control `helicalc` (ρ_H=0.05) with
**identical E0=0.125 AND Z0=0.534374** (same energy+enstrophy spectrum, helicity flipped via the
± helical-mode sign of a +helical Beltrami-wave superposition) — at Re=1600, **N=256↔512
(resolution-robust to 3–4 digits)**.
- **Net depletion:** helical enstrophy grows **2–4× slower** (Z/Z0 @t=6: 1.59 vs 6.67; @t=10:
  6.87 vs 13.03); energy decays slower (E/E0 @t=10: 0.89 vs 0.69) ⇒ helicity inhibits the cascade.
- **Mechanism = delay + concentration, not elimination:** the helical cascade is suppressed
  early, then a *delayed, intense, localized* burst (winf 154, S_ω 0.26 @t=9 vs the control's
  already-declining 0.15; burst top-production set ~1.7–2D, D30 rising with N 1.47→1.73 per
  T-08 — not filamentary). Integral enstrophy stays far lower throughout. `abcpert` (ρ_H=0.98,
  large-scale) is near-laminar (Z/Z0=1.15 @t=10) — extreme depletion, same direction.
- Evidence: **computed** (GPU float32 vs a matched control; N-convergent to 3–4 digits).
  **Status: :tested.** Depends_on: NS-038 (boundary program A→B→C), NS-022 (helical triad).
- Source: `metal/dns_gpu.swift` (helical/helicalc/abcpert ICs) + `scripts/load_gpu_snapshot.jl`
  + `metal/B_{helical,helicalc,abcpert}_{256,512}.txt`; companion
  `docs/helicity_depletion_companion.md`.
- Scope: **resolved 3D pseudospectral DNS truncation — NOT the PDE.** All flows REGULAR
  (Re=1600); a mechanism result on helicity vs stretching, asserts no regularity claim.
  `:proved`=0; distance UNTOUCHED.

---

*Stage 1a DONE (NS-010/011 `:tested`, validated on Burgers, T-01/T-02 PASS). Open
priority (see `dashboard.md`): Stage 1b — apply the validated δ(t) diagnostic to a
spectral Euler/NS truncation, with the BKM (NS-004) and critical-norm (NS-005)
co-movement check (T-04). Remains a diagnostic in models, not a PDE proof.*

---

## FORWARD TARGETS — collaborator extension (Brian; `:open`)

*Origin: Brian's extension notes (2026-06-05), re-numbered into the obstruction ledger (his draft
labelled both "NS-041" on an older spec). **CCATT** = **Certified Constraint-Access Transport Theory**
(Brian's framework, definition relayed 2026-06-05) — now recorded in `docs/ccatt_reference.md` so it is
not a hidden primitive when cited below. Canonical upstream source (paper/repo) still TBD. CCATT is an
epistemic/methodological governance layer; citing it does not change `:proved`=0 or the prize distance.*

**NS-045 — Helicity-depletion mechanism audit (HOW does NS-040 deplete?).**
NS-040 established that strong helicity depletes vortex stretching (matched-spectrum pair, ρ_H≈0.97 vs
≈0.05, identical E₀ and Z₀). NS-045 asks *by what mechanism*: reduced ω–S alignment, increased
Beltramization (u∥ω), modified helical-sector transfers, or delayed scale-to-scale flux. Diagnostics
on the same matched pair: global production `P(t)=∫ω·Sω`; normalized skewness
`S_ω(t)=P/⟨|ω|²⟩^{3/2}`; relative helicity `ρ_H(t)=H/(2√(EΩ))`; integrated alignment `c²_int(t)`;
spectral transfers `Π_E(k,t), Π_Z(k,t), Π_H(k,t)`; helical-mode decomposition
`u(k)=u₊(k)h₊(k)+u₋(k)h₋(k)` with sector-to-sector transfers `T^{++→+}, T^{+−→−}, …`.
- **Pass:** resolution-converged (N=256↔512) reduction/delay in `P(t)`, `S_ω(t)`, or enstrophy flux
  that *correlates with* a specific alignment / Beltramization / sector-transfer diagnostic — a
  mechanism *beyond* scalar helicity conservation.
- **Fail:** depletion vanishes after conditioning on spectrum + alignment + sector transfers ⇒ NS-040
  is a phenomenological correlation, not a mechanism.
- **RESULT (2026-06-05) — the mechanism is (b) BELTRAMIZATION, not (a) ω–S alignment.** On the matched
  pair (rebuilt in the ± helical basis: `|ΔE|=1.4e-17`, `|ΔZ|=2.2e-16`, ρ_H=+0.968 vs −0.069 — exact),
  the *only* large helical-vs-control difference present **from t=0** is the Lamb-vector geometry: the
  normalized `⟨|u×ω|²⟩/⟨|u|²|ω|²⟩` is **0.026 (helical) vs 0.69 (control), ~26×**, with `cos²(u,ω)=0.92`
  vs 0.32. Since `u×ω` *is* the nonlinear driver, strong helicity (u∥ω) geometrically switches off the
  production ⇒ enstrophy growth delayed; the depletion ends as the field de-Beltramizes (helical lamb²
  0.026→0.48, ρ_H 0.97→0.80 by t=8) — NS-040's "delay + concentration", now mechanistic. The ω–S
  alignment `c²_int` develops **near-identically** in both members (0.33→0.56 vs 0.33→0.66), so (a) is a
  *lagging consequence*, not the cause. **N-converged 16↔64↔128** (the signal is IC-geometry-fixed).
  PASS (Brian's condition: a delay correlating with a mechanism diagnostic beyond scalar helicity).
- Evidence: **computed (N=16/64/128, matched-spectrum pair). Status: :tested.** Scope: **resolved 3D
  pseudospectral DNS truncation — NOT the PDE.** Caveat (LOW#1 lesson): certifies the within-truncation
  mechanism only — a regular truncation cannot certify the singular-limit mechanism. `:proved`=0; prize
  untouched. (Deeper sector-transfer tensor `T^{++→+}` and the GPU N=256↔512 full pass remain optional
  follow-ups; the IC-geometry-fixed mechanism is already N-converged.)
- Depends_on: NS-040, NS-022 (helical triad). CCATT note (defined, `docs/ccatt_reference.md`): "helicity scalar conservation
  ⇏ mechanism certificate" — the audit exhibits the explicit transport *H-rich geometry → Beltramization
  (u∥ω) → Lamb-vector `u×ω` suppression → ω–S production depletion → delayed enstrophy growth*.
- Source: `scripts/ns045_helicity_mechanism.jl` (+ `.out.txt` N=64, `_N128.out.txt`); companion
  `docs/ns045_helicity_mechanism_companion.md`.
- **Extension (2026-06-06, Idea-3 zero-helicity stress test) — the depletion mechanism is
  helicity-dependent and COMPLEMENTARY.** Probed the mechanism across the helicity range
  (helical ρ_H=0.97 / control ρ_H≈0 / **anti-parallel tubes** ρ_H=0-exact + max-stretch = the
  weakest-Beltramization worst case). Beltramization dominates at high H; at the **zero-helicity
  maximal-stretch (Kerr-tube)** case where Beltramization is weakest (cos²(u,ω)→0.07), the **nonlocal
  pressure-Hessian counter-transport is DOMINANT** — `⟨e₃ᵀ(∇²p)e₃⟩` is 1.5–11× the self-amplification
  `⟨λ₃²⟩` (it enters as `−e₃ᵀ(∇²p)e₃` ⇒ depletes the max stretch), and the tubes attain the *lowest*
  enstrophy growth despite maximal stretching. The control (neither mechanism strong) bursts most.
  N-converged 64↔128 (ordering IC-identical, resolution-robust). **WITNESS-CORRECTED (triad 3/3,
  2026-06-06): the "complementary, anti-correlated-with-helicity" reading is REFUTED as a general law —
  the *random* zero-helicity control does NOT show pressure dominance (it bursts most), so it is
  not "zero-H ⇒ pressure dominates" but "the *Kerr-tube* (special, symmetric) IC shows stronger pressure
  depletion than the helical run." IC-specific phenomenology, not a complementarity law.**
  Scope: DNS truncation, within-truncation only (vacuity cap). Source:
  `scripts/ns046_gradxi_pressure_probe.jl` (+ `.out.txt`, `_N128.out.txt`); companion
  `docs/ns046_gradxi_pressure_companion.md`. Status unchanged `:tested`.

**NS-046 — Critical coercive deformation inequality (the pressure–strain closure target).**
The admissible analytic target after the criticality–Casimir hinge. Once regularity reduces to bounding
the production `P(t)=∫ω·Sω` (NS-036; MID-coordination identity `P=∫|ω|²(ξ·Sξ)`), the question is
whether the **nonlocal pressure Hessian** + strain geometry + viscosity supply a *coercive* inequality
controlling a critical (σ=0) quantity uniformly in time. Local eigenframe dynamics:
`Dλ₃/Dt = −λ₃² − e₃ᵀΩ²e₃ − e₃ᵀ(∇²p)e₃ + νΔλ₃ + (eigenframe rotation)`, with nonlocal recovery
`∇²p = |S|²−|Ω|²`. **Target:** a bound `D_crit(u) ≲ R_pressure(S,ω) + νR_visc(S,ω) + (controlled
lower-order)` with `D_crit` a σ=0 functional (L³, Ḣ^{1/2}, Prodi–Serrin) dominating the production at
the same scaling — equivalently `∫_{Ω_high(t)} ω·Sω ≤ (critical coercive dissipation) + (lower-order)`
uniformly, on CKN-compatible (filamentary / sheet / intermittent) high-strain sets.
- Admissibility: acts at σ=0 (not energy scale); controls the production channel or an implied critical
  norm; incorporates the nonlocal pressure term explicitly; survives localization to CKN-compatible
  sets; **DNS/model evidence admissible only as witness / counter-witness generator, never as the
  analytic step**; any depletion claim must export to a *quantitative inequality*, not stay descriptive.
- **Incorporates this session's witness lessons:** the MID-witness refuted "local ∇ξ-alignment is the
  deficit" precisely because local alignment must survive the nonlocal pressure-kernel counter-transport
  (Q2); NS-046 makes that nonlocal term (the pressure Hessian) the explicit object. It is a **sharp
  formulation of the hard core, NOT progress.**
- Evidence: **none (analytic target). Status: :open** (analytic target). Scope: **PDE-analysis target
  (deformation geometry / pressure–strain interaction).** `:proved`=0; prize untouched.
- Depends_on: NS-005, NS-034, NS-036, NS-006 (CKN localization). CCATT note (defined, `docs/ccatt_reference.md`): "recoverable
  transport" — every term derives from NS + eigenframe + elliptic pressure recovery + scaling,
  invariant under admissible transport (dilation, localization, pressure-kernel counter-transport).
- Source: Brian's extension notes (2026-06-05); `docs/obstruction_program_writeup.md` §5 (the
  criticality–Casimir hinge) is the upstream context.
- **LP/harmonic-analytic route analyzed + witnessed (2026-06-05; NS-047 candidate → REFUTED, folded
  here, NOT a new entry).** Tested whether the straightforward Littlewood–Paley / paraproduct-local-
  coercivity scheme reduces NS-046 to known walls. Witnessed 3/3 (Grok edge-Φ + Gemini + naive ChatGPT,
  convergent). **C1 REFUTED:** "controlling the pressure Hessian must strike the BKM L^∞-endpoint" is a
  *false dichotomy* — CZ/Riesz operators are bounded on critical Besov `Ḃ⁰_{∞,1}` (no log-penalty), and
  LP machinery *slices around* the L^∞ endpoint, so a critical-*Besov* coercive bound need never invoke
  BKM (NS-004). **C2 HOLDS (modestly):** the maximal-function tail-absorption needs a local-Reynolds
  smallness that CKN generates only on already-regular cylinders ⇒ the gap relocates to the ≤1-D
  singular set (NS-006), where local Reynolds is O(1) — a restatement of the known supercritical
  difficulty, not a new barrier. **Net:** the harmonic-analytic route is **NOT blocked at BKM** (the §11
  `∇ξ`-frontier kill-criterion does NOT fire — a harmonic-analytic route is genuinely live); its real
  obstacle is the supercritical smallness on the CKN singular set, and the correct framework is
  **critical Besov, not L^∞**. A diagnostic, not a no-go. (Fourth tidy-"reduces to the wall" over-reach
  this session, witness-corrected.) Brief + verdict: `docs/ns047_lp_route_brief.md`,
  `docs/ns047_lp_route_verdict.md`.
- **DNS witness for the counter-transport object (2026-06-06, Idea-3 probe; NS-045 §extension).** In the
  resolved truncation, NS-046's `−e₃ᵀ(∇²p)e₃` counter-transport is the **dominant** depletion exactly in
  the **anti-parallel-tube (zero-helicity, maximal-stretch) worst case** — `⟨e₃ᵀ(∇²p)e₃⟩` is 1.5–11×
  `⟨λ₃²⟩` (N-converged 64↔128), and that flow stays the most regular despite the weakest Beltramization.
  This is a **witness/calibration** that the pressure-Hessian object is the operative one in the hard
  regime — NOT the analytic step (a regular truncation observes the term; it does not bound it).
  `scripts/ns046_gradxi_pressure_probe.jl`; companion `docs/ns046_gradxi_pressure_companion.md`.
  `:open` unchanged.
- **Uniform-domination sub-probe (2026-06-06) — the depletion is NON-UNIFORM; the inequality's
  uniformity FAILS even in the truncation (qualifies the line above).** Conditioning the ratios on the
  top-{100,10,1,0.1}% production set (`ns046_uniform_domination_probe.jl`): `⟨e₃ᵀ∇²p e₃⟩/⟨λ₃²⟩` is
  **negative on the full field** (the pressure *enhances* the max-stretch on the bulk — Vieillefosse),
  turning strongly positive (depleting) **only at the extreme high-`|ω|` cores** (top-0.1%: 8–16 in
  tubes, →2.6 late-helical; the control never dominates), and the viscous `⟨ν|∇ω|²⟩/⟨ω·Sω⟩` is **≪1 on
  the intense set** (supercriticality). So the Idea-3 "dominant" was an enstrophy-weighted statement
  about the cores; the domination is **concentrated, not uniform** in the truncation. **WITNESS-CORRECTED
  (triad 3/3, 2026-06-06): "makes NS-047's C2 computationally visible / blocks the analytic reduction"
  was the 6th over-reach — a regular truncation has NO singular set, so its non-uniform *pointwise*
  ratios do NOT bear on the *analytic* inequality, which can hold via Besov/integral/cancellation
  controls that pointwise ratios never see (the live `Ḃ⁰_{∞,1}` route).** Honest residue: the probe
  refutes only the *pointwise-domination heuristic* (a useful narrowing — it says any closing inequality
  must go through Besov/integral controls, not pointwise domination); it is a within-truncation
  diagnostic, NOT evidence about the PDE inequality or the analytic obstacle. Companion
  `docs/ns046_uniform_domination_companion.md`. `:open` unchanged; `:proved`=0.
- **Critical-Besov smallness probe (2026-06-07, `scripts/ns046_besov_smallness_probe.jl`) — the SPECTRAL
  complement to the uniform-domination sub-probe; corroborates NS-047 C1, frames C2.** Measures the
  dyadic Littlewood–Paley budget shell-by-shell: (**C1**) the Riesz/pressure-Hessian ratio
  `R_j=‖Δ_j∇²p‖_∞/‖Δ_jQ‖_∞` is **flat across all shells and N-stable** ([0.60–0.74], no upward drift with
  `j`; per-shell values agree N=64↔128 to ~1%) ⇒ the CZ operator is `Ḃ⁰_{∞,1}`-bounded with **NO log** —
  NS-047 C1 corroborated computationally and resolution-robustly. (**C2**) the shell local Reynolds
  `Re_j=‖Δ_jω‖_∞/(ν k_j²)` and its frontier `j*` are **resolution-gated**: a Reynolds sweep moves the
  frontier from the grid edge (Re=1600, `Re_tail`≫1 — dissipation unresolved) to the interior (Re=100,
  `Re_tail`≪1, `j*=3` — the small-scale tail viscously absorbed, smallness EXHIBITED). N-convergence
  splits cleanly: at Re=1600 (under-resolved) `j*` tracks the grid (4→5, Class-I); at Re=100 (resolved)
  `j*` is **fixed at the same physical shell** N=64↔128 (`k∈[8,16)`, Class-II / scope-coupled) — so when the
  dissipation scale is resolved the Besov budget is a resolution-STABLE diagnostic (unlike the δ-fit). **Honest
  limits:** vacuity cap (regular truncation, no singular set); Besov norms are GLOBAL Fourier objects so
  cannot localize to the CKN set — that physical-space localization is the uniform-domination probe above;
  together they bracket the question, neither is the analytic step. The genuine positive: the framework
  choice that keeps the harmonic-analytic route live (critical-Besov, not L^∞) is computationally consistent
  — a witness-level reason to keep NS-046/047 standing. `:open` unchanged; `:proved`=0. Companion
  `docs/ns046_besov_smallness_companion.md`.
- **Precise standing target recorded — NS-046 PAUSED here (2026-06-06).** The crisp, admissible
  open-problem statement (critical-Besov framework per NS-047; CKN localization; the nonlocal
  pressure-Hessian + viscosity vs the production at σ=0; CCATT loss ledger; the kill criteria) is
  written in `docs/ns046_target.md`. **WITNESS-CORRECTED (triad 3/3, 2026-06-06): NOT "*the* irreducible
  difficulty is the non-uniformity" (that over-claimed — 6th over-reach this arc; the real difficulty
  could be elsewhere, e.g. derivative loss at marginal-cancellation scaling).** The honest target: IF the
  Besov-endpoint objection is set aside (NS-047), uniform domination on the bad set is **a** natural
  remaining target — pursued through Besov/integral controls, not pointwise domination. Closing NS-046
  needs a genuine analytic idea the program does not have; the discipline forbids manufacturing one
  (six over-reaches caught this arc: four witness-, one probe-, one witness- again here).
  **Held as the standing frontier.**

**NS-048 — The exclusion / no-split frontier (the *dynamic* complement to NS-046).** `:open`, **unengaged
candidate direction — NOT a claim.** Origin: a math-physics colleague's attack notes (relayed
2026-06-06), whose mindset shift is *don't prove "all turbulence is smooth"; corner the hypothetical
singularity into a regime so rigid the remaining configuration is impossible.* That is the
**singularity-exclusion / blowup-rescaling / Liouville-for-ancient-solutions** attack shape — the
*dynamic* frontier, where this program is almost entirely *static*. We hold pieces: **NS-007** killed the
*self-similar* case (Nečas–Růžička–Šverák); **NS-006** is the CKN local-regularity / rescaling piece;
**NS-005** (ESS) rests on backward uniqueness. The gap: **no entry for the general rescaled-limit
(asymptotically / discretely self-similar) exclusion, nor the *no-split* (concentration-compactness)
mechanism** that prevents different rescaled subsequences converging to different limits.
- **Proposed shape:** (1) assume a concentrated singular core; (2) rescale to the blowup → an ancient /
  self-similar limit; (3) **exclude** that limit via a Liouville-type rigidity + a no-split control —
  *re-tasking our geometry findings as rigidity constraints, not uniform-domination targets*:
  Beltramization (NS-045), the nonlocal pressure-Hessian counter-transport (NS-046), the `∇ξ` object
  (NS-013/CFM). This **reframes NS-046 from domination → exclusion**, sidestepping the exact wall the
  uniform-domination sub-probe hit.
- **Why it connects to our findings:** the sub-probe's *non-uniform, concentrated-at-cores* depletion is
  the **no-split problem's shadow** — the truncation could only *observe* the concentration; the
  no-split machinery is what would *resolve* which rescaled limit it selects. NS-046 (the inequality) and
  NS-048 (the exclusion) are two faces of the same wall.
- **Honest scope:** a candidate *attack shape* + machinery to LEARN (concentration-compactness /
  Aubin–Lions, Liouville theorems for the rescaled limit, backward uniqueness / unique continuation) —
  **not** a result, **not** a new geometric gadget (the colleague's own warning, and our six refuted
  over-reaches). Status: `:open` (unengaged). Scope: PDE-analysis (frontier direction). `:proved`=0;
  distance UNTOUCHED.
- Depends_on: NS-007 (self-similar special case it generalizes), NS-006 (CKN/rescaling), NS-005
  (ESS / backward uniqueness), NS-046 (the static complement), NS-002 (scaling). Source: colleague's
  attack notes (2026-06-06, recorded in changelog v0.1.70); geometry inputs NS-013/045/046. *(Not yet in
  the TCE self-map corpus — appropriate for a brand-new unengaged direction; add on the next re-run if
  pursued.)*
- **Mapped (2026-06-06): `docs/ns048_exclusion_frontier.md`** — the machinery laid out (rescaling →
  ancient limit → Liouville + no-split + backward-uniqueness; Type-I vs Type-II; NS-007 = the
  self-similar sub-case done; general Liouville + no-split + Type-II = the gap), with the one-sentence
  obstruction + sub-targets. **HONEST CORRECTION to the bullet above:** "re-task our geometry as rigidity
  constraints" is **over-optimistic — the same vacuity cap.** Our geometry findings (NS-045/046/sub-probe)
  are *within-truncation*; the ancient limit is a singular-limit PDE object the truncation cannot reach,
  so any Liouville rigidity must be proven *analytically on the ancient solution*, not inherited from a
  truncation. The honest role of the geometry is a **suggestive prior** (where to probe the ancient
  limit), **NOT** an exclusion input. (A 7th tidy hope, deflated by working it through.) Engaging NS-048
  for real = learning the §2 machinery + attacking one sub-target; not a session task.
- **Machinery STUDIED (2026-06-06): `docs/ns048_machinery_study.md`** — the §2 machinery actually
  learned, literature-verified (7 modules M1–M7; changelog v0.1.72). A **study artifact, status
  unchanged** (`:open`/unengaged). Locates the two open holes to the theorem level: the **general 3D
  Liouville theorem for bounded mild ancient solutions** (⟺ Type-I exclusion — KNSS have only 2D +
  axisymmetric-no-swirl) and the **entire Type-II branch** (no compact rescaled limit to attack).
  Names three real sub-targets; a restricted non-self-similar Liouville (beyond axisym-no-swirl) is the
  most tractable. Carries a 16-item don't-bluff appendix (§12) of everything not primary-verified.
- **Sub-target ATTACKED (2026-06-06): `docs/ns048_axisym_swirl_attack.md`** — the most tractable
  sub-target (restricted non-self-similar = **axisymmetric-with-swirl ancient Liouville**) attacked
  honestly (changelog v0.1.73). **No theorem; status unchanged; `:proved`=0.** Wall LOCALIZED to the
  single production term `(1/r⁴)∂_z(Γ²)` in the `Ω=ω^θ/r` equation, in the **non-compact axial (`z`)
  direction**; the *source* is benign at the axis `r=0` (smooth flows have `Γ=O(r²)`, source `O(1)` there
  — though `1/r`-weighted operators may still constrain there). **[WITNESS-CORRECTED 2026-06-07,
  changelog v0.1.76:** the original "no soft just-beyond step / collapses onto the bare conjecture" was an
  **over-reach (10th)** — `ℝ²×T¹` is *itself* a proven intermediate class, and softer refinements
  plausibly exist (weak-`L^p`/Lorentz swirl; small-swirl perturbing KNSS). Honest statement: the three
  *specific* frontier hypotheses are near-endpoint and the session-scale *methods* all stop at the
  non-compact axial direction, but the sub-target does NOT collapse onto the conjecture.**]** The 8th
  over-reach (a manufactured restricted theorem) was declined.
- **Sub-target (C) ATTACKED (2026-06-07): `docs/ns048_swirl_sign_condition_attack.md`** — the one
  genuinely *new* restricted class (a swirl **sign/monotonicity condition** signing the source
  `(1/r⁴)∂_z(Γ²)`) worked through (changelog v0.1.74). **No theorem; status unchanged; `:proved`=0.** The
  preserved sign (`Γ≥0`) doesn't sign the source; the signing sign (`∂_zΓ`) isn't dynamically preserved
  (`∂_z`-differentiated `Γ` eq has a no-sign shear coupling) and is plausibly vacuous; even granting
  `S≤0`, `Ω` is only a subsolution ⇒ one-sided control, never `Ω≡0` (the sign is on the source `S`, not
  on the non-sign-definite `Ω` — witness-confirmed survivor). Closes only in the degenerate `∂_zΓ≡0`
  (columnar) case = the known periodic-in-`z` reduction (not new). 9th tidy hope deflated.
  **[WITNESS-CORRECTED 2026-06-07, changelog v0.1.76:** the claim "(C) is a *third independent
  convergent* diagnostic / `z`-dependence is *the* irreducible difficulty" was an **over-reach (11th)** —
  the energy attack and this sign attack act on the *same* term `S` (echo, not independence; ~1.5 lines,
  not 3), plus a selection effect, and the localization merely re-derives the known hypotheses. Honest
  residue: these elementary methods all stop at the non-compact axial direction, consistent with known
  structure — method-failure localization, not proof of "the" difficulty.**]**
- **EXTERNAL witness triad (2026-06-07): `docs/ns048_axisym_swirl_witness_verdict.md`** (Grok / Venice.ai /
  ChatGPT; `~/Desktop/triad.rtf`; changelog v0.1.77). Across 3 model families **confirmed the trim** (math
  clean; C9 = echo, refuted unanimously; C4 overstated; no theorem found). **Two refinements:** (12th
  over-reach, external-caught) my own C4 fix's "weak-`L^p` swirl plausibly closable" was imprecise — `L^p`
  on `Γ` gives **no** control of `∂_zΓ`; the open frontier is a **weighted condition controlling `∂_zΓ` in
  `z`**, strictly weaker than KNSS, or a proof none exists. And C7 sharpened: the one-sided-bound bootstrap
  stalls at two concrete points (CZ fails for linearly-`r`-growing `ω^θ∉L^∞`; div-free drift + isotropic
  diffusion give no `z`-decay) ⇒ "no *known* closure mechanism," not "dead end" — "no theorem" stands.
- **Open problem FORMULATED (2026-06-07): `docs/ns048_swirl_source_frontier.md`** (changelog v0.1.78).
  Sharpened the witnesses' target (a weighted `∂_zΓ` space that closes `S`) by reading LZZ §5 line-by-line:
  **every known with-swirl closer bypasses `S` — it forces `Γ`-decay (radial / z-periodic / small radial
  oscillation) → swirl-free reduction; none controls `S`.** So "close `S` via `∂_zΓ`" is a **road not
  taken**, not a weakening of the known road. "Strictly weaker than KNSS" is **unjustified** (the columnar
  `S≡0⇒Γ≡0` cuts against independence — comparison OPEN; the naive "incomparable" claim **declined as a
  13th over-reach**). The `z`-anisotropic / `∂_z`-swirl machinery (`J=−∂_zv^θ/r`; `|x₃|^α u^θ`) exists only
  in finite-time regularity, **untransferred** to ancient Liouville. **Cleanest entry sub-question:** port
  those anisotropic-`z` swirl conditions to the ancient setting. Both horns open; `:proved`=0.
- **Entry sub-question ATTEMPTED (2026-06-07): `docs/ns048_anisotropic_z_port.md`** (changelog v0.1.79).
  Ported the `|x₃|^α u^θ` criterion (**Yu / Wang–Huang–Wei–Yu** — correction: NOT CFZ, who are
  *radial*-weighted) to the ancient setting. **No theorem; `:proved`=0.** Condition is **scale-critical**
  (`2/q+3/p=1−α`). **Transfer verdict:** the finite-time proof is **direct Gronwall-on-`[0,T)`** (anchored
  to initial data + finite-`T` continuation), **not** blow-up/ancient-limit ⇒ the ancient Liouville is
  **NOT implicit**; the port is a **genuine new question**, gap = the finite-`T`/initial-data steps.
  **Scoped positive + limit:** `|x₃|^α` gives `z`-decay of `u^θ` ⇒ `z`-decay of `S` (`≲|z|^{−2α−1}/r²`),
  killing the **dominant `z`-tail** of the source — but the **borderline radial-log tail survives**, so a
  complete closer likely needs **axial `|x₃|^α` + radial (LZZ) control combined** (the source's "two
  tails"). Honest next step: the blow-down/Liouville-rescaling route under the critical bound. Comparison
  disciplined (`|x₃|^α` excludes the columnar case; "incomparable" not claimed).
- **Route (i) ATTEMPTED (2026-06-07): `docs/ns048_route_i_blowdown.md`** (changelog v0.1.82; first artifact
  under the C0–C5 discipline). Blow-down / Liouville-rescaling on the `|x₃|^α` conjecture. **Does NOT close
  it; `:proved`=0.** Decisive break (self-derived + C3-LZZ contrast): the blow-down is matched to **radial**
  decay — LZZ's `|Γ|≲|x_h|^{−1/p}` gives `Γ_λ→0` (concentrates), but the axial `|x₃|^α` gives
  `Γ_λ≲λ^{1−α}|x_h||x_3|^{−α}→∞` (the radial growth of `Γ=ru^θ` is *amplified*). Second break: compactness
  fails (`‖u_λ‖_∞=λ‖u‖_∞→∞`; critical norm too weak — supercriticality). **14th honesty-ledger item:
  corrects my own port-doc claim** that route (i) "sidesteps the radial tail" / "criticality is exactly
  what it requires" — both wrong (route (i) needs radial control *more*; criticality ≠ sufficiency).
  Reinforces two-tail; raises a **counterexample suspicion** (saturating gives `Γ~r|x_3|^{−α}`, linear
  radial growth; Pan–Li `α=1` sharp ⇒ axial-only conjecture **suspect, possibly false** — not constructed).
  Live conjecture now: **axial `|x₃|^α` + radial combined**; sharp sub-question = construct/exclude a
  linear-radial-growth `z`-decaying non-constant ancient solution.
- **"Combined axial+radial" COLLAPSED (2026-06-07): `docs/ns048_combined_axial_radial.md`** (changelog
  v0.1.88). Worked the combined conjecture: **redundant** where radial is strong (`Γ∈L^p`/LZZ or `|u|≤C/r`/
  KNSS Thm 5.3 each **close alone**, both C3) and **stuck** where radial is weak (yields only `∫|S|<∞` = the
  un-mechanised `S`-control route; weak-radial solo status open either way). So "needs combined" was the
  **15th over-reach, retired.** **NS-048 session-scale attacks now exhausted** — every concrete attack
  reduces to the *bare* conjecture (`Γ∈L^∞`) or the *un-mechanised* `S`-control route, both needing a new
  idea. `:proved`=0.
- **Type-II branch MAPPED (2026-06-07): `docs/ns048_type_ii_frontier.md`** (changelog v0.1.93). The harder
  half of the exclusion program (M7), the part the ancient-Liouville machinery **structurally cannot reach**
  (Type-II = the complement of the C3 Type-I⟺ancient bridge; the program has a **Type-I ceiling**). Both
  sides primary-read (mostly C3): **exclusion** = the quantitative-regularity rate bounds (Tao triple-log,
  Palasek axisym double-log) — partial only, the gap to full exclusion is *qualitative* (rates diverge
  arbitrarily slowly); **construction** = **NO rigorous true-NS blowup** (Hou numerical; Chen–Hou CAP is
  Euler/Boussinesq-with-boundary; modified/forced/complex-NS are different equations). Structural reads:
  the *rate* is the shared object; **viscosity is tool-and-obstacle**; axisymmetric is the sharpest arena
  both sides. Tractable entry (research-scale): the axisym double-log → Besov rate (Palasek conjecture).
  Both sides OPEN. `:proved`=0.

---

**NS-050 — Modulation theory for the Type-II frontier** | FORWARD-TARGET (frontier map + within-truncation witness) | Evidence: external-spec-reference (prior art, C1) + computed witness (1D-model) | **Status: :open** | **Scope: PDE-analysis** (≠ the PDE) | Source: `docs/ns050_modulation_type2_scope.md` (+ `ns050_dss_modulation.md`, `ns050_modulation_witness_companion.md`); witness `scripts/ns050_modulation_witness.jl` (+.out.txt). `:proved`=0; distance UNTOUCHED.

Scopes NS-048's **Type-II** sub-branch (the part the ancient-Liouville machinery structurally cannot reach, the NS-048 Type-I ceiling) via **modulation / dynamic-rescaling**. **The finding:** modulation is the *construction* (disproof) engine, and its prerequisite — a self-similar profile to modulate around — is **exactly what G3 / NS-007 deletes** in the smooth / finite-energy / no-boundary (Clay) category. Verified prior art (C1): MRRS compressible implosion (their NS singularities ARE Type-II, via a quantized self-similar Euler profile + spectral gap), Elgindi `C^{1,α}` axisym Euler (no swirl, degraded regularity), Chen–Hou computer-assisted (2D Boussinesq + 3D axisym Euler **with boundary**; dynamic-rescaling = modulation made rigorous). The clean incompressible / smooth / no-boundary profile is absent, and incompressibility removes the implosion mechanism — so modulation cannot start for incompressible smooth NS; the Clay (exclusion) direction uses ancient-Euler-Liouville, **not** modulation (conditional literature arXiv:2304.04045 / 2507.08733 = the NS-048 Hole-B machinery). **M1–M5 prerequisite checklist, gated at M1 (no profile).** DSS route (`ns050_dss_modulation.md`): a discretely-self-similar (log-τ-periodic) profile evades G3's *exact*-self-similar exclusion; at the singular scale `λ²ν→0` so rescaled NS→Euler (M1 reduces to a DSS Euler profile); τ-periodicity ⇒ a **Floquet/monodromy** spectral-gap problem for a nonlocal non-self-adjoint operator (no NS precedent); still a construct-side setup. **Within-truncation witness (T-24):** a dynamic-rescaling fit, calibrated on CLM (closed-form), recovers the self-similar profile Φ(η)=−4η/(1+4η²) (‖U−Φ‖₂ halves each step), center x₀=π/2, and rate (T*,p)=(2.00,1.00), N-robust — validating the *instrument*; the Type-II discriminator is its negative (non-converging U / drifting p). Firewall: 1D model + finite truncation; instrument-validation only; does NOT touch 3D-NS regularity. Depends NS-007 (G3) / NS-048 / NS-002 / NS-036.
