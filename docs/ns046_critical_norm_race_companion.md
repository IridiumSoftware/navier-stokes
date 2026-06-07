# NS-005/046 — Critical-norm detector race (companion)

**Date:** 2026-06-07. **Scope: resolved-ish 3D pseudospectral DNS truncation (Re=1600, N=64). NOT the
PDE.** `:proved`=0; distance UNTOUCHED. A within-truncation detector-sensitivity ranking on an intense
transient — NOT a blowup race (the flow is regular; no norm actually diverges).

## §1 — Computational basis

- **Script:** `scripts/ns046_critical_norm_race.jl` (reuses the `dns_tg256` solver chain + the dyadic
  Littlewood–Paley band-pass). Output `scripts/ns046_critical_norm_race.out.txt`.
- **Question.** GKP (CMP 2016): at a finite-time singularity *every* critical Besov norm
  `Ḃ^{-1+3/p}_{p,q}` (`1<p,q<∞`) blows up; ESS: the `L³` endpoint blows up. All σ=0 norms must diverge and
  none is controlled a priori (NS-002) — but they are not equally *sharp detectors*. Race them on the most
  singular-like resolved event: the Kerr anti-parallel-tube reconnection (NS-038: `D30` touches the CKN ≤1
  edge there), at Re=1600, N=64, `t=0..6`.
- **The field (all spectral; each normalized to its own baseline).** CRITICAL (σ=0): `‖u‖_{L³}` (ESS
  endpoint), `‖u‖_{Ḣ^{1/2}}`, `‖ω‖_{Ḃ⁰_{∞,1}}=Σ_j‖Δ_jω‖_∞` (Kozono–Taniuchi), `‖u‖_{Ḃ⁻¹_{∞,∞}}=sup_j
  2^{-j}‖Δ_ju‖_∞` (Koch–Tataru). REFERENCE: `‖ω‖_∞` (BKM), `S_ω` (production skewness — the program's
  current detector). CONTRAST: `‖u‖_{L²}` (energy, σ=−1 supercritical), `‖ω‖_{L²}` (enstrophy, σ=+1
  subcritical).

## §2 — Results

**Detector race — sharpness = peak/baseline at the reconnection (peak ~t=5.5):**

| norm | class | sharpness (peak/base) | steepest d/dt log | peak @ t |
|---|---|---|---|---|
| `‖ω‖∞` | ref (BKM) | 2.63× | +1.09 | 5.75 |
| **`‖ω‖_{Ḃ⁰_{∞,1}}`** | **σ0 CRIT** | **2.51×** | **+0.67** | 5.50 |
| `‖u‖_{Ḃ⁻¹_{∞,∞}}` | σ0 CRIT | 1.57× | +0.11 | 6.00 |
| enstrophy `‖ω‖_{L²}` | σ+1 sub | 1.51× | +0.19 | 6.00 |
| `‖u‖_{Ḣ^{1/2}}` | σ0 CRIT | 1.07× | +0.03 | 6.00 |
| **`‖u‖_{L³}`** | **σ0 CRIT** | **1.00× (decays)** | −0.01 | 0.00 |
| `‖u‖_{L²}` | σ−1 super | 1.00× (flat) | −0.005 | 0.00 |
| `S_ω` | ref | 0→0.166 turn-on | — | 5.75 |

**Critical-norm ranking (sharpness): `Ḃ⁰_{∞,1}` (2.51×) ≫ `Ḃ⁻¹_{∞,∞}` (1.57×) > `Ḣ^{1/2}` (1.07×) >
`L³` (1.00×, decays).**

**The theorem-norm and the detector-norm are different.** `L³` carries the celebrated ESS theorem
(`L³`-bounded ⇒ regular), yet it is the **worst practical detector** — it does not even rise at the
reconnection (it monotonically decays with the energy). The vorticity-side critical-Besov `Ḃ⁰_{∞,1}` is
**~2.5× sharper**. The energy `L²` (σ−1, controlled) is flat (sharpness 1.00 — blind, as the controlled
quantity must be).

**Why (the mechanism, tying the arc together).** The reconnection is an intense, *localized, small-scale
vorticity* event. The velocity-integral critical norms (`L³`, `Ḣ^{1/2}`) are **dominated by the large
energy-containing scales**, so a localized small-scale spike is a tiny fraction of their budget — sharp in
*theory* (σ=0), blunt in *practice*. Only the norms weighting the small-scale `L^∞` peaks (`Ḃ⁰_{∞,1}`,
`‖ω‖∞`) resolve it. That **large-scale-dominance blindness is another face of supercriticality** (NS-002:
the controlled / large-scale-dominated quantities cannot see the localized small-scale structure) and of
the phase/intermittency finding (`ns013_phase_norm_split`: the sharp detectors are exactly the
intermittency-sensitive ones).

**Practical upshot.** Hunting blowup in a DNS, monitor the **vorticity critical-Besov norm `Ḃ⁰_{∞,1}` /
`‖ω‖∞`**, NOT the velocity `L³` — despite `L³` being the norm with the theorem. (The program's current
detectors — `S_ω` and the δ-strip — sit alongside `‖ω‖∞`/`Ḃ⁰_{∞,1}` on the right, vorticity-small-scale
side; the velocity critical norms are the wrong practical tool.)

## §3 — Verification

- *Computed.* DNS truncation on the validated chain. N=1 gate: all eight norms finite & positive on the
  tube IC.
- *Control.* The contrast norms behave exactly as their scaling predicts — energy `L²` (σ−1) flat
  (sharpness 1.00), enstrophy (σ+1) responsive (1.51×) — confirming the race is reading the
  scaling/locality structure, not an artifact.

## §4 — Spec impact

**No new S-ID; no status change.** Within-truncation witness for **NS-005** (the critical-norm criterion)
/ **NS-010** (diagnostics): among the σ=0 norms that all must blow up at a singularity (GKP/ESS), the
**vorticity Kozono–Taniuchi `Ḃ⁰_{∞,1}` is the sharpest practical detector and the velocity ESS-endpoint
`L³` is the bluntest** on a resolved reconnection — the theorem-norm ≠ the detector-norm. Connects to
NS-002 (the blunt critical norms are the large-scale-dominated ones — another face of supercriticality)
and to the phase/intermittency arc (`ns013_phase_norm_split`).

**Honest limits.** Within-truncation, regular flow — a *sensitivity* ranking on an intense transient, NOT
a blowup race; no norm diverges. N=64 is a coarse reconnection; the ranking should be N-confirmed, though
it most likely *strengthens* with resolution (higher N adds the small-scale shells that make `Ḃ⁰_{∞,1}`
sharper). `S_ω`'s peak/baseline is a floored artifact (it starts at ~0); its real signal is the 0→0.166
turn-on at the event. `:proved`=0; prize UNTOUCHED.
