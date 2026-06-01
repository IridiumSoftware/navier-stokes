# Companion — NS-010 Stage 1a: analyticity-strip diagnostic validated (Burgers)

**2026-06-01.** First `Scope: PDE-method` work in the repo. **Scope: 1D-model.**
Validates the complex-singularity / analyticity-strip blowup diagnostic
(NS-010/011) against an exact closed form. Firewall: a diagnostic in a 1D model —
NOT a statement about the 3D NS PDE.

## §1 — Computational basis

`scripts/burgers_analyticity_strip.jl` (+ `.out.txt`). Julia, std-lib only (manual
DFT — no FFTW dependency). Two computations on `u(x,0)=−sin x`, period 2π:
- **Inviscid Burgers** `u_t+uu_x=0`: real solution by Newton on the implicit map
  `x=ξ−sin(ξ)t`, `u=−sin ξ`. Spectrum `|û(k)|` by manual DFT; δ(t) by fitting the
  exponential decay rate (plain, and with the cube-root prefactor `k^{-4/3}`
  removed). N=4096, k up to 900.
- **Viscous Burgers** (ν=0.10) via exact Cole–Hopf: `φ0=exp(−cos x/2ν)`
  (normalized), heat-evolved in Fourier, `u=−2ν(ln φ)_x`. N=1024.

## §2 — Results

**Exact benchmark (derived here):** the inverse-map singularity `cos ξ*=1/t` gives
the nearest complex singularity at `ξ*=i·arccosh(1/t)`, hence the analyticity-strip
width **`δ(t)=arccosh(1/t)−√(1−t²)`**, `0<t≤1`; shock at `t*=1`; near `t*`,
`δ~(√2/6)(t*−t)^{3/2}` (cube-root singularity ⇒ `|û(k)|~k^{-4/3}e^{−δk}`).

| t | δ_exact | δ_fit (prefactor-corr.) | ratio |
|---|---|---|---|
| 0.30 | 0.9199 | 0.9302 | 1.011 |
| 0.50 | 0.4509 | 0.4575 | 1.015 |
| 0.70 | 0.1815 | 0.1849 | 1.019 |
| 0.85 | 0.0589 | 0.0603 | 1.024 |
| 0.92 | 0.0222 | 0.0228 | 1.027 |
| 0.95 | 0.0108 | 0.0112 | 1.041 |

- **Spectrum-fitted δ reproduces the exact δ(t) to ≤4.1%** across the range.
- **3/2-law:** fitted shock-approach exponent **p=1.519** (theory 1.5).
- **Viscous control:** δ bounded (~0.36–0.74) for all t incl. past t*=1, vs
  inviscid δ→0. Viscosity holds the singularity off the real axis; the viscous
  floor shrinks with ν.

## §3 — Verification (TEST_SPEC)

- **T-01 (closed-form): PASS.** δ_fit vs the exact δ(t), ≤4.1%; 3/2 exponent 1.519.
- **T-02 (spectrum ↔ singularity): PASS (inviscid).** The spectrum decay rate
  equals the analytically-tracked nearest-singularity distance (they are compared
  directly — the exact δ *is* the tracked singularity).
- **T-03 (resolution honesty): PARTIAL.** Run at N=4096; near t→1 the fit needs
  ever-higher k (window 13→891 modes). A full N-convergence sweep is pending
  before any quantitative δ near t* is promoted.
- **T-04 (obstruction co-movement, BKM/critical-norm): PENDING** — that test
  belongs to the spectral NS/Euler truncation (Stage 1b), not Burgers.

## §4 — Spec impact

- **NS-010** (analyticity strip) and **NS-011** (complex-singularity tracking):
  `:argued → :tested`, Scope: **PDE-method validated in 1D-model**. The method is
  now validated, not merely cited. PDE-applicability remains the cited result
  (Foias–Temam); the PDE computation is Stage 1b.
- The firewall is intact: this validates the *tool*. Whether `δ(t)→0` for 3D NS —
  the actual prize — is untouched and is not addressed by a 1D model.
