# Companion — does the real repair cost grow under 3D stretching? (NS-020 strengthening)

**2026-06-01.** Adjudicates the central empirical claim of the Desktop `discrete.rtfd`
document (a Grok exploratory "dual-closure uplift" pass): that under 3D stretching the
**repair cost** `Cost(c)=inf{‖z‖ : ∂z=c}` *"grows exponentially, proxied by enstrophy +
curvature"* — the asserted mechanism of turbulence ("repair overflow") and the basis for
its claim that the classical PDE is *"the wrong model."* **We computed the real cost (not
the proxy) and watched whether it grows.** Scope: 3D pseudospectral truncation. NOT the
PDE. `:proved` = 0; distance to the prize UNTOUCHED. Confirms **NS-020**; connects to **NS-036**.

## §1 — Computational basis

- **Source (new):** `scripts/repair_cost_under_stretching.jl` (+ `.out.txt`). Reuses the
  validated 3D solver `spectral_3d_control.jl` (rotational-form pseudospectral, hand-rolled
  FFT, RK4, Leray projection; energy+helicity conserved to ~6 digits). Std-lib Julia.
- **The object.** The vorticity field `ω=∇×u` is the obstruction-carrier. Its minimal
  filling — the smallest `z` with `∇×z=ω` — is the natural repair cost. The minimal-`L²`
  such `z` is the divergence-free field with `∇×z=ω`, which **is the velocity `u` itself**
  (any other `z` differs by a gradient: adds norm, killed by curl). Recovered FROM `ω`
  alone via the Fourier inverse-curl `ẑ = i k×ω̂/|k|²`:
  `R_X(ω) = min{‖z‖_{L²} : ∇×z=ω} = ‖curl⁻¹ω‖_{L²} = ‖u‖_{L²} = √(2E)`.
- **Runs:** (A) inviscid Taylor–Green N=64 to T=5 (vortex stretching on, energy conserved);
  (B) low-band (`|k|≤cut/2`) fraction of the repair-cost vs enstrophy density, t=0 vs t=3;
  (C) viscous Taylor–Green (ν=0.02) N=64 to T=8.
- **Run:** `julia scripts/repair_cost_under_stretching.jl`.

## §2 — Results

**Sanity (machine-exact):** the filling recovered from `ω` equals the velocity, mismatch
`0.0e+00`. So `R_X` is exactly the right object.

**(A) Inviscid Taylor–Green (stretching on, energy conserved):**

| t | E/E₀ | enstrophy½ (proxy) | `R_X=√(2E)` (real) | ratio `R_X/‖ω‖` | ‖ω‖∞ |
|---|---|---|---|---|---|
| 0.0 | 1.000000 | 0.866 | 0.5000 | 0.577 | 2.0 |
| 2.0 | 1.000000 | 1.072 | 0.5000 | 0.467 | 1.9 |
| 3.0 | 1.000000 | 1.370 | 0.5000 | 0.365 | 4.0 |
| 5.0 | 1.000000 | **2.897** | **0.5000** | **0.173** | 20.2 |

The proxy (enstrophy½) grows **×3.34** (‖ω‖∞ **×10**); the real repair cost drifts
**×1.0000** — it equals the *conserved* energy. They **diverge**: the proxy rises, the
real cost is flat. The ratio `R_X/‖ω‖` decays 0.577→0.173 — exactly the NS-020
"repair-cost ≈ 1/vorticity."

**(B) Where each lives in k-space:** repair-cost density stays **99.8% low-band** (t=0→3:
1.000→0.998); enstrophy density migrates to the high band (1.000→0.941). The repair cost
is literally a derivative smoother than what it "repairs."

**(C) Viscous Taylor–Green:** enstrophy½ peaks (~0.88 at t≈3, stretching) then falls
(dissipation); the real repair cost `R_X` decays **monotonically with the energy**
(0.500→0.220). It tracks the *controlled* quantity, never the battleground one. No
"overflow" anywhere.

## §3 — Verification

**Type — algebraic + computed.**
- *Algebraic (exact):* `R_X = √(2E)` is a theorem — the minimal-`L²` filling of a
  divergence-free `ω` is the unique div-free `z` with `∇×z=ω`, i.e. the velocity. This is
  an *identity*, not a fit. 3D Euler conserves `E` ⇒ `R_X` is constant on the nose.
- *Computed:* the run confirms it on a genuinely stretching flow — `E/E₀=1.000000` while
  enstrophy grows ×3.34 and ‖ω‖∞ ×10; the k-space split and the viscous decay corroborate
  "repair cost = energy-side, smoother."
- *Asserted outputs:* sanity mismatch `< 1e-10` ✓; `R_X/R_X(0) = 1.0000` under Euler;
  enstrophy½ strictly rising; ratio strictly falling.

**Honest scope.** This decisively refutes the **field/Hodge `L²`-repair** version of the
claim, and *argues* the general case: any sensible filling is a derivative smoother than
`ω`, so it sits at lower `σ` (more controlled), not at enstrophy's `σ=+1`. (Repairing the
*velocity* 1-chain `q=∂₂z₂` gives an even smoother `z ~ ‖u‖_{Ḣ⁻¹}` — the conclusion only
strengthens.) The explicit **2-chain Seifert-surface** version — a spanning surface of an
individual material filament 1-cycle, in a peak/area norm — is a separate GMT object NOT
computed here; it is the target of the DEC-sandbox follow-up. Nothing here touches the PDE.

## §4 — Spec impact

No new entry. This **strengthens NS-020** (the falsified homological reformulation): its
"repair-cost ≈ 1/vorticity" sub-finding is now directly verified under stretching with the
*real* minimal-filling computation (not just the static homology diagnostic), and the new
result connects it to **NS-036** — the repair cost is the energy-side (σ=−½, supercritical)
quantity, so a bound on it is scale-vacuous. Per the conjunctive-claim rule, NS-020's
status is unchanged (`:falsified`); the note records the added confirming evidence and the
adjudication of the external `discrete.rtfd` proposal.

*Firewall: 3D pseudospectral truncation; not the PDE; ideal-flow identity + viscous
corroboration. `:proved` = 0; distance to the prize UNTOUCHED. Metabolized by Claude,
2026-06-01.*
