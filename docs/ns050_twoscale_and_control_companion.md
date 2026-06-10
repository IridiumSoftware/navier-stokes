# Companion — NS-050 (c1)+(c3): the two-scale fit, and the 3D negative control

**Date:** 2026-06-10. **`Scope: 1D-model (c1) / resolved-3D-DNS-truncation (c3)` — NOT the NS PDE.**
**`:proved`=0; distance to the Clay prize UNTOUCHED.** Two paired follow-ups to the NS-050 instrument arc:
**(c1)** the *two-scale* dynamic-rescaling fit that `ns050_dss_spectral_gap.jl` (b) showed was needed, and
**(c3)** a *negative control* confirming the instrument does not false-positive on a regular flow.

## §1 — Computational basis

- **(c1)** `scripts/ns050_twoscale_fit.jl` — adds an INDEPENDENT spatial scale `ℓ = A/‖ω_x‖∞` (a length,
  decoupled from the amplitude scale `λ=1/A`) to the dynamic-rescaling fit on the Okamoto–Sakajo–Wunsch 1D
  family (`a=0` CLM ↔ `a=1` De Gregorio). Anomaly exponent `β = d ln ℓ / d ln λ` (CLM: β=1). Std-lib only;
  OSW solver reused from `ns050_dss_spectral_gap.jl`. Output `ns050_twoscale_fit.out.txt`.
- **(c3)** `scripts/ns050_3d_control.jl` — the instrument as a negative control on **regular** viscous
  Taylor–Green (Re=1600, N=64). Reuses the verified `dns_tg256.jl` solver via `include`
  (`make_ops`/`taylor_green_ic`/`rk4`/`diagnose`/`curl_hat`/`ifft3`). Output `ns050_3d_control.out.txt`.

## §2 — Results

**(c1) Two-scale fit resolves the `a>0` UNDETERMINED toward self-similar (β≠1), not DSS:**

| a | blows up? | β = dlnℓ/dlnλ | two-scale drift ratio | reading |
|---|---|---|---|---|
| 0.0 (CLM) | yes | 1.10 | 0.166 | calibration: β≈1, U converges ✓ |
| 0.3 | yes | 0.70 | 0.013 | two-scale CONVERGES ⇒ self-similar, β≠1 |
| 0.5 | yes | 0.42 | 0.017 | two-scale CONVERGES ⇒ self-similar, β≠1 |
| 1.0 (De Gregorio) | **no** | — | — | no finite-time blow-up within `tmax` |

Once given an independent spatial scale, the `a=0.3, 0.5` blow-ups converge cleanly (drift collapses to
~0.01–0.02) with `β` dropping below 1 as advection strengthens — the anomalous spatial exponent the
single-amplitude-scale fit (which assumes `β=1`) structurally could not see. De Gregorio (`a=1`) on smooth
data does not blow up in `tmax` (consistent with the literature).

**(c3) Negative control — the instrument correctly returns NULL on a regular 3D flow:**
`‖ω‖∞` rises to a peak **21.45 at t=8** then **DECAYS** (18.1→16.2→14.4→12.9) — bounded, no divergence;
`Z/Z0` peaks at **28.37 at t=9**, reproducing the Brachet-1983 TG Re=1600 enstrophy peak. The rescaled
line-profile drift stays in 0.56–1.2 and never settles to 0 (no steady attractor). So the instrument's
first gate ("‖ω‖∞→∞?") fails and no self-similar attractor forms — the correct NULL, no false-positive.

## §3 — Verification

**Evidence type: example-tested (within-truncation), both.**
- **(c1)** asserted: *an independent spatial scale converges the `a>0` fit ⇒ self-similar with β≠1*.
  Calibrated on CLM (β recovered 1.10 vs true 1.0). The drift-ratio collapse (0.013, 0.017 ≪ the
  single-scale's >1) is the evidence. **Honest caveats:** the β values carry a **~10% systematic** (the
  CLM calibration reads 1.10, not 1.00 — from the discrete half-width estimator and the `ℓ=A/‖ω_x‖∞`
  proportionality constant), so read β as *approximate* (≈0.7, ≈0.4); the **qualitative** result
  (two-scale converges where single-scale failed; β<1 decreasing with `a`) is robust. A genuine DSS would
  show the two-scale fit *still* failing **plus** τ-periodicity — **not** observed; so the resolution is
  toward *self-similar with anomalous exponent*, not DSS, for these `a`.
- **(c3)** asserted: *the instrument does not false-positive on a regular flow*. Evidence: `‖ω‖∞` bounded
  (peaks + decays) and the profile drift never →0 — the negation of the CLM calibration (where drift →0 at
  a true self-similar blow-up, `ns050_modulation_witness.jl`). The `Z/Z0≈28` Brachet match validates the
  reused solver at N=64.

**Vacuity caps.** (c1) 1D OSW model, finite truncation, amplitude+width scales only (no `x₀`-drift —
symmetry-pinned — no rotation). (c3) regular resolved DNS at N=64, a CONTROL not a near-singular test;
the program has no clean near-singular 3D fixture (TG and Kerr reconnection are regular). Both: `:proved`=0,
do NOT touch 3D-NS regularity.

## §4 — Spec impact

- **No NS-ID upgrade; no `SPEC.md`/`dashboard.md` status change.** Both feed `NS-050`
  (`ns050_dss_modulation.md`), which stays `:open`, `Scope: PDE-analysis`, `:proved`=0.
- **What they earn:** (c1) the *two-scale* instrument — the 1D analog of direction-1's `(λ,x₀)`-modulation
  requirement (M3) — and a resolution of b's UNDETERMINED (the `a>0` OSW blow-ups are self-similar with
  `β≠1`, not DSS). (c3) a calibrated *negative control*: the dynamic-rescaling instrument returns the
  correct NULL on a regular flow, so a future positive on a genuinely near-singular fixture would be
  meaningful rather than a tautology.
- **The arc:** b found the single-scale instrument's edge → named the missing piece (an independent spatial
  scale) → c1 built it and got a clean β≠1 self-similar answer → c3 confirmed no-false-positive. The
  through-line is *instrument-building under the witness discipline* (two readings retracted in b, the β
  systematic flagged here), not a claim about 3D NS.

**Pointers:** `ns050_dss_spectral_gap_companion.md` (b — the gap + the UNDETERMINED this resolves),
`ns050_modulation_witness_companion.md` (the original calibrated instrument), `ns050_dss_modulation.md`
(M1–M5 / Floquet), `dns_tg256.jl` (the reused 3D solver). Boussinesq fixture (c2) — separate companion.
