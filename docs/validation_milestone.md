# Consolidation — validated-diagnostic milestone (pre-3D)

**2026-06-01, v0.1.x.** Consolidation checkpoint before the 3D escalation. The
analyticity-strip / complex-singularity blowup diagnostic (NS-010/011) is now
validated against ground truth in **three** regimes, and the repo passes an
internal cross-audit. **Distance to the prize: UNTOUCHED** (`:proved` = 0).

## The validated diagnostic ladder

| Stage | System | Ground truth | Result | Tests |
|---|---|---|---|---|
| **1a** | inviscid Burgers (shock) | exact `δ(t)=arccosh(1/t)−√(1−t²)`, `t*=1`, 3/2-law | δ_fit matches ≤4.1%, exponent 1.519 | T-01, T-02 |
| **1b** | CLM `ω_t=ωH(ω)` (vortex-stretching blowup) | exact `δ(t)=ln(2/t)`, `t*=2` | spectral solver matches <1% N-robust; **δ→0 ⇔ BKM→∞** | T-02, T-03, T-04 |
| **1c-2D** | 2D Euler/NS (regular) | Tier-1 invariants conserved exactly | **δ bounded, BKM finite**; energy/enstrophy/‖ω‖∞ to <1e-6 | T-05 |

**The decisive property:** the diagnostic is **two-sided** — it reports **blowup**
(δ→0, BKM→∞) on CLM *and* **regularity** (δ bounded, BKM finite) on 2D, each checked
against ground truth. A tool that only ever "found blowup" would be worthless; this
one correctly says *no blowup* when there is none. That is what licenses trusting it
where there is no benchmark (3D).

Also validated: a hand-rolled radix-2 FFT (1D and 2D), self-checked against the
manual DFT to machine precision — hermetic, no FFTW dependency.

## Internal cross-audit (TCE-style A1/A3/A4) — PASS

- **A1 coverage:** every `SPEC.md` NS-ID has an `artifact_registry.md` row, and vice
  versa (21 IDs: NS-001..013, NS-020..025, NS-030..031 — NS-031 added at v0.1.7).
- **A3 artifacts:** every referenced `scripts/*.jl` and `docs/*.md` exists; every
  `.jl` has its `.out.txt`.
- **A4 firewall:** **zero** entries with status `:proved` (the only `:proved` text is
  the reserved-language: "reserved / none / by design"). Every RESULT carries a
  `Scope` that is not `PDE`.

## What is, and is not, established

- **Established:** a *validated tool chain* (pseudospectral solver + δ-fit + BKM
  co-movement) that correctly distinguishes blowup from regularity in 1D and 2D
  against exact ground truth.
- **NOT established:** anything about the 3D-NS PDE. Distance to the prize unchanged.
  Every result is `Scope ∈ {1D-model, ODE-truncation, 2D-truncation}`.

## 3D readiness + the epistemic shift (load-bearing)

The next step (3D NS/Euler) crosses a line the firewall must hold hard:
- **No ground truth.** 3D is the open problem; a measured `δ(t)→0` would be
  *suggestive evidence in a finite truncation* — **never a proof**, and weak on its
  own. This is exactly where numerical near-blowups have historically misled.
- **T-03 (N-convergence) and T-04 (BKM + critical-norm co-movement) become the whole
  game** — a δ→0 that is not N-converged and not co-moving with BKM/NS-005 is a
  resolution artifact, not a result.
- **Protocol:** a known-regular 3D control first (validate the 3D solver the way 2D
  validated the 2D solver), then a blowup-candidate IC, always N-converged.
- **Compute:** 3D FFT (hand-rolled 3D, or FFTW + `Project.toml`/`Manifest`); N³ cost.

The repo is consolidated and consistent; the tool is trusted; the firewall is loaded.
That is "as prepped as we can be" before 3D.
