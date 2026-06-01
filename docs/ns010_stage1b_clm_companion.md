# Companion — NS-010 Stage 1b: δ(t) on a pseudospectral solver (CLM blowup)

**2026-06-01.** **Scope: 1D-model + pseudospectral ODE-truncation.** Applies the
validated analyticity-strip diagnostic (NS-010/011, validated in Stage 1a) to a
*real pseudospectral solver* of a model that **genuinely blows up via vortex
stretching** — the Constantin–Lax–Majda (CLM) equation — and tests the BKM
co-movement (T-04) and resolution robustness (T-03). Firewall: still a 1D model;
does NOT touch 3D-NS regularity.

## §1 — Computational basis

`scripts/spectral_clm_blowup.jl` (+ `.out.txt`). Julia, std-lib only — a
hand-rolled iterative radix-2 FFT (no FFTW dependency), **self-checked against the
manual DFT** (max|fft−DFT|=5e-13, roundtrip 9e-16).
- **Model:** CLM `ω_t = ω·H(ω)`, H = Hilbert transform (`Ĥω=−i·sgn(κ)·ω̂`). The
  `ωH(ω)` term is the 1D analog of 3D vortex stretching (NS-004 mechanism). IC
  `ω₀=cos x`.
- **Exact solution** (Majda–Bertozzi §5): `ω=4ω₀/[(2−tHω₀)²+t²ω₀²]`; blowup `t*=2`.
  Derived here: complex singularity `x*=π/2+i·ln(2/t)` ⇒ **exact strip
  `δ(t)=ln(2/t)`** (simple pole, linear δ→0), `‖ω‖∞~1/(2−t)`.
- **Solver:** pseudospectral RK4 with 2/3-dealiasing, N∈{512,1024,2048}.

## §2 — Results

**(A) Exact, T-04 co-movement.** δ_fit(FFT of exact ω) = ln(2/t) to 5 digits;
‖ω‖∞ grows 1.04→20.3 (t:0.4→1.95, ~1/(2−t)); the BKM integral ∫‖ω‖∞ diverges
(logarithmically) at t*=2. **δ→0 and BKM→∞ at the SAME t*=2.**

**(B) Spectral solver vs exact (N-convergence).**

| t | δ_spectral (N=512/1024/2048) | exact ln(2/t) | rel.err |
|---|---|---|---|
| 1.60 | 0.2231 / 0.2231 / 0.2231 | 0.2231 | <0.1% |
| 1.90 | 0.0513 / 0.0513 / 0.0513 | 0.0513 | <0.1% |
| 1.95 | 0.0253 / 0.0253 / 0.0253 | 0.0253 | <0.1% |
| 1.98 | 0.0101 / 0.0101 / 0.0101 | 0.0101 | <0.1% |

The solver+diagnostic reproduce the exact strip to **<1% for all N through
t=1.98** (δ down to 0.010) — **N-robust**.

## §3 — Verification (TEST_SPEC)

- **T-04 (δ↔BKM co-movement): PASS** (exact CLM: δ→0 and ∫‖ω‖∞→∞ at t*=2).
- **T-02 cross-method: PASS** (spectral δ = exact δ = analytic ln(2/t)).
- **T-03 (resolution honesty): PASS-with-correction.** I *predicted* a small-N
  breakdown at t=1.98 (δ below the N=512 grid scale 0.012); **there is none** — all
  N match to <0.1%. The spectrum-*slope* fit reads δ from the bulk of the resolved
  band, so it is robust to under-resolution at the cutoff. A genuine breakdown needs
  δ ≲ a few grid modes (t≳1.99); not probed, to avoid conflating spatial
  under-resolution with time-integration error near t*. The error IS shown vs N
  (no silent truncation); the honest finding is that the diagnostic is *robust*.

## §4 — Spec impact

- **NS-010/011** (already `:tested` from 1a): the diagnostic is now exercised on a
  second exact benchmark (CLM) **and on a real pseudospectral time-stepper**, with
  T-04 (BKM co-movement) PASS. The tool chain (solver + δ-fit + BKM) is validated on
  the vortex-stretching nonlinearity.
- **NS-004** (BKM): the δ↔BKM co-divergence is now demonstrated computationally
  (CLM, exact), corroborating the obstruction's structure.
- **Firewall:** validates the *machinery*; the 3D-NS question is untouched. Next
  escalation (2D→3D pseudospectral) has **no exact benchmark** — that is where the
  diagnostic stops being validatable and the open problem begins.
