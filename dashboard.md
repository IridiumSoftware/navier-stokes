# dashboard.md — Navier–Stokes obstruction program

**Read this first, every session.** Status + priority stack + open gaps. Scorecard
lives in `SPEC.md`, not here.

## Distance to the prize

**UNTOUCHED.** Zero rigorous PDE results (`:proved` count = 0, by design). Anything
below with `Scope ≠ PDE` is **not** prize progress. This line changes only when a
`:proved`, `Scope: PDE` entry exists.

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

## Status summary (v0.1.19, 2026-06-01)

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

- **Ledger:** 24 entries — 1 PROBLEM (`:open`), 8 OBSTRUCTION (`:cited`/`:argued`),
  2 DIAGNOSTIC (`:tested`), 2 live (`:cited`/`:open`), 6 our RESULTS/FALSIFIED
  (1 `:falsified`, 4 `:tested` non-PDE-Scope incl. NS-032 gated-null, 1 `:argued`),
  1 RELATED (`:cited`), 2 PROGRAM, 1 GEOMETRY (NS-033 manifold study `:tested`),
  1 ANALYSIS (NS-034 scaling calculus `:argued`, the rigorous Slice 3). `:proved` = 0.
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
   - 1c-3D Step 2 (blowup candidate). **[NEXT]** a blowup-candidate IC in the OPEN
     regime — enstrophy not coercive, NO benchmark, δ(t)→0 would be the actual
     question. **GATED (from Step 1 + NS-031):** a δ→0 counts ONLY if (a) N-converged
     in the *spectrum itself* (not just the fitted δ — see the Step-1 caveat) AND
     (b) co-moving with BKM ∫‖ω‖∞→∞ (NS-004, T-06), per the {NS-003,004,010} bridge.
     Build the IC on the mechanism axis {NS-002,004,009} (band-finding #1): drive
     vortex stretching toward the anomalous-dissipation regime. Epistemics:
     suggestive-in-a-truncation, NEVER a proof. Firewall paramount.
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

- NS-013: does complex-data blowup (NS-012) imply anything for real data? `:open`.
- No `Project.toml`/lockfile yet — add when spectral code (FFTW) lands (package
  discipline, CLAUDE.md).
- TEST_SPEC currently has the diagnostic-validation rows pending the NS-010 build.

## Cross-project note

Method (obstruction ledger + Scope firewall + witnessing) is the part that
transfers to CFS / closure-quotient / possibilistic-inversion *now*; substantive
math transfers only when a scoped, witnessed result earns it (DESIGN §5).
