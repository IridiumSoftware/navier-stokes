# Companion — NS-050 direction 2: the dynamic-rescaling (modulation) witness

**Date:** 2026-06-09. **`Scope: 1D-model + pseudospectral ODE-truncation` (≠ the NS PDE).**
**`:proved`=0; distance to the Clay prize UNTOUCHED.** A *within-truncation witness* validating the
*instrument* of `ns050_modulation_type2_scope.md` §6-2: can a dynamic-rescaling fit recover, from a field
alone, (i) a converging rescaled profile and (ii) the blow-up rate exponent `p` and time `T*`? Calibrated on
a model whose self-similar answer is **exact**. It certifies the diagnostic, **not** anything about 3D NS.

## §1 — Computational basis

- **File:** `scripts/ns050_modulation_witness.jl` (Julia 1.12.6, std-lib only — `Printf`; hand-rolled
  radix-2 FFT, self-checked vs the manual DFT to 5e-13). Output: `scripts/ns050_modulation_witness.out.txt`.
- **Run:** `julia scripts/ns050_modulation_witness.jl`. No external deps (does not use the project's FFTW).
- **Model — Constantin–Lax–Majda** `ω_t = ω·H(ω)` (`H` = Hilbert transform; the 1D analog of 3D
  vortex-stretching `ω·∇u`). Exact solution for `ω₀=cos x`: `ω = 4cos x/[(2−t sin x)²+t²cos²x]`, blow-up at
  `t*=2`. The FFT/Hilbert/RHS/RK4 machinery is reused (kept self-contained) from the verified
  `spectral_clm_blowup.jl` (NS-010 Stage 1b).
- **The known answer (calibration ground truth).** Near the self-similar center `x₀=π/2` (the steepest
  point, between the two extrema), `ω(x,t) ≈ λ(t)⁻¹ Φ((x−x₀)/λ)` with `λ(t)=1/‖ω‖∞ ≈ (2−t)`,
  `Φ(η) = −4η/(1+4η²)` (`‖Φ‖∞=1`). So CLM blows up **self-similarly**: rate exponent **p=1**
  (`‖ω‖∞∼(2−t)⁻¹`), blow-up time **T*=2**.
- **The fit (the instrument under test).** From a field `ω`: center `x₀ = argmax|ω_x|` (parabolically
  refined); amplitude `A=‖ω‖∞`; scale `λ=1/A`; rescaled profile `U(η) = ±λ·ω(x₀+λη)` on a fixed grid
  `η∈[−4,4]` (161 pts, linear interpolation), oriented `U'(0)<0` to match `Φ`. Rate via the asymptotic
  window `t≥1.7`: `λ=1/A` linear in `t` ⇒ `T*` (where `λ→0`); `p = −` slope of `lnA` vs `ln(T*−t)`.

## §2 — Results

**(A) On the exact solution** — the fit recovers the profile and rate as `t→t*`:

| t | x₀ (→π/2) | A=‖ω‖∞ | ‖U−Φ‖_L2 | drift ‖ΔU‖ |
|---|---|---|---|---|
| 1.00 | 1.57080 | 1.33 | 4.41e−1 | — |
| 1.40 | 1.57080 | 1.96 | 2.55e−1 | 2.30e−1 |
| 1.70 | 1.57080 | 3.60 | 1.38e−1 | 1.27e−1 |
| 1.85 | 1.57080 | 6.93 | 7.31e−2 | 6.55e−2 |
| 1.92 | 1.57080 | 12.76 | 4.02e−2 | 3.29e−2 |
| 1.96 | 1.57080 | 25.25 | 2.06e−2 | 1.97e−2 |
| 1.98 | 1.57080 | 50.25 | 1.08e−2 | 9.89e−3 |

- **Center** recovered to machine accuracy (`x₀=π/2=1.57080` at every `t`).
- **Profile** `‖U−Φ‖_L2` **halves each step** (4.4e−1 → 1.1e−2) — clean convergence to the *known* profile
  `Φ`; the inter-step drift `‖ΔU‖` falls in lock-step, confirming a genuine self-similar limit (not a
  numerical artifact).
- **Rate fit (window t≥1.7):** `T*=2.0039` (exact 2.0), `p=1.0344` (exact 1.0).

**(B) On the pseudospectral solver** (RK4, 2/3-dealias, `ω₀=cos x`), within truncation, N∈{1024,2048,4096}:
`‖U−Φ‖_L2` decreases the same way and is **N-convergent** (e.g. at t=1.96: 2.89e−2 / 2.21e−2 / →exact
2.06e−2 for N=1024 / 2048 / exact); rate fit `T*=2.002, p≈1.005` at every N.

## §3 — Verification

**Evidence type: example-tested (within-truncation).** The asserted behavior — *the dynamic-rescaling fit
recovers (center, profile, T*, p) of a known self-similar blow-up* — is exhibited against a model with an
**exact** closed-form answer:
- center: asserted `π/2`, measured `1.57080` (exact);
- profile: asserted `Φ(η)=−4η/(1+4η²)`, measured `‖U−Φ‖_L2 → 0` (1.1e−2 and still halving at t=1.98);
- rate/time: asserted `(T*,p)=(2,1)`, measured `(2.004, 1.034)` exact / `(2.002, 1.005)` spectral, N-robust.

**Vacuity caps (mandatory).** (1) CLM is **1D** and the solver is a **finite truncation** — no singular
limit is reached; the witness validates the *instrument*, never the PDE. (2) The modulation here is the
**amplitude scale only**, not the full NS `(λ,x₀,R)` triple. (3) `:proved`=0. State on any use.

## §4 — Spec impact

- **No NS-ID upgrade; no `SPEC.md`/`dashboard.md` change.** This is the *instrument-validation* witness for
  the proposed `NS-050` (direction 2 in `ns050_modulation_type2_scope.md`), which stays `:open`,
  `Scope: PDE-analysis`, `:proved`=0.
- **What it earns:** the dynamic-rescaling fit is a *working, calibrated instrument*. Its standing value is
  the **Type-II discriminator** framing: a Type-II event is exactly the **negative** of this calibration —
  `U` would **fail to converge** (drift not →0) and/or `p(t)` would **drift** (one modulation scale
  insufficient). So the instrument is built to detect non-self-similarity in a near-singular flow.
- **Gated next step (not done):** apply the fit to a genuinely near-singular **3D incompressible** fixture.
  The program does not currently have one in clean form — resolved Taylor–Green and the Kerr reconnection
  (`ns049_anisotropy_defect_probe.jl`) are **not** true blow-ups — so this awaits either such a fixture or a
  near-self-similar axisymmetric run (cf. the DSS seed in `ns050_dss_modulation.md` §7). Honest: until then
  the instrument has nothing 3D-singular to measure.

**Pointers:** `ns050_modulation_type2_scope.md` (the map), `ns050_dss_modulation.md` (the profile/spectral
prerequisite), `ns_blowup_generator_class.md` (G2/S2/W1 the profile must satisfy),
`spectral_clm_blowup.jl` (the reused verified machinery).
