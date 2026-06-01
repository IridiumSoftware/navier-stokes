# changelog — Navier–Stokes obstruction program

## v0.1.17 — 2026-06-01 — The σ=0-detector question, answered (production skewness) + an amendment

Grok's 2nd Oracle pass refined "Critical Gate Flux" (Move 1) → anchored to the
**vortex-stretching production skewness** `S_ω=P/⟨|ω|²⟩^{3/2}`, `P=⟨ω·(ω·∇)u⟩`.
`scripts/grok_production_skewness_probe.jl` (same spectrally-embedded inviscid flow, N=32/64/128).
- **Correctness:** `dΩ/dt = P` verified (2–6%) — S_ω built on the genuine enstrophy-blowup driver.
- **The right detector CLASS:** S_ω is **both** resolution-robust (4.8% across N, vs δ-fit 63%)
  **and** singularity-relevant (the stretching efficiency; `dΩ/dt=c·Ω^{3/2}` ⇒ blowup iff S_ω
  bounded below) — the "both" that ρ_H (robust-but-blind) and δ (sensitive-but-a-fragile-fit) lacked.
- **AMENDMENT to Grok's "both by construction" (the metabolism's honest correction):** NO FREE
  LUNCH — robustness↔sensitivity are in **TENSION**. S_ω is *less* robust than ρ_H (4.8% vs 0.5%)
  precisely because it depends on the strain (small scales = the cutoff-sensitive part);
  sensitivity to the singularity *is* small-scale dependence ⇒ the diagnostic you need is the
  one resolution hurts most. (A real structural reason the numerical attack is hard.)
- **Honest verdict:** S_ω peaks ~0.18 (resolved) then decays, but the decay is resolution-
  contaminated past the wall — the right OBJECT, not a verdict; the bounded-vs-growing question
  stays resolution-gated, now posed in the correct variable.
- Appended to `docs/grok_oracle_anchoring_companion.md` §6; NS-010 note extended. No new spec
  entry. `:proved`=0; distance to prize UNTOUCHED.

## v0.1.16 — 2026-06-01 — Grok Oracle pass: metabolized, anchored, one nugget tested

Triad protocol — Grok in the Oracle/Φ (exploratory) seat; metabolism seat anchored
his 5 wild moves to NS and ran the one computable one. `docs/grok_oracle_exploratory_brief.md`
(the brief), `docs/grok_oracle_anchoring_companion.md` (the integration),
`scripts/grok_scale_invariant_probe.jl`.
- **Anchoring:** Move 3 (mirror world) = our analyticity-strip method (NS-010..013);
  Move 5 (fracture dimension) = CKN (NS-006); Moves 1+2 distill to a real diagnostic
  nugget; Move 4 (substrate predicts) **walks back through the fenced bridge — not chased**;
  the "anomaly class in H³(Diff,ℝ)" is evocative (helicity *is* cohomological,
  supercriticality *is* anomaly-like) but **not literal** — a name, not a construction.
- **The tested nugget (Moves 1+2):** our δ-diagnostic failed because it's a spectrum-
  SLOPE FIT (resolution-fooled). A σ=0 (scale-invariant) diagnostic should be robust.
  **CONFIRMED:** on one spectrally-embedded inviscid flow (same flow at N=32/64/128),
  relative helicity ρ_H and E·Ω agree to **0.5% / 1.0%** across N where δ drifts **63%**.
  **Honest limit:** robust ≠ singularity-DETECTOR (ρ_H just tracks Ω-growth). Open:
  a σ=0 quantity that's *both* robust and singularity-sensitive.
- **Honesty catch mid-test:** first run compared *different* random ICs per N (confounded —
  ρ_H spuriously "drifted 152%"); spectral-embedding fix (verified E/H/Ω identical at t=0)
  made it a true resolution test. Confirmed Grok's idea cleanly.
- NS-010 gets a "better-diagnostic-class" note. No new spec entry. `:proved`=0; prize UNTOUCHED.

## v0.1.15 — 2026-06-01 — Synthesis write-up of the obstruction program

`docs/obstruction_program_writeup.md` — a standalone preprint-style synthesis of the
whole arc (NS-001..034), written to survive a witness pass: enthusiasm in the framing,
rigor in the claims. Sections: the firewall frame; the walls; the validated diagnostic +
its charted inviscid-3D limit; the honest nulls (Step 2 + N=128); **the geometric
capstone — three routes (scaling/NS-034, coadjoint Casimir deficit, Arnold curvature)
converging on one structural wall**; and **§6 "the residue is speaking"** — the
closure/GPG/triad thread, fully firewalled:
- decay-default / closure-as-achievement; the autopoietic CTMC; GPG/hypergraph-rewrite
  substrate (Brian's Substrate→GPG→RCFS→derived, test-first/unverified).
- **the S↔A triad rotation** (gate = weak-edge target, rotation-covariant; (M,R) gate S
  and turbulent roll-gate A are the same triangle rotated — `closure_triad_rotation`).
- the witness trims: convergence "real but overstated" (C1 broad / C2 dead / C3 refuted),
  "one notion or two? → two", Slice-2 gate-is-multi-mode, Gosme NEGATIVE — **four
  independent trims**, with an explicit **Required Witness Check (RWC-NS)** fencing any
  load-bearing use.
- the honest synthesis: the residue speaks a structural GRAMMAR (triadic closure,
  rotation-covariant gate, decay-default, the recurring wall), NOT a bridge to the PDE.
No new spec entries (synthesis of existing); `:proved`=0; distance to prize UNTOUCHED.

## v0.1.14 — 2026-06-01 — High-res near-singularity hunt N=128 (recreational; confirms NS-032)

`scripts/blowup_highres.jl` — "just for fun" resolution push of the Step-2 hunt
(NS-032) to N=128 (2× linear, 8× grid points), hermetic hand-rolled FFT, multithreaded
(16 cores; threaded fft3 roundtrip verified 2e-15). Inviscid Taylor–Green, T=5.
- **Resolution wall moves cleanly with N:** t_res ≈ 3.0 / 4.26 / ≥5.0 for N=32/64/128.
  More resolution buys more resolved cascade time (finer 2/3 cutoff), not removal.
- **δ does NOT converge — it drifts DOWN monotonically with N** (at fixed t,
  δ(N=32)>δ(N=64)>δ(N=128); |Δ|₆₄,₁₂₈ up to 73%, growing with time). The δ-slope-fit
  tracks the widening fit band over the developing power-law range, not a converged
  analyticity strip. Confirmed at a THIRD resolution — pushing N does NOT rescue the
  δ-diagnostic for inviscid 3D. δ-decline decelerates (consistent with no finite-time TGV
  singularity, the literature reading). BKM finite (→38), energy conserved, enstrophy ×15.
- **Verdict UNCHANGED in kind: a higher-res INCONCLUSIVE.** Vivid demonstration of why the
  real studies need N≳512 — the problem is genuinely hard, not just under-computed here.
- Recorded as a recreational extension of NS-032 (no new entry); SPEC/registry noted.
  **`:proved`=0; distance to prize UNTOUCHED.** (First file to break hermetic? No — still
  hand-rolled FFT, no FFTW; only added: `Base.Threads` + `julia -t`.)

## v0.1.13 — 2026-06-01 — Slice 6: 3D-Euler coadjoint/isovortical structure — the Casimir deficit

`scripts/manifold_6_coadjoint_3d.jl` (extends NS-033). The geometric capstone:
Euler = coadjoint-orbit flow (vorticity frozen-in / Lie-dragged); the 2D/3D gap is
the **CASIMIR DEFICIT**.
- **2D Euler (∞ Casimirs):** ∫ω², ∫ω⁴, ∫|ω|, max|ω| conserved to 1.000000 + the
  sorted vorticity distribution preserved — the flow only REARRANGES ω (isovortical)
  ⇒ enstrophy bounded ⇒ rigid orbit ⇒ regular.
- **3D Euler (~1 Casimir):** HELICITY conserved to 1.000000 (topological Casimir,
  vortex-line linking — Moffatt) + energy conserved, but ∫|ω|² grows ×6 and max|ω| ×3.6
  over t∈[0,2] (vortex stretching) — the ∫f(|ω|) family is NOT conserved ⇒ loose orbit
  ⇒ open.
- **The capstone:** the Casimir deficit (∞→1) is the coadjoint-geometric statement of
  the 2D/3D gap — the SAME wall as enstrophy non-coercivity (`physical_invariants.md`)
  and energy supercriticality (Slice 3 / NS-002, NS-034), now in orbit-invariant terms.
  Three independent geometric routes, one wall.
- Compact 2D Euler inline (distinct names; spectral_2d_control has no include-guard);
  3D via the guarded spectral_3d_control. Honest: 3D enstrophy growth resolution-limited
  (resolved window shown); viscosity breaks the Casimirs — ideal-flow geometry, NOT NS.
- Folded into NS-033 (now 6 slices). **`:proved`=0; distance to prize UNTOUCHED.**

## v0.1.12 — 2026-06-01 — Gosme/MFE symmetrization test (NS-021×NS-025) → NEGATIVE

Ran the queued NS-025 phenomenology experiment: does Gosme's causal-symmetrization
signature (structure↔activity Granger coupling becomes bidirectional at maturity)
appear in the MFE 9-mode saddle? `scripts/mfe_gosme_symmetrization.jl`.
- Operationalization: structure = streak a₂ / roll a₃; activity = fluctuation energy
  Σ₄..₉ aᵢ² (disjoint — avoids the q_pert⊃a₃² confound the queue note missed);
  maturity ↦ Re (250→400); directional Granger (Geweke); symmetrization index SI.
- Sanity passed (white noise ⇒ G≈0). **Result: NO robust maturity-symmetrization
  signature.** Roll a₃ is activity-DRIVEN at every Re (G(A→S)≫G(S→A), SI low); streak
  a₂ is bidirectional at low–mid Re (SI≈0.997 @Re300) but DE-symmetrizes by Re=400;
  the proxies disagree on the trend; high-Re coupling near the noise floor. **The Gosme
  signature is NOT reproduced** — honest negative, consistent with NS-024's broad/generic.
- **Confirmation-bias guard:** caught and corrected an initial cherry-picked "present"
  verdict (lenient slope-test on one proxy) → the honest mixed/negative reading.
- Recorded under NS-025 (queued experiment DONE) + registry; no new entry (a negative
  phenomenology probe). Scope: ODE-truncation. **`:proved`=0; distance to prize UNTOUCHED.**

## v0.1.11 — 2026-06-01 — Slice 5: Arnold curvature of SDiff(T²) (extends NS-033)

The ∞-dim sibling of Slice 4 — `scripts/manifold_5_sdiff_curvature.jl`. Arnold
(1966): 2D ideal flow = geodesics on the area-preserving diffeo group SDiff(T²),
L² metric; its sectional curvature is mostly negative (the geometric root of
weather unpredictability). Algebra built exactly: velocity modes v_k=ik^⊥e^{ik·x},
bracket [v_k,v_l]=−(k×l)v_{k+l} (derived), energy metric ⟨v_k,v_k⟩∝|k|², coadjoint
B(v_k,v_l)=(k×l)(|k|²/|k−l|²)v_{k−l}, connection ∇=½([,]−B−B); curvature on the
closed finite set {a·k+b·l: a,b∈−3..3}.
- **Verified:** k∥l (k×l=0) ⇒ C=0 (flat, commuting flows) exactly; C symmetric.
- **Sign census** (2256 sections, k,l∈[−3,3]², DATA not asserted): **84% NEGATIVE
  (Arnold)** / **9% POSITIVE (Misiołek, e.g. C((2,2),(2,1))=+0.35)** / 6% flat.
  Both classical results reproduced. (My first 9-pair sample hit all-negative —
  corrected by the full census showing genuine positive sections exist.)
- **Predictability:** negative κ ⇒ error δ(t)≈δ₀e^{t/τ}, 1/τ=|v|√(−κ) (Jacobi);
  Arnold's atmosphere figures ⇒ ~10⁵ amplification over 2 months = "5 more digits
  for a 2-month forecast" ⇒ ~2-week horizon. Our curvature matches the sign/structure;
  absolute rate is normalization-dependent (flagged).
- Folded into NS-033 (now 5 slices; scope "2D ideal flow / finite truncations").
  Registry + companion updated. **`:proved`=0; distance to prize UNTOUCHED** (2D Euler
  geometry, not the 3D PDE). Slices 1+4+5 = one Lie-group object (orbit / finite curv /
  ∞-dim curv).

## v0.1.10 — 2026-06-01 — Slice 3 made rigorous: the scaling-exponent calculus (NS-034)

Upgraded the manifold study's most load-bearing finding ("supercriticality = the
non-compact scaling quotient") from a torus demonstration to an **exact calculus**
(`scripts/manifold_3b_criticality.jl`).
- **Exact exponents** (change of variables on ℝ³): σ(L^q)=1−3/q, σ(Ḣ^s)=s−½,
  σ(L^p_tL^q_x)=1−3/q−2/p. CRITICAL (σ=0, scale-invariant, descends to the dilation
  quotient) = {L³, Ḣ^{1/2}, BMO⁻¹, **Prodi–Serrin 2/p+3/q=1**}; SUPERCRITICAL (σ<0)
  = energy (σ=−1) and dissipation (σ=−1), the a-priori-controlled quantities.
- **Verified** continuous-λ: σ(Ḣ^s)=s−½ to quadrature precision (s=0 decays λ^{−½};
  s=½ flat ≡1 = critical; s=1 grows); PS borderline ⟺ σ=0 exactly.
- **Supercriticality as a precise descent failure:** controlled norms σ<0 (a Leray
  bound is vacuous as λ→∞), regularity-deciding norms σ=0 (uncontrolled), no overlap
  = the wall. **Unifies NS-002 (supercriticality) ↔ NS-005 (critical-norm criterion).**
- Added **NS-034** (Class ANALYSIS, evidence algebraic+computed, **:argued** — the
  analytic exponents are exact but the entry FRAMES the obstruction, standard
  criticality theory re-derived + verified; NOT a regularity proof). NS-002 evidence
  strengthened to cite it. Companion Slice-3 §2 extended. Counts → 24 entries.
  **`:proved`=0; distance to prize UNTOUCHED** (a framing of the wall, not a breach of it).

## v0.1.9 — 2026-06-01 — Step-2 gated null (NS-032) + the state-space manifold study (NS-033)

**NS-032 — Stage 1c-3D Step 2, the gated blowup hunt → NULL.**
`scripts/spectral_3d_blowup_candidate.jl`. Inviscid Taylor–Green (Brachet, the
canonical Euler near-singularity probe), N=32 & 64, three gates (G1 resolved,
G2 N-converged, G3 BKM co-moving). δ narrows 2.10→0.37 but **G2 fails** (~50%
δ-disagreement across N — the Step-1 δ-fit fragility) and **G3 fails** (δ bottoms
0.37, BKM finite). **INCONCLUSIVE — the gates correctly flag a resolution-limited
cascade, no false-positive blowup.** Decline decelerates (weakly consistent with,
not evidence for, no-finite-time-singularity). `:tested` null, Scope inviscid-3D.

**NS-033 — the NS state-space manifold study (4 exact slices).** CFS-style
geometric reconnaissance (no resolution wall) — `scripts/manifold_{1,2,3,4}_*.jl`
+ `docs/manifold_study_companion.md`:
- **Slice 1 coadjoint orbit (exact):** triad = Euler rigid body; Casimir=energy
  sphere, helicity polhodes, middle-leg saddle (cascade donor), separatrix,
  invariants ~1e-13.
- **Slice 2 edge manifold (MFE):** laminar|turbulent boundary, log critical
  slowing σ≈0.19, shear+streak edge state. **CORRECTION: the edge-manifold normal
  is multi-mode and the roll a3 is ~TANGENT — "a3=gate" refuted; the NS-023
  committor-gate is a distinct conditional notion (two notions, not one).**
- **Slice 3 invariant/scaling quotient:** rotation-invariant (1e-15); scaling
  field-exponents (λ²,λ³,λ⁴,λ⁶) exact. **CORRECTION: physical exponents need the
  λ⁻³ domain rescaling — E~λ⁻¹ supercritical, H~λ⁰ invariant; supercriticality is
  a measure/scale fact, not amplitude. H, E·Ω descend to the critical quotient.**
- **Slice 4 Arnold curvature:** Koszul sectional curvature **verified κ≡¼ on
  bi-invariant SO(3)**; anisotropic rigid body has a negative plane (κ(2,3)=−0.91);
  Lyapunov λ>0 (MFE saddle) vs ≈0 (integrable triad) = Arnold unpredictability.
- The study **re-derives the firewall's thesis geometrically**: supercriticality =
  the non-compact scaling direction of the invariant quotient; the cascade donor =
  a coadjoint saddle + a negatively-curved plane. `:tested`, Scope geometry.
- Two honest corrections recorded mid-build (Slices 2, 3), not buried.
- Counts → 23 entries; `:proved` = 0. **Distance to prize: UNTOUCHED.**

## v0.1.8 — 2026-06-01 — NS-010 Stage 1c-3D Step 1: the 3D regularity control

First 3D move — deliberately the known-regular CONTROL, not a blowup hunt.
`scripts/spectral_3d_control.jl` (+ companion `docs/ns010_stage1c_3d_companion.md`):
3D pseudospectral solver, rotational form `∂_t û = P[(u×ω)^] − νk²û` (Leray
projection, vortex stretching LIVE), hand-rolled radix-2 3D FFT (no FFTW), RK4,
2/3 dealias. N=1 smoke gate (`SMOKE=1`) passed before the full sweep.
- **(A) Solver VALIDATED** — 3D Euler on a seeded helical IC conserves ENERGY and
  **HELICITY** to 0.0000%, div_max≈1e-12 (T-07). Helicity is the 3D-specific Tier-1
  check 2D could not provide (vortex stretching is live; enstrophy grows ~8.6×).
- **(C) Regularity control PASS** — viscous Taylor–Green (ν=0.02, N=64): δ bounded
  (min 0.605, never→0), BKM ∫‖ω‖∞ finite (≈14.2), energy monotonically decays,
  enstrophy peaks-then-decays. Clean exponential tail (well-resolved). T-06 (BKM
  co-movement) affirmed in the regular direction.
- **(B) HONEST CORRECTION** — the exponential-strip δ-FIT does NOT cleanly converge
  across N∈{16,32,64} on the inviscid developing-cascade run (~50% non-monotonic
  spread); the fit band k=2..N/3 is window-sensitive once a power-law range forms.
  Energy is conserved at every N (the SOLVER is robust; the δ-slope-FIT is the
  fragile piece). An earlier draft script line claimed clean convergence — corrected
  in the script + companion, not buried. Panel A's δ-decline is the expected inviscid
  cascade (strip narrowing as enstrophy grows), NOT a regularity claim.
- **Consequence:** Step 2 (blowup-candidate IC) is GATED on BKM co-movement (T-06)
  + true *spectral* N-convergence, NOT the δ-slope-fit alone — the fit is fragile
  exactly in the inviscid/under-resolved regime a blowup hunt lives in. Build the
  Step-2 IC on the mechanism axis {NS-002,004,009} (band-finding #1).
- Spec: NS-010/011 Scope note extended to "1D+2D+3D(viscous-control)" with the
  δ-fit caveat documented (status stays :tested). TEST_SPEC: T-06 (BKM gate,
  defined/affirmed-regular) + T-07 (3D solver E+H validation, PASS). Registry +
  dashboard updated. **Distance to prize: UNTOUCHED; Scope: 3D-truncation, not the PDE.**

## v0.1.7 — 2026-06-01 — TCE self-map: triadic coordination structure of the program (NS-031)

Pre-3D structural reconnaissance. Ran TCE's `Discovery.Triadic` engine (via
`SpecBridge`, test-suite `triadic-coordination-runonspec`) on the NS obstruction
ledger encoded as a 20-node corpus (`discovery/ns_obstruction_corpus.json`): `deps`
= genuine logical premises from SPEC prose, `layer` = program depth, `logic` tier
carrying the Scope firewall (`classical` PDE-analysis / `other:closure` model arc /
`bridge` = NS-024,NS-030 only). `status: proved_conditional` is the engine's
anchor-eligibility flag, **decoupled from the PDE-proof firewall** (`:proved` still 0).
- **64 triads → 10 independent units** (edge-disjoint dedup). Keystone obstruction
  triad **{NS-002,003,004} @1.0** (supercriticality+energy+BKM); pure-scaling
  {NS-002,007,009} @1.0; closure-arc {NS-023,024,025} @1.0; Leray-energy cluster
  {NS-005,006,008} @0.78; **live complex-plane attack triad {NS-011,012,013} @0.70**;
  PDE bridge **{NS-003,004,010} @0.83** (walls → validated diagnostic).
- **Firewall reproduced, not assumed:** a scan of all 64 triads finds **zero**
  mixing the PDE-analysis tier with the closure tier; the bridge NS-024 has one
  pairwise cross-tier edge (→NS-009) that never closes a triangle — an independent
  engine-side reproduction of NS-024's witnessed "broad/generic, no PDE purchase."
- NS-001 (root) and NS-021 (MFE) appear in no triad (universal-premise / most-isolated);
  {NS-010,011,012} is subsumed by NS-013 (collapse filter).
- Added **NS-031** (Class PROGRAM, `computed`, **:tested**, **Scope: methodology —
  NOT PDE**), registry row, companion `docs/ns_triad_discovery_companion.md`,
  reproducible log `discovery/ns_triad_discovery.out.txt`. Counts → 21 entries;
  `:proved` = 0. **Sets the 3D attack geometry** (NS-002 wall — NS-004/010 — NS-011).
- **Band stratification folded in** (companion §2 + run-log View D): HIGH =
  foundational redundancy; **MID = "cross-framing invariance" is where the
  actionable couplings sit** — two NEW readings beyond the dedup-10: the
  *mechanism* axis **{NS-002,004,009}** (how it blows up: scaling×stretching×
  anomalous-dissipation) and the *dead-ends* triple **{NS-007,008,020}** (the
  fenced-off method classes, incl. our own falsified homology); LOW = structural
  echo (keystone shadows, no new PDE nugget). 8 band-finding follow-ups added to
  `dashboard.md`. Threshold caveat: 0.85/0.70/0.55 are closure-v5 defaults, not
  recalibrated for 20 nodes (relative-only).
- Housekeeping: TCE de-dup DONE (turbulence scripts pruned from TCE @`8fcf1b4`);
  navier-stokes is their sole home. **Distance to prize: UNTOUCHED.**

## v0.1.6 — 2026-06-01 — Consolidation: validated-diagnostic milestone + internal audit

Pre-3D consolidation checkpoint (`docs/validation_milestone.md`).
- **Internal cross-audit PASS** (TCE-style): A1 spec↔registry ID parity (20 IDs),
  A3 every referenced artifact exists (+ every `.jl` has its `.out.txt`), A4 firewall
  intact (**zero** `:proved` status; only reserved-language mentions).
- **Validation ladder consolidated:** the NS-010/011 diagnostic is two-sided —
  correctly reports blowup (1a Burgers exact δ; 1b CLM exact δ + BKM co-movement)
  AND regularity (1c 2D: δ bounded, invariants conserved <1e-6) against ground truth.
  Hermetic radix-2 FFT (1D+2D), self-checked. Tool chain trusted before 3D.
- Dashboard milestone recorded; distance-to-prize UNTOUCHED.
- Open (decisions, not done here): push/remote; prune the migrated turbulence scripts
  from TCE; and "run the TCE" prep step before the 3D escalation.

## v0.1.5 — 2026-06-01 — NS-010 Stage 1c (2D): the regularity control

`scripts/spectral_2d_control.jl` (+ companion). 2D pseudospectral NS/Euler
(vorticity form; hand-rolled FFT extended to 2D, roundtrip exact). 2D is *known*
globally regular ⇒ the diagnostic must report regularity — and it does:
- **Solver validated** by the Tier-1 invariants: 2D Euler conserves energy,
  enstrophy, ‖ω‖∞ to <1e-6 (the exact-invariant ground truth in lieu of a closed
  form). FFT 2D self-check exact.
- **Control PASS (T-05):** δ(t) decreases via filamentation but stays **bounded
  (≥0.23, never→0)**; ‖ω‖∞ conserved ⇒ BKM ∫‖ω‖∞ **finite** ⇒ no blowup. NS (ν>0):
  energy & enstrophy monotonically decay, δ bounded. The diagnostic **distinguishes
  regularity from blowup** (vs CLM Stage 1b, δ→0) — the prerequisite for 3D.
- **physical_invariants.md made concrete:** enstrophy & ‖ω‖∞ are Tier-1 coercive in
  2D (no vortex stretching) ⇒ BKM finite ⇒ regular. The 2D side of the 2D/3D gap.
- **Honesty:** corrected a text claim ("N=256 conserves enstrophy better") that the
  data didn't support (both N conserve exactly; cascade not yet at the cutoff).
- **Firewall:** 2D truncation, not the PDE. NEXT = 3D (open regime, no benchmark).

## v0.1.4 — 2026-06-01 — NS-010 Stage 1b: spectral solver + BKM co-movement (CLM)

`scripts/spectral_clm_blowup.jl` (+ companion). Apply the validated δ(t) diagnostic
to a *real pseudospectral solver* of the Constantin–Lax–Majda model `ω_t=ωH(ω)` —
the 1D vortex-stretching (NS-004) analog that genuinely blows up.
- Hand-rolled radix-2 FFT (no FFTW dependency), self-checked vs manual DFT (5e-13).
- Derived exact CLM strip `δ(t)=ln(2/t)` (complex singularity `x*=π/2+i ln(2/t)`),
  blowup `t*=2`, simple pole. δ_fit reproduces it exactly.
- **T-04 PASS (BKM half):** δ→0 co-diverges with ∫‖ω‖∞→∞ at the same t*=2.
- **T-03 PASS (with honest correction):** solver+δ N-robust to <0.1% for
  N∈{512,1024,2048} through t=1.98. I predicted a small-N breakdown there; there is
  none — the spectrum-slope fit is robust to cutoff under-resolution. Recorded as a
  correction, not buried.
- NS-010/011 stay `:tested` (now exercised on a 2nd exact benchmark + a real
  time-stepper); NS-004 corroborated computationally.
- **Firewall:** validates the tool chain on the vortex-stretching nonlinearity in a
  1D model. Does NOT touch 3D-NS regularity. NEXT = Stage 1c (2D→3D, no benchmark).

## v0.1.3 — 2026-06-01 — NS-010 Stage 1a: analyticity-strip diagnostic VALIDATED

`scripts/burgers_analyticity_strip.jl` (+ companion `docs/ns010_analyticity_strip_companion.md`).
First `Scope: PDE-method` work. The complex-singularity / analyticity-strip blowup
diagnostic (NS-010/011) is validated against an EXACT 1D closed form:
- Derived the exact inviscid-Burgers strip width `δ(t)=arccosh(1/t)−√(1−t²)` (from
  the complex-characteristic singularity `cos ξ*=1/t`, `ξ*=i·arccosh(1/t)`), shock
  at `t*=1`, `δ~(t*−t)^{3/2}`.
- **Spectrum-fitted δ(t) matches it to ≤4.1%** (t=0.3–0.95; cube-root `k^{-4/3}`
  prefactor removed); **3/2-law exponent = 1.519** (theory 1.5). **T-01 PASS, T-02
  PASS (inviscid).**
- Viscous control (Cole–Hopf, ν=0.1): δ bounded (~0.4) for all t incl. past t*=1,
  vs inviscid δ→0 — viscosity holds the complex singularity off the real axis.
- NS-010/011 promoted `:argued → :tested` (Scope: PDE-method, validated in 1D-model).
- **Firewall intact:** validates the *tool*; the 3D-NS question (does δ→0 there) is
  untouched — Stage 1b (spectral truncation) + ultimately the open problem. T-03
  (full N-sweep) PARTIAL; T-04 (BKM/critical-norm co-movement) PENDING for 1b.

## v0.1.2 — 2026-05-31 — Log external related work (Gosme)

Added **NS-025 (Class RELATED)**: Gosme, *Causal symmetrization as an empirical
signature of operational autonomy in complex systems*, arXiv:2512.09352 (Dec 2025)
— verified real (paper fetched; Aaron's cited title was a close paraphrase). An
external empirical operationalization of the closure-to-efficient-causation /
(M,R) framework on 50 software ecosystems: order parameter Γ (bimodal phase
transition), "causal symmetrization" (Granger structure↔activity coupling 0.71→0.94
at maturity), "structural zombies." **Scope: software-ecosystems / phenomenology —
NOT NS-PDE; cannot bear on the prize.** Bears on NS-023/024 (closure-theory side).
Added Class `RELATED` to `CLAUDE.md`; registry row; flagged the symmetrization-vs-
(M,R)-symmetry comparison as caution-not-claim. Queued a phenomenology experiment:
test whether the symmetrization signature appears in the MFE saddle (Granger
structure=roll a₃ vs activity=perturbation energy), Scope: ODE-truncation.

## v0.1.1 — 2026-05-31 — Physical invariants reference

Added `physical_invariants.md` — the tiered invariant constraint set for NS, in
the lineage of the closure-v5 `physical_invariants.md` and the possibilistic-
inversion `geophysical_invariants.md`. Tier 1 (frame-independent / hard:
incompressibility, energy inequality, momentum, scaling symmetry→supercriticality,
Galilean/rotation symmetries, helicity & circulation [Euler-exact / NS-decaying],
enstrophy [2D-coercive / 3D-battleground], BKM); Tier 2 (frame-dependent
phenomenology: K41 −5/3, increment 1/3, anomalous dissipation, intermittency, Re
thresholds, blowup scenarios — soft only, anchoring anti-pattern if hard); Tier 3
(established theorems = the fixed end). **Load-bearing reading recorded: the 2D/3D
regularity gap IS an invariant-tier story — enstrophy is Tier-1 coercive in 2D, the
battleground in 3D, leaving only the supercritical energy as Tier-1 control.** The
tier-confusion anti-pattern is the Scope firewall in invariant terms. Wired into
`CLAUDE.md` ground-truth hierarchy and cross-referenced to `SPEC.md` NS-IDs.

## v0.1.0 — 2026-05-31 — Repository established

**Founding commit.** Set up the obstruction-program scaffold for the 3D
incompressible Navier–Stokes global-regularity (Clay) problem, in the TCE
ground-truth-hierarchy style, adapted for a mathematics obstruction program.

- **Business files:** `CLAUDE.md` (constitution + the Scope firewall),
  `SPEC.md` (the obstruction ledger, 18 entries), `DESIGN.md` (strategy +
  the complex-plane live attack + cross-project framing), `dashboard.md`,
  `artifact_registry.md`, `TEST_SPEC.md`.
- **Spec populated from what we know:** problem statement (NS-001);
  obstructions NS-002..009 (supercriticality, Leray energy-only control, BKM,
  Prodi–Serrin–ESS, CKN partial regularity, no-self-similar-blowup, Tao
  averaged-blowup no-go, Onsager 1/3); diagnostics NS-010/011 (analyticity
  strip, complex-singularity tracking); live NS-012/013 (Li–Sinai complex-data
  blowup; real⇐complex open).
- **Prior arc migrated** (copied from TCE; TCE copies remain @79e5e35):
  15 scripts + 2 witness docs. Recorded honestly as NS-020 (homology
  reformulation **:falsified**), NS-021 (MFE saddle phenomenology, Scope:
  ODE-truncation), NS-022 (helical triad, Scope: model), NS-023 (autopoietic
  closure / (M,R) rotation-covariant gate, Scope: abstract closure — a separate
  domain), NS-024 (closure↔turbulence convergence, witness-trimmed to
  broad/generic, Scope: analogy).
- **Honest baseline recorded:** zero progress on the prize; `:proved` count = 0
  by design; distance-to-prize = UNTOUCHED.

**Next:** the complex-plane diagnostic (NS-010/011) — Burgers exact poles, then a
spectral truncation watching the analyticity-strip width δ(t). First in-repo
direction with `Scope: PDE-method`; still a diagnostic in models, not a proof.
