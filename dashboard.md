# dashboard.md — Navier–Stokes obstruction program

**Read this first, every session.** Status + priority stack + open gaps. Scorecard
lives in `SPEC.md`, not here.

## Distance to the prize

**UNTOUCHED.** Zero rigorous PDE results (`:proved` count = 0, by design). Anything
below with `Scope ≠ PDE` is **not** prize progress. This line changes only when a
`:proved`, `Scope: PDE` entry exists.

## Status summary (v0.1.1, 2026-05-31)

- **`physical_invariants.md`** added — tiered invariant constraint set (Tier 1
  hard / Tier 2 phenomenology / Tier 3 established), closure-v5 / possibilistic-
  inversion lineage. Key reading: the 2D/3D gap is an invariant-tier story
  (enstrophy Tier-1 in 2D, battleground in 3D).

- **Ledger:** 18 entries — 1 PROBLEM (`:open`), 8 OBSTRUCTION (`:cited`/`:argued`),
  2 DIAGNOSTIC (`:argued`/`:open`), 2 live (`:cited`/`:open`), 5 our RESULTS
  (1 `:falsified`, 3 `:tested`-with-non-PDE-Scope, 1 `:argued`), 1 PROGRAM.
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
2. **[QUEUED, phenomenology] MFE causal-symmetrization test (NS-021 × NS-025).**
   Test whether Gosme's symmetrization signature (arXiv:2512.09352) appears in the
   MFE saddle: directional Granger coupling between structure (roll `a₃`) and
   activity (perturbation energy); does it symmetrize on the self-sustaining branch
   and collapse at relaminarization? Scope: ODE-truncation — NOT the PDE. Keep the
   Gosme-vs-(M,R)-symmetry comparison caution-flagged (NS-025).
3. Tighten the obstruction citations (page-level refs for NS-005 endpoint, NS-009
   constants) — `:cited` hygiene.
4. Decide TCE de-duplication: the 15 scripts are also committed in TCE @79e5e35;
   prune from TCE or mark migrated (mirror of the closure-v5 physics migration).

## Open gaps / honest unknowns

- NS-013: does complex-data blowup (NS-012) imply anything for real data? `:open`.
- No `Project.toml`/lockfile yet — add when spectral code (FFTW) lands (package
  discipline, CLAUDE.md).
- TEST_SPEC currently has the diagnostic-validation rows pending the NS-010 build.

## Cross-project note

Method (obstruction ledger + Scope firewall + witnessing) is the part that
transfers to CFS / closure-quotient / possibilistic-inversion *now*; substantive
math transfers only when a scoped, witnessed result earns it (DESIGN §5).
