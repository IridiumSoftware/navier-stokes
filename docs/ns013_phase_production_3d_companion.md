# NS-013 — Does reality's phase structure gate the 3D production? (companion)

**Date:** 2026-06-07. **Scope: resolved-ish 3D pseudospectral DNS truncation (Re=1600). NOT the 3D-NS
PDE.** `:proved`=0; distance to the prize UNTOUCHED. A within-truncation witness — a phase surrogate is a
diagnostic of *where* the production lives in the field (phase vs amplitude), not an analytic step.

## §1 — Computational basis

- **Script:** `scripts/ns013_phase_production_3d.jl` (std-lib Julia; reuses the validated `dns_tg256`
  solver chain via `include` — solver, `field_diag`, `diagnose`, ICs, FFTs). Threaded hand FFT.
- **Output:** `scripts/ns013_phase_production_3d.out.txt`.
- **The sequel.** The 1D probe (`ns013_realcomplex_production.jl`) found the production object `∫g³≡0` on
  the complex-blowup class (one-sided / analytic-signal spectrum) by Fourier support, and reality (the
  two-sided conjugate-symmetric spectrum) *activates* it. Its honest non-transfer note left an explicit
  open question: the 3D production `∫ω·Sω` is not a single one-sided cubic, so "identically zero" does not
  transfer — but the **question** does: *does reality's spectral/phase structure gate the 3D production?*
- **Method — phase-scrambled surrogate.** `P=∫ω·Sω=∫ω_iS_{ij}ω_j` is a cubic (triadic) functional of `û`
  — its value (the `k=0` mode of a cubic field) is a sum over triads `k₁+k₂+k₃=0` that, in a real field,
  close through `û(−k)=conj û(k)`. The surrogate multiplies each mode by `e^{iα·φ(k)}` with `φ(−k)=−φ(k)`
  and `φ=0` on self-conjugate modes (`k=0`, Nyquist). This (i) **preserves `|û(k)|` per component** ⇒ the
  full spectrum `E(k)`, hence `E`, enstrophy `Z`, **and helicity `H`** (since `ω̂=ik×û` picks up the same
  `e^{iφ}`, `û·conj(ω̂)` per `k` is invariant) — all the *quadratic* invariants; (ii) **preserves
  div-free** (a per-`k` phase preserves `k·û=0`); (iii) **destroys the cubic/triadic phase coherence**.
  `α: 0→1` interpolates coherent → fully scrambled.
- **Run.** Develop TG (`H=0`) and a random helical field (`H≠0`) to `t=4` (N=64, Re=1600), then sweep
  `α∈{0,0.25,0.5,0.75,1.0}` averaged over 5 random seeds. N=1 invariant gate at N=16 first.

## §2 — Results

**N=1 gate.** Full scramble preserves `E,Z,H` to ~1e-16 and div-free to <1e-9, while `P` changes — the
surrogate is spectrum-and-quadratic-invariant matched, phases only.

**The production collapses with phase coherence; the spectrum and all quadratic invariants do not.**

| α | TG `P/P0` | TG `S_ω` | TG `c²int` | Helical `P/P0` | Helical `S_ω` | `|dE|/E,|dZ|/Z,|dH|` |
|---|---|---|---|---|---|---|
| 0.00 | 1.000 | 0.223 | 0.627 | 1.000 | 0.0138 | 0 |
| 0.25 | 0.735 | 0.164 | 0.522 | 0.728 | 0.0100 | ~1e-16 |
| 0.50 | 0.279 | 0.062 | 0.411 | 0.253 | 0.0035 | ~1e-16 |
| 0.75 | 0.063 | 0.014 | 0.370 | 0.023 | 0.0003 | ~1e-16 |
| 1.00 | **0.033 ± 0.020** | **0.0074** | 0.362 | **0.007 ± 0.024** | **0.0001** | ~1e-16 |

Full phase-scramble removes **97% (TG) / 99% (helical)** of the production `∫ω·Sω` and drives the skewness
`S_ω → ~0`, with `E`, `Z`, and **helicity** (`H=+0.049` in the helical run) preserved to ~1e-16 at every
`α`. The residual ~3% (TG) sits within the seed-to-seed scramble noise (±0.02) — consistent with zero (the
random scramble does not annihilate `P` exactly the way the 1D Fourier-support argument does). The strain–
vorticity alignment `c²int` also relaxes toward its phase-random value (TG 0.63→0.36).

**The 3D analog of the 1D finding, confirmed.** 1D: one-sided spectrum ⇒ `∫g³≡0` (Fourier support). 3D:
phase-incoherent surrogate (same spectrum + all quadratic invariants) ⇒ `∫ω·Sω → ~0`. Both say the
production is a **phase-coherence object, not a spectrum object** — it lives in reality's conjugate/triadic
phase structure. Destroying that structure (one-sidedness in 1D, scrambling in 3D) kills the production
while `E,Z,H` are untouched. The "what transfers to 3D" question is answered: **yes — reality's phase
structure gates the 3D production.**

## §3 — Verification

- *Computed.* Resolved-ish DNS truncation; solver is the `dns_tg256`-validated chain. N=1 invariant gate
  passes (E,Z,H to ~1e-16, div-free, P changes).
- *Control built into the design.* The surrogate preserves every quadratic invariant **exactly** (verified
  per-`α`, `|dE|/E,|dZ|/Z,|dH| ~ 1e-16`), so the production collapse cannot be a spectrum/energy/helicity
  artifact — it isolates the phase coherence as the carrier.
- *Known-physics anchor.* The velocity-gradient skewness is a 3rd-order moment that vanishes for
  Gaussian/phase-random fields; this probe exhibits it for the full production `∫ω·Sω` with helicity held
  fixed, across two flows and a coherence sweep, averaged over seeds.

## §4 — Spec impact

**No new S-ID; no status change.** Within-truncation witness extending **NS-013** (and the
`ns013_realcomplex_production` probe). It **answers the 1D probe's flagged open question in 3D**: reality's
phase structure gates the production `∫ω·Sω`, the 3D shadow of "one-sided ⇒ `∫g³=0`." Reinforces the
NS-013→NS-046 framing — the regularity-relevant production object lives in the phase coherence, the very
structure the complex-blowup channel degrades.

**Honest limits.** Vacuity cap (regular truncation, no singular set); a phase surrogate diagnoses *where*
the production lives in the field, it is not an analytic statement about the PDE. The collapse is to
within-scramble-noise of zero, not an exact zero (unlike the 1D Fourier-support result). `:proved`=0;
prize UNTOUCHED.
