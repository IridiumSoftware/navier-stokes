# Companion — NS-010 Stage 1c-3D, Step 1: the 3D regularity control

**2026-06-01.** The first 3D move. Deliberately the **control**, not a blowup
hunt: before any δ(t)→0 search we validate that the 3D pseudospectral solver +
the analyticity-strip diagnostic behave correctly on **known-regular** flows,
anchored to the Tier-1 invariants. **Scope: 3D pseudospectral ODE-truncation —
NOT the 3D-NS PDE, NOT a blowup claim. Distance to the prize: UNTOUCHED.**

This is the 3D analog of Stage 1c-2D, but 3D is the *open* regime: enstrophy is
no longer a-priori finite because vortex stretching (ω·∇u) is live. So the
solver-correctness anchor shifts from enstrophy (2D) to the two invariants that
*are* conserved by 3D Euler — **energy and helicity**.

---

## §1 — Computational basis

**File.** `scripts/spectral_3d_control.jl` (+ output
`scripts/spectral_3d_control.out.txt`). Std-lib Julia only: hand-rolled radix-2
`fft!` (⇒ N a power of two), extended to 3D by transforming along each axis
(`fft3`/`ifft3`); `Random` (stdlib) for the seeded initial condition. Run as a
script (`julia spectral_3d_control.jl`); an `SMOKE=1` gate runs an N=16
correctness check first (FFT roundtrip, divergence-free IC, Euler E/H
conservation over a few steps) before the full sweep.

**Formulation.** Incompressible momentum in **rotational form**:

```
∂_t u = u×ω − ∇Π + νΔu ,   Π = p + ½|u|² ,   ω = ∇×u .
```

In Fourier the **Leray projection** `P = I − k kᵀ/|k|²` annihilates `∇Π`:

```
∂_t û = P[(u×ω)^] − ν|k|² û .
```

`ω̂ = i k × û`; the cross product `u×ω` is formed in physical space; the
nonlinear transform is **2/3-dealiased**; time stepping is RK4. This is the
standard energy-conserving pseudospectral scheme, and it puts the
vortex-stretching nonlinearity (absent in 2D) front and center.

**Initial conditions.**
- *Seeded helical field* (panels A, B): `u = ∇×A` with a random smooth vector
  potential `A` low-passed to `|k|≤4` ⇒ exactly divergence-free and generically
  **nonzero helicity** (so helicity conservation is a real test), energy
  normalized to ½. Seed fixed (`20260601`) ⇒ deterministic.
- *Taylor–Green vortex* (panel C): `u=(sin x cos y cos z, −cos x sin y cos z, 0)`
  — the canonical dynamical 3D test; helicity-free by symmetry (H≡0).

**Validation anchors (Tier-1, `physical_invariants.md`).** 3D Euler conserves
`E=½⟨|u|²⟩` and `H=⟨u·ω⟩`; incompressibility is `k·û=0` (`div_max`). The N=16
smoke confirmed FFT roundtrip exact, IC `div_max≈1e-13`, and E,H conserved to 6
digits over the smoke window before the full run.

---

## §2 — Results

### (A) 3D Euler, helical IC, N=32 — solver validation

| t | E/E0 | H/H0 | Z/Z0 | ‖ω‖∞ | δ(t) | div_max |
|---|---|---|---|---|---|---|
| 0.0 | 1.000000 | 1.000000 | 1.000 | 8.98 | — | 1.3e-12 |
| 1.0 | 1.000000 | 1.000000 | 2.712 | 22.9 | 0.320 | 5.8e-12 |
| 2.0 | 1.000000 | 1.000000 | 6.142 | 26.2 | 0.190 | 6.7e-12 |
| 3.0 | 1.000000 | 1.000000 | 8.575 | 28.1 | 0.093 | 6.5e-12 |

**Energy conserved to 0.0000%, HELICITY to 0.0000%**, `div_max≈1e-12` (machine).
This is the result: the 3D solver — advection, projection, and vortex stretching
— is wired correctly, validated by the 3D-specific Tier-1 invariant (helicity)
that 2D could not provide. Enstrophy **grows ~8.6×** — vortex stretching is
genuinely active. δ **declines** 0.46→0.09: the inviscid analyticity strip
narrows as the cascade fills modes — **expected Euler physics, not a regularity
claim** (3D Euler regularity is itself open). By t=3, `δ·k_cut ≈ 0.9`, i.e. the
strip has shrunk to the grid scale and the run is at its N=32 resolution limit.
This panel is **solver-validation, not a blowup verdict.**

### (B) N-convergence of the δ-fit — HONEST CORRECTION

| t | δ (N=16 / 32 / 64) | E/E0 (N=16 / 32 / 64) |
|---|---|---|
| 0.5 | 0.348 / 0.458 / 0.361 | 1.0000 / 1.0000 / 1.0000 |
| 1.0 | 0.219 / 0.320 / 0.243 | 1.0000 / 1.0000 / 1.0000 |
| 1.5 | 0.166 / 0.252 / 0.191 | 1.0000 / 1.0000 / 1.0000 |
| 2.0 | 0.114 / 0.190 / 0.148 | 1.0000 / 1.0000 / 1.0000 |

**Energy is conserved at every N — the solver is resolution-robust.** But the
**δ-fit does NOT cleanly converge**: the values are non-monotonic in N (N=16 <
N=64 < N=32 at every time) with ~30–50% spread. *(An earlier draft of this
companion's script line claimed clean convergence; the data do not support it.
Recorded as a correction, not buried — same discipline as the Stage-1b small-N
and Stage-1c-2D enstrophy corrections.)*

**Why.** The exponential-slope fit (`log|û| ~ −δk` over the band `k=2..N/3`) is
**window-sensitive** once an inviscid cascade develops a power-law range: the fit
band widens with N (cut = 5 / 10 / 21), and a wider band captures more of the
flatter low-k power-law bend, biasing the slope. The strip width is well-defined
only when there is a clean **exponential tail** — true for the 1D/2D exact
benchmarks and the viscous case (C), but **not** for inviscid, developing,
under-resolved 3D turbulence.

**This is the load-bearing finding of the whole step.** The δ-slope-fit is
fragile *exactly* in the inviscid / under-resolved regime where a blowup hunt
operates. So Step 2 cannot trust a δ→0 slope on its own.

### (C) 3D NS, Taylor–Green, ν=0.02, N=64 — the regularity control

| t | E/E0 | Z/Z0 | ‖ω‖∞ | δ(t) | BKM ∫‖ω‖∞ |
|---|---|---|---|---|---|
| 0.0 | 1.000000 | 1.000 | 2.00 | — | 0.00 |
| 2.0 | 0.764528 | 1.022 | 1.34 | 0.731 | 3.13 |
| 3.0 | 0.639920 | 1.041 | 1.71 | 0.660 | 4.65 |
| 5.5 | 0.363127 | 0.750 | 2.08 | 0.605 | 9.59 |
| 8.0 | 0.193716 | 0.401 | 1.55 | 0.656 | 14.21 |

Energy **monotonically decays**; enstrophy **peaks then decays** (vortex
stretching, then viscous dissipation wins); **δ stays bounded** (min **0.605**,
never→0); ‖ω‖∞ finite ⇒ **BKM ∫‖ω‖∞ finite** (≈14.2, growing ~linearly) ⇒ **no
blowup**. The diagnostic correctly reports **REGULARITY** on a genuinely 3D,
vortex-stretching, dynamically-rich flow. Here the fit is **clean** — the viscous
exponential tail is well-resolved (`δ·k_cut ≈ 0.6·21 ≈ 13 ≫ 1`), unlike the
inviscid (B). At Re≈50 the Kolmogorov scale sits well inside N=64.

---

## §3 — Verification

**Type / evidence.** `computed`, deterministic (seeded), reproducible via
`julia scripts/spectral_3d_control.jl`. **Scope: 3D pseudospectral
ODE-truncation.** Not a PDE statement; `:proved` count unchanged (0).

- *Solver correctness:* validated by exact conservation of the two Tier-1 Euler
  invariants — energy (0.0000%) and **helicity** (0.0000%) — plus `div_max ≈
  machine`. Helicity is the 3D-specific check 2D could not offer.
- *Diagnostic — what it does and does not establish:*
  - **Establishes:** on the viscous, well-resolved Taylor–Green control (C), the
    δ-diagnostic + BKM correctly report regularity (δ bounded, BKM finite, energy
    decays) — the two-sided property (it says "regular" when the answer is
    regular) now demonstrated in 3D, completing the 1D/2D/3D control ladder for
    the *viscous, resolved* case.
  - **Does NOT establish:** any clean δ-fit in the inviscid/under-resolved regime
    (B) — the slope-fit is window-sensitive there and varies ~50% with N. The
    *solver* is robust; the *δ-slope-fit* is not, in that regime.
- *Honesty corrections recorded:* (i) panel A is solver-validation, not a
  regularity claim (inviscid Euler δ-decline is the expected cascade); (ii) panel
  B's δ-fit does not converge — the earlier "resolution-robust" wording was wrong
  and is corrected in the script and here.

**Firewall.** Nothing here touches the 3D-NS PDE. The viscous control passing is
the prerequisite for Step 2; it is not progress on the open problem.

---

## §4 — Spec impact

- **NS-010 / NS-011** — extend the Scope note to *"validated in 1D + 2D + 3D
  (viscous, well-resolved) controls"*; **add the documented caveat** that the
  exponential-strip δ-fit is **not resolution-robust for inviscid / under-resolved
  3D developing turbulence** (panel B). Status stays **:tested** (the new evidence
  is corroboration + a limitation, not a new claim tier). Scope unchanged
  (PDE-method, validated in models).
- **TEST_SPEC** — two new rows:
  - **T-06 (BKM co-movement gate).** Any reported 3D δ→0 must co-move with
    ∫‖ω‖∞→∞ (NS-004); else reject as a resolution artifact. (Dashboard
    band-finding #2.) *Status here: defined; exercised affirmatively by (C) in the
    regular direction (BKM finite ⇔ δ bounded).*
  - **T-07 (3D solver validation).** 3D Euler conserves energy and helicity to
    ≤0.01% and `div_max ≤ 1e-9` on a helical IC. **PASS** (A).
- **Dashboard** — Stage 1c-3D Step 1 DONE (control); Step 2 (blowup-candidate IC)
  is gated on T-06 + true spectral N-convergence (not the δ-slope alone), per the
  {NS-003,004,010} bridge (NS-031). Band-finding #1 (mechanism axis {NS-002,004,
  009}) informs the Step-2 IC: drive vortex stretching toward anomalous
  dissipation.

**The actionable takeaway for Step 2.** The solver is trustworthy in 3D. The
diagnostic is trustworthy *when the spectrum has a clean exponential tail*
(viscous, resolved). In the regime where blowup would live (inviscid /
near-singular / under-resolved), the δ-slope-fit alone is **not** reliable —
Step 2 must (a) hold N-convergence of the *spectrum itself*, not just the fitted
δ, and (b) require BKM co-movement (T-06). A bare δ→0 is not evidence.
