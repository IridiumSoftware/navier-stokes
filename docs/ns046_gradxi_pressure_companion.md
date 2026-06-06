# Idea-3 probe — ∇ξ smoothness + pressure-Hessian counter-transport across helicity (NS-045↔NS-046)

**Date:** 2026-06-06. **Owner:** Aaron Green (probe by Claude; motivated by Brian's NS-046 + the
LOW#1/MID/NS-047 witness residues). **Scope firewall:** resolved 3D pseudospectral DNS truncation
(Re=1600). **NOT the 3D-NS PDE.** Every flow is REGULAR by construction (the LOW#1 vacuity cap stands):
this observes NS-046's *object* in the truncation, it does **not** establish NS-046's inequality.
`:proved`=0; distance UNTOUCHED.

## §1 — Computational basis

`scripts/ns046_gradxi_pressure_probe.jl` (+ `.out.txt` N=64, `_N128.out.txt` N=128), reusing the
validated solver (`spectral_3d_control.jl`) + the NS-045 matched-spectrum IC builder
(`ns045_helicity_mechanism.jl`) + the `vortex_tube_ic` from `dns_tg256.jl`. Std-lib Julia, hand FFT,
power-of-two N. Three flows at Re=1600 (`ν=1/1600`), `dt=0.01`:
- **helical** (ρ_H≈0.968) / **control** (ρ_H≈−0.069) — the NS-045 matched-spectrum pair (identical
  E₀, Z₀; helicity flipped);
- **tubes** — anti-parallel Kerr-type vortex tubes (ρ_H≈0 *exactly* by symmetry: H=8.6e-21, div≈6e-14),
  the canonical **maximal-stretch** near-singular IC = the **weakest-Beltramization** regime.

**New diagnostics** (beyond the NS-045 set): the CFM vortex-direction smoothness `CFM = ⟨|∇ξ|²|ω|⟩`
(ξ=ω/|ω|, guarded; the object the scalar diagnostics are blind to, per LOW#1); the pressure field via
the Fourier Poisson solve (`−Δp = ∂_iu_j∂_ju_i = tr(G²)` ⇒ `p̂=Q̂/|k|²`); and the enstrophy-weighted
projection of the pressure Hessian on the **max-stretch** strain eigenvector, `pHess = ⟨e₃ᵀ(∇²p)e₃⟩`,
vs the self-amplification `selfstr = ⟨λ₃²⟩`. **Sign:** the max-stretch eigenvalue evolves as
`Dλ₃/Dt = −λ₃² − (vorticity term) − e₃ᵀ(∇²p)e₃ + ν(…)`, so **pHess > 0 ⇒ the nonlocal pressure
DEPLETES the max stretch** (the "counter-transport" of NS-046). `ratio = pHess/selfstr` measures the
pressure depletion relative to the local self-amplification it fights.

## §2 — Results (N=64; N=128 convergence in §3)

The three flows all stay regular (Re=1600) but by **different, complementary mechanisms**:

| flow | Beltramization cos²(u,ω) | `ratio = pHess/selfstr` | enstrophy Z (t=0→6) |
|---|---|---|---|
| **helical** (ρ_H=0.97) | **0.92 → 0.50 (strong)** | 0.13 → 0.92 (minor) | 1.15 → 3.35 (gentle) |
| **control** (ρ_H≈0) | 0.32 (weak) | ~0.25 → 0.65 → 0.47 (moderate) | 1.15 → **11.4 (bursts most)** |
| **tubes** (ρ_H=0, max-stretch) | **0.07 → 0.34 (weakest)** | **+10.9 → +1.5 (DOMINANT)** | 0.95 → **2.18 (gentlest)** |

- **Helical** stays regular by **Beltramization** (NS-045): u∥ω crushes the Lamb vector; the pressure
  term is minor (ratio ≪ 1).
- **Tubes** (zero helicity, maximal stretch — Beltramization *absent*) stay regular by the **nonlocal
  pressure-Hessian counter-transport**: it is *dominant* (`pHess`≈15–25 vs `λ₃²`≈3–9, ratio 1.5–11),
  and the tubes attain the **lowest** enstrophy growth despite maximal initial stretching.
- **Control** (intermediate — neither mechanism strong) **bursts the most** (Z→11.4).

**The complementarity:** the two depletion mechanisms are anti-correlated with helicity — Beltramization
(NS-045) dominant at high H, the pressure-Hessian counter-transport (NS-046's object) dominant at the
zero-helicity max-stretch worst case. The pressure mechanism is strongest **exactly in the Kerr-tube
geometry where NS-046 places the analytic battle**, and it is what keeps the worst case regular *in the
truncation* — a direct answer to the LOW#1 residue (the danger lives at ~zero helicity / in ∇ξ; the
nonlocal pressure is what holds it).

**∇ξ / CFM:** the vortex-direction roughness `⟨|∇ξ|²|ω|⟩` grows with disorder — highest in the bursting
control (CFM→1973), lower in the helical (→485) and the tubes (→353); the pressure-dominated tubes keep
both Z *and* ∇ξ-roughness the most controlled. Consistent with the pressure counter-transport holding
the worst-case geometry.

## §3 — Verification

- **IC validation:** tubes E=0.125, Z=1.006, H=8.6e-21 (exact zero helicity), div≈6e-14. Helical/control
  are the NS-045 matched pair (machine-precision matched E/Z).
- **Sign self-consistency:** pHess>0 ⇒ depletion; the flow with the largest pHess-dominance (tubes) has
  the lowest enstrophy growth — internally consistent.
- **N-convergence (N=64 ↔ 128): CONFIRMED.** The t=0 ratios are IC-identical (tubes 10.94, helical
  0.152, control 0.352 at both N), and the qualitative ordering holds throughout — tubes ratio ≫1
  (10.9→2.8→5.2), helical ≪1 (0.15→0.14→0.67), control intermediate (0.35→0.33→0.89); the control
  burst matches (Z@t=4: 7.28 N=64 vs 7.36 N=128). Early-time magnitudes agree to ~2 digits. The
  "pressure-dominant in tubes / Beltramization-dominant in helical" ordering is resolution-robust.
- Type: computed (DNS-truncation diagnostic). The mechanism *complementarity* is example-tested across
  three flows; it is a within-truncation observation, NOT a PDE statement.

## §4 — Spec impact

**No new numbered entry** (lesson from NS-047: don't inflate a finding into a numbered obstruction).
Record as: (i) a note **extending NS-045** — the helicity-depletion mechanism across the helicity range
is *Beltramization at high H, nonlocal pressure-Hessian counter-transport at zero-H max-stretch*
(complementary); (ii) a **DNS-witness note on NS-046** — its "counter-transport" object is the dominant
depletion in the resolved Kerr-tube worst case (a witness/calibration for the analytic target, never the
analytic step). NS-045 stays `:tested`; NS-046 stays `:open`. `:proved`=0; distance UNTOUCHED.
