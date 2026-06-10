# Companion — NS-050 (c2): 2D Boussinesq front-sharpening fixture

**Date:** 2026-06-10. **`Scope: 2D Boussinesq pseudospectral DNS truncation` — NOT the NS PDE.**
**`:proved`=0; distance to the Clay prize UNTOUCHED.** The third (c) follow-up: give the dynamic-rescaling
instrument a genuinely-sharpening *incompressible-family* flow beyond the 1D CLM/OSW models. **Honest scope
up front:** this is a periodic-box 2D Boussinesq DNS with a rising-thermal IC; it is **not** a faithful
reproduction of the Chen–Hou / Hou–Luo finite-time blow-up (which requires a SOLID WALL that a periodic
spectral box does not impose), and **no singularity is claimed**.

## §1 — Computational basis

- **File:** `scripts/ns050_boussinesq_2d.jl` (Julia, std-lib only; 2D FFT built from the 1D radix-2 `fft!`,
  rows-then-columns). Output: `scripts/ns050_boussinesq_2d.out.txt`. N=128, periodic `[0,2π]²`.
- **System** (vorticity form): `ω_t + u·∇ω = ∂_xθ + νΔω`, `θ_t + u·∇θ = κΔθ`, `u=∇^⊥ψ`, `Δψ=ω`
  (Biot–Savart in Fourier: `û=i k_y ω̂/|k|²`, `v̂=−i k_x ω̂/|k|²`). RK4, 2/3-dealiased.
- **IC:** rising thermal — a warm blob `θ₀=exp(−((x−π)²+(y−π)²)/0.25)`, `ω₀=0`; the baroclinic term `∂_xθ`
  generates vorticity → roll-up → a sharpening mushroom front. `ν=κ=2e-4` (sharpening run).
- **Instrument:** the (c1) two-scale fit applied to `|∇θ|` along the line through its peak (amplitude
  `A=‖∇θ‖∞`, width `ℓ` from half-max), with `β=d lnℓ/d lnλ`. A **resolution gate** (spectral tail energy in
  the outer band >1%) halts the run.

## §2 — Results

**(V) Validation (`ν=κ=0`) — the solver is sound:**
- Biot–Savart velocity divergence: `max|∇·u| = 2.1e-14` ✓ div-free.
- Inviscid scalar transport: `∫θ` drift `3.5e-18`, `∫θ²` drift `5.4e-7` over `T=4` ✓ (θ-variance conserved —
  the transport is faithful; no spurious scalar production).

**(S) Sharpening run (`ν=κ=2e-4`):**

| t | ‖ω‖∞ | ‖∇θ‖∞ | ℓ (front) | spectral tail | status |
|---|---|---|---|---|---|
| 0 | 0.00 | 1.72 | 0.442 | 6e-31 | rising |
| 1 | 1.70 | 2.24 | 0.540 | 3e-12 | rising |
| 2 | 3.36 | 5.12 | 0.295 | 1.4e-5 | rising |
| 3 | 6.42 | 11.18 | 0.098 | 4.3e-3 | rising |
| 4 | 10.96 | 13.23 | 0.098 | **2.5e-2** | **UNDER-RESOLVED (gate) — stop** |

The thermal develops a sharpening front — `‖∇θ‖∞` grows ~8× and the front width `ℓ` shrinks ~4.5× — until
the **resolution gate trips at t=4** (tail >1%), where the run is **halted** (NS-032 discipline: results past
the resolution wall are truncation artifacts, not physics). `β = d lnℓ/d lnλ = 0.854` over the resolved
window.

## §3 — Verification

**Evidence type: example-tested (within-truncation).** The solver is validated by two independent checks
(div-free to 2e-14; inviscid θ-variance conserved to ~5e-7) before any sharpening claim. The front-sharpening
(`‖∇θ‖∞`↑, `ℓ`↓) is the asserted behavior; the resolution gate is enforced, not optional.

**Honest caveats (load-bearing):**
1. **No blow-up claimed.** Smooth dissipative 2D Boussinesq is globally regular (Chae 2006); the inviscid
   smooth-data question is open. This run sharpens then under-resolves — it does not (and cannot, here)
   exhibit a singularity.
2. **Not the Hou–Luo scenario.** The established Chen–Hou finite-time blow-up needs a **solid wall** (the
   boundary drives it); a periodic box does not impose one. This is therefore a *front-sharpening witness*,
   not a reproduction of that blow-up. Stated loudly.
3. **`β≈0.85` is preliminary.** The resolved window is short (~4 points before the gate), so `β` is a rough
   estimate, not a converged self-similar exponent — read it as "an `O(1)`, sub-1 front scaling, consistent
   with the c1 picture," not a precise measurement.
4. **N=128, finite truncation; `:proved`=0; does NOT touch 3D-NS regularity.**

## §4 — Spec impact

- **No NS-ID upgrade; no `SPEC.md`/`dashboard.md` status change.** Feeds `NS-050`; `:open`,
  `Scope: PDE-analysis`, `:proved`=0.
- **What it earns:** a *validated* 2D Boussinesq solver and a demonstration that the dynamic-rescaling
  instrument + resolution gate operate on a genuine 2D incompressible-family sharpening flow — the closest
  the program gets to a near-singular incompressible fixture without a wall. The honest yield is the
  **discipline** (validate → sharpen → gate-and-stop), not a singularity or a precise `β`.
- **Gated next step (not done):** a wall-bounded (Hou–Luo) geometry — via odd/even spectral symmetrization or
  a Chebyshev wall — to make the fixture *faithful*, plus higher N to extend the resolved window before the
  gate. Only then would `β` from this flow be load-bearing.

**Pointers:** `ns050_twoscale_and_control_companion.md` (c1 two-scale fit + c3 control),
`ns050_dss_spectral_gap_companion.md` (b), `ns050_modulation_type2_scope.md` (the map).
