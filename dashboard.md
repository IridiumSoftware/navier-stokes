# dashboard.md — Navier–Stokes obstruction program

**Read this first, every session.** Status + priority stack + open gaps. Scorecard
lives in `SPEC.md`, not here.

## Distance to the prize

**UNTOUCHED.** Zero rigorous PDE results (`:proved` count = 0, by design). Anything
below with `Scope ≠ PDE` is **not** prize progress. This line changes only when a
`:proved`, `Scope: PDE` entry exists.

**MDAGC synthesis (2026-06-07, `docs/ns_blowup_generator_class.md`):** the program's global no-go's
assembled into the positive necessary-conditions object — *what any 3D-NS singularity must be*: non-self-
similar (G3) ∧ ≤1-D (G2) ∧ critical-norm-blowing (G1) ∧ energy-method-invisible (G5) ∧ Type-I-conditioned-
ancient-or-Type-II (G4), framed by supercriticality (S1) + production-is-the-breaker (S2), with the recent
phase-coherence/detector arc as heuristic structure (W1/W2). Dead: energy-/spectrum-only methods, exact
self-similar, region-filling. Live attack must engage σ=0 production (NS-046) or the ancient/Type-II
objects (NS-048). The ② test — phase-blindness — **sharpens S1 (a counterexample family: `P` is not a
function of the coercive invariants), but is NOT a new hard method-exclusion** (over-reach declined).
Reorganization, not progress; `:proved`=0.

**NS-049 — Lockwood "Singularity Surgery" (2026-06-07, external review prep):** added a live/conditional
entry for James Lockwood's 5-part anisotropy-depletion CKN-deformation program (the recipient of the
external-review brief, `docs/ns_external_review_brief.md`). Anisotropy of the high-vorticity set depletes
stretching via the Riesz/CZ principal-strain identity `S₃₃=R₁R₃ω₂−R₂R₃ω₁`; reduced across Parts I–V to a
strict-core rigidity + a final trace-selection problem (his framing: not a completed proof). **Tier C0/C1,
`:open`, UNVERIFIED** (self-contained AI-assisted working papers; the "resolved" depletion lemma + strict-
core are unverified — structured-local-coherence caution). Lands on our NS-046/047 frontier; two
convergences flagged (his weighted/integral depletion = our "must be integral, not pointwise" conclusion;
his anisotropy trigger vs our helicity/Beltramization trigger). No new *external* citations (his papers
have no bibliography). `:proved`=0. **VERIFIED (engaged the math, line-read I–V,
`docs/ns049_lockwood_verification.md`):** the whole program is conditional on the anisotropy defect
vanishing (`δ_Λ→0`), ASSUMED in every theorem (Part III Thm 8.1 `δ≤ε`; Part IV Lemma 3.1 eq 21), never
derived; the multi-directional (`δ` bounded-below) case is open + unadvertised — and our NS-038
(intermediate-eigenvector alignment, not frozen-direction) says that unhandled case is the physical one.
So it's a **conditional anisotropic regularity criterion** (CF-family, weaker integral trigger), NOT the
unconditional proof its framing implies. Depletion lemma = sound-but-unfinalized skeleton; strict-core =
definitional `∫χ|ω×e|²=tr·δ`. **PROBED (`ns049_anisotropy_defect_probe.jl`): the resolved dynamics drive
`δ_Λ` UP, not toward 0** — at the Kerr reconnection the top-0.1% `|ω|` cores rise δ 0.008→0.35→0.59 (bridge
adds directions), and cores sit at δ≈0.32–0.54 across TG/tubes/helical (one-directional = 0). So *nothing in
the resolved flow forces `δ_Λ→0`*; it could hold only on the rescaled ancient/Type-I limit, linking NS-049
to NS-048. Vacuity cap (resolved, not the singular limit).

**FORWARD TARGETS (2026-06-05, Brian's extension; SPEC 35 entries as of 2026-06-09).**
**NS-045 = `:tested` — DONE.** Helicity-depletion mechanism audit run: the mechanism is **(b)
Beltramization** — strong helicity (u∥ω) crushes the Lamb vector `u×ω` (the nonlinear driver) ~26×,
switching off production until the field de-Beltramizes (the delay) — **not** (a) ω–S alignment (which
develops near-identically). N-converged 16↔64↔128; sharpens NS-040. DNS-scope, within-truncation only.
**NS-046 = `:open`** — the critical coercive deformation inequality (PDE-analysis target; the honest
"where the prize sits," built on the nonlocal pressure Hessian — independently incorporates this
session's MID-witness Q2 lesson). **CCATT** (Brian's classifier) held as a pending external primitive
until he specs it. Both `:proved`=0; prize UNTOUCHED. Recent: LOW #1 + MID coordinations both
witness-REFUTED (over-reach caught); see `docs/ns_corollaries_synthesis.md`.
**Besov-smallness DNS probe (2026-06-07, `scripts/ns046_besov_smallness_probe.jl`):** the dyadic
Littlewood–Paley budget **corroborates NS-047 C1** — the Riesz/pressure-Hessian ratio `R_j` is flat across
shells and N-stable ([0.60–0.74], no log) ⇒ the CZ operator is `Ḃ⁰_{∞,1}`-bounded with no log, the
framework choice that keeps the harmonic-analytic route live. **C2** (local-Reynolds smallness) is
exhibited via a Reynolds sweep and shown **resolution-gated**: the frontier `j*` tracks the grid when
under-resolved (Re=1600, Class-I) but is N-fixed at the same physical shell when resolved (Re=100,
N=64↔128 `j*=3`, Class-II) ⇒ a resolution-stable diagnostic, unlike the δ-fit. Within-truncation witness
(global Besov can't localize to the CKN set — complements the uniform-domination probe); `:open`/`:proved`=0
unchanged. `docs/ns046_besov_smallness_companion.md`.

## MILESTONE (v0.1.6–v0.1.8, 2026-06-01) — diagnostic validated 1D/2D/3D-control

The NS-010/011 diagnostic is **validated two-sided** against ground truth in 3
regimes — blowup (Burgers 1a, CLM 1b: δ→0, BKM→∞) AND regularity (2D 1c: δ bounded,
BKM finite) — with a hermetic FFT (1D+2D, self-checked). Internal cross-audit PASS
(A1 spec↔registry parity, A3 artifacts exist, A4 zero `:proved`). Tool chain trusted;
firewall loaded. See `docs/validation_milestone.md`. **Distance to prize: UNTOUCHED.**

**TCE self-map DONE (v0.1.7, NS-031).** Ran TCE's `Discovery.Triadic` on the NS
ledger (20-node corpus → `discovery/`). The program's triadic structure: keystone
**{NS-002,003,004}** (supercriticality+energy+BKM) @1.0; live frontier
**{NS-011,012,013}** (complex-plane attack) @0.70; PDE bridge **{NS-003,004,010}**
(walls→diagnostic) @0.83; the closure arc is tier-walled (zero PDE/closure mixed
triads — engine-side reproduction of NS-024's "no PDE purchase"). This set the 3D
attack geometry.

**3D CONTROL DONE (v0.1.8, Stage 1c-3D Step 1).** First 3D move — the known-regular
*control*, not a blowup hunt. The 3D pseudospectral solver is VALIDATED (3D-Euler
energy + HELICITY conserved to 0.0000%, div_max≈machine — the 3D Tier-1 check 2D
lacked). Viscous Taylor–Green: diagnostic correctly reports REGULARITY (δ≥0.605,
BKM finite). **Honest caveat carried forward:** the δ-slope-fit is NOT
resolution-robust in the inviscid/under-resolved regime (~50% spread across N) —
so Step 2 (blowup candidate) is GATED on BKM co-movement + spectral N-convergence,
not the δ-fit alone. Distance to prize: UNTOUCHED. Epistemics capped: a 3D δ→0
would be suggestive-in-a-truncation, never a proof.

**STEP-2 NULL + MANIFOLD STUDY DONE (v0.1.9, NS-032 + NS-033).** Step 2 (inviscid
Taylor–Green blowup hunt) → **gated INCONCLUSIVE**: gates correctly flag the
resolution limit (no false-positive blowup). Then pivoted to the EXACT geometric
route — a 4-slice **state-space manifold study** (NS-033, no resolution wall):
(1) coadjoint orbit (triad=rigid body, exact); (2) MFE edge manifold (log slowing;
**"a3=gate" refuted — a3 is tangent, committor-gate ≠ edge-normal, two notions**);
(3) invariant/scaling quotient (**supercriticality = the non-compact scaling
direction; needs the λ⁻³ domain factor**); (4) Arnold curvature (Koszul, verified
κ≡¼; negative plane; Lyapunov λ>0 chaotic vs ≈0 integrable). The study **re-derives
the firewall thesis geometrically.** Distance to prize: UNTOUCHED.

**ACTIVE-TURBULENCE TRACK (fenced — entries AT-1..7 in `SIM_SPEC.md`, NOT the NS-### obstruction map).**
Phase 0 (AT-1, v0.1.46). The *faithful* version of the fluoddity agent engine — a real 2D Navier–Stokes fluid driven by active
agents (active turbulence), exploring self-organization. Phase 0 = the faithful fluid substrate
(`active_turbulence_fluid.jl`): exact `ν∇²` viscosity via IF-RK4 + a curl-of-force active-coupling
hook, extending the validated 2D solver (NS-010). Validated: **AT-01** energy+enstrophy conserved
1.3e-14, **AT-02** viscous mode-decay ≡ `exp(−ν|k|²t)` to 7.3e-16 (T-15/T-16). **Phase 1 DONE
(v0.1.47, AT-2):** the passive forced-turbulence control proves the faithful fluid is a *real
turbulence engine* — under steady band-limited forcing it reaches a statistically steady state with
a **clean forward enstrophy cascade E(k)~k^−3 (slope −3.36, R²=0.99, AT-04/T-17)**, a *universal*
Kraichnan exponent the fluoddity dial lacked. (Inverse −5/3 deferred to N≥256.) **Phase 2 DONE
(v0.1.48, AT-3):** discrete active-dipole agents (1500 swimmers + ported Fourier brain) coupled to
the faithful fluid — sense, brain-steer, co-rotate by ω/2, force back as **net-zero force dipoles**.
**AT-03/T-18: dipole net momentum = MACHINE ZERO (rel 9.5e-18)** vs the fluoddity monopole's O(1) —
the faithful-swimmer fix, named + verified. Stable coupled run (weak flow at these params; Phase 3
strengthens coupling). **Phase 3 DONE (v0.1.49, AT-4) — an honest NULL that reframes fluoddity:**
cranked to a vigorous active flow (u_rms≈0.6>swim, 42% vortex-dominated — the *fluid* self-organizes
into coherent vortices), the AGENTS do **not** cluster (g(r)≈1.0, brain = dumb control). Lifelike
organization does not emerge from velocity-sensing agents on a faithful fluid ⇒ fluoddity's "creatures"
were **chemotaxis + a compressible-forcing artifact**, not active turbulence (the monopole's convergence
sinks are impossible on a divergence-free fluid). **AT-5 (v0.1.51) CLOSES IT — chemotaxis clusters:**
adding the density-aggregation steering, g(r) peaks **4.0× at contact** (1.86× near-field) vs the dumb
control's g≈1.0 (T-20). Lifelike organization DOES survive on a faithful fluid — via **chemotaxis
(aggregation), not active turbulence** — and on a *divergence-free* fluid, **ruling out** the
compressible-monopole artifact. Fluoddity's creatures = genuine chemotaxis-driven aggregation; the
fluid self-organizes into vortices, chemotaxis makes the creatures, the two are separate. **AT-6
(v0.1.52) — GPU port, Phase 4a:** the faithful IF-RK4 solver re-implemented in MPSGraph
(`metal/active_turbulence_gpu.swift`), **GPU(float32) ≡ CPU(float64) to ~6 digits** (AT-01 3.8e-6,
AT-02 2.95e-6, forced cascade −3.48 R²=0.99 vs CPU −3.36; T-21) and **~100× faster** (3100 steps in
3.1 s, M5 Max). **Phase 4b DONE (cross-repo):** the faithful fixes (ν∇² viscosity + net-zero dipole
forcing) retrofitted into the interactive `fluoddity-metal` app (`IridiumSoftware/fluoddity-metal`
commit `6a3d9bf`, `docs/faithful_fluid.md`) — its existing chemotaxis (AT-5) + Hodge projection kept;
`--simtest` stable+projected — so the creatures can be **watched live on a real NS fluid**. (An
application of AT-1..6, not a new claim; no AT entry.) **AT-7 (v0.1.55) — the creatures are
path-dependent: a HYSTERETIC clumping transition.** From watching the live app: an IC-ensemble at
fixed cohesion is monostable (one foam phase), but a cohesion up/down ramp traces a clean **hysteresis
loop** (clumps form at coh≈25–35, persist to coh≈5–15; loop area 15.4, max gap 0.59; bistable zone
coh≈10–35) — so the interesting creatures are hard to replicate because they live in the hysteretic
zone (state = f(path), not params); clumps self-stabilize via deposited density + the fluid's viscous
memory (T-22). **ARC COMPLETE (AT-1..7 + the interactive app). Scope: phenomenology — NOT the PDE.
Distance to prize: UNTOUCHED.**

## Status summary (v0.6.2, 2026-06-09)

- **NS-038 FORMALIZED — resolved N=256 DNS boundary program A→B→C (v0.1.31–39, `:tested`,
  new RESOLVED-DNS class):** first use of the real 6-hour budget. Resolved viscous DNS at
  N=256/Re=1600, FFTW-validated (≡ hand-rolled; Brachet enstrophy peak t=9). Verdicts: S_ω
  **bounded** (~0.2 TG / 0.15 helical), δ bounded+resolved (δ·k_cut≈6.5–7.5), production-set
  dimension dynamic (TG/helical floor D30~1.33, never ≤1; the **vortex-tube reconnection
  transiently drives D30→0.99** at the CKN ≤1 edge — reconnection-specific, flow stays
  regular). Geometric depletion (c²_int peaks 0.72 at stretching-max) observed. FFTW-18 ≈3.3×
  end-to-end (N=256: 3.9h→~70min). RWC-038: ≤1D-at-reconnection needs N≥512 (edge of N=256).
- **N=512 DONE via Metal — the ≤1 touch is a RESOLUTION ARTIFACT (NS-039, `:tested`):** GPU
  spectral solver (`metal/dns_gpu.swift`, MPSGraph/Metal 4, M5 Max, float32) ≡ CPU float64 to
  5–6 digits (TG Brachet Z/Z0=27.43@t=9; tubes N=256 D30=0.986@t=5.5 to the digit). At N=512 the
  tubes reconnection D30 minimum **lifts 0.986 → 1.426** (finely time-sampled); N-convergence is
  upward/away-from-1, reconnection more intense yet less localized ⇒ RWC-038 cleared, the touch
  was numerical. `:proved`=0; all flows regular; prize untouched.
- **NS-040 — helicity DEPLETES vortex stretching (clean matched-spectrum pair, `:tested`):**
  resolves the confounded boundary-run B. GPU pair helical (ρ_H=0.97) vs control helicalc
  (ρ_H=0.05) with IDENTICAL E0=0.125 + Z0=0.534 — strong helicity grows enstrophy **2–4× slower**
  (Z/Z0@t=6: 1.59 vs 6.67), resolution-robust N=256↔512 to 3–4 digits. Mechanism = delay +
  concentration (suppressed cascade, then a delayed localized burst winf 154 / S_ω 0.26@t=9).
  `docs/helicity_depletion_companion.md`. `:proved`=0; all flows regular; prize untouched.
- **NS-037 FORMALIZED — inverse-Born / possibilistic map of turbulence's constants (v0.1.26–28,
  `:argued`, new POSSIBILISTIC class; prize-focus deliberately dropped):** maps possibility +
  probability (not just necessity) of the *phenomenon*. (a) inverse-Born = inverse Legendre of
  the multifractal formalism (ζ_p↔D(h)); the measured attractor runs down to the CKN wall.
  (b) the log-normal cascade is FORBIDDEN by realizability (a clean structural null); log-Poisson
  survives, pinned by the codim-2 (1-D filament) integer. (c) the hard layer bounds μ∈[0,1]
  (tight) but no tighter — separating *forced* (ζ_3=1, ≤1-D filament) from *frame-dependent*
  (μ, C_K, κ). Methodology: closure-v5 `inverse_born_methodology.md`. `:proved`=0; prize untouched.
- **§5 TIGHTENED — the criticality–Casimir hinge (v0.1.22, NS-036, `:argued`):** the §5
  capstone "three routes, one wall" made exact + resolution-free. **(a) supercriticality
  (NS-034) ≡ (b) Casimir deficit (NS-033 Slice 6), joined at ENSTROPHY:** on the Ḣ^s
  ladder (quadratic σ) energy −1 / critical Ḣ^{1/2} 0 / enstrophy ‖ω‖²_{L²} +1 are
  symmetric about σ=0, critical = the geometric-mean midpoint via the exact interpolation
  `‖u‖²_{Ḣ^{1/2}}≤‖u‖_{L²}·‖u‖_{Ḣ¹}` ⇒ bounded energy+enstrophy ⇒ regular ⇒ the whole 3D
  question collapses to ONE rung (can enstrophy be bounded?) = the Casimir question
  verbatim; common mechanism = vortex-stretch production P=∫ω·Sω (= the S_ω detector).
  **(c) curvature CORRECTED to an INDEPENDENT companion** (Arnold neg-curvature is on
  SDiff(𝕋²)=2D=regular ⇒ sensitivity, not singularity). Verified
  `criticality_casimir_hinge.jl` (interp ratio ≤0.87 generic, =1.000 iff scale-pure; the
  gap below 1 IS the multi-scale/cascade content). Sharpens the wall to one inequality on
  one rung; does NOT close it. `:proved`=0.
- **M\*↔CKN CLOSED via box-counting dimension (v0.1.20):** the scope-INVARIANT measure
  (box-counter validated line/plane/volume→1/2/3) gives **D≈2.3, resolution-robust + stable**
  — an intermittent ~2.3-D fractal (vortex sheets/tubes), NOT a ≤1D singular set, NOT
  space-filling. **CORRECTS f50** (its "localization" was a resolution-coupled artifact). D>1
  ⇒ no resolved singular set (CKN's ≤1 not approached at N≤128). Ryan principle validated:
  the scope measure was right where the resolution-coupled one misled. `:proved`=0.
- **TWO PROBES (v0.1.19):** (a) **Reality stabilizer (Grok Move 4)** — 1D complex Burgers;
  reality PROTECTS against complex-data blowup with a boundary λ_c≈0.03–0.05 (Cole–Hopf-
  validated), sharpening NS-013; (b) **M\*↔CKN scope localization** — the vortex-stretching
  production LOCALIZES + sharpens with N (Ryan-Class-II/CKN-≤1D signature), but f50 is a
  resolution-coupled fraction ⇒ the conclusive scope-invariant measure is the box-counting
  DIMENSION (next step). Both Scope≠PDE; `docs/move4_ckn_probes_companion.md`. :proved=0.
- **RYAN SCOPE/RESOLUTION LENS (v0.1.18, NS-035):** Ryan's "emergence coupled to SCOPE
  not level" (arXiv:nlin/0609011) gives the PRINCIPLE behind the diagnostic arc —
  resolution=Class-I epistemic (why δ drifts/fails), scope=Class-II ontological (why the
  σ=0 quantities are the right class; real blowup, if any, is scope-coupled). Explains the
  robustness↔sensitivity tension; re-reads supercriticality + the Casimir deficit; new
  criterion (Class-II = resolution-converged scope-divergence) + M\*↔CKN handle. Conceptual
  lens, NOT PDE; `docs/ryan_scope_resolution_lens.md`. :proved=0.
- **σ=0-DETECTOR QUESTION ANSWERED (v0.1.17):** Grok Move-1 anchored to the vortex-
  stretching **production skewness** S_ω=P/⟨|ω|²⟩^{3/2} (dΩ/dt=P verified). It's the
  RIGHT detector class — **both** resolution-robust (4.8% vs δ's 63%) **and**
  singularity-relevant (unlike blind ρ_H). **Amendment:** no free lunch —
  robustness↔sensitivity are in TENSION (S_ω less robust than ρ_H *because* it sees the
  strain/small-scales = what resolution truncates). Object found; verdict resolution-gated.
- **GROK ORACLE PASS, ANCHORED (v0.1.16):** triad exploratory pass; metabolism anchored
  the 5 wild moves (3=our complex method, 5=CKN, 1+2=a real diagnostic nugget, 4=fenced
  bridge not chased, "anomaly class"=evocative-not-literal). Tested nugget: a σ=0
  (scale-invariant) diagnostic (relative helicity, E·Ω) is **resolution-robust (≤1%)
  where the δ-fit drifts 63%** — CONFIRMED; honest limit: robust ≠ singularity-sensitive.
  Open: a σ=0 quantity that's both. `docs/grok_oracle_anchoring_companion.md`. :proved=0.
- **SYNTHESIS WRITE-UP (v0.1.15):** `docs/obstruction_program_writeup.md` — the whole
  arc as one preprint (the walls; validated diagnostic + its limit; honest nulls; the
  geometric capstone "three routes, one wall"; and §6 "the residue is speaking" — the
  closure/GPG/triad-rotation thread, fully firewalled with a Required Witness Check).
  The deliverable of the program: the map of *why* 3D resists. `:proved`=0; prize UNTOUCHED.
- **High-res hunt N=128 (v0.1.14, recreational, confirms NS-032):** pushed the Step-2
  inviscid-TGV hunt to N=128 (8× grid, 16 threads). Resolution wall moves cleanly with
  N (t_res 3.0/4.26/≥5.0); δ drifts DOWN with N (not converged, |Δ| up to 73%) —
  pushing resolution does NOT rescue the δ-diagnostic. Higher-res INCONCLUSIVE; vivid
  why real studies need N≳512. :proved=0, prize UNTOUCHED.
- **NS-033 Slice 6 (v0.1.13) — the CASIMIR DEFICIT (coadjoint capstone):** 2D Euler
  conserves the whole ∫f(ω) family (∞ Casimirs, only rearranges ω ⇒ rigid orbit ⇒
  regular); 3D Euler conserves helicity (1 Casimir) but enstrophy ∫|ω|² grows ×6
  (vortex stretching ⇒ loose orbit ⇒ open). The 2D/3D gap, in orbit-invariant terms —
  the same wall as enstrophy non-coercivity + energy supercriticality (NS-034). Three
  geometric routes, one wall. (Ideal-flow geometry, NOT the 3D-NS PDE.)
- **Gosme/MFE symmetrization test (v0.1.12, NS-021×NS-025) → NEGATIVE:** the queued
  experiment is done. Gosme's maturity-symmetrization signature is NOT robustly
  reproduced in the MFE saddle (roll a₃ activity-driven; streak a₂ de-symmetrizes at
  high Re; proxies disagree; near noise floor). Honest negative (a cherry-picked
  "present" verdict was caught + corrected). Scope: ODE-truncation, NOT PDE.
- **NS-033 Slice 5 (v0.1.11):** Arnold curvature of SDiff(T²) — 2D ideal flow as
  geodesics; verified k∥l⇒flat + symmetry; sign census 84% negative (Arnold) / 9%
  positive (Misiołek), both reproduced; the geometric root of the ~2-week weather
  horizon. Slices 1+4+5 = one Lie-group object. (Geometry of 2D Euler, NOT the 3D PDE.)

- **`physical_invariants.md`** added — tiered invariant constraint set (Tier 1
  hard / Tier 2 phenomenology / Tier 3 established), closure-v5 / possibilistic-
  inversion lineage. Key reading: the 2D/3D gap is an invariant-tier story
  (enstrophy Tier-1 in 2D, battleground in 3D).

- **Ledger:** 35 entries (SPEC.md is authoritative) — 1 PROBLEM (`:open`), 8 OBSTRUCTION (`:cited`/`:argued`),
  2 DIAGNOSTIC (`:tested`), 2 live (`:cited`/`:argued`), 6 our RESULTS/FALSIFIED
  (1 `:falsified`, 4 `:tested` non-PDE-Scope incl. NS-032 gated-null, 1 `:argued`),
  2 RELATED (`:cited`; NS-025 Gosme + NS-035 Ryan), 2 PROGRAM, 1 GEOMETRY (NS-033
  manifold study `:tested`), 2 ANALYSIS (NS-034 scaling calculus + NS-036 criticality–
  Casimir hinge, both `:argued`), 1 POSSIBILISTIC (NS-037 inverse-Born map, `:argued`),
  3 RESOLVED-DNS (NS-038 boundary queue A→B→C, N=256 FFTW-validated; NS-039 GPU N=512
  RWC-038 verdict — ≤1 touch is a resolution artifact; NS-040 helicity depletes vortex
  stretching — clean matched-spectrum pair; all `:tested`).
  `:proved` = 0.
- **Computational record:** 15 scripts (turbulence/closure arc) carried as
  phenomenology/model results — **none PDE**. The homology approach is `:falsified`.
- **Witnessed:** the closure↔turbulence convergence trimmed to "broad/generic"
  (NS-024) by Grok+Gemini+ChatGPT.
- **First PDE-relevant direction identified, not yet computed:** the complex plane
  (analyticity strip / complex-singularity, NS-010/011).

## Priority stack

1. **Complex-singularity / analyticity-strip diagnostic (NS-010/011).**
   - 1a. **DONE ✓** — Burgers (1D): spectrum-fitted `δ(t)` matches the exact
     `arccosh(1/t)−√(1−t²)` to ≤4.1% (T-01 PASS), 3/2-law exponent 1.519, viscous
     δ bounded. NS-010/011 → `:tested`. (`burgers_analyticity_strip.jl`.)
   - 1b. **DONE ✓** — pseudospectral CLM (vortex-stretching blowup, t*=2): solver +
     δ-fit reproduce exact `δ=ln(2/t)` to <1% N-robust (T-03 PASS); δ→0 co-diverges
     with BKM ∫‖ω‖∞ at t*=2 (T-04 PASS, BKM half). Hand-rolled FFT, self-checked.
     (`spectral_clm_blowup.jl`.)
   - 1c-2D. **DONE ✓** — 2D pseudospectral CONTROL (`spectral_2d_control.jl`): the
     diagnostic correctly reports REGULARITY — δ bounded (≥0.23), BKM finite, Euler
     invariants conserved <1e-6 (solver-validation), NS monotone-decay. Distinguishes
     2D-regular from CLM-blowup (T-05 PASS). The 2D side of the 2D/3D invariant gap.
   - 1c-3D Step 1 (control). **DONE ✓** — 3D pseudospectral solver
     (`spectral_3d_control.jl`, rotational form + Leray projection, hand-rolled 3D
     FFT, vortex stretching LIVE). **Solver VALIDATED** by exact 3D-Euler ENERGY +
     **HELICITY** conservation (both 0.0000%, div_max≈1e-12; T-07) — the 3D Tier-1
     check 2D could not give. Viscous Taylor–Green control: diagnostic correctly
     reports REGULARITY (δ≥0.605 bounded, BKM finite, energy decays; T-06 affirmed
     regular-direction). **HONEST CAVEAT:** the δ-slope-fit is NOT resolution-robust
     in the inviscid/under-resolved regime (~50% non-monotone spread across
     N∈{16,32,64}; window-sensitive once a power-law range forms). Solver robust,
     δ-fit fragile — exactly where blowup lives.
   - 1c-3D Step 2 (blowup candidate). **DONE ✓ (NS-032 extended, N=256↔512 GPU).** The
     inviscid-TG hunt ran at N=256↔512 (`metal/dns_gpu.swift`) with the full T-06 (G1
     δ·k_cut>6 / G2 spectral-N-convergence / G3 BKM) + T-08 gate (`scripts/step2_gate.jl`):
     **INCONCLUSIVE / regular-leaning** — the full-band δ-fit is 42–48% non-converged across
     N=256↔512 in the resolved window, and δ does not co-move with BKM at a common finite t*.
     The gate (G2) correctly refuses a naive δ→0 as a resolution artifact. Default NULL holds;
     `:proved`=0; suggestive-in-a-truncation only. `docs/step2_gate_inviscid_tg_companion.md`.
2. **[QUEUED, phenomenology] MFE causal-symmetrization test (NS-021 × NS-025).**
   Test whether Gosme's symmetrization signature (arXiv:2512.09352) appears in the
   MFE saddle: directional Granger coupling between structure (roll `a₃`) and
   activity (perturbation energy); does it symmetrize on the self-sustaining branch
   and collapse at relaminarization? Scope: ODE-truncation — NOT the PDE. Keep the
   Gosme-vs-(M,R)-symmetry comparison caution-flagged (NS-025).
3. Tighten the obstruction citations (page-level refs for NS-005 endpoint, NS-009
   constants) — `:cited` hygiene.
4. **DONE** — TCE de-duplication: the 15 turbulence scripts + 2 seam docs pruned
   from TCE (commit `8fcf1b4`, local-only; navier-stokes is now their sole home).

## Band-finding follow-ups (from the NS-031 TCE self-map)

**v2 re-run (2026-06-04, 30-node ledger; `docs/ns_corollaries_synthesis.md`):** the engine recovered
the new {NS-038,039,040} + {NS-010,011,032} HIGH clusters and **elevated the critical-norm cluster
{NS-005,008,033,034} — NS-005 (the one open backward path NS-002 leaves) is the structural HUB and the
indicated next direction.** Enstrophy-rung = loose MID coordination (chain, not tight triad); NS-013↔DNS
geometric-depletion link at LOW. Original 20-node follow-ups below still stand.

Eight items from the HIGH/MID/LOW band stratification (companion §2 "Band
stratification"). MID = "cross-framing invariance" is where the actionable
couplings sit; HIGH is foundational redundancy; LOW is structural echo (no new
PDE nugget). All Scope ≠ PDE unless a `:proved` PDE result is produced.

1. **Mechanism axis {NS-002, NS-004, NS-009} (MID @0.833, NEW).** In 3D, design
   the blowup-candidate IC to drive vortex stretching (NS-004) *toward* the
   anomalous-dissipation regime (NS-009) against supercriticality (NS-002) — not
   just watch δ→0 in isolation. The "how it blows up" complement to the keystone.
2. **PDE bridge {NS-003, NS-004, NS-010} (MID @0.833).** Make BKM co-movement the
   *formal gate* for any 3D δ→0: add a TEST_SPEC row (T-06) asserting δ→0 ⇒
   ∫‖ω‖∞→∞ co-divergence, else reject as a resolution artifact.
3. **Dead-ends triple {NS-007, NS-008, NS-020} (MID @0.778, NEW).** Add a
   "what-NOT-to-do" checklist for the 3D attack: not exact self-similar (NS-007),
   not energy-only (NS-008), not topology-only (NS-020, our own falsified arc).
4. **Norm-axis {NS-002, NS-005, NS-020} (MID @0.722).** Track that the 3D target
   is a *critical-norm* (NS-005) blowup — the only path NS-002 leaves open; the
   homology failure (NS-020) is the negative evidence that it is the norm.
5. **CKN consistency guard {NS-002, NS-003, NS-006} (MID @0.833).** Add a check:
   a 3D numerical near-singularity must respect CKN (singular set parabolic-dim
   ≤1); a δ→0 spread over more than a 1D spacetime set is an artifact, not blowup.
6. **Live frontier {NS-011, NS-012, NS-013} (MID floor @0.70).** Pair the 3D
   complex-singularity tracking with the open real⇐complex question (NS-013):
   does the nearest complex singularity reach the real axis? (Li–Sinai NS-012 is
   the known complex-data blowup.)
7. **Closure triad {NS-022, NS-023, NS-025} (MID @0.783).** The queued MFE
   causal-symmetrization (Gosme) test — closure-side only, Scope: ODE-truncation
   (= priority-stack item 2). Keep tier-walled from the PDE side.
8. **Recalibrate band thresholds.** The 0.85/0.70/0.55 cutoffs are closure-v5
   defaults for a several-hundred-entry corpus; recalibrate (or document as
   relative-only) before over-reading the 20-node absolute scores.

## Open gaps / honest unknowns

- NS-013: does complex-data blowup (NS-012) imply anything for real data? **PDE question still
  `:open`.** Attacked 2026-06-04: obstruction-map + reality-leakage ladder → **triad-witness-REFUTED**
  (Grok+Gemini convergent) → withdrawn; sharpened to an `:argued` reduction — the protective direction
  is the emergent **CFM/Hou–Li geometric depletion** (conditional, open) → NS-006 + NS-038 `c²_int`.
  `docs/ns013_triad_verdict.md`. **Production-object probe (2026-06-07, `ns013_realcomplex_production.jl`):**
  ran real-vs-complex ON the production object `P=−½∫g³` (1D shadow of `∫ω·Sω`) — the complex-blowup class
  (analytic signals) has `∫g³≡0` by Fourier support (3 positive wavenumbers can't sum to 0); reality
  (two-sided spectrum) ACTIVATES production (Skew 0→0.67) ⇒ the two channels are disjoint, corroborating
  "complex⇏real vacuous." 1D-specific (cubic argument doesn't transfer to 3D); `:argued`/`:proved`=0
  unchanged. `docs/ns013_realcomplex_production_companion.md`. **3D phase follow-ups (2026-06-07):** the 3D
  question is answered YES via phase-scrambled DNS surrogates — scrambling (|û(k)| fixed ⇒ E,Z,H exact)
  collapses the production `∫ω·Sω` ~97–99% (`ns013_phase_production_3d.jl`), and the controlled L² invariants
  are phase-BLIND while the production is phase-SENSITIVE (`ns013_phase_norm_split.jl`) — a concrete
  phase-space face of supercriticality (NS-002). BKM/Besov-norm sensitivity is intermittency-dependent
  (coherent-flow only; 14th over-reach declined). Within-truncation; `:proved`=0.
- **Critical-norm detector race (2026-06-07, `ns046_critical_norm_race.jl`, NS-005/NS-010):** raced the σ=0
  norms (all must blow at a singularity, GKP/ESS) on the Kerr-tube reconnection — by peak/baseline
  sharpness the **vorticity Kozono–Taniuchi `Ḃ⁰_{∞,1}` is sharpest (2.5×)**, the **velocity ESS-endpoint
  `L³` bluntest (1.0×, decays)**; energy `L²` flat (blind). The theorem-norm ≠ the detector-norm — the
  velocity-integral critical norms are large-scale-dominated (another face of supercriticality). Practical:
  monitor `Ḃ⁰_{∞,1}`/`‖ω‖∞`, not `L³`. Within-truncation, regular-flow sensitivity ranking (not a blowup
  race), N=64. `:proved`=0. `docs/ns046_critical_norm_race_companion.md`.
- `Project.toml` + `Manifest.toml` present (FFTW pinned) — package discipline satisfied.
- TEST_SPEC has T-01..T-24 (+ AT-track T-15..T-22).

## Cross-project note

Method (obstruction ledger + Scope firewall + witnessing) is the part that
transfers to CFS / closure-quotient / possibilistic-inversion *now*; substantive
math transfers only when a scoped, witnessed result earns it (DESIGN §5).
