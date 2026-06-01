# dashboard.md — Navier–Stokes obstruction program

**Read this first, every session.** Status + priority stack + open gaps. Scorecard
lives in `SPEC.md`, not here.

## Distance to the prize

**UNTOUCHED.** Zero rigorous PDE results (`:proved` count = 0, by design). Anything
below with `Scope ≠ PDE` is **not** prize progress. This line changes only when a
`:proved`, `Scope: PDE` entry exists.

## Status summary (v0.1.0, 2026-05-31)

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

1. **[NEXT] Complex-singularity / analyticity-strip diagnostic (NS-010/011).**
   - 1a. Burgers (1D, exact): complex-pole dynamics + `δ(t)` vs the Cole–Hopf
     closed form. Validates the diagnostic (TEST_SPEC T-01). Scope: 1D-model.
   - 1b. Spectral Euler/NS truncation: `δ(t)` via spectrum decay; co-movement with
     BKM integral (NS-004) and critical norm (NS-005). Scope: ODE-truncation.
   - Firewall: diagnostics in models; not a PDE statement.
2. Tighten the obstruction citations (page-level refs for NS-005 endpoint, NS-009
   constants) — `:cited` hygiene.
3. Decide TCE de-duplication: the 15 scripts are also committed in TCE @79e5e35;
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
