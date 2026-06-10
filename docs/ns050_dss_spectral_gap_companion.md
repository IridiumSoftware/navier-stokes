# Companion — NS-050 direction 1: the spectral-gap probe (and two refuted readings)

**Date:** 2026-06-09. **`Scope: 1D-model + pseudospectral ODE-truncation` (≠ the NS PDE).**
**`:proved`=0; distance to the Clay prize UNTOUCHED.** Extends the calibrated dynamic-rescaling instrument
of `ns050_modulation_witness.jl` to deliver the *new* content of direction 1 (`ns050_dss_modulation.md`):
**M2 — the spectral gap of the self-similar fixed point** — and to probe self-similar ⟷ DSS by sweeping the
advection parameter of the 1D Okamoto–Sakajo–Wunsch (OSW) family. This companion also records, per the
witness discipline, **two successive readings I had to retract** — the instrument's own data refuted them.

## §1 — Computational basis

- **File:** `scripts/ns050_dss_spectral_gap.jl` (Julia 1.12.6, std-lib only; hand-rolled FFT self-checked to
  5e-13). Output: `scripts/ns050_dss_spectral_gap.out.txt`. Run: `julia scripts/ns050_dss_spectral_gap.jl`
  (~3 min; the larger-`a` cases evolve to `t*≈3`).
- **Model — OSW family** `ω_t = −a·u·ω_x + (Hω)·ω`, `u_x = Hω` (⇒ `û(k)=−ω̂(k)/|k|`), on `[0,2π)`,
  `ω₀=cos x`. `a=0` = Constantin–Lax–Majda (exact self-similar blow-up, `t*=2`); `a=1` = De Gregorio. The
  advection term `a·u·ω_x` is **regularizing** — it competes with the `(Hω)ω` stretching that drives blow-up.
- **Observable.** Rescaled log-time `τ=ln‖ω‖∞` (amplitude-doubling = `Δτ=ln2`); the `(c)`-instrument
  profile `U(η,τ)`; **spectral gap** `g = −d ln‖∂_τU‖/dτ` (the rate the rescaled profile relaxes to its
  attractor = the leading stable eigenvalue magnitude). Center `x₀ = argmax|ω_x|` tracked each step.

## §2 — Results

**(A) Calibration, `a=0` (CLM) — the solid deliverable:**
- center `x₀ = 1.5708 = π/2` at every threshold, **`Δx₀ = 2e-12` (fixed, no translation)**;
- drift `‖ΔU‖` per amplitude-doubling: `1.34e-1 → 6.15e-2 → 3.13e-2 → 1.59e-2` (ratio 0.12 — clean decay);
- **spectral gap `g = 1.024`** ⇒ leading stable eigenvalue ≈ **−1.02**; the self-similar fixed point is a
  **stable attractor**. M2 made numerical, consistent with `(c)`'s drift-halving per amplitude-doubling.

**(B) Sweep `a = 0 … 0.5` — an honest negative:** advection delays blow-up (`t*` rises 1.97 → 2.11 → 2.27 →
2.48 → 3.09); all still reach finite-time blow-up within `tmax`. But for **every `a>0` the amplitude-only
fit stops converging** (drift ratio ≈ 1.1–1.8, "gap" ≈ 0 or negative). Verdict: **UNDETERMINED** — no DSS
claimed.

| a | t* | gap g | drift ratio | Δx₀ | reading |
|---|---|---|---|---|---|
| 0.00 | 1.969 | **1.024** | 0.119 | 2e-12 | steady self-similar (gap≈1) ✓ |
| 0.10 | 2.106 | −0.057 | 1.127 | 1e-10 | single-scale fit fails — UNDETERMINED |
| 0.20 | 2.272 | −0.278 | 1.785 | 2e-10 | single-scale fit fails — UNDETERMINED |
| 0.30 | 2.477 | −0.098 | 1.225 | 4e-10 | single-scale fit fails — UNDETERMINED |
| 0.50 | 3.087 | 0.060 | 0.882 | 5e-09 | single-scale fit fails — UNDETERMINED |

## §3 — Verification (and the two retracted readings)

**Evidence type: example-tested (within-truncation).** The asserted result — *the dynamic-rescaling fit
recovers the spectral gap of a known self-similar fixed point* — is exhibited at `a=0` against CLM, whose
self-similar structure is exact: gap `g≈1.02` (leading eigenvalue ≈ −1), `x₀` fixed, profile steady. ✓

**Two readings the data forced me to retract** (recorded because the program treats its own verdicts as
witnessable):
1. The script's **first run labelled `a>0` "DSS/oscillatory candidate."** Self-witness before emitting:
   that is an over-claim — a crude instrument's non-convergence is not a DSS detection. **Retracted.**
2. I then hypothesized the non-convergence was **translation contamination** (advection moves the
   structure; the fit quotients only `λ`, not `x₀`). The **`Δx₀` diagnostic refuted it**: `Δx₀ ≈ 1e-10`,
   the center is symmetry-pinned at `π/2`. **Retracted.**
   The **actual** cause: the single-scale fit uses `λ=1/A` as *both* amplitude and spatial scale (valid for
   CLM, both `~(2−t)`); for `a>0` the self-similar *spatial* exponent generally differs from the amplitude
   exponent, so `λ` is the wrong spatial scale and `U` is progressively stretched ⇒ non-decay. This is an
   instrument limitation, **UNDETERMINED** between genuine non-self-similarity/DSS and a `β≠1` self-similar
   profile the single-scale fit cannot resolve.

**Vacuity caps.** (1) 1D OSW model, finite truncation — no singular limit reached; validates the
*instrument*, never the PDE. (2) amplitude-scale modulation only (no spatial-scale, no `x₀`, no rotation) —
the tractable surrogate for direction-1's M1/M2 (a backward DSS *Euler* profile + its Floquet gap), which
this does **not** compute. (3) `:proved`=0.

## §4 — Spec impact

- **No NS-ID upgrade; no `SPEC.md`/`dashboard.md` change.** Feeds `NS-050` direction 1
  (`ns050_dss_modulation.md`); the entry stays `:open`, `Scope: PDE-analysis`, `:proved`=0.
- **What it earns:** M2 is now numerical in the tractable case — the CLM self-similar fixed point has a
  **measured spectral gap `g≈1`** (stable attractor). And the sweep **locates the instrument's edge**: the
  single amplitude-scale cannot probe `a>0` self-similarity, and the `Δx₀` refutation pins *why* (the
  spatial exponent, not translation).
- **Gated next step:** a **two-scale fit** (amplitude `A` *and* an independent spatial width, e.g. from the
  profile's curvature or a `‖ω_x‖`-based length) to disentangle a `β≠1` self-similar profile from genuine
  DSS — the prerequisite before *any* DSS reading of `a>0`. This is the 1D analog of direction-1's
  `(λ,x₀)`-modulation requirement (M3); the boundaryless DSS-*Euler* question (the real M1) remains
  untouched.

**Pointers:** `ns050_dss_modulation.md` (the analytic setup — M1–M5, Floquet),
`ns050_modulation_witness_companion.md` (the `(c)` instrument this extends),
`ns050_modulation_type2_scope.md` (the map).
