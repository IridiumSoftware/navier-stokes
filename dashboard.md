# dashboard.md — Navier–Stokes obstruction program

**Read this first, every session.** Status + priority stack + open gaps. Scorecard
lives in `SPEC.md`, not here.

## Distance to the prize

**UNTOUCHED.** Zero rigorous PDE results (`:proved` count = 0, by design). Anything
below with `Scope ≠ PDE` is **not** prize progress. This line changes only when a
`:proved`, `Scope: PDE` entry exists.

## CONSOLIDATION MILESTONE (v0.1.6–v0.1.7, 2026-06-01) — pre-3D

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
triads — engine-side reproduction of NS-024's "no PDE purchase"). This sets the 3D
attack geometry. Next is 3D — the open regime, no ground truth (epistemics capped:
suggestive, never proof).

## Status summary (v0.1.7, 2026-06-01)

- **`physical_invariants.md`** added — tiered invariant constraint set (Tier 1
  hard / Tier 2 phenomenology / Tier 3 established), closure-v5 / possibilistic-
  inversion lineage. Key reading: the 2D/3D gap is an invariant-tier story
  (enstrophy Tier-1 in 2D, battleground in 3D).

- **Ledger:** 21 entries — 1 PROBLEM (`:open`), 8 OBSTRUCTION (`:cited`/`:argued`),
  2 DIAGNOSTIC (`:tested`), 2 live (`:cited`/`:open`), 5 our RESULTS
  (1 `:falsified`, 3 `:tested`-with-non-PDE-Scope, 1 `:argued`), 1 RELATED
  (`:cited`), 2 PROGRAM (`:argued` method + `:tested` TCE self-map NS-031). `:proved` = 0.
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
   - 1c-3D. **[NEXT]** 3D pseudospectral (real NS/Euler): the OPEN regime — enstrophy
     no longer coercive (vortex stretching ON), NO exact benchmark, δ(t)→0 would be
     the actual question. Heavier (3D FFT); a hand-rolled 3D FFT or FFTW + `Project.toml`.
     T-04 critical-norm (NS-005) half. Epistemics shift: suggestive-in-a-truncation,
     never a proof. Firewall paramount. Scope: ODE-truncation → the actual problem.
     - **Attack geometry (from the NS-031 TCE self-map):** build the 3D step as the
       triple **(NS-002 wall) — (NS-004 BKM / NS-010 strip) — (NS-011 complex
       singularity)**. The engine's keystone is {NS-002,003,004}; its PDE bridge is
       {NS-003,004,010} (so a 3D δ→0 counts only if it co-moves with BKM under the
       energy budget); its live frontier is {NS-011,012,013} (blowup is *known* for
       complex data — track whether the singularity reaches the real axis). Known-
       regular 3D control first, then a blowup-candidate IC, always N-converged.
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

## Open gaps / honest unknowns

- NS-013: does complex-data blowup (NS-012) imply anything for real data? `:open`.
- No `Project.toml`/lockfile yet — add when spectral code (FFTW) lands (package
  discipline, CLAUDE.md).
- TEST_SPEC currently has the diagnostic-validation rows pending the NS-010 build.

## Cross-project note

Method (obstruction ledger + Scope firewall + witnessing) is the part that
transfers to CFS / closure-quotient / possibilistic-inversion *now*; substantive
math transfers only when a scoped, witnessed result earns it (DESIGN §5).
